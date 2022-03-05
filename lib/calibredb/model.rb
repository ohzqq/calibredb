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
    autoload :Preference, 'calibredb/model/preference'
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
        
        def as_json(desc = nil, books = true, *associations)
          as_hash(desc, books, *associations).to_json
        end

        def as_hash(desc = nil, books = true, *associations)
          d = desc ? data.reverse : data
          d.map do |row|
            meta = {}
            meta[:value] = row.value
            meta[:id] = row.id
            if books
              if Calibredb.fields.many_books_to_many.to_sym.include?(category) ||
                  Calibredb.fields.one_to_many_books.to_sym.include?(category)
                meta[:book_ids] = row.books_dataset.map(:id)
                meta[:total_books] = row.books_dataset.count
              end
            end
            #meta[:url] = "/#{library.name}/#{category}/#{row.id}"
            meta
          end
        end

        def library
          Calibredb.libraries.select do |l|
            l.db.values.include?(self.model)
          end.first
        end
      end
    end
  end
end

