
module Calibredb
  module Model
    class CustomColumn
      include Calibredb::DatasetMethods::Associations

      def initialize(library)
        @library = library.models
        @model = library.models[:custom_columns]
      end

      def dataset_module
        @model.dataset_module do
          select :default

          def category
            :custom_columns
          end

          def list
            as_hash(:label, :id)
          end
        end
        all_associations
      end
    end
  end
end
