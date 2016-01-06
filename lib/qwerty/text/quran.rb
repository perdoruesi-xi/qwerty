require "./lib/qwerty/text"

module Qwerty
  class Text
    class Quran < Ruote::Participant
      def on_workitem
        parse_quran_trans
        workitem.fields['text']['quran'] = {
          :surah => surah,
          :ayah => ayah,
          :verse => random_ayah,
          :source => trans_source,
          :language_list => language_list
        }
        reply
      end

      def parse_quran_trans
        @quran ||= {}
        quran_transliterations.each do |t|
          trans_name = t.split(/\//).last
          data = read_from_text_file(t)
          @quran[trans_name] = data
        end
      end

      def read_from_text_file(path)
        IO.readlines(path).map do |line|
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

      def get_row
        @quran.fetch("en_sahih").sample
      end

      def random_ayah
        find_by_surah_num_and_ayah_num(get_row[:surah], get_row[:ayah])
      end

      def find_by_surah_num_and_ayah_num(surah, ayah)
        trans_list ||= {}
        @quran.each do |key, v|
          verse_t = v.detect { |r| r[:surah] == surah && r[:ayah] == ayah }
          verse_t = verse_t.delete(:verse)
          trans_list[key] = verse_t
        end
        trans_list
      end

      def surah
        get_row[:surah]
      end

      def ayah
        get_row[:ayah]
      end

      def verse
        get_row[:verse]
      end

      def quran_transliterations
        if config.respond_to?(:quran)
          language_list.collect { |_, trans| trans.fetch("dir") }
        end
      end

      def trans_source
        language_list.fetch("en_sahih", {})["source"]
      end

      def language_list
        config.quran.fetch("language_list")
      end

      private

        def config
          @config ||= Sinatra::Application.settings
        end
    end
  end
end
