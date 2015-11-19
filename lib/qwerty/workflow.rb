require "active_support/inflector"
require "ruote"

module Qwerty
  module Workflow
    def line(class_name)
      class_name = class_name.to_s
      constant_name = "Qwerty::#{class_name.camelize}"
      @ruote.register_participant("#{class_name}_data", constant_name.constantize)
    rescue NameError
      halt 500, "#{constant_name} is not defined. Create a new class to lib/qwerty/#{class_name}.rb"
    end

    def conveyor(opts={}, &block)
      process_definition_name = opts[:name].to_s
      Ruote.define(:name => process_definition_name) do
        instance_eval(&block) if block_given?
      end
    end

    def ruote
      @ruote ||= Ruote::Engine.new(Ruote::Worker.new(Ruote::HashStorage.new()))
    end
  end
end
# Helper methods can be separately defined in a module
helpers Qwerty::Workflow
