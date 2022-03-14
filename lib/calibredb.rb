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

    libs = Struct.new(*libraries.keys.map(&:to_sym))
    @libraries = libs.new

    libraries.each do |name, meta|
      library = Library.new(name, meta.transform_keys(&:to_s))
      library.connect
      @libraries[name] = library
    end
    conf_lib
  end

  def conf_lib
    idk = [:list, :default, :update] + Calibredb.libraries.map(&:name)
    @lib = Struct.new(*idk) do
      def current
        Calibredb.libraries[update]
      end
    end.new
    @lib.list = Calibredb.libraries.map(&:name)
    @lib.update = Calibredb.libraries.first.name
    @lib.default = Calibredb.libraries.first.name
  end

  def filter(cmd: nil, args: nil, options: {})
    Calibredb.lib.update = options.fetch("library") if options.key?("library")
    Calibredb::Filter.new.results(cmd: cmd, args: args, options: options)
  end

  def db(library)
    self.libraries[library.to_s].db
  end

  def fields(library = Calibredb.lib.current.name)
    Calibredb::Fields.new(library)
  end
  
  def connect
    @libraries.each_entry { |library| library.connect }
  end

  def read_config(config)
    YAML.safe_load_file(config)
  end
end
