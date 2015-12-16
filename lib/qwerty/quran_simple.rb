require_relative 'text'
require_relative 'config'

module Qwerty
  class Text
    class QuranSimple < Ruote::Participant
      attr_accessor :collection, :row, :random_num

      def on_workitem
        workitem.fields['text'][:quran_simpleb] = {
          :source => "http://tanzil.info",
          :languageList => Qwerty.configuration.language_list,
        }.merge! language_definition
        workitem.fields['text']['content'] = row[:verse][:en_ahmedali]
        workitem.fields['text']['source'] = "KUR'AN #{row[:ayah]}:#{row[:surah]}"
        reply
      end

      def language_definition
        languages = Qwerty.configuration.language_list
        text = {}
        languages.each_key do |language|
           text = get_row(languages[language][:dir], language) 
        end
        return text
      end

      def get_row(dir, language)
        collection_language = "@collection_#{language}"
        instance_variable_set(collection_language, []) unless instance_variable_defined? collection_language
        @collection = instance_variable_get "@collection_#{language}"
        read_file dir if @collection.empty?
        random_generate language
      end

      def read_file(file_name)
        File.read(file_name).each_line do |line|
          line.gsub!(/\n/, '')
          surah, ayah, verse = line.split(/\|/)
          @collection << { surah: surah, ayah: ayah, verse: verse}
        end
      end

      def random_generate(language)
        @random_num = rand(collection.size) if row == nil
        @row = collection[random_num]
        (@verse ||= {}).merge!({ language => row[:verse] })
        row[:verse] = @verse
        collection.delete_at(random_num)
        return row
      end
    end
  end
end
