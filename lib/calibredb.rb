# frozen_string_literal: true
Bundler.require(:default)

require_relative "calibredb/version"

module Calibredb
  autoload :Model, 'calibredb/model'
  autoload :Library, 'calibredb/library'
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
    "preferences" => :Preference,
    "publishers" => :Publisher,
    "ratings" => :Rating,
    "series" => :Series,
    "tags" => :Tag
  }

  def configure(libraries: nil, config: nil)
    libraries ||= read_config(config)

    @libraries = {}
    libraries.each do |name, meta|
      const = constantize(name)
      Library.configure(name, const, meta.transform_keys(&:to_s))
      @libraries[name] = self.const_get(const)
    end
  end

  def db(library)
    self.libraries[library.to_s]
  end

  def connect
    @libraries.each_key { |library| @libraries[library].connect }
  end

  def read_config(config)
    YAML.safe_load_file(config)
  end

  def constantize(name)
    name.gsub(/[[:punct:]]/, " ")
      .split
      .map(&:capitalize)
      .join
      .to_sym
  end
end
