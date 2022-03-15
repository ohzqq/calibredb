
module Calibredb
  module Book
    module Fields
      class Collections
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Dataset
        include Calibredb::Book::Helpers::Associations

        attr_accessor :data, :library, :model, :book

        def initialize(book, field)
          @book = book
          @data = book.send(:"#{field}_dataset")
          @library = @data.library.name
          @model = field
        end

        def get(val = nil)
          val ? data_get(val) : map.map(&:smart_format).join(", ")
        end
      end
    end
  end
end
