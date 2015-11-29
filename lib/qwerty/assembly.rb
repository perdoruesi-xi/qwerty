module Qwerty
  class Draw < Ruote::Participant
    def on_workitem
      workitem.fields['draw'] = {
        :top => '223px',
        :bottom => workitem.lookup('source.font_size')
      }
      reply
    end
  end
end
