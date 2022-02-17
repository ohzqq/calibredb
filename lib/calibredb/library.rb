module Calibredb
  module Library
    extend self

    def configure(name, const, meta)
      lib = Calibredb.const_set(const, library)
      lib.name = name
      lib.path = meta["path"]
      lib.audiobooks = meta["audiobooks"]
      lib.custom_columns = {}
      lib.models = MODELS
    end

    def library
      Module.new do
        def self.[](table)
          self.const_get(@models[table.to_s])
        end

        def self.from(table)
          self.const_get(@models[table.to_s])
        end

        def self.connect
          Sequel.connect(
            {
              adapter: "sqlite",
              database: File.join(@path, "metadata.db"),
              readonly: true
            }
          ) do |database| 

            self.db_models(database)
            self.associations
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

        private

        def self.db_models(database)
          MODELS.each do |table, model|
            self.send(:remove_const, model) if self.const_defined?(model)

            self.const_set(model, Class.new(Sequel::Model))
            self.const_get(model).dataset = database[table.to_sym]
          end
        end

        def self.associations
          MODELS.each do |table, model|
            m = Calibredb::Model.const_get(model).new(self)
            m.associations unless table == "custom_columns"
            m.dataset_module
          end
        end
      end
    end
  end
end
