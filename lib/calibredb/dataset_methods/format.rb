module Calibredb
  module DatasetMethods
    class Format
      attr_accessor :formats

      def initialize(book, library)
        @book = book
        @library = library
        @formats = book.data_dataset
      end
      
      def get(format)
        basename = format == :cover ? "cover.jpg": @formats.where(format: format.to_s.upcase).basename
        absolute(basename)
      end
      
      def absolute(basename)
        library.join(book, basename)
      end
      
      def library
        @library.path
      end
      
      def book
        Pathname.new(@book.path)
      end
      
      def all_formats
        @formats.children
      end
    end
  end
end
