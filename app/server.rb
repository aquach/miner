#!/usr/bin/ruby1.8

ENV['EXECJS_RUNTIME'] = 'Node'

require 'rubygems'
require 'sinatra'

set :port, 8000
set :views, :less => 'css', :default => 'views'

get '/' do
  haml :main
end

get '/css/*' do |path|
  less path.gsub(/\..*$/, '').to_sym
end
