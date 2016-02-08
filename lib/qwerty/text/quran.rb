require "./lib/qwerty/text"

module Qwerty
  class Text
    class Quran < Ruote::Participant
      def on_workitem
        random_ayah
        workitem.fields['text']['quran'] = {
          :source => "http://tanzil.info",
          :language_list => translations_list,
          :surah => surah.to_s,
          :ayah => ayah,
          :verse => verse
        }
        reply
      end

      def random_ayah
        quran_transliterations
        @quran = translations.fetch("en_sahih").sample
      end

      def surah
        @quran.fetch("surah")
      end

      def ayah
        @quran.fetch("ayah")
      end

      def verse
        find_by_surah_num_and_ayah_num(surah, ayah)
      end

      def find_by_surah_num_and_ayah_num(surah, ayah)
        trans_list ||= {}
        translations.each do |k, v|
          verse_t = v.detect { |r| r["surah"] == surah && r["ayah"] == ayah }
          verse_t = verse_t.delete("verses")
          trans_list[k] = verse_t
        end
        trans_list
      end

      def quran_transliterations
        translations_list.map do |key, translation|
          file_path = translation.fetch("dir")
          translation_text = read_quran_trans(file_path)

          add_translation(key, translation_text)
        end
      end

      def add_translation(key, content)
        translations[key] = content
      end

      def translations_list
        Sinatra::Application.settings.quran["language_list"]
      end

      def translations
        @translations ||= Hash.new
      end

      private

      def read_quran_trans(filename)
        local_fname = "#{filename}.json"
        if exists?(local_fname)
          load_translation(local_fname)
        else
          raise StandardError, "Translation file missing: #{local_fname}"
        end
      end

      def load_translation(filename)
        data = File.read(filename)
        JSON.parse(data)
      end

      def exists?(filename)
        File.exists?(filename)
      end
    end
  end
end
