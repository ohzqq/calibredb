module Calibredb
  module Library
    extend self

    def configure(name, const, meta)
      lib = Calibredb.const_set(const, lib_module)
      lib.name = name
      lib.path = meta["path"]
      lib.audiobooks = meta["audiobooks"]
      lib.custom_columns = {}
      lib.models = MODELS
    end

    def lib_module
      Module.new do
        def self.[](table)
          self.const_get(@models[table.to_s])
        end

        def self.from(table)
          self.const_get(@models[table.to_s])
        end

        def self.connect
          path = File.join(@path, "metadata.db")
          db_opts = {adapter: "sqlite", database: path, readonly: true}

          Sequel.connect(**db_opts) do |database| 
            MODELS.each do |table, model|
              self.send(:remove_const, model) if self.const_defined?(model)
              self.const_set(model, Class.new(Sequel::Model))
              self.const_get(model).dataset = database[table.to_sym]
            end

            models = Calibredb::Associations.new(self)
            MODELS.each do |table, model|
              next if table == "custom_columns"
              models.send(table)
            end

            CustomColumns.new(database, self).models
          end
        end

        def self.name
          @name
        end

        def self.name=(name)
          @name = name
        end

        def self.path
          @path
        end

        def self.path=(path)
          @path = path
        end

        def self.audiobooks
          @audiobooks
        end

        def self.audiobooks=(audiobooks)
          @audiobooks = audiobooks
        end

        def self.custom_columns
          @custom_columns
        end

        def self.custom_columns=(custom_columns)
          @custom_columns = custom_columns
        end

        def self.models
          @models
        end

        def self.models=(models)
          @models = models
        end
      end
    end
  end
end
