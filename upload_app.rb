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
require 'sinatra'
require 'pg'
Dotenv.load(".env.#{ENV['APP_ENV']}")

set :bind, '0.0.0.0'

get '/' do
  erb :index
end

post '/upload' do
  base_path = 'uploads_' + ENV['APP_ENV']
  FileUtils.mkdir_p(base_path)
  FileUtils.copy(params[:file][:tempfile].path, "#{base_path}/#{params[:file][:filename]}")
  puts ENV['APP_ENV']
  puts ENV['POSTGRES_DATABASE']

  DbManager.insert('uploads', ['filename'], [params[:file][:filename]])
  redirect('/')
end
