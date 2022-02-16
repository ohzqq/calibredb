module Calibredb
  class CustomColumns
    include Calibredb

    def initialize(db, library)
      @db = db
      @library = library
    end

    def models
      @library.const_get(:CustomColumn).each do |custom_column|
        label = custom_column.label
        model = constantize(label)
        table = :"custom_column_#{custom_column.id}"

        add_to_models({label => model})

        klass = Class.new(Sequel::Model)
        @library.const_set(model, klass)
        @library.const_get(model).dataset = @db[table]

        case custom_column.is_multiple
        when true
          many_to_many(table, model, label.to_sym)
        when false
          one_to_many(model, label.to_sym)
        end
      end
    end

    def add_to_models(custom)
      @library.custom_columns = @library.custom_columns.merge(custom)
      @library.models = @library.models.merge(custom)
    end

    def many_to_many(table, model, label)
      @library.const_get(model).many_to_many(
        :books,
        left_key: :value, 
        right_key: :book, 
        join_table: :"books_#{table}_link",
        class: @library.const_get(:Book),
        order: :sort
      )

      @library.const_get(:Book).many_to_many(
        label,
        join_table: :"books_#{table}_link",
        left_key: :book,
        right_key: :value,
        class:  @library.const_get(model)
      )
    end

    def one_to_many(model, label)
      @library.const_get(model).many_to_one(
        :book,
        key: :book,
        class: @library.const_get(:Book)
      )

      @library.const_get(:Book).one_to_many(
        label,
        key: :book,
        class:  @library.const_get(model)
      )
    end
  end
end

