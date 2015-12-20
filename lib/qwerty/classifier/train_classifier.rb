require "sinatra/base"
require "sinatra/flash"
require "./lib/qwerty/classifier"

module Qwerty
  class TrainClassifier < Sinatra::Base
    register Sinatra::Flash
    set :root, "./"

    get "/train_set" do
      ots = Qwerty::Classifier::Ots.new
      text  = "Visit the sick, feed the hungry, free the captive."
      keywords = ots.summary(text)[:keywords]
      erb :train_classifier, locals: { text: text, keywords: keywords}
    end

    post "/train_set/new" do
      text = params[:text]
      keywords = params[:keywords]

      bayes = Qwerty::Classifier::Bayes.new
      r = bayes.train_classifier(text, keywords: keywords)

      logger.info "#{r}"
      flash[:success] = r
      redirect "/train_set"
    end
  end
end
