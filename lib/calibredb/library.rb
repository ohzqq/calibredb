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
