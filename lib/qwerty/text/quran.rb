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
        quran_transliteration = [
          "lib/qwerty/trans/de_aburida",
          "lib/qwerty/trans/en_sahih"
        ]
        @collection ||= {}
        quran_transliteration.each do |t|
          t_name = t.split(/\//).last
          content = IO.readlines(t).map do |line|
            line.chomp!
            next if line.empty?

            r = line.split(/\|/)
            Hash[
              :surah => r[0],
              :ayah  => r[1],
              :verse => r[2]
            ]
          end
          @collection[t_name] = content
        end

        trans_list ||= {}

        @collection.each do |key, v|
          verse_t = v.detect { |r| r[:surah] == surah.to_s && r[:ayah] == ayah.to_s }
          if verse_t.any?
            verse_t = verse_t.delete(:verse)
            trans_list[key] = verse_t
          end
        end
        trans_list
      end
    end
  end
end
