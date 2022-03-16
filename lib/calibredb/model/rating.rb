module Calibredb
  module Model
    class Rating
      include Calibredb::DatasetMethods::Associations

      def initialize(library)
        @library = library.models
        @model = library.models[:ratings]
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :rating, 
          right_key: :book, 
          join_table: :books_ratings_link,
          class: @library[:books]
        )
      end

      def dataset_module
        all_associations
        collections
        @model.def_column_alias(:value, :rating)
        @model.dataset_module do
          order :default, :rating

          def category
            :ratings
          end
        end
      end
    end
  end
end
