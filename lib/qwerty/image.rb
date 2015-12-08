require 'awesome_print'
require 'rmagick'
require 'date'
module Qwerty
  class Image < Ruote::Participant
    attr_reader :surah, :ayah, :verse, :source
   include Magick

     def on_workitem
      @surah = workitem.lookup("text.quran_simple.surah")
      @ayah = workitem.lookup("text.quran_simple.ayah")
      @verse = workitem.lookup("text.quran_simple.verse.sq_nahi")
   
      workitem.fields['image'] = { result: image_generate }
      reply # work done, let flow resume
    end

   def image_generate
     @source = Magick::Image.read("./lib/qwerty/images/background-#{rand(1..5)}.jpg").first
     generate_verse
     generate_syrah_ayah
     create_image          
   end
   
   def generate_verse
     render_text = verse
     text = Magick::Draw.new

     text.annotate(source, 0,0,0, 0, render_text) do 
        self.gravity = Magick::CenterGravity
        self.fill = "#ffffff  "
        self.font = 'fonts/Futura.ttc'
        self.stroke = 'transparent'
        self.font_weight = Magick::BoldWeight
        self.pointsize = 52
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
     timestamp = ::Date.today.to_time.to_i
     file_name = "sq_nahi" #ME HEK
     source.write("./lib/qwerty/generate_images/"+"#{surah}.#{ayah}.#{file_name}.jpg")
   end
  end
end

