#!/usr/bin/env ruby
# frozen_string_literal: true

#
# parser.rb
# Copyright (C) 2020 vinicius <vinicius@debian>
#
# Distributed under terms of the MIT license.
#

class SalesParser
  attr_accessor :header, :content

  def initialize(filename, tempfile)
    base_path = 'uploads_' + ENV['APP_ENV']
    uploaded_path = "#{base_path}/#{filename}"
    FileUtils.mkdir_p(base_path)
    FileUtils.copy(tempfile.path, uploaded_path)
    preparsed_file = CSV.read(uploaded_path, { col_sep: "\t" })

    @header = preparsed_file[0].map { |column| column.gsub(' ', '_') }
    @content = parse(preparsed_file[1, preparsed_file.length].to_s[1...-1])
  end

  def parse(data)
    transform_content(data)
  end

  private

  def transform_content(data)
    data.gsub('[', '(').gsub(']', ')').gsub('\'', "''").gsub('"', '\'')
  end
end
