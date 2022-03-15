module Calibredb
  module Book
    class Builder
      def self.build
        builder = self.new
        yield(builder)
        builder.book
      end

      def initialize
        @book = BookMeta.new
        custom
      end
      
      def library(lib)
        @book.library = lib
        @book.custom(lib)
      end

      def data(meta)
        @book.data = row(meta)
      end
      
      def row(meta)
        dataset?(meta) ? meta.first : meta
      end
      
      def dataset?(meta)
        meta.class.name == "Sequel::SQLite::Dataset" 
      end

      def association_dataset(meta, association)
        row(meta).send(:"#{association}_dataset")
      end

      def authors(value)
        @book.authors = Book::Fields::Names.new(association_dataset(value, :authors))
      end

      def tags(value)
        @book.tags = collections(association_dataset(value, :tags))
      end

      def languages(value)
        @book.languages = collections(association_dataset(value, :languages))
      end

      def ratings(value)
        @book.ratings = collections(association_dataset(value, :ratings))
      end

      def identifiers(value)
        @book.identifiers = collections(association_dataset(value, :identifiers))
      end

      def pubdate(value)
        @book.pubdate = dates(:pubdate)
      end

      def added(value)
        @book.added = dates(:timestamp)
      end

      def last_modified(value)
        @book.last_modified = dates(:last_modified)
      end

      def path(value)
        @book.path = Calibredb::Book::Fields::Path.new(data, association_dataset(value, :data))
      end

      def cover(value)
        @book.cover = Calibredb::Book::Fields::Cover.new(data)
      end

      def formats(value)
        @book.formats = Calibredb::Book::Fields::Formats.new(data, association_dataset(value, :data))
      end

      def comments(value)
        @book.comments = singles(association_dataset(value, :comments))
      end

      def publishers(value)
        @book.publishers = singles(association_dataset(value, :publishers))
      end

      def series(value)
        @book.series = title_series_index.series
      end

      def title(value)
        @book.title = title_series_index.title
      end

      def series_index(value)
        @book.series_index = title_series_index.series_index
      end

      def title_series_index
        Calibredb::Book::Fields::TitleSeriesIndex.new(
          title: misc(:title),
          series: singles(association_dataset(value, :series)),
          series_index: misc(:series_index)
        )
      end

      def sort(value)
        @book.sort = misc(:sort)
      end

      def id(value)
        @book.id = misc(:id)
      end

      def author_sort(value)
        @book.author_sort = misc(:author_sort)
      end

      def lccn(value)
        @book.lccn = misc(:lccn)
      end

      def isbn(value)
        @book.authors = misc(:isbn)
      end

      def uuid(value)
        @book.uuid = misc(:uuid)
      end

      def custom
        Calibredb.fields.custom_columns.to_sym.each do |col|
          self.class.send(:define_method, col) do |value|
            if Calibredb.fields.names.to_sym.include?(col)
              names(association_dataset(value, col))
            elsif Calibredb.fields.collections.to_sym.include?(col)
              collections(association_dataset(value, col))
            else
              singles(association_dataset(value, col))
            end
          end
        end
      end

      def book
        obj = @book.dup
        @book = BookMeta.new
        return obj
      end
    end
  end
end
