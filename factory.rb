
require 'ruote'
module Qwerty
  class Factory
    include Ruote::LocalParticipant
    def conveyor
      { sabahi: '06:13',
        dreka: '11:24',
        ikindia: '14:07',
        akshami: '16:28',
        jacia: '18:01' }
    end

    def consume(workitem)
      workitem.fields['factory'] = conveyor
      reply_to_engine(workitem)
    end
  end
end
