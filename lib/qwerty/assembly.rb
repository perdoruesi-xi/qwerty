# lib/qwerty/assembly.rb
require "ruote"

module Qwerty
  class Assembly < Ruote::Participant
    def consume(workitem)
      workitem.fields['assembly'] = {
        :text => 'Git LFS is now available for all repositories.',
        :size => workitem.lookup('source.font_size')
      }

      puts "Assembly: #{workitem.lookup('assembly')}"
      reply_to_engine(workitem)
    end
  end
end
