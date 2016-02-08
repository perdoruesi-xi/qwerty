module Qwerty
  class Classifier < Ruote::Participant
    def on_workitem
      workitem.fields['classifier'] = {
        :text => workitem.lookup("text.quran.verse.en_sahih")
      }
      reply
    end
  end
end
