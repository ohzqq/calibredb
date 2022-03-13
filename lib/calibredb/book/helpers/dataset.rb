module URbooks
  module Data
    module Helpers
      module Dataset
        extend self

        def model
          data.model.to_s.split("::")[1..2]
        end

        def column
          model_index[model.last] || custom_column_index[model.last]
        end

        def model_index
          Calibredb::MODELS.transform_values(&:to_s).invert
        end

        def custom_column_index
          Calibredb.db(lib.current.name).custom_columns.transform_values(&:to_s).invert
        end

        def all
          data.all
        end

        def data_get(val)
          data.get(val)
        end

        def association_ids(association)
          data.send(association).map(&:id)
        end

        def association_dataset(association)
          Calibredb
            .db(library)
            .from(association.to_s)
            .data
            .where(id: association_ids(association))
        end

        def first
          data.first
        end

        def as_hash(book_ids: nil, book_total: nil, books: nil)
          data.map do |row|
            hash = hashify(row)
            hash[:book_ids] = book_ids(row.id) if book_ids
            hash[:book_total] = book_total(row.id) if book_total
            hash[:books] = books(row.id) if books
            hash
          end
        end

        def names(dataset)
          Data::Fields::Names.new(dataset)
        end

        def singles(dataset)
          Data::Fields::Singles.new(dataset)
        end

        def collections(dataset)
          Data::Fields::Collections.new(dataset)
        end

        def sort_by_book_count(data)
          data
            .map {|d| [d.books_dataset.count, d.id]}
            .sort
            .map(&:last)
        end
        
        def sorted_book_count_map(cols, sorted)
          result = []
          sorted.each do |id|
            result << cols[id]
          end
          result
        end
      end
    end
  end
end
