require_relative 'text'
module Qwerty
  class Text
    class QuranSimple < Ruote::Participant

      def on_workitem
        workitem.fields['text'][:quran_simple] = {
            :source => "http://tanzil.info",
            :languageList => language_list 
          }

        reply # work done, let flow resume
      end

      def language_list 
       {  :de_aburida => {
            :english_name => "German",
            :native_name => "Ελληνικά",
            :dir => "./lib/qwerty/de_aburida",
            :is_pack => 1
          },
          :sq_nahi => {
            :english_name => "Shqip",
            :native_name => "العربية",
            :dir => "./lib/qwerty/sq_nahi",
            :is_pack => 1
          }
       }
      end
    end
  end
end