
module Calibredb
  module Book
    module Fields
      class Cover
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Dataset
        include Calibredb::Book::Helpers::Formats

        attr_accessor :book, :ext, :data

        def initialize(book)
          @book = book
          @data = book
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
