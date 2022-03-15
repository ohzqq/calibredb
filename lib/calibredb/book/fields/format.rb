module Calibredb
  module Book
    module Fields
      class Format
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Dataset
        include Calibredb::Book::Helpers::Formats

        attr_accessor :library, :column, :book, :model, :data, :ext

        def initialize(book, ext)
          @book = book
          data = book.data_dataset
          @data = data.all.select {|f| f.format.downcase == ext.to_s}.first
          @library = data.library.name
          @column = :data
          @model = :books
          @ext = ext
        end

        def path
          self
        end

        def get
          File.join(@book.path, basename)
        end

        def basename
          "#{@data.name}.#{@ext}"
        end
      end
    end
  end
end
