module Calibredb
  module Book
    module Helpers
      module Dataset
        extend self

        def column
          model
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

        def first
          data.first
        end

        def as_hash(book_ids: nil, book_total: nil, books: nil)
          data.map do |row|
            hashify(row, book_ids: book_ids, book_total: book_total, books: books)
          end
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
