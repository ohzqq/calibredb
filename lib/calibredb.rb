# frozen_string_literal: true
#
Bundler.require(:default)

require_relative "calibredb/version"

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
    configatron_setup
  end

  def configatron_setup
    configatron.list = Calibredb.libraries.map(&:name)

    configatron.update = Calibredb.libraries.first.name
    configatron.default = Calibredb.libraries.first.name

    configatron.current = Configatron::Dynamic.new do
      library = 
        if configatron.has_key?(:update)
          configatron.default = configatron.update
          self.libraries[configatron.update].connect
          configatron.update 
        else
          configatron.default
        end
      self.libraries[library]
    end
  end

  def filter(cmd: nil, args: nil, options: {})
    configatron.update = options.fetch("library") if options.key?("library")
    Calibredb::Filter.new.results(cmd: cmd, args: args, options: options)
  end

  def db(library)
    self.libraries[library.to_s].db
  end

  def fields(library = configatron.current.name)
    Calibredb::Fields.new(library)
  end
  
  def connect
    @libraries.each_entry { |library| library.connect }
  end

  def read_config(config)
    YAML.safe_load_file(config)
  end
end
