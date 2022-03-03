module Calibredb
  class Library
    attr_accessor :name, :path, :audiobooks, :custom_columns, :db, :saved_searches

    def initialize(name, meta)
      @name = name
      @path = meta.fetch("path")
      @audiobooks = meta.fetch("audiobooks")
      @custom_columns = {}
      @db = ModelStruct.new
      @db.library = name
    end

    def connect
      Sequel.sqlite(File.join(@path, "metadata.db"), readonly: true) do |db| 
        db_models(db)
        associations
        #CustomColumn.models(db, self)
      end
      @saved_searches = JSON.parse(@db.preferences[3].val)
    end

    def from(table)
      @db[table]
    end

    private

    def db_models(database)
      MODELS.each do |table, model|
        @db[table] = Class.new(Sequel::Model)
        @db[table].dataset = database[table.to_sym]
      end
    end

    def associations
      MODELS.each do |table, model|
        next if table == "preferences"
        m = Calibredb::Model.const_get(model).new(@db)
        m.associations unless table == "custom_columns"
        m.dataset_module
      end
    end
  end
end
