# lib/qwerty/tfidf.rb
require './lib/qwerty/classifier'

module Qwerty
	class Classifier
	  class Tfidf < Ruote::Participant
	    def on_workitem
				verse = workitem.lookup('text.quran_simple.verse.en_ahmedali')
	      workitem.fields['classifier']['tfidf'] = {
					:name => 'tf-idf weights',
	        :text => verse,
					:category => classify(verse),
					:tokenizer => word_tokenizer(verse)
	      }
	      reply # Work done, let flow resume
	    end

			def classify(text)
				textoken = word_tokenizer(text)
				store = file_storage('tfidf')
				tfidf = tfidf(textoken, storage: store)
				textoken.each do |t|
					tfidf.train(t.to_sym, text)
				end
				tfidf.save_state
				classify_with_score(text)
			end

			def classify_with_score(text)
				@tfidf.classify(text)
			end

			def file_storage(path)
				local_file = StuffClassifier::FileStorage.new(path)
				StuffClassifier::Base.storage = local_file
			end

			def tfidf(textoken, options={})
        storage = options[:storage] || nil
        @tfidf ||= StuffClassifier::TfIdf.new(textoken, storage: storage)
      end

			def word_tokenizer(word)
				Textoken(word, exclude: 'punctuations, numerics', more_than: 4).words
			end
	  end
	end
end
