require_relative 'text'
module Qwerty
  class Text
    class Hadith < Ruote::Participant
      
      attr_accessor :hadith_content
      
      def initialize
        @collection = Array.new
        @hadith_content = Array.new
        read_file(source_file)
      end

      def on_workitem
        workitem.fields['text']['hadith_simple'] = {
          :source => source_file,
          :book => "Sahih al-Bukhari",
          :num_char => num_char,
          :num_hadith => @hadith_content[:num],
          :english_tr => "",
          :albanian_tr =>  @hadith_content[:hadith],
          :chain_of_narration => "Bukhari & Muslimi"
        }
        reply # work done, let flow resume
      end

      def read_file(file)
          line = IO.readlines(file)         
          line.each do |l|
            l.gsub!(/\n/, '')
            num, hadith = l.split(/\s\|\s/)
            @collection << { num: num, hadith: hadith } 
          end 
          generate_hadith   
      end
      
      def source_file
        "./lib/qwerty/hadithfile"
      end


      def generate_hadith
          # generate hadith from file that have hadiths
          @hadith_content = @collection.sample
          @collection.delete_at(@hadith_content[:num].to_i - 1)         
      end

      def num_char
          @hadith_content[:hadith].length
      end
    end
  end
end