require 'bundler'
Bundler.require(:development)

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'debug_log'

RSpec.configure do |config|
  config.mock_with :mocha
end
