module Calibredb
  module Book
    class BookMeta
      attr_accessor :data, :library, :authors, :tags, :languages, :ratings, :comments, :publishers, :identifiers, :series, :title, :pubdate, :added, :last_modified, :cover, :formats, :path, :series_index, :id, :sort, :author_sort, :lccn, :isbn, :uuid

      def initialize(data: nil, library: nil)
        @data = data
        @library = library
      end

      def custom(lib)
        self.class.send(:attr_accessor, *Calibredb.libraries[lib].custom_columns)
      end

      def as_hash(field = nil, plain: nil)
        field ? self.send(field).as_hash : book_to_hash(plain)
      end

      def as_ini
        Calibredb::Book.convert(self).ini
      end

      def as_yml
        Calibredb::Book.convert(self).yml
      end

      def as_calibre
        Calibredb::Book.convert(self).calibre
      end

      def book_to_hash(type)
        Calibredb::Book.convert(self).hash(plain: type)
      end
    end
  end
end
