require "./lib/qwerty/text"
require "pry"

module Qwerty
  class Text
    class Quran < Ruote::Participant
      def on_workitem
        workitem.fields['text']['quran'] = {
          :surah => 2,
          :ayah => 3,
          :verse => generate_random_ayah,
          :source => trans_source,
          :language_list => language_list
        }
        reply
      end

      def generate_random_ayah
        find_by_surah_num_and_ayah_num(rand(10), rand(20))
      end

      def find_by_surah_num_and_ayah_num(surah, ayah)
        @collection ||= {}

        quran_transliterations.each do |t|
          trans_name = t.split(/\//).last
          data = read_from_text_file(t)
          @collection[trans_name] = data
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
          verse_t = v.detect { |r| r[:surah] == surah.to_s && r[:ayah] == ayah.to_s }
          if verse_t.any?
            verse_t = verse_t.delete(:verse)
            trans_list[key] = verse_t
          end
        end
        trans_list
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
