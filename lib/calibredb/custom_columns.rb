module Calibredb
  class CustomColumns
    include Calibredb

    def initialize(db, library)
      @db = db
      @library = library
    end

    def models
      @library.const_get(:CustomColumn).each do |custom_column|
        model = constantize(custom_column.label)

        @library.send(:remove_const, model) if @library.const_defined?(model)

        add_to_models({custom_column.label => model})

        col = CustomColumn.new(@library, @db, custom_column)
        col.model
        col.associations
      end
    end

    def add_to_models(custom)
      @library.custom_columns = @library.custom_columns.merge(custom)
      @library.models = @library.models.merge(custom)
    end
  end
end

