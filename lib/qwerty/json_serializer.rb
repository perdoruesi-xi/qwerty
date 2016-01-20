require "active_support/all"

module Qwerty
  class JsonSerializer
    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def dump_and_load
      file_content ||= []
      open(file_path) { |f|
        f.slice_after(%r{(\.|\?)\n}).each { |lines|
          values = lines.collect { |line| line.split(%r{\|}) }.transpose
          file_content.push(
            transform_hash(values)
          )
        }
      }
      create_file(file_path, file_content)
      file_content
    end

    def create_file(file_path, content)
      json = JSON.generate(content)
      write_to_file(file_path, json)
    end


    def write_to_file(file_path, json)
      local_fname = "#{file_path}.json"
      File.open(local_fname, "w") do |f|
        f.write(json)
      end
    end

    private

    def transform_hash(ary)
      %w(surah ayah verse).zip(ary).map do |k, v|
        [transform_key(k), transform_value(k, v)]
      end.to_h
    end

    def transform_key(key)
      key.to_sym
    end

    def transform_value(key, value)
      case transform_key(key)
      when :surah
        value.fetch(0)
      when :ayah
        value.join(',')
      when :verse
        value.join.squish
      end
    end
  end
end
