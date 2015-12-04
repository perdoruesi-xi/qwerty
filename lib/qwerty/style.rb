module Qwerty
  class Style < Ruote::Participant
    def on_workitem
      workitem.fields[:style] = {
         :font => 'Arial',
         :font_size => set_font_size(workitem.fields['text']['hadith_simple']['num_char']),
         :font_style => "italic",
         :font_weight => "bold",
         :text_decoration => set_text_deco(workitem.fields['text']['hadith_simple']['albanian_tr']),
         :default => 0
      }
      reply # work done, let flow resume
    end

    def set_font_size(text_length)
      case text_length
      when 300..500
        "23px"
      when 500..700
        "18px"
      when 700..100
        "12px"
      else
        "10px"
      end
    end

    def set_text_deco(str)
      str.gsub!("Allahu", "_____Allahu_____")
    end
  end
end