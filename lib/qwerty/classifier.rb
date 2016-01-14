module Qwerty
  class Classifier < Ruote::Participant
    def on_workitem
      workitem.fields['classifier'] = {
        :text => "Allah is Subtle with His servants; He gives provisions to whom He wills. And He is the Powerful, the Exalted in Might.

        " # workitem.lookup("text.quran.verse.en_sahih")
      }
      reply
    end
  end
end
