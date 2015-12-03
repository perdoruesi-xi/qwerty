require "ruote"
require_relative "quran_simple"

module Qwerty
  class Text
   class QuranSimple
      class Datatype < Ruote::Participant
        attr_accessor :collection, :text, :random_num

        def on_workitem
          language = workitem.fields['text']['quran_simple']['languageList']
           text = Hash.new
          language.each_key do |key| 
            text = read_file(language[key]['dir'], key)
          end
          workitem.fields['text']['quran_simple'].merge!(text)
          reply
        end 

        def read_file(file_name, key)
          @collection = Array.new
          File.read(file_name).each_line do |line|
            line.gsub!(/\n/, '')
            surah, ayah, verse = line.split(/\|/)
            @collection << { surah: surah, ayah: ayah, verse: verse}
          end
             random_generate(key)
        end

        def random_generate(key)
            @random_num = rand(collection.size) if @text == nil
            @text = collection[random_num]
            (@verse ||= Hash.new).merge!({ key => text[:verse] })
            text[:verse] = @verse
            collection.delete_at(random_num)
            return text
        end
      end
    end
  end
end

