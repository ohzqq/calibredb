
module Calibredb
  module Model
    class Identifier
      include Calibredb::Model

      def initialize(library)
        @library = library
        @model = library.const_get(:Identifier)
      end

      def associations
        @model.many_to_one(
          :book,
          key: :book,
          class: @library.const_get(:Book)
        )
      end

      def dataset_module
        @model.def_column_alias(:value, :val)
        @model.dataset_module do
          order :default, :val
        end
        shared_dataset_modules
      end
    end
  end
end
