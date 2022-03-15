module Calibredb
  module Book
    module Helpers
      module Associations
        def map(&block)
          block ? data.map(&block) : map_default
        end

        def map_default
          data.map {|r| r.value.smart_format unless r.value.is_a?(Integer)}
        end

        def id
          data.map(:id)
        end

        def path
          id.to_h {|i| [i, File.join(library.to_s, column.to_s, i.to_s)]}
        end

        def hashify(row, book_ids: nil, book_total: nil, books: nil)
          meta = {}
          meta[:id] = row.id
          meta[:value] = row.value.smart_format
          meta[:book_ids] = book_ids(row.id) if book_ids
          meta[:book_total] = book_total(row.id) if book_total
          meta[:books] = books(row.id) if books
          return meta
        end

        def books(a_id = nil)
          a_id ||= id.first
          data[a_id].books_dataset
        end

        def book_ids(a_id = nil)
          books(a_id).map(:id)
        end

        def book_total(a_id = nil)
          books(a_id).count
        end
      end
    end
  end
end
