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
          File.join(library, column, id.to_s)
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

        def hashify(row)
          meta = {}
          meta[:id] = row.id
          meta[:value] = row.value.smart_format
          return meta
        end
      end
    end
  end
end
