module Calibredb
  module Book
    module Fields
      class Format
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Dataset
        include Calibredb::Book::Helpers::Formats

        attr_accessor :book, :ext, :data

        def initialize(book, data, ext)
          @book = book
          @data = data
          @ext = ext
          @path = File.join(book.path, name)
        end

        def path
          self
        end

        def get
          @path
        end

        def name
          "#{row.name}.#{@ext}"
        end

        def duration
          @book.duration.first.value
        end
      end
    end
  end
end
