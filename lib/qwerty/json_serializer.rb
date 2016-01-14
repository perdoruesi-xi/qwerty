module Qwerty
  class JsonSerializer
    def dump_and_load(file_path)
      file_content ||= []
      open(file_path) { |f|
        f.slice_after(/(\.|\?)\n/).each { |elm|
          row ||= elm.join('')
          surah = fetch(row, /(?:^|\n)\d+\|/, sep: ',').chr
          ayah  = fetch(row, /\|\d+\|/, sep: ',')
          verse = row.gsub(/\d+\|\d+\|/, '').chomp!

          attr = attributes_list(surah, ayah, verse)
          file_content.push(attr)
        }
      }
      create_file(file_path, file_content)
      file_content
    end

    def fetch(ary, pattern, sep: '')
      ary.scan(pattern)
        .join(sep)
        .gsub(/\n|\|/, '')
    end

    def attributes_list(surah, ayah, verse)
      Hash[
        :surah => surah,
        :ayah => ayah,
        :verse => verse
      ]
    end

    private

      def create_file(file_path, content)
        json = JSON.generate(content)
        write_to_file(file_path, json)
      end

      def write_to_file(file_path, json)
        local_fname = "#{file_path}.json"
        File.open(local_fname, "w") do |f|
          f.write(json.to_json)
        end
      end
  end
end
