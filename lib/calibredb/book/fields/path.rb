module Calibredb
  module Book
    module Fields
      class Path
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Dataset
        include Calibredb::Book::Helpers::Formats

        attr_accessor :data, :library, :model, :book, :path

        def initialize(book, field)
          @book = book
          @data = book.send(:"#{field}_dataset")
          @library = @data.library.name
          @model = field
          @path = book.path
        end

        def as_hash(book_ids: nil, book_total: nil)
          meta = {value: @path}
        end

        def path
          self
        end

        def get(format = nil)
          format ? Calibredb::Book::Fields::Format.new(@book, format.to_s) : @path
        end
      end
    end
  end
end
