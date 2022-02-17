# frozen_string_literal: true
require 'sequel'
require 'sqlite3'
require 'yaml'
require 'json'

require_relative "calibredb/version"

module Calibredb
  autoload :Model, 'calibredb/model'
  autoload :Library, 'calibredb/library'
  autoload :Dataset, 'calibredb/dataset'
  autoload :CustomColumns, 'calibredb/custom_columns'
  autoload :CustomColumn, 'calibredb/custom_column'

  attr_accessor :libraries

  extend self

  MODELS = {
    "authors" => :Author,
    "books" => :Book,
    "comments" => :Comment,
    "custom_columns" => :CustomColumn,
    "data" => :Datum,
    "identifiers" => :Identifier,
    "languages" => :Language,
    "publishers" => :Publisher,
    "ratings" => :Rating,
    "series" => :Series,
    "tags" => :Tag
  }

  def configure(libraries: nil)
    libraries ||= read_config

    @libraries = {}
    libraries.each do |name, meta|
      const = constantize(name)
      Library.configure(name, const, meta)
      @libraries[name] = self.const_get(const)
    end
  end

  def db(library)
    self.libraries[library.to_s]
  end

  def connect
    @libraries.each_key { |library| @libraries[library].connect }
  end

  def read_config
    YAML.safe_load_file("tmp/config.yml")
  end

  def constantize(name)
    name.gsub(/[[:punct:]]/, " ")
      .split
      .map(&:capitalize)
      .join
      .to_sym
  end
end
