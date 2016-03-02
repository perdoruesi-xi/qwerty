require "./lib/qwerty/text"

module Qwerty
  class Text
    class Quran < Ruote::Participant
      def on_workitem
        @quran_text = parse_quran_trans
        workitem.fields['text']['quran'] = {
          :source => "http://tanzil.info",
          :language_list => translations_list,
          :surah => surah,
          :ayah => ayah,
          :verse => verse
        }
        reply
      end

      def surah
        @quran_text.fetch("surah")
      end

      def ayah
        @quran_text.fetch("ayah")
      end

      def verse
        add_verse(surah, ayah)
      end

      def parse_quran_trans
        quran_transliterations
        translations.fetch("en_sahih").sample
      end

      def add_verse(surah, ayah)
        trans_list ||= {}
        translations.each do |key, trans|
          verse = trans.detect { |r| r["surah"] == surah && r["ayah"] == ayah }.delete("verse")
          trans_list[key] = verse
        end
        trans_list
      end

      def quran_transliterations
        translations_list.collect do |key, translation|
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
