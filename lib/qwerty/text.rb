module Qwerty
  class Text < Ruote::Participant
    def on_workitem
      workitem.fields['text'] = {
        :format => 'text',
        :type => 'quran',
        :default => 0
      }
      reply
    end
  end
end
