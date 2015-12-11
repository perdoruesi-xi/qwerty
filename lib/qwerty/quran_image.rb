require 'rmagick'

module Qwerty
  class Image
    class QuranImage < Ruote::Participant

      attr_reader :surah, :ayah, :verse, :source
      include Magick

       def on_workitem
        @surah = workitem.lookup("image.quran_image.surah")
        @ayah = workitem.lookup("image.quran_image.ayah")
        @verse = workitem.lookup("image.quran_image.verse.sq_nahi")
     
        workitem.fields['image'][:quran_generate] = { create_quren_image: image_generate }
        reply 
      end

     def image_generate
       @source = Magick::Image.read("./lib/qwerty/images/background-5.jpg").first
       generate_verse
       generate_syrah_ayah
       create_image          
     end
     
     def generate_verse
       render_text = edit_text(verse)
       text = Magick::Draw.new
       

       text.annotate(source, 0,0,0, 0, render_text) do 
          self.gravity = Magick::CenterGravity
          self.fill = "#ffffff  "
          self.font = 'fonts/Futura.ttc'
          self.stroke = 'transparent'
          self.font_weight = Magick::BoldWeight
          self.pointsize = 27
       end
     end

     def generate_syrah_ayah
       format_source = "KUR'AN #{surah}:#{ayah}"
       stamp = Magick::Draw.new

       stamp.annotate(source, 0,0,0,0, "#{format_source}") do 
         self.gravity = Magick::SouthGravity
         self.fill = 'white'
         self.font = 'fonts/Bodoni_72.ttc'
         self.font_weight = Magick::BoldWeight
         self.pointsize = 35
       end
     end

     def create_image
       source.write("./lib/qwerty/generate_images/"+"#{surah}.#{ayah}.jpg")
       "#{surah}.#{ayah}.jpg"
     end

     def edit_text(line)
      if line.length > 80
        (95..115).to_a.each do |i|
          if line[i] == " "
            line[i] = "\\n"
            return line
          end
        end
        
       else 
         return line
      end
     end

    end
  end
end