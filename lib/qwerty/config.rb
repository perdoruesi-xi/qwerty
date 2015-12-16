module Qwerty
  extend self
  def configuration
    Configuration.new
  end

  class Configuration
    def language_list
      config[:quran_simple]
    end

    def hadith_file
      config[:hadith][:dir]
    end

    def type
      config[:type]
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
      hash.inject({}) do |res, (k, v)|
        n_k = k.is_a?(String) ? k.to_sym : k
        n_v = v.is_a?(Hash) ? symbolize_keys(v) : v
        res[n_k] = n_v
        res
      end
    end
  end
end
