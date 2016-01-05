require "sinatra"
require "sinatra/config_file"

module Qwerty
  # Load application configuration from YAML file.
  config_file "./config.yml"

end
