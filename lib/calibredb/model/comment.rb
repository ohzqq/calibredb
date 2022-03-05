module Calibredb
  module Model
    class Comment
      include Calibredb::Model

      def initialize(library)
        @library = library.models
        @model = library.models[:comments]
      end

      def associations
        @model.many_to_one(
          :book,
          key: :book,
          class: @library[:books]
        )
      end

      def dataset_module
        @model.def_column_alias(:value, :text)
        @model.dataset_module do
          order :default, :text

          def category
            :comments
          end
        end
        shared_dataset_modules
      end
    end
  end
end
