
module Calibredb
  module Model
    class CustomColumn
      include Calibredb::Model::Shared

      def initialize(library)
        @library = library
        @model = library.const_get(:CustomColumn)
      end

      def associations
      end

      def dataset_module
      end
    end
  end
end
