require 'ruote'

module Qwerty
  class Source
    include Ruote::LocalParticipant
    def consume(workitem)
      p workitem.fields['source']['prayer_time']['ikindia']
      reply_to_engine(workitem)
    end
  end
end

