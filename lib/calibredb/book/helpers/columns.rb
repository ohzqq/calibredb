module URbooks
  module Data
    module Helpers
      module Columns
        extend self

        def model
          book.model.to_s.split("::")[1..2]
        end

        def data
          book[column]
        end

        def as_hash(book_ids: nil, book_total: nil)
          meta = {value: get}
        end

        def misc(column)
          Data::Fields::Misc.new(data, column)
        end

        def dates(column)
          Data::Fields::Dates.new(data, column)
        end
      end
    end
  end
end
