require 'ruote'
module Qwerty
  class Source
    class Datatype
      include Ruote::LocalParticipant
      attr_accessor :collection, :text
      def initialize
        @collection = Array.new
        @text = nil
      end
      def read_file(file_name = 'file')
        File.read(file_name).each_line do |line|
          line.gsub!(/\n/, '')
          surah, ayah, verse = line.split(/\|/)
          collection << { surah: surah, ayah: ayah, verse: verse}
        end
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

      def random_generate(conveyor)
        if collection.empty?
          read_file
        end
        conveyor.each do |key, value|
          random_num = random_number
          previous_relation(random_num)
          next_relation(random_num)
          collection.delete_at(random_num)
          conveyor[key] = { time: value }.merge!(text)
        end
        return conveyor
      end

      def random_number
        ran_number = rand(collection.size)
        @text = collection[ran_number]
        return ran_number
      end

      def consume(workitem)
        workitem.fields['source'] = { :prayer_time => random_generate(workitem.fields['factory']) }
        reply_to_engine(workitem)
      end
    end
  end
end
