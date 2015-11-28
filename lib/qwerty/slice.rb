# lib/qwerty/slice.rb
require "ruote"

module Qwerty
  class Slice < Ruote::Participant
    def on_workitem
      workitem.fields['slice'] = {
        :key => 'value'
      }
      reply # work done, let flow resume
    end
  end
end