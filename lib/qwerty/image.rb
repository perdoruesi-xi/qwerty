require 'rmagick'

module Qwerty
  class Image < Ruote::Participant
    attr_reader :content, :chain_of_narration, :draw, :image
    include Magick
    def on_workitem
      @content = workitem.fields['text']['content']
      @chain_of_narration = workitem.fields['text']['source']
      workitem.fields['image'] = { create_images: image_generate }
      reply
    end

    def image_generate
      @image = Magick::Image.read("./lib/qwerty/images/background-2.jpg").first
      @image = image.adaptive_resize(936, 700)
      style_of_verse
      style_of_narration if has_chain_of_narration?
      create_image('content.jpg')
    end

    def style_of_verse
      render_text = wrap(content)
      size = set_font_size(render_text)
      set_annotate(0, 20, render_text) do
        draw.gravity = Magick::CenterGravity
        draw.fill = "white"
        draw.font = 'fonts/Futura.ttc'
        draw.stroke = 'transparent'
        draw.font_weight = Magick::BoldWeight
        draw.pointsize = size
        draw.font_stretch  = Magick::ExpandedStretch
      end
    end

    def style_of_narration
      set_annotate(250, 10, chain_of_narration) do
        draw.gravity = Magick::SouthGravity
        draw.fill = 'white'
        draw.font = 'fonts/Bodoni_72.ttc'
        draw.font_weight = Magick::BoldWeight
        draw.pointsize = 30
      end
    end

    def set_annotate(x, y, text, &block)
      @draw = Magick::Draw.new
      draw.annotate(image, 0, 0, x, y, text) do
        block.call
      end
    end

    def has_chain_of_narration?
      chain_of_narration
    end

    def create_image(name_of_photo)
      image.write("./lib/qwerty/generate_images/"+"#{name_of_photo}")
    end

    def wrap(text, width=43)
      text.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
    end

    def set_font_size(text)
      case text.length
      when 0..80
        40
      when 81..160
        35
      when 161..290
        30
      else
        28
      end
    end
  end
end
