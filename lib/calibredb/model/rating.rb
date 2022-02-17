module Calibredb
  module Model
    class Rating
      include Calibredb::Model::Shared

      def initialize(library)
        @library = library
        @model = library.const_get(:Rating)
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :rating, 
          right_key: :book, 
          join_table: :books_ratings_link,
          class: @library.const_get(:Book)
        )
      end

      def dataset_module
        @model.def_column_alias(:value, :rating)
        @model.dataset_module do
          order :default, :rating
        end
      end
    end
  end
end
