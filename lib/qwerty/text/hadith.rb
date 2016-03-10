require './lib/qwerty/text'

module Qwerty
  class Text
    class Hadith < Ruote::Participant
      def on_workitem
        workitem.fields['text']['hadith'] = {
          :source => "http://ahadith.co.uk",
          :chapter => "Purification (Kitab Al-Taharah)",
          :arabic => "",
          :transliteration => "Abdullah son of Umar came to Ibn'Amir in order to inquire after his health as he was ailing. He said Ibn 'Umar, why don't you pray to Allah for me? He said: I heard of Allah's Messenger (may peace be upon him) say: Neither the prayer is accepted without purification nor is charity accepted out of the ill-gotten (wealth), and thou wert the (governor) of Basra.",
          :chain_of_narration => "Musab bin Sad"
        }
        reply # Work done, let flow resume
      end
    end
  end
end
