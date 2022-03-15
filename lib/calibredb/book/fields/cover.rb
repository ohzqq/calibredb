
module Calibredb
  module Book
    module Fields
      class Cover
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Formats

        attr_accessor :library, :column, :book, :model, :data, :ext

        def initialize(library, book, field)
          @book = book
          @data = book[field]
          @library = library
          @column = field
          @model = :books
          @ext = 'jpg'
        end

        def get
          cover
        end

        def path
          self
        end
      end
    end
  end
end
