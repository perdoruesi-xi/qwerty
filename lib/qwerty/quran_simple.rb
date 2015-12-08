require_relative 'text'
require_relative 'config'
module Qwerty
  class Text
    class QuranSimple < Ruote::Participant
      def on_workitem
          workitem.fields['text'][:quran_simple] = {
              :source => "http://tanzil.info",
              :languageList => Qwerty.configuration.language_list
            } 
          reply 
      end
    end
  end
end



