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
require 'csv'
require 'byebug'
ENV['APP_ENV'] ||= 'development'
Dotenv.load(".env.#{ENV['APP_ENV']}")

set :bind, '0.0.0.0'

get '/' do
  erb :index
end

post '/upload' do
  base_path = 'uploads_' + ENV['APP_ENV']
  uploaded_path = "#{base_path}/#{params[:file][:filename]}"
  FileUtils.mkdir_p(base_path)
  FileUtils.copy(params[:file][:tempfile].path, uploaded_path)
  parsed_file = CSV.read(uploaded_path, { col_sep: "\t" })
  sales = parsed_file[1, parsed_file.length].to_s[1...-1].gsub('[', '(').gsub(']', ')').gsub('\'', "''").gsub('"', '\'')
  # byebug
  # puts sales

  DbManager.insert('sales', parsed_file[0].map { |column| column.gsub(' ', '_') }, sales)
  redirect('/')
end
