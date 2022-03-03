module Calibredb
  module CustomColumn
    autoload :Model, 'calibredb/custom_column/model'

    include Calibredb

    extend self

    def models(db, library)
      library.models[:custom_columns].each do |custom_column|
        col = Model.new(library, db, custom_column)
        col.associations
        col.dataset_module
        add_to_models(library, {custom_column.label => col.model})
      end
    end

    def add_to_models(library, custom)
      library.custom_columns = library.custom_columns.merge(custom)
      library.models = library.models.merge(custom)
    end
  end
end

