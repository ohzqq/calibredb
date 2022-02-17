module Calibredb
  module CustomColumn
    class Model
      include Calibredb::Model
      include Calibredb

      def initialize(library, db, custom_column)
        @library = library
        @db = db
        @label = custom_column.label.to_sym
        @model_constant = constantize(custom_column.label)
        @book = @library.const_get(:Book)
        @table = :"custom_column_#{custom_column.id}"
        @is_multiple = custom_column.is_multiple
      end

      def model
        @library.const_set(@model_constant, Class.new(Sequel::Model))
        @library.const_get(@model_constant).dataset = @db[@table]
      end

      def associations
        @model = @library.const_get(@model_constant)
        case @is_multiple
        when true
          many_to_many
        when false
          one_to_many
        end
      end

      def dataset_module
        @model = @library.const_get(@model_constant)
        shared_dataset_modules
        unless @model.columns.include?(:book)
          many_to_many_modules
        end

        modules_for_all_models
      end

      def modules_for_all_models
        @model.dataset_module do
          order :default, :value

          def custom_column
            library.const_get(:CustomColumn)
          end

          def row
            custom_column[model.table_name.to_s.split('_').last.to_i]
          end

          def label
            row.label
          end

          def display
            JSON.parse(row[:display])
          end

          def multiple?
            row.is_multiple
          end

          def names?
            if display.key?("is_names") 
              display["is_names"]
            else
              false
            end
          end

          def editable?
            row.editable
          end

          def datatype
            row.datatype
          end

          def name
            row.name
          end

          def mark_for_delete?
            row.mark_for_delete
          end

          def normalized?
            row.normalized
          end

          def column_id
            row.id
          end

          def description
            display["description"]
          end

          def one_to_one?
            columns.include?(:book)
          end
        end
      end

      def many_to_many_modules
        @model.dataset_module do
          def query(query, sort = nil)
            opts = {all_patterns: true, case_insensitive: true}
            query = query.split(" ").map {|q| "%#{q}%"}
            default.grep(:value, query, opts)
          end
        end
      end

      def many_to_many
        @model.many_to_many(
          :books,
          left_key: :value, 
          right_key: :book, 
          join_table: :"books_#{@table}_link",
          class: @book
        )

        @book.many_to_many(
          @label,
          join_table: :"books_#{@table}_link",
          left_key: :book,
          right_key: :value,
          class: @model
        )
      end

      def one_to_many
        @model.many_to_one(
          :book,
          key: :book,
          class: @book
        )

        @book.one_to_many(
          @label,
          key: :book,
          class: @model
        )
      end
    end
  end
end
