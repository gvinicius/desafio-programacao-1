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
SimpleCov.coverage_dir('./')
SimpleCov.start
