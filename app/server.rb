#!/usr/bin/ruby1.8

require 'rubygems'
require 'sinatra'
require 'haml'
require 'less'
require 'coffee_script'

set :port, 8000
set :views, :coffee => 'js', :less => 'css', :default => 'views'

THIRD_PARTY_JS_FILES = [
  'underscore-min',
  '**/*'
]

JS_FILES = [
  'setup',
  '**/*'
]

SPEC_FILES = [
  '**/*'
]

helpers do
  def find_template(views, name, engine, &block)
    _, folder = views.detect { |k,v| engine == Tilt[k] }
    folder ||= views[:default]
    super(folder, name, engine, &block)
  end

  def find_js(globs, dir)
    globs.map { |glob| Dir[dir + glob + '.{js,coffee}'] }.flatten
  end

  def third_party_js_files
    find_js(THIRD_PARTY_JS_FILES, 'public/third-party-js').map { |filename|
      filename.split('/').drop(1).join('/')
    }
  end

  def app_files
    find_js(JS_FILES, 'js/game/')
  end

  def spec_files
    find_js(SPEC_FILES, 'js/specs/')
  end
end

get '/main' do
  haml :main
end

get '/specs' do
  haml :specs
end

get '/js/*' do |path|
  coffee path.gsub(/\..*$/, '').to_sym
end

get '/css/*' do |path|
  less path.gsub(/\..*$/, '').to_sym
end
