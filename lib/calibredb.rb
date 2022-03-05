# frozen_string_literal: true
#
Bundler.require(:default)

require_relative "calibredb/version"

alias lib configatron

module Calibredb
  autoload :CustomColumn, 'calibredb/custom_column'
  autoload :Fields, 'calibredb/fields'
  autoload :Filter, 'calibredb/filter'
  autoload :Library, 'calibredb/library'
  autoload :Model, 'calibredb/model'

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

  def configure(libraries: nil, config: nil)
    libraries ||= read_config(config)

    libs = Struct.new(*libraries.keys.map(&:to_sym))
    @libraries = libs.new

    libraries.each do |name, meta|
      library = Library.new(name, meta.transform_keys(&:to_s))
      library.connect
      @libraries[name] = library
    end
    configatron
  end

  def configatron
    Calibredb.libraries.each do |l|
      lib[l.name] = l
    end
    
    lib.list = Calibredb.libraries.map(&:name)

    lib.default = Calibredb.libraries.first.name

    lib.current = Configatron::Dynamic.new do
      library = 
        if lib.has_key?(:update)
          lib.default = lib.update
          lib.update 
        else
          lib.default
        end
      lib[library]
    end
  end

  def fields(library = lib.current.name)
    Calibredb::Fields.new(library)
  end
  
  def db(library)
    self.libraries[library.to_s].db
  end

  def connect
    @libraries.each_key { |library| @libraries[library].connect }
  end

  def read_config(config)
    YAML.safe_load_file(config)
  end
end
