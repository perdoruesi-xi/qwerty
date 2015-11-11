require_relative 'source'
require_relative 'qwerty'
require_relative 'datatype'
require_relative 'factory'
require 'ruote'
require 'rails'
module Qwerty
  class Client
    include QwertyHelper
    def initialize
      add_sector(:source)
      add_sector(:datatype, 'source')
      add_sector(:factory)
      factory = Ruote.define do
        factory_data
        datatype_data
        source_data
        Qwerty::Factory.new
      end
      process = engine.launch(factory)
      r = engine.wait_for(process)
    end
  end
end

Qwerty::Client.new
