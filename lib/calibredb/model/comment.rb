module Calibredb
  module Model
    class Comment
      include Calibredb::Model::Shared

      def initialize(library)
        @library = library
        @model = library.const_get(:Comment)
      end

      def associations
        @model.many_to_one(
          :book,
          key: :book,
          class: @library.const_get(:Book)
        )
      end

      def dataset_module
        @model.def_column_alias(:value, :text)
        @model.dataset_module do
          order :default, :text
        end
      end
    end
  end
end
