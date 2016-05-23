$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'
Bundler.require(:default, ENV['RACK_ENV'])

Dotenv.load!
Dir[File.expand_path('../initializers/*.rb', __FILE__)].each do |file|
  require file
end
