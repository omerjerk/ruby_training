ENV['RACK_ENV'] = 'test'

require './api_server.rb'
require 'test/unit'
require 'rack/test'

class APITest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_main
    get '/generate'
    assert last_response.ok?
    assert_equal json_response("success"), last_response.body

    5.times {
      get '/get'
      assert last_response.ok?
    }

    get '/get'
    assert last_response.ok?
    assert_equal json_response("key_not_available"), last_response.body

    get '/generate'
    assert last_response.ok?

    get '/get'
    assert last_response.ok?
    key = JSON.parse(last_response.body)["result"]

    get '/delete', :key => key
    assert last_response.ok?
    assert_equal json_response("success"), last_response.body
  end

end

