#!/usr/bin/env ruby
#
# uploader.rb
# Copyright (C) 2020 vinicius <vinicius@debian>
#
# Distributed under terms of the MIT license.
#

require 'dotenv'
require './db_manager.rb'
require 'sinatra'
require 'pg'
Dotenv.load(".env.#{ENV['APP_ENV']}") # Remember to set your app environment

set :bind, '0.0.0.0'

get '/' do
  erb :index
end

post '/upload' do
  FileUtils.mkdir_p 'uploads'
  FileUtils.copy(params[:file][:tempfile].path, "./uploads/#{params[:file][:filename]}")

  items = DbManager.connection.exec_params('SELECT * FROM items;')
end
