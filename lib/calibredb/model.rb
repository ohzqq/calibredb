module Calibredb
  module Model
    autoload :Author, 'calibredb/model/author'
    autoload :Book, 'calibredb/model/book'
    autoload :Comment, 'calibredb/model/comment'
    autoload :CustomColumn, 'calibredb/model/custom_column'
    autoload :Datum, 'calibredb/model/datum'
    autoload :Identifier, 'calibredb/model/identifier'
    autoload :Language, 'calibredb/model/language'
    autoload :NameColumn, 'calibredb/model/name_column'
    autoload :Publisher, 'calibredb/model/publisher'
    autoload :Rating, 'calibredb/model/rating'
    autoload :Series, 'calibredb/model/series'
    autoload :Shared, 'calibredb/model/shared'
    autoload :Tag, 'calibredb/model/tag'

    def shared_dataset_modules
      @model.dataset_module do
        def data
          default
        end

        def library
          Calibredb.const_get(default.model.to_s.split("::")[1])
        end
      end
    end

  end
end

