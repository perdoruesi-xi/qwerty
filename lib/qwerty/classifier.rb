module Qwerty
  class Classifier < Ruote::Participant
    def on_workitem
      workitem.fields['classifier'] = {
        :classifier => 100
      }
      reply
    end
  end
end