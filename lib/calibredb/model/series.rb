
module Calibredb
  module Model
    class Series
      include Calibredb::DatasetMethods::Associations

      def initialize(library)
        @library = library.models
        @model = library.models[:series]
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :series, 
          right_key: :book, 
          join_table: :books_series_link,
          class: @library[:books],
          order: :sort
        )
      end

      def dataset_module
        tables_with_name_column
        singles
        all_associations
        @model.dataset_module do
          def category
            :series
          end
        end
      end
    end
  end
end
