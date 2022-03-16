
module Calibredb
  module Model
    class Identifier
      include Calibredb::DatasetMethods::Associations

      def initialize(library)
        @library = library.models
        @model = library.models[:identifiers]
      end

      def associations
        @model.many_to_one(
          :book,
          key: :book,
          class: @library[:books]
        )
      end

      def dataset_module
        @model.def_column_alias(:value, :val)
        @model.dataset_module do
          order :default, :val

          def category
            :identifiers
          end
        end
        all_associations
        collections
      end
    end
  end
end
