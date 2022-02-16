# frozen_string_literal: true
require 'sequel'
require 'sqlite3'
require 'yaml'

require_relative "calibredb/version"

module Calibredb
  autoload :Associations, 'calibredb/associations'
  autoload :Models, 'calibredb/models'
  autoload :Library, 'calibredb/library'
  autoload :CustomColumns, 'calibredb/custom_columns'

  include Calibredb::Associations

  attr_accessor :libraries

  extend self

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

  CUSTOM_COLUMNS = {}

  def read_config
    YAML.safe_load_file("tmp/config.yml")
  end

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

  def db_opts(path)
    {adapter: "sqlite", database: path, readonly: true}
  end

  def connect
    configure
    @libraries.each_key do |library|
      lib_db = db(library)
      next if lib_db.path.nil?

      path = File.join(lib_db.path, "metadata.db")
      Sequel.connect(**db_opts(path)) do |database| 
        MODELS.each do |table, model|
          lib_db.const_set(model, Class.new(Sequel::Model))
          lib_db.const_get(model).dataset = database[table.to_sym]
        end

        #custom_column_models(lib_db, database, library)
      end
    end
  end

  def constantize(name)
    name.gsub(/[[:punct:]]/, " ")
      .split
      .map(&:capitalize)
      .join
      .to_sym
  end
end
