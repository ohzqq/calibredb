module Calibredb
  class CustomColumn
    include Calibredb

    def initialize(library, db, custom_column)
      @library = library
      @db = db
      @label = custom_column.label.to_sym
      @model = constantize(custom_column.label)
      @table = :"custom_column_#{custom_column.id}"
      @is_multiple = custom_column.is_multiple
    end

    def model
      @library.const_set(@model, Class.new(Sequel::Model))
      @library.const_get(@model).dataset = @db[@table]
    end

    def associations
      case @is_multiple
      when true
        many_to_many
      when false
        one_to_many
      end
    end

    def many_to_many
      @library.const_get(@model).many_to_many(
        :books,
        left_key: :value, 
        right_key: :book, 
        join_table: :"books_#{@table}_link",
        class: @library.const_get(:Book),
        order: :sort
      )

      @library.const_get(:Book).many_to_many(
        @label,
        join_table: :"books_#{@table}_link",
        left_key: :book,
        right_key: :value,
        class:  @library.const_get(@model)
      )
    end

    def one_to_many
      @library.const_get(@model).many_to_one(
        :book,
        key: :book,
        class: @library.const_get(:Book)
      )

      @library.const_get(:Book).one_to_many(
        @label,
        key: :book,
        class:  @library.const_get(@model)
      )
    end
  end
end

