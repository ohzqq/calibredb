
module Calibredb
  module Model
    class Tag
      include Calibredb::DatasetMethods::Associations

      def initialize(library)
        @library = library.models
        @model = library.models[:tags]
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :tag, 
          right_key: :book, 
          join_table: :books_tags_link,
          class: @library[:books],
          order: :sort
        )
      end

      def dataset_module
        tables_with_name_column
        collections
        all_associations
        @model.dataset_module do
          def category
            :tags
          end
        end
      end
    end
  end
end
