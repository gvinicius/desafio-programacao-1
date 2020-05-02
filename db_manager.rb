#!/usr/bin/env ruby
# frozen_string_literal: true

#
# db_manager.rb
# Copyright (C) 2020 vinicius <vinicius@debian>
#
# Distributed under terms of the MIT license.
#
require 'pg'

class DbManager
  def self.connection
    db_params = {
      host: ENV['POSTGRES_HOST'],
      user: ENV['POSTGRES_USER'],
      password: ENV['POSTGRES_PASSWORD']
    }

    @@connection ||= PG::Connection.new(db_params)
    @@connection
  end

  def self.check_if_exists
    connection.exec_params("SELECT 1 FROM pg_database WHERE datname = '#{ENV['POSTGRES_DATABASE']}'").first&.values&.to_a&.any? || false
  end

  def self.create
    connection.exec_params("CREATE DATABASE #{ENV['POSTGRES_DATABASE']};")
  end

  def self.migrate
    connection.exec_params('CREATE TABLE uploads (id bigserial primary key, filename varchar(20) NOT NULL);')
  end

  def self.drop
    connection.exec_params("DROP DATABASE #{ENV['POSTGRES_DATABASE']};")
  end

  def self.setup
    unless check_if_exists
      create
      migrate
    end
  end

  def self.insert(table, columns, values)
    connection.exec_params("INSERT INTO #{table} (#{columns.join(',')}) values (#{values.map { |value| "'#{value}'" }.join(',')});")
  end

  def self.list(table)
    connection.exec_params("SELECT * FROM #{table};")
  end
end
