require 'ots'
require './lib/qwerty/classifier'

module Qwerty
  class Classifier
    class Ots < Ruote::Participant
      def on_workitem
        text = workitem.lookup('classifier.text')
        workitem.fields['classifier']['ots'] = {
          :text => text,
          :ots => summary(text)
        }
        reply
      end

      def summary(text)
        ots = OTS.parse(text)
        open_text = {
          :topics => ots.topics,
          :keywords => ots.keywords,
          :percentage_summary => ots.summarize(percent: 50),
          :sentence_summary => ots.summarize(sentences: 1)
        }
        open_text
      end
    end
  end
end
