module Qwerty
  class Draw < Ruote::Participant
    def on_workitem
      workitem.fields['draw'] = {
        :key => 'value'
      }
      reply # Work done, let flow resume
    end
  end
end
