module Calibredb
  module Book
    module Fields
      class Formats
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Dataset
        include Calibredb::Book::Helpers::Formats

        attr_accessor :data, :library, :model, :book

        def initialize(book, field)
          @book = book
          @data = book.send(:"#{field}_dataset")
          @library = @data.library.name
          @model = field
        end

        def map
          extensions
        end

        def get(format = nil)
          if map.include?(format.to_s)
            Calibredb::Book::Fields::Format.new(@book, format.to_s)
          else
            extensions.join(", ")
          end
        end
      end
    end
  end
end
