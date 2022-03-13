module URbooks
  module Data
    class Books
      include URbooks::Data::Helpers

      def initialize(dataset)
        @dataset = dataset
      end

      def data
        @dataset
      end

      def library
        get.library
      end

      def column
        get.column
      end

      def all
        data.all
      end

      def get(field = nil)
        b = book(first)
        field ? b.send(field).get : b
      end

      def map(&block)
        a = data.map {|b| book(b)}
        block ? a.map(&block) : a
      end

      def first
        dataset? ? data.first : book(data.first)
      end

      def book(row)
        URbooks::Data::Book.new(book_row(row))
      end

      def book_row(info)
        dataset? ? info : lib.current.db.books[info]
      end
    end
  end
end
