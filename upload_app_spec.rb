#!/usr/bin/env ruby
# frozen_string_literal: true

#
# uploader_spec.rb
# Copyright (C) 2020 vinicius <vinicius@debian>
#
# Distributed under terms of the MIT license.
#

ENV['APP_ENV'] = 'test'

require './upload_app.rb'
require './db_manager.rb'
require 'minitest/autorun'
require 'rack/test'
require 'byebug'

class UploaderTest < Minitest::Test
  include Rack::Test::Methods

  def app
    if DbManager.check_if_exists
      DbManager.drop
    end
    DbManager.setup
    Sinatra::Application
  end

  def test_index
    get '/'

    assert_match /Upload/, last_response.body
    # Here the database is not erased because there is no database manipulation there
  end

  def test_upload
    filename = 'example_input.tab'
    post '/upload', file: Rack::Test::UploadedFile.new(filename, 'text/plain')

    assert_equal 'João Silva', DbManager.list('sales').first["purchaser_name"]

    system('rm -Rf uploads_test/*')
    DbManager.drop
  end
end
