module Calibredb
  module Model
    autoload :Author, 'calibredb/model/author'
    autoload :Book, 'calibredb/model/book'
    autoload :Comment, 'calibredb/model/comment'
    autoload :CustomColumn, 'calibredb/model/custom_column'
    autoload :Datum, 'calibredb/model/datum'
    autoload :Identifier, 'calibredb/model/identifier'
    autoload :Language, 'calibredb/model/language'
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
        
        def as_string
          d = data.map(&:value)
          if Calibredb.fields.collections.to_sym.include?(category)
            d.join(", ")
          elsif Calibredb.fields.names.to_sym.include?(category)
            d.join(" & ")
          else
            d.first.to_s
          end
        end

        def as_json(desc = nil, *fields)
          as_hash(desc, *fields).to_json
        end

        def as_hash(desc = nil, *fields)
          d = desc ? data.reverse : data
          d.map do |row|
            meta = {}
            meta[:value] = row.value
            meta[:id] = row.id
            if fields.include?("books")
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
          Calibredb
            .libraries
            .to_h
            .slice(*Calibredb.libraries.list.map(&:to_sym))
            .values
            .select do |l|
            l.db.map(&:object_id).include?(self.model.object_id)
          end.first
        end
      end
    end
  end
end

