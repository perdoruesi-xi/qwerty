module Qwerty
  class Classifier < Ruote::Participant
    def on_workitem
      workitem.fields['classifier'] = {
        :key => 'value'
      }
      reply
    end
  end
end