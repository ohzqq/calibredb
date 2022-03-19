module Calibredb
  module CustomColumn
    class Model
      include Calibredb::Model
      include Calibredb::DatasetMethods::Associations
      include Calibredb

      attr_accessor :model

      def initialize(library, db, custom_column)
        @library = library
        @db = db
        @label = custom_column.label.to_sym
        @book = @library.models[:books]
        @table = :"custom_column_#{custom_column.id}"
        @is_multiple = custom_column.is_multiple
        @model = Class.new(Sequel::Model)
        @model.dataset = db[@table]
      end

      def associations
        case @is_multiple
        when true
          many_to_many
        when false
          one_to_many
        end
      end

      def dataset_module
        all_associations

        unless @model.columns.include?(:book)
          many_to_many_modules
        end

        modules_for_all_models
      end

      def modules_for_all_models
        @model.dataset_module do
          order :default, :value

          def library
            Calibredb
              .libraries
              .to_h
              .slice(*Calibredb.libraries.list.map(&:to_sym))
              .values
              .select do |l|
              l.db.values.include?(self.model)
            end.first
          end

          def custom_column
            library.db.custom_columns
          end
          
          def table
            self.first_source_table
          end

          def row
            custom_column[table.to_s.split('_').last.to_i]
          end
          
          def to_s
            if multiple?
              if names?
                map(&:value).map(&:smart_format).join(" & ")
              else
                map(&:value).map(&:smart_format).join(", ")
              end
            else
              first.value.smart_format
            end
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

          def category
            :"#{row.label}"
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
