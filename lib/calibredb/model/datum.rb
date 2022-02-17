
module Calibredb
  module Model
    class Datum
      include Calibredb::Model::Shared

      def initialize(library)
        @library = library
        @model = library.const_get(:Datum)
      end

      def associations
        @model.many_to_one(
          :book,
          key: :book,
          class: @library.const_get(:Book)
        )
      end

      def dataset_module
        @model.def_column_alias(:value, :format)
        @model.dataset_module do
          order :default, :format
        end
      end
    end
  end
end
