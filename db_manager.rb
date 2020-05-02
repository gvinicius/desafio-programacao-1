#!/usr/bin/env ruby
# frozen_string_literal: true

#
# db_manager.rb
# Copyright (C) 2020 vinicius <vinicius@debian>
#
# Distributed under terms of the MIT license.
#
require 'pg'
ENV['APP_ENV'] ||= 'development'

class DbManager
  def self.connection(dbname={})
    db_params = {
      host: ENV['POSTGRES_HOST'],
      user: ENV['POSTGRES_USER'],
      password: ENV['POSTGRES_PASSWORD']
    }

    @@connection ||= PG::Connection.new(db_params)
    @@connection = PG::Connection.new(db_params.merge(dbname)) if dbname != {}
    @@connection
  end

  def self.check_if_exists
    connection.exec_params("SELECT 1 FROM pg_database WHERE datname = '#{ENV['POSTGRES_DATABASE']}'").first&.values&.to_a&.any? || false
  end

  def self.create
    connection.exec_params("CREATE DATABASE #{ENV['POSTGRES_DATABASE']};")
    @@connection.close
    @@connection = nil
    connection({dbname: ENV['POSTGRES_DATABASE']})
  end

  def self.migrate
    connection.exec_params('CREATE TABLE sales (id bigserial primary key, purchaser_name varchar(60), item_description varchar(60), item_price decimal(10,2), purchase_count integer, merchant_address varchar(60), merchant_name varchar(60), file_name varchar(60));')
  end

  def self.drop
    @@connection.close
    @@connection = nil
    connection.exec_params("DROP DATABASE #{ENV['POSTGRES_DATABASE']};")
  end

  def self.insert(table, columns, values)
    connection.exec_params("INSERT INTO #{table} (#{columns.join(',')}) values " + values + ';')
  end

  def self.setup
    drop
    create
    migrate
  end

  def self.list(table)
    connection.exec_params("SELECT * FROM #{table};")
  end
end
