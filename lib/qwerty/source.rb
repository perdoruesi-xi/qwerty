module Qwerty
  class Source < Ruote::Participant
    def on_workitem
      workitem.fields['source'] = {
        :text => "Visit the sick, feed the hungry, free the captive."
      }
      reply
    end
  end
end
