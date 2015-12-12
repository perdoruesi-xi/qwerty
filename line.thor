class Line < Thor::Group
  include Thor::Actions

  argument :name
  class_option :subclass, :aliases => "-s"
  class_option :test_framework, :default => :test_unit

  def self.source_root
    File.dirname(__FILE__)
  end

  def create_lib_file
    class_name = name.downcase
    path = options[:subclass] ? "templates/subclass_line.tt" : "templates/line.tt"

    if options[:subclass]
      subclass = options[:subclass].downcase
      find_in_source_paths("lib/qwerty/#{subclass}.rb")
      template(path, "lib/qwerty/#{subclass}/#{class_name}.rb")
      insert_into_file "app.rb", :after => "conveyor do" do
        %(
    line(:#{subclass}) do
      line(:#{class_name})
    end
        )
      end
    else
      template(path, "lib/qwerty/#{class_name}.rb")
      insert_into_file "app.rb", :after => "conveyor do" do
        %(
    line(:#{class_name})
        )
      end
    end
  end
end
