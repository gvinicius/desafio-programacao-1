#!/usr/bin/env ruby
#
# test_helper.rb
# Copyright (C) 2020 vinicius <vinicius@debian>
#
# Distributed under terms of the MIT license.
#
ENV['RACK_ENV'] = 'test'
ENV['APP_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter %r{^/test|db_manager/}
  add_group "Files", "./**.rb"
end
