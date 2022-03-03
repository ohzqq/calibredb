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
    authors: :Author,
    books: :Book,
    comments: :Comment,
    custom_columns: :CustomColumn,
    data: :Datum,
    identifiers: :Identifier,
    languages: :Language,
    preferences: :Preference,
    publishers: :Publisher,
    ratings: :Rating,
    series: :Series,
    tags: :Tag
  }

  ModelStruct = Struct.new(:authors, :books, :comments, :custom_columns, :data, :identifiers, :languages, :preferences, :publishers, :ratings, :series, :tags, :library)

  def configure(libraries: nil, config: nil)
    libraries ||= read_config(config)

    libs = Struct.new(*libraries.keys.map(&:to_sym))
    @libraries = libs.new
    libraries.each do |name, meta|
      const = constantize(name)
      #Library.configure(name, const, meta.transform_keys(&:to_s))
      
      lib = Library.new(name, meta.transform_keys(&:to_s))
      lib.connect
      @libraries[name] = lib
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
