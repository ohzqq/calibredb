module Calibredb
  module Model
    module Shared
      extend self

      def data_with_default_order
        @model.dataset_module do
          def data
            default
          end
        end
      end
    end
  end
end
