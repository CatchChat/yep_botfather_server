require File.expand_path('../config/environment', __FILE__)
require 'permessage_deflate'
require 'faye/websocket'
require 'eventmachine'
require 'yep_api'
require 'yep_bot'

unless ENV['PIDFILE'].nil? || ENV['PIDFILE'].empty?
  FileUtils.mkdir_p(File.dirname(ENV['PIDFILE']))
  File.write(ENV['PIDFILE'], Process.pid)
  at_exit { File.delete(ENV['PIDFILE']) }
end

YepBot::App.instance.start!
