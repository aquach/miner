#!/usr/bin/ruby

ENV['EXECJS_RUNTIME'] = 'Node'

require 'rubygems'
require 'sinatra'

set :port, 8000
set :bind, '192.168.1.98'
#set :views, :less => 'css', :default => 'views'

get '/' do
  haml :main
end

get '/css/*' do |path|
  less "../css/#{File.basename(path, File.extname(path))}".to_sym
end
