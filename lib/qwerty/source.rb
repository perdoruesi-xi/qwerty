# lib/qwerty/source.rb
require "ruote"

module Qwerty
  class Source < Ruote::Participant
    def on_workitem
      workitem.fields['source'] = {
        :font_size => '12px',
        :font_family => 'Helvetica'
      }
      reply # work done, let flow resume
    end
  end
end