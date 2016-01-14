require "./lib/qwerty/text"
require "./lib/qwerty/json_serializer"

module Qwerty
  class Text
    class Quran < Ruote::Participant
      def on_workitem
        process_verse
        workitem.fields['text']['quran'] = {
          :source => trans_source,
          :language_list => language_list,
          :surah => surah,
          :ayah => ayah,
          :verse => random_ayah
        }
        reply
      end

      def process_verse
        @quran ||= {}
        quran_transliterations.each do |key, value|
          path = value.fetch("dir")
          data = read_quran_trans(path)
          @quran[key] = data
        end
        @quran
      end

      def get_row
        @quran.fetch("en_sahih").shuffle.pop
      end

      def random_ayah
        find_by_surah_num_and_ayah_num(get_row[:surah], get_row[:ayah])
      end

      def find_by_surah_num_and_ayah_num(surah, ayah)
        trans_list ||= {}
        @quran.each do |key, v|
          binding.pry
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
          language_list
        end
      end

      def trans_source
        language_list.fetch("en_sahih", {})["source"]
      end

      def language_list
        config.quran.fetch("language_list")
      end

      private

        def read_quran_trans(local_fname)
          file_path = "#{local_fname}.json"
          if trans_file_exists?(file_path)
            load_from_json(file_path)
          else
            generate_quran_trans(local_fname)
          end
        end

        def load_from_json(file_path)
          data = File.read(file_path)
          JSON.parse(data)
        end

        def generate_quran_trans(file_path)
          json = Qwerty::JsonSerializer.new
          json.dump_and_load(file_path)
        end

        def trans_file_exists?(file_path)
          File.exists?(file_path)
        end

        def config
          @config ||= Sinatra::Application.settings
        end
    end
  end
end
