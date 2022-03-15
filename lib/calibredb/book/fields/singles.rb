
module Calibredb
  module Book
    module Fields
      class Singles
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

        def get(val = :value)
          data.first ? data.first.public_send(val).smart_format : ""
        end
      end
    end
  end
end
