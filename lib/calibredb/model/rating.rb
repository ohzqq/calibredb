module Calibredb
  module Model
    class Rating
      include Calibredb::Model

      def initialize(library)
        @library = library
        @model = library.ratings
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :rating, 
          right_key: :book, 
          join_table: :books_ratings_link,
          class: @library.books
        )
      end

      def dataset_module
        shared_dataset_modules
        @model.def_column_alias(:value, :rating)
        @model.dataset_module do
          order :default, :rating
        end
      end
    end
  end
end
