require 'classifier-reborn'
require 'textoken'
require './lib/qwerty/classifier'

module Qwerty
  class Classifier
    class Bayes < Ruote::Participant
      def on_workitem
        text = workitem.lookup('text.quran.verse.en_sahih')
        workitem.fields['classifier']['bayes'] = {
          :text => text,
          :predict => train_classifier(text),
          :classifications => classifications(text)
        }
        reply
      end

      def train_classifier(text, opts={})
        training_set = if opts[:tags]
                         opts.fetch(:tags)
                       else
                         word_tokenizer(text)
                       end
        bayes = bayes(training_set)
        training_set.each do |t|
          bayes.train(t, text)
        end
        dump_to_file("trained.dat", bayes)
        predict(text)
      end

      def classifications(text)
        classifier = load_from_file("trained.dat")
        word_hash  = classifier.classifications(text)
        word_hash  = word_hash.map { |k, v| [k.downcase, v] }
        word_hash
      end

      def load_from_file(path)
        data = File.read(path)
        Marshal.load(data)
      end

      def dump_to_file(file, snapshot)
        classifier_snapshot = Marshal.dump(snapshot)
        File.open(file, "w") {|f| f.write(classifier_snapshot) }
      end

      def predict(text)
        classifier = load_from_file("trained.dat")
        classifier = classifier.classify_with_score(text)
        category, score = classifier[0].downcase, classifier[1]
        Hash[:category => category, :score => score]
      end

      def bayes(words)
        @bayes ||= ClassifierReborn::Bayes.new(
          words,
          auto_categorize: true,
          enable_threshold: true,
          threshold: -10.0
        )
      end

      def word_tokenizer(word)
        Textoken(
          word,
          exclude: 'dates, numerics, punctuations',
          more_than: 4
        ).words
      end
    end
  end
end
