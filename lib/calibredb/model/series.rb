
module Calibredb
  module Model
    class Series
      include Calibredb::Model::NameColumn

      def initialize(library)
        @library = library
        @model = library.series
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :series, 
          right_key: :book, 
          join_table: :books_series_link,
          class: @library.books,
          order: :sort
        )
      end
    end
  end
end
