class Line < Thor::Group
  include Thor::Actions

  argument :name
  class_option :test_framework, :default => :test_unit

  def self.source_root
    File.dirname(__FILE__)
  end

  def create_lib_file
  	file_name = name.downcase
    template('templates/line.tt', "lib/qwerty/#{file_name}.rb")

    insert_into_file "app.rb", :after => "conveyor do\n" do 
		  "    line(:#{file_name})\n"
		end
  end

  def create_test_file
    test = options[:test_framework] == "rspec" ? :spec : :test
    create_file "#{test}/#{name.downcase}_#{test}.rb"
  end
end