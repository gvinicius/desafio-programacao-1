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

class UploaderTest < Minitest::Test
  include Rack::Test::Methods

  def app
    DbManager.drop
    DbManager.create
    Sinatra::Application
  end

  def test_index
    get '/'

    assert_match /Upload/, last_response.body
  end

  def test_upload
    filename = 'file_example.txt'
    post '/upload', file: Rack::Test::UploadedFile.new(filename, 'text/plain')

    assert filename, DbManager.list('uploads')

    system('rm -Rf uploads_test/*')
    DbManager.drop
  end
end
