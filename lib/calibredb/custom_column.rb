module Calibredb
  module CustomColumn
    autoload :Model, 'calibredb/custom_column/model'

    include Calibredb

    extend self

    def models(db, library)
      library.const_get(:CustomColumn).each do |custom_column|
        model = constantize(custom_column.label)

        library.send(:remove_const, model) if library.const_defined?(model)

        add_to_models(library, {custom_column.label => model})

        col = Model.new(library, db, custom_column)
        col.model
        col.associations
        col.dataset_module
      end
    end

    def add_to_models(library, custom)
      library.custom_columns = library.custom_columns.merge(custom)
      library.models = library.models.merge(custom)
    end
  end
end

