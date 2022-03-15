
module Calibredb
  module Book
    module Fields
      class Dates
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Columns

        attr_accessor :book, :column

        def initialize(book, column)
          @book = book
          @column = column
        end

        def get
          data == null ? "" : data.strftime("%F")
        end

        private

        def null
          Time.parse('0101-01-01 00:00:00 +0000')
        end
      end
    end
  end
end
