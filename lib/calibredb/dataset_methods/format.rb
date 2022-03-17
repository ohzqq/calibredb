module Calibredb
  module DatasetMethods
    class Format
      attr_accessor :formats, :basename
      
      def initialize(book, library)
        @book = book
        @library = library
        @formats = book.data_dataset
      end
      
      def get(format)
        @basename = format == :cover ? "cover.jpg": @formats.where(format: format.to_s.upcase).basename
        self
      end
      
      def relative
        library.join(book, @basename)
      end
      
      def as_hash
        @formats.as_hash
      end
      
      def base_path
        @library.path.dirname
      end
      
      def absolute
        base_path.join(library, book, @basename)
      end
      
      def book_id
        @book.id
      end
      
      def library
        Pathname.new(@library.name.to_s)
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
