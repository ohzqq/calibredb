
module Calibredb
  module Model
    class CustomColumn
      include Calibredb::Model

      def initialize(library)
        @library = library
        @model = library.const_get(:CustomColumn)
      end

      def dataset_module
        @model.dataset_module do
          select :default

          def is_multiple?(column)
            default[list[column]].is_multiple
          end

          def display(column)
            JSON.parse(default[list[column]][:display])
          end

          def is_names?(column)
            display = display(column)
            if display.key?("is_names") 
              display["is_names"]
            else
              false
            end
          end

          def list
            as_hash(:label, :id)
          end
        end
        shared_dataset_modules
      end
    end
  end
end
