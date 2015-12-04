require_relative 'text'
module Qwerty
  class Text
    class QuranSimple < Ruote::Participant

      def on_workitem
        workitem.fields['text'][:quran_simple] = {
            :source => "http://tanzil.info",
            :languageList => language_list
          }

        reply # work done, let flow resume
      end

      def language_list
        config[:quran_simple]
      end

      def config
        load_yaml_file
      end

      def load_yaml_file(file_name='./config.yml')
        raw_config = File.open(file_name)
        yaml = YAML::load(raw_config)

        symbolize_keys(yaml)
      end

      def symbolize_keys(hash)
        hash.inject({}) { |res, (k, v)|
          n_k = k.is_a?(String) ? k.to_sym : k
          n_v = v.is_a?(Hash) ? symbolize_keys(v) : v
          res[n_k] = n_v
          res
        }
      end
    end
  end
end