
module Calibredb
  module Model
    class Datum
      include Calibredb::Model

      def initialize(library)
        @library = library
        @model = library.data
      end

      def associations
        @model.many_to_one(
          :book,
          key: :book,
          class: @library.books
        )
      end

      def dataset_module
        @model.def_column_alias(:value, :format)
        @model.dataset_module do
          order :default, :format
        end
        shared_dataset_modules
      end
    end
  end
end
