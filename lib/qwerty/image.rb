
module Qwerty
  class Image < Ruote::Participant
    def on_workitem    
      workitem.fields['image'] = { 
        quran_image: workitem.lookup("text.quran_simple"),
        hadith_image: workitem.lookup("text.hadith_simple")
      } 
      reply 
    end
  end
end

