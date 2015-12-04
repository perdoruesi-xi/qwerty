module Qwerty
  class Source < Ruote::Participant
    def on_workitem
      workitem.fields['source'] = {
        :surah => 14,
        :ayah => 5,
        :verse => 'Who suggests evil thoughts to the hearts of men -- (5)'
      }
      reply
    end
  end
end