require "bundler/setup"
require "sinatra"
require "sinatra/config_file"
require "rack/csrf"
require "ruote"
require "json"
require "sinatra/reloader" if development?

Dir.glob(File.join("lib/qwerty", "**", "*.rb")).each do |klass|
  require_relative klass
end

use Rack::Session::Cookie, :secret => ""
use Rack::Csrf, :raise => true
use Qwerty::TrainClassifier

# Load application configuration from YAML file.
config_file "./config.yml"

get '/' do
  engine = ruote
  @ruote.noisy = true

  conveyor do
    initial :text

    line(:text) do
      line(:quran)
    end

    line(:classifier) do
      line(:ots)
      line(:lda)
      line(:bayes)
    end
  end
end
