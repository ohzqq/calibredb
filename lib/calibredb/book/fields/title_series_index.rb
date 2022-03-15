module Calibredb
  module Book
    module Fields
      class TitleSeriesIndex
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Dataset

        attr_reader :data

        def initialize(title:, series:, series_index:)
          @title = title
          @series = series
          @series_index = series_index
        end

        def title
          @data = @title
          @meta = @title.get
          self
        end

        def series
          @data = @series
          @meta = @series.get
          self
        end

        def series_index
          @data = @series_index
          @meta = @series_index.get.to_s
          self
        end

        def get
          @meta
        end

        def as_hash(book_ids: nil, book_total: nil)
          @data.as_hash(book_ids: book_ids, book_total: book_total)
        end

        def join
          if @series.get.empty?
            @meta
          else
            "#{@title.get} [#{@series.get}, Book #{@series_index.get}]"
          end
        end
      end
    end
  end
end
