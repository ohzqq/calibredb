module Calibredb
  module Book
    module Fields
      class Path
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Dataset
        include Calibredb::Book::Helpers::Formats

        attr_accessor :book, :data

        def initialize(book, data)
          @book = book
          @data = data
          @path = book.path
        end

        def as_hash(book_ids: nil, book_total: nil)
          meta = {value: @path}
        end

        def path
          self
        end

        def get(format = nil)
          format ? format_data(@book, format.to_s) : @path
        end
      end
    end
  end
end
