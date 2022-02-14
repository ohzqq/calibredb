# frozen_string_literal: true
require 'sequel'
require 'sqlite3'
require 'configatron'

require_relative "calibredb/version"

module Calibredb
  autoload :Models, 'calibredb/models'

  MODELS = {
    "authors" => :Author,
    "books" => :Book,
    "tags" => :Tag,
    "series" => :Series,
    "publishers" => :Publisher,
    "languages" => :Language,
    "ratings" => :Rating,
    "identifiers" => :Identifier,
    "data" => :Datum,
    "custom_columns" => :CustomColumn,
    "comments" => :Comment
  }
end
