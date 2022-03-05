
module Calibredb
  module Model
    class Publisher
      include Calibredb::Model::NameColumn

      def initialize(library)
        @library = library.models
        @model = library.models[:publishers]
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :publisher, 
          right_key: :book, 
          join_table: :books_publishers_link,
          class: @library[:books]
        )
      end

      def dataset_module
        name_dataset_module
        @model.dataset_module do
          def category
            :publishers
          end
        end
      end
    end
  end
end
