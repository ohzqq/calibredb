
module URbooks
  module Data
    module Fields
      class Misc
        include URbooks::Data::Helpers
        include URbooks::Data::Helpers::Columns

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
