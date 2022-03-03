
module Calibredb
  module Model
    class CustomColumn
      include Calibredb::Model

      def initialize(library)
        @library = library
        @model = library.custom_columns
      end

      def dataset_module
        @model.dataset_module do
          select :default

          def list
            as_hash(:label, :id)
          end
        end
        shared_dataset_modules
      end
    end
  end
end
