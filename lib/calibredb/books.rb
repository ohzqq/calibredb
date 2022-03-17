module Calibredb
  module Book
    autoload :Books, 'calibredb/book/books'
    autoload :Convert, 'calibredb/book/convert'
    autoload :Fields, 'calibredb/book/fields'
    autoload :Helpers, 'calibredb/book/helpers'
    autoload :Meta, 'calibredb/book/meta'
    autoload :XML, 'calibredb/book/xml'

    extend self

    def convert(book)
      Calibredb::Book::Convert.new(book)
    end
  end
end
