module Calibredb
  class Library
    attr_accessor :name, :path, :audiobooks, :custom_columns, :db, :saved_searches, :models

    def initialize(name, meta)
      @name = name
      @path = meta.fetch("path")
      @audiobooks = meta.fetch("audiobooks")
      @custom_columns = {}
      @models = MODELS.transform_keys(&:to_sym)
      #@db = ModelStruct.new
    end

    def connect
      Sequel.sqlite(File.join(@path, "metadata.db"), readonly: true) do |db| 
        db_models(db)
        associations
        CustomColumn.models(db, self)
      end
      @saved_searches = JSON.parse(@models[:preferences][3].val)
      @db = model_struct.new(@models)
    end

    def model_struct
      Struct.new(*@models.keys, keyword_init: true)
    end

    def from(table)
      @db[table]
    end

    private

    def db_models(database)
      MODELS.transform_keys(&:to_sym).each do |table, model|
        @models[table] = Class.new(Sequel::Model)
        @models[table].dataset = database[table.to_sym]
      end
    end

    def associations
      MODELS.transform_keys(&:to_sym).each do |table, model|
        next if table == :preferences
        m = Calibredb::Model.const_get(model).new(self)
        m.associations unless table == :custom_columns
        m.dataset_module
      end
    end
  end
end
