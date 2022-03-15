module Calibredb
  module Book
    class Meta
      include Calibredb::Book::Helpers
      include Calibredb::Book::Helpers::Columns
      include Calibredb::Book::Helpers::Dataset
      include Calibredb::Book::XML::Formattable

      attr_accessor :data, :library, :authors, :tags, :languages, :ratings, :comments, :publishers, :identifiers, :series, :title, :pubdate, :added, :last_modified, :cover, :formats, :path, :series_index, :id, :sort, :author_sort, :lccn, :isbn, :uuid

      def initialize(data, library)
        @data = row(data)
        @library = library

        @added = added_data
        @author_sort = author_sort_data
        @authors = authors_data
        @comments = comments_data
        @cover = cover_data
        @formats = formats_data
        @id = id_data
        @identifiers = identifiers_data
        @isbn = isbn_data
        @languages = languages_data
        @last_modified = last_modified_data
        @lccn = lccn_data
        @path = path_data
        @pubdate = pubdate_data
        @publishers = publishers_data
        @ratings = ratings_data
        @series = series_data
        @series_index = series_index_data
        @title = title_data
        @sort = sort_data
        @tags = tags_data
        @uuid = uuid_data
        custom
      end

      def row(meta)
        dataset?(meta) ? meta.first : meta
      end
      
      def dataset?(meta)
        meta.class.name == "Sequel::SQLite::Dataset" 
      end

      def association_dataset(association)
        @data.send(:"#{association}_dataset")
      end

      def authors_data
        names(association_dataset(:authors))
      end

      def tags_data
        collections(association_dataset(:tags))
      end

      def languages_data
        collections(association_dataset(:languages))
      end

      def ratings_data
        collections(association_dataset(:ratings))
      end

      def identifiers_data
        collections(association_dataset(:identifiers))
      end

      def pubdate_data
        dates(:pubdate)
      end

      def added_data
        dates(:timestamp)
      end

      def last_modified_data
        dates(:last_modified)
      end

      def path_data
        Calibredb::Book::Fields::Path.new(data, association_dataset(:data))
      end

      def cover_data
        Calibredb::Book::Fields::Cover.new(data)
      end

      def formats_data
        Calibredb::Book::Fields::Formats.new(data, association_dataset(:data))
      end

      def comments_data
        singles(association_dataset(:comments))
      end

      def publishers_data
        singles(association_dataset(:publishers))
      end

      def series_data
        title_series_index.series
      end

      def title_data
        title_series_index.title
      end

      def series_index_data
        title_series_index.series_index
      end

      def title_series_index
        Calibredb::Book::Fields::TitleSeriesIndex.new(
          title: misc(:title),
          series: singles(association_dataset(:series)),
          series_index: misc(:series_index)
        )
      end

      def sort_data
        misc(:sort)
      end

      def id_data
        misc(:id)
      end

      def author_sort_data
        misc(:author_sort)
      end

      def lccn_data
        misc(:lccn)
      end

      def isbn_data
        misc(:isbn)
      end

      def uuid_data
        misc(:uuid)
      end

      def custom
        Calibredb.libraries[@library].custom_columns.each do |col|
          self.class.send(:define_method, col) do
            if Calibredb.fields.names.to_sym.include?(col)
              names(association_dataset(col))
            elsif Calibredb.fields.collections.to_sym.include?(col)
              collections(association_dataset(col))
            else
              singles(association_dataset(col))
            end
          end
        end
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
