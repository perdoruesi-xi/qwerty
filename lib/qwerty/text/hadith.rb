require './lib/qwerty/text'

module Qwerty
  class Text
    class Hadith < Ruote::Participant
      def on_workitem
        a_hadith = random_hadith
        workitem.fields['text']['hadith'] = {
          :source => a_hadith["source"],
          :chapter => a_hadith["chapter"],
          :arabic => a_hadith["arabic"],
          :transliteration => a_hadith["transliteration"],
          :chain_of_narration => a_hadith["chain_of_narration"]
        }
        reply
      end

      def random_hadith
        read_trans_file("lib/qwerty/trans/hadith/sahih_muslim").sample
      end

      def read_trans_file(filename)
        local_fname = "#{filename}.json"
        if File.exists?(local_fname)
          data = File.read(local_fname)
          JSON.parse(data)
        else
          raise StandardError, "file missing: #{local_fname}"
        end
      end
    end
  end
end
