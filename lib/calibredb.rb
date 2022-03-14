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

  attr_accessor :libraries, :lib

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

    libs = Struct.new(*libraries.keys.map(&:to_sym) + [:list, :default, :update])do
      def current
        Calibredb.libraries[update]
      end
    end
    @libraries = libs.new
    @libraries.list = libraries.keys
    @libraries.update = libraries.keys.first
    @libraries.default = libraries.keys.first

    libraries.each do |name, meta|
      library = Library.new(name, meta.transform_keys(&:to_s))
      library.connect
      @libraries[name] = library
    end
  end

  def filter(cmd: nil, args: nil, options: {})
    Calibredb.libraries.update = options.fetch("library") if options.key?("library")
    Calibredb::Filter.new.results(cmd: cmd, args: args, options: options)
  end

  def db(library)
    self.libraries[library.to_s].db
  end

  def fields(library = Calibredb.libraries.current.name)
    Calibredb::Fields.new(library)
  end
  
  def connect
    Calibredb.libraries.list.each do |library|
      Calibredb.libraries[library].connect
    end
  end

  def read_config(config)
    YAML.safe_load_file(config)
  end
end
