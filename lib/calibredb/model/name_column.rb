module Calibredb
  module Model
    module NameColumn
      include Calibredb::Model

      def dataset_module
        @model.def_column_alias(:value, :name)
        @model.dataset_module do
          order :default, :name

          def query(query, sort = nil)
            grep(
              :name,
              query.split(" ").map {|q| "%#{q}%"},
              all_patterns: true, case_insensitive: true
            )
          end
        end
        shared_dataset_modules
      end
    end
  end
end
