require 'ruote'

module QwertyHelper
  ENGINE =  Ruote::Engine.new(Ruote::Worker.new(Ruote::HashStorage.new()))
  def engine
     ENGINE
   end

  def add_sector(class_name, superclass_name = nil)
    class_name = class_name.to_s if class_name.is_a?(Symbol)
    if superclass_name != nil
      klass = "Qwerty::#{superclass_name.classify}::#{class_name.classify}"
    else
      klass = "Qwerty::#{class_name.classify}"
    end
    engine.register "#{class_name}_data", klass.constantize
  end
end
