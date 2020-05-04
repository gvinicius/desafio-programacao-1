#!/usr/bin/env ruby
# frozen_string_literal: true

#
# uploader_spec.rb
# Copyright (C) 2020 vinicius <vinicius@debian>
#
# Distributed under terms of the MIT license.
#

require './test_helper.rb'
require './sales_parser.rb'
require './db_manager.rb'
require 'minitest/autorun'
require 'rack/test'
require './upload_app.rb'

class UploadAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    # Erase database everytime in order to prevent undesirable data
    DbManager.drop if DbManager.check_if_exists
    DbManager.setup
  end

  def test_index
    get '/'

    assert last_response.ok?
    assert_match(/Upload/, last_response.body)
  end

  def test_sales_parser
    sales = SalesParser.new('example_input.tab', File.new('example_input.tab'))

    assert_equal('purchaser_name', sales.header.first)
  end

  def test_upload
    filename = 'example_input.tab'
    post '/upload', file: Rack::Test::UploadedFile.new(filename, 'text/plain')

    assert_equal('João Silva', DbManager.list('sales').first['purchaser_name'])

    system('rm -Rf uploads_test/*')
  end

  def test_revenues
    filename = 'example_input.tab'
    post '/upload', file: Rack::Test::UploadedFile.new(filename, 'text/plain')
    get '/revenues'

    assert_equal(DbManager.aggregate.to_f, 95.0)
    assert_match(DbManager.aggregate, last_response.body)
  end
end
