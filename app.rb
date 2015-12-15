require "bundler/setup"
require "sinatra"
require "rack/csrf"
require "ruote"
require "json"
require './lib/qwerty/classifier'

Dir.glob(File.join("lib/qwerty", "**", "*.rb")).each do |klass|
  require_relative klass
end

require "sinatra/reloader" if development?

use Rack::Session::Cookie, :secret => ""
use Rack::Csrf, :raise => true

get '/' do
  engine = ruote
  @ruote.noisy = true

  conveyor do
    initial :source

    line(:classifier) do
      line(:ots)
      line(:lda)
      line(:bayes)
    end
  end
end

get '/classifier' do
  bayes = Qwerty::Classifier::Bayes.new
  text = "Visit the sick, feed the hungry, free the captive."
  textoken = bayes.word_tokenizer(text)

  erb :classifier, locals: { text: text, textoken: textoken}
end