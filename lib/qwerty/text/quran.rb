require './lib/qwerty/text'
require 'pry'

module Qwerty
  class Text
    class Quran < Ruote::Participant
      def on_workitem
        workitem.fields['text']['quran'] = {
          :verse => find_by_surah_num_and_ayah_num(2, 3),
          :source => "http://tanzil.info",
          :language_list => {}
        }
        reply
      end

      # :ar_jalalayn => {
      #   :english_name => "English",
      #   :native_name => "Ελληνικά",
      #   :dir => "",
      # }
      def find_by_surah_num_and_ayah_num(surah, ayah)
        quran_transliterations = [
          "lib/qwerty/trans/de_aburida",
          "lib/qwerty/trans/en_sahih",
          "lib/qwerty/trans/tr_yildirim"
        ]
        @collection ||= {}

        quran_transliterations.each do |t|
          trans_name = t.split(/\//).last
          content = read_from_text_file(t)
          @collection[trans_name] = content
        end
        parse_quran_trans(surah, ayah)
      end

      def read_from_text_file(path)
        IO.readlines(path).collect do |line|
          line.chomp!
          next if line.empty?
          a_line = line.split(/\|/)
          Hash[
            :surah => a_line[0],
            :ayah  => a_line[1],
            :verse => a_line[2]
          ]
        end
      end

      def parse_quran_trans(surah, ayah)
        trans_list ||= {}
        @collection.each do |key, v|
          trans_list[key] = v.detect { |r| r[:surah] == surah.to_s && r[:ayah] == ayah.to_s }
        end
        trans_list
      end
    end
  end
end
