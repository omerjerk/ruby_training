#!/usr/bin/ruby

require 'sinatra'
require 'json'

require './api.rb'

before '/*' do
  content_type 'application/json'
end

def json_response(result)
  JSON.generate({:result => result})
end

get '/generate' do
  json_response(API::generate_keys)
end

get '/get' do
  json_response(API::get_available_key)
end

get '/unblock' do
  json_response(API::unblock(params[:key]))
end

get '/delete' do
  json_response(API::delete(params[:key]))
end

get '/live' do
  json_response(API::live(params[:key]))
end
