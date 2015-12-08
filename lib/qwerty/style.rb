module Qwerty
  class Style < Ruote::Participant
    def on_workitem
      workitem.fields[:style] = {
         :font => 'Arial',
         :font_size => set_font_size(workitem.lookup("text.hadith_simple.num_char")),
         :font_style => "italic",
         :font_weight => "bold",
         :text_decoration => "decoration",
         :default => 0
      }
      reply
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
  end
end