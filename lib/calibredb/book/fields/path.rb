module URbooks
  module Data
    module Fields
      class Path
        include URbooks::Data::Helpers
        include URbooks::Data::Helpers::Dataset
        include URbooks::Data::Helpers::Formats

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
