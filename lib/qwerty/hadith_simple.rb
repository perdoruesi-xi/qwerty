require_relative 'text'
require_relative 'config'

module Qwerty
  class Text
    class HadithSimple < Ruote::Participant
      attr_accessor :hadith_content, :hadith_collection

      def on_workitem
        read_file
        workitem.fields['text']['hadith_simple'] = {
          :source => "http://tezkije.com",
          :book => "Sahih al-Bukhari",
          :num_hadith => hadith_content[:num],
          :albanian_tr =>  hadith_content[:hadith],
          :chain_of_narration => hadith_content[:transmitter]
        }
        workitem.fields['text']['content'] = hadith_content[:hadith]
        workitem.fields['text']['source'] = hadith_content[:narrator]
        reply 
      end

      def read_file(file_name = Qwerty.configuration.hadith_file)
        line = IO.readlines(file_name)
        line.each do |l|
          l.gsub!(/\n/, '')
          num, hadith = l.split(/\s\|\s/)
          hadith, narrator = split_text(hadith)
          (@hadith_collection ||= []) << { num: num, hadith: hadith , narrator: narrator }
        end
        get_random_hadith
      end

      def split_text(hadith)
        /(?<hadith>.+)\.\((?<narrator>.+)\)/ =~ hadith
        return hadith, narrator
      end

      def get_random_hadith
        @hadith_content = hadith_collection.sample
        @hadith_collection.delete_at(hadith_content[:num].to_i - 1)
      end
    end
  end
end
