require_relative 'draw'
module Qwerty
  class Draw
    class Crop < Ruote::Participant
      def on_workitem
        workitem.fields['draw']['crop'] = {
          :clip => 'rect(0px,60px,200px,0px);'
        }
        reply
      end
    end
  end
end
