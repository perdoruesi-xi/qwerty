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
            text[key] = read_file(language[key]['dir'])
          end
          workitem.fields['text']['quran_simple'].merge!(text)
          reply
        end 

        def read_file(file_name)
          @collection = Array.new
          File.read(file_name).each_line do |line|
            line.gsub!(/\n/, '')
            surah, ayah, verse = line.split(/\|/)
            @collection << { surah: surah, ayah: ayah, verse: verse}
          end
             random_generate
        end

        def next_relation(random_number)
          x = random_number + 1
          text_verse = text[:verse]
          next_verse = collection[x]
          while text_verse[-2, 2] !~ (/[\.\?\!]/)
            @text[:verse] = text[:verse] + next_verse[:verse]
            text[:ayah] = "#{text[:ayah]}, #{next_verse[:ayah]}"
            text_verse = collection[x][:verse]
            x += 1
            next_verse = collection[x]
          end
        end

        def previous_relation(random_number)
          x = random_number - 1
          previous_verse = collection[x]
          while previous_verse[:verse][-2, 2] !~ (/[\.\?\!]/)
            text[:verse] = previous_verse[:verse] + text[:verse]
            x -= 1
            text[:surah] = text[:surah]
            text[:ayah] = "#{previous_verse[:ayah]}, #{text[:ayah]}"
            previous_verse = collection[x]
          end
        end

        def random_generate
            @random_num = rand(collection.size) if @text == nil
            @text = collection[random_num]
            previous_relation(random_num)
            next_relation(random_num)
            collection.delete_at(random_num)
            return text
        end
      end
    end
  end
end

