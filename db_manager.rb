#!/usr/bin/env ruby
#
# db_manager.rb
# Copyright (C) 2020 vinicius <vinicius@debian>
#
# Distributed under terms of the MIT license.
#

class DbManager
  def self.connection
    db_params = {
      host: ENV['POSTGRES_HOST'],
      user: ENV['POSTGRES_USER'],
      password: ENV['POSTGRES_PASSWORD']
    }

    @@connection ||= PG::Connection.new(db_params)
    return @@connection
  end

  def self.check_if_exists
    self.connection.exec_params("SELECT 1 FROM pg_database WHERE datname = '#{ENV['POSTGRES_DATABASE']}'").first&.values&.to_a&.any? || false
  end

  def self.create
    self.connection.exec_params("CREATE DATABASE #{ENV['POSTGRES_DATABASE']};")
  end

  def self.migrate
    self.connection.exec_params("CREATE TABLE uploads (id bigserial primary key, filename varchar(20) NOT NULL);")
  end

  def self.drop
    self.connection.exec_params("DROP DATABASE #{ENV['POSTGRES_DATABASE']};")
  end

  def self.setup
    if self.check_if_exists
      self.drop
      self.create
      self.migrate
    end
  end
end
