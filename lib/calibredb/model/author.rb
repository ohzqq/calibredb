module Calibredb
  module Model
    class Author
      include Calibredb::DatasetMethods::Associations

      def initialize(library)
        @library = library.models
        @model = library.models[:authors]
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :author, 
          right_key: :book, 
          join_table: :books_authors_link,
          class: @library[:books],
          order: :sort
        )
      end

      def dataset_module
        tables_with_name_column
        all_associations
        names
        @model.dataset_module do
          def category
            :authors
          end
        end
      end
    end
  end
end
