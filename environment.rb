require 'rubygems'
require 'sinatra'
require 'mongoid'
require 'mongoid_spacial'
require 'json'
require 'mongoid_grid'
require 'base64'
require 'pusher'

require 'RMagick'
include Magick

set :port, 9494

ENV['RACK_ENV'] = ENV['RACK_ENV'] || 'development'

['model'].each do |directory|
  Dir.glob(File.join(File.join(File.dirname(__FILE__), "."), directory, '*.rb')).each { |rb| require rb }
end

Mongoid.load!("./mongoid.yml")

Pusher.app_id = 'redacted'
Pusher.key = 'redacted'
Pusher.secret = 'redacted'