module Calibredb
  module Book
    class Books
      include Calibredb::Book::Helpers

      attr_accessor :library

      def initialize(dataset, library)
        @library = library
        @dataset = dataset
      end

      def data
        @dataset
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
        Calibredb::Book::Meta.new(book_row(row), @library)
      end

      def book_row(info)
        dataset? ? info : Calibredb.libraries[@library].db.books[info]
      end
    end
  end
end
