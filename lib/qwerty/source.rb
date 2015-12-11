module Qwerty
  class Source < Ruote::Participant
    def on_workitem
      workitem.fields['source'] = {
        :font_size => '12px',
        :font_family => 'Helvetica',
        :font_weight => '400' 
      }
      reply # work done, let flow resume
    end
  end
end