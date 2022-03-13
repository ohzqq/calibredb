module URbooks
  module Data
    class Book
      include URbooks::Data::Helpers
      include URbooks::Data::Helpers::Columns
      include URbooks::Data::Helpers::Dataset
      include URbooks::Book::XML::Formattable

      def initialize(dataset)
        @dataset = dataset
        custom
      end

      def data
        @dataset
      end

      def authors
        names(association_dataset(:authors))
      end

      def tags
        collections(association_dataset(:tags))
      end

      def languages
        collections(association_dataset(:languages))
      end

      def ratings
        collections(association_dataset(:ratings))
      end

      def identifiers
        collections(association_dataset(:identifiers))
      end

      def pubdate
        dates(:pubdate)
      end

      def added
        dates(:timestamp)
      end

      def last_modified
        dates(:last_modified)
      end

      def path
        URbooks::Data::Fields::Path.new(data, association_dataset(:data))
      end

      def cover
        URbooks::Data::Fields::Cover.new(data)
      end

      def formats
        URbooks::Data::Fields::Formats.new(data, association_dataset(:data))
      end

      def comments
        singles(association_dataset(:comments))
      end

      def publishers
        singles(association_dataset(:publishers))
      end

      def series
        title_series_index.series
      end

      def title
        title_series_index.title
      end

      def series_index
        title_series_index.series_index
      end

      def title_series_index
        URbooks::Data::Fields::TitleSeriesIndex.new(
          title: misc(:title),
          series: singles(association_dataset(:series)),
          series_index: misc(:series_index)
        )
      end

      def sort
        misc(:sort)
      end

      def id
        misc(:id)
      end

      def author_sort
        misc(:author_sort)
      end

      def lccn
        misc(:lccn)
      end

      def isbn
        misc(:isbn)
      end

      def uuid
        misc(:uuid)
      end

      def custom
        URbooks::Book.fields.custom_columns.to_sym.each do |col|
          self.class.send(:define_method, col) do
            if URbooks::Book.fields.names.to_sym.include?(col)
              names(association_dataset(col))
            elsif URbooks::Book.fields.collections.to_sym.include?(col)
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
        URbooks::Book.convert(self).ini
      end

      def as_yml
        URbooks::Book.convert(self).yml
      end

      def as_calibre
        URbooks::Book.convert(self).calibre
      end

      def book_to_hash(type)
        URbooks::Book.convert(self).hash(plain: type)
      end
    end
  end
end
