#!/usr/bin/env ruby
# frozen_string_literal: true

#
# uploader.rb
# Copyright (C) 2020 vinicius <vinicius@debian>
#
# Distributed under terms of the MIT license.
#

require 'dotenv'
require './db_manager.rb'
require './sales_parser.rb'
require 'sinatra'
require 'pg'
require 'csv'
ENV['APP_ENV'] ||= 'development'
Dotenv.load(".env.#{ENV['APP_ENV']}")

set :bind, '0.0.0.0'

get '/' do
  erb :index
end

post '/upload' do
  sales = SalesParser.new(params[:file][:filename], params[:file][:tempfile])

  DbManager.insert('sales', sales.header, sales.content)
  redirect('/revenues')
end

get '/revenues' do
  @revenues = DbManager.aggregate

  erb :revenues
end
