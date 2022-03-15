module Calibredb
  module Book
    module Fields
      class BookColumn
        attr_accessor :library, :column, :book, :model, :data

        def initialize(library, book, field)
          @book = book
          @data = book[field]
          @library = library
          @column = field
          @model = :books
        end

        def get
          date? ? date_meta : misc_meta
        end

        def as_hash(book_ids: nil, book_total: nil)
          meta = {value: get}
        end

        private

        def date_meta
          @data == null ? "" : @data.strftime("%F")
        end
        
        def misc_meta
          @data || ""
        end

        def date?
          column = @column == :timestamp ? :added : @column
          Calibredb.fields.dates_and_times.to_sym.include?(column)
        end

        def null
          Time.parse('0101-01-01 00:00:00 +0000')
        end
      end
    end
  end
end
