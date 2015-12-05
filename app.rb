require "bundler/setup"
require "sinatra"
require "rack/csrf"
require "ruote"
require "json"
require_relative 'workflow'
require_relative 'workflow'
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
    line :text do 
    line :hadith_simple

    	line :quran_simple do 
        line :datatype 
      end
    end
    # line :style

    line :classifier do
      line :bayes
    end 
  end
end
