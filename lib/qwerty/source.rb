# lib/qwerty/source.rb
require "ruote"

module Qwerty
  class Source < Ruote::Participant
    def consume(workitem)
      workitem.fields['source'] = {
        :font_size => '12px',
        :font_family => 'Helvetica'
      }
      puts "Source: #{workitem.fields['source']}"
      reply_to_engine(workitem)
    end
  end
end
