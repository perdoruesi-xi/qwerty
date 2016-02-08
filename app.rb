require "bundler/setup"
require "sinatra"
require "sinatra/config_file"
require "rack/csrf"
require "ruote"
require "json"
require "sinatra/reloader" if development?
require "./lib/qwerty"

# Load application configuration from YAML file.
config_file "./config.yml"

Dir.glob(File.join("lib/qwerty", "**", "*.rb")).each do |klass|
  require_relative klass
end

use Rack::Session::Cookie, :secret => ""
use Rack::Csrf, :raise => true
use Qwerty::TrainClassifier

get '/' do
  engine = ruote
  @ruote.noisy = true

  conveyor do
    initial :text

    section(:text) do
      action(:quran)
    end

    section(:classifier) do
      action(:ots)
      action(:lda)
      action(:bayes)
    end
  end
end
