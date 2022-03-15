
module Calibredb
  module Book
    module Fields
      class Misc
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Columns

        attr_accessor :book, :column

        def initialize(book, column)
          @book = book
          @column = column
        end

        def get
          data || ""
        end
      end
    end
  end
end
