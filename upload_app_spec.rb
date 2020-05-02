#!/usr/bin/env ruby
#
# uploader_spec.rb
# Copyright (C) 2020 vinicius <vinicius@debian>
#
# Distributed under terms of the MIT license.
#

ENV['RACK_ENV'] = 'test'

require './upload_app.rb'
require './db_manager.rb'
require 'minitest/autorun'
require 'rack/test'
require 'byebug'

class UploaderTest < Minitest::Test
  include Rack::Test::Methods

  def app
    DbManager.setup
    Sinatra::Application
  end

  def test_index
    get '/'
    assert_match /Upload/, last_response.body
  end
end
