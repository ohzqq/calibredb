module Calibredb
  module Model
    module Shared
      extend self

      def shared_modules
        @model.dataset_module do
          def data
            default
          end

          def library
            Calibredb.const_get(default.model.to_s.split("::")[1])
          end
        end
      end
    end
  end
end
