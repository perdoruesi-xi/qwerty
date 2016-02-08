require 'lda-ruby'

module Qwerty
  class Classifier
    class Lda < Ruote::Participant
      def on_workitem
        text = workitem.lookup('classifier.text')
        workitem.fields['classifier']['lda'] = {
          :lda => lda(text)
        }
        reply
      end

      def lda(text)
        corpus.add_document(::Lda::TextDocument.new(corpus, text))
        lda = ::Lda::Lda.new(corpus)
        lda.num_topics = (3)
        lda.em('random')
        lda.top_words(3)
      end

      def corpus
        @corpus ||= ::Lda::Corpus.new
      end
    end
  end
end
