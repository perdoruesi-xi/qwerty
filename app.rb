require "bundler/setup"
require "sinatra"
require "rack/csrf"
require "ruote"
require "json"

Dir.glob(File.join("lib/qwerty", "**", "*.rb")).each do |klass|
  require_relative klass
end

require "sinatra/reloader" if development?

use Rack::Session::Cookie, :secret => ""
use Rack::Csrf, :raise => true

get "/" do
  # FIXME:
  engine = ruote
  line(:source)
  line(:assembly)

  pdef = conveyor(name: 'qwerty') do
    source_data
    assembly_data
  end
  
  @ruote.noisy = true

  process = @ruote.launch(pdef)
  r = @ruote.wait_for(process)
  JSON.pretty_generate(r)
end