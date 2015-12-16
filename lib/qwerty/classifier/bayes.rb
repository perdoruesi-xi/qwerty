require 'classifier-reborn'
require 'textoken'
require './lib/qwerty/classifier'
require './lib/qwerty/text'
require './lib/qwerty/config'

module Qwerty
  class Classifier
    class Bayes < Ruote::Participant
      def on_workitem
        text = workitem.fields['text']['content'] 
        workitem.fields['classifier']['bayes'] = {
          :text => text,
          :classify => train_classifier(text),
          :classifications => classifications(text)
        }
        reply
      end

      def train_classifier(text)

        training_set = word_tokenizer(text)
        bayes = bayes(training_set)
        training_set.each do |t|
          bayes.train(t, text)
        end
        snapshot = Marshal.dump(bayes)
        write_to_file("classifier.dat", snapshot)
        classify(text)
      end

      def write_to_file(storage_path, snapshot)
        File.open(storage_path, "w") {|f| f.write(snapshot) }
      end

      def classifications(text)
        word_hash = @bayes.classifications(text)
        word_hash = word_hash.map { |k, v| [k.downcase, v] }
        word_hash
      end

      def load_from_file(path)
        data ||= File.read(path)
        Marshal.load(data)
      end

      def classify(text)
        classifier = load_from_file("classifier.dat")
        classifier = classifier.classify_with_score(text)
        category, score = classifier[0].downcase, classifier[1]
        Hash[:category => category, :score => score]
      end

      def bayes(words)
        @bayes ||= ClassifierReborn::Bayes.new(words)
      end

      def word_tokenizer(word)
        Textoken(
          word,
          exclude: 'dates, numerics',
          more_than: 4
        ).words
      end
    end
  end
end
