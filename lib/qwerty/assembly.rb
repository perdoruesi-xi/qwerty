# lib/qwerty/assembly.rb
require "ruote"

module Qwerty
  class Assembly
    include Ruote::LocalParticipant

    def consume(workitem)
      workitem.fields['assembly'] = {
        :text => 'Git LFS is now available for all repositories.',
        :size => workitem.fields['source']['font_size']
      }

      puts "Assembly: #{workitem.fields['assembly']}"
      reply_to_engine(workitem)
    end
  end
end
