
module Calibredb
  module Model
    class Series
      include Calibredb::Model::NameColumn

      def initialize(library)
        @library = library
        @model = library.const_get(:Series)
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :series, 
          right_key: :book, 
          join_table: :books_series_link,
          class: @library.const_get(:Book),
          order: :sort
        )
      end
    end
  end
end
