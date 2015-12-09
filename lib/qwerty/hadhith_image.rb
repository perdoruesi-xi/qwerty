require 'rmagick'

module Qwerty
  class Image
    class HadithImage < Ruote::Participant

      attr_reader :hadith, :num_hadith, :transmitter, :source
      include Magick

       def on_workitem
        @num_hadith = workitem.lookup("image.hadith_image.num_hadith")
        @hadith = workitem.lookup("image.hadith_image.albanian_tr")
        @transmitter = workitem.lookup("image.hadith_image.chain_of_narration")
     
        workitem.fields['image'][:hadith_generate] = { create_hadith_image: image_generate }
        reply 
      end

     def image_generate
       @source = Magick::Image.read("./lib/qwerty/images/background-2.jpg").first
       generate_hadith
       generate_transmitter
       create_image          
     end
     
     def generate_hadith
       text = Magick::Draw.new

       text.annotate(source, 0,0,0, -10, hadith) do 
          self.gravity = Magick::CenterGravity
          self.fill = "#660029"
          self.font = 'fonts/generic-family.ttc'
          self.stroke = 'transparent'
          self.font_weight = Magick::BoldWeight
          self.pointsize = 27
       end
     end

     def generate_transmitter
       format_source = "(#{transmitter})"
       stamp = Magick::Draw.new

       stamp.annotate(source, 0,0,0, 40, "#{format_source}") do 
         self.gravity = Magick::SouthGravity
         self.fill = "#330000"
         self.font = 'fonts/Bodoni_72.ttc'
         self.font_weight = Magick::BoldWeight
         self.pointsize = 35
       end
     end

     def create_image
       source.write("./lib/qwerty/generate_images/"+"#{num_hadith}-hadith.jpg")
       "#{num_hadith}-hadith.jpg"
     end
    end
  end
end

