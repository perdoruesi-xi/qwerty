require "active_support/inflector"

module Qwerty
  module Workflow
    def line(class_name, position: nil, &block)
      class_name = class_name.to_s if class_name.is_a?(Symbol)
      @constant_name ||= "Qwerty"
      @constant_name << "::#{class_name.camelize}"
      register_line(class_name, @constant_name, position)

      block.call if block_given?
      @constant_name.slice!("::#{class_name.camelize}")
    rescue NameError
      halt 500, "#{@constant_name} is not defined. Create a new class to lib/qwerty/#{class_name}.rb"
    end

    def register_line(class_name, constant_name, position)
      @ruote.register_participant("#{class_name}_data",
                                  constant_name.constantize,
                                  :pos => position)
    end

    def conveyor(options={}, &block)
      pdef_name = options[:name].to_s
      instance_eval(&block)

      pdef = assign_workflow(pdef_name, participant_list)
      process = @ruote.launch(pdef)
      ruote = @ruote.wait_for(process)

      erb :index, :locals => { ruote: ruote }
    end

    def assign_workflow(pdef_name, participant_list)
      Ruote.process_definition(:name => pdef_name) do
        participant_list.each do |participant|
          instance_eval(participant)
        end
      end
    end

    def participant_list
      @ruote.participant_list.collect! { |p| p.regex.gsub(/[\^\$]/,'') }
    end

    def initial_state(class_name)
      line(class_name, position: 'first')
    end
    alias_method :initial, :initial_state

    private

    def ruote
      @ruote ||= Ruote::Engine.new(Ruote::Worker.new(Ruote::HashStorage.new()))
    end
  end
end
helpers Qwerty::Workflow
