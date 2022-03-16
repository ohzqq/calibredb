module Calibredb
  module DatasetMethods
    module Associations
      def tables_with_name_column
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
      end

      def names
        @model.dataset_module do
          def to_s
            map(&:value).map(&:smart_format).join(" & ")
          end
        end
      end
      
      def collections
        @model.dataset_module do
          def to_s
            map(&:value).map(&:smart_format).join(", ")
          end
        end
      end
      
      def singles
        @model.dataset_module do
          def to_s
            first.value.smart_format
          end
        end
      end

      def all_associations
        @model.dataset_module do
          def data
            default
          end

          def library
            Calibredb
              .libraries
              .to_h
              .slice(*Calibredb.libraries.list.map(&:to_sym))
              .values
              .select do |l|
              l.db.map(&:object_id).include?(self.model.object_id)
            end.first
          end

          def as_hash(*fields, desc: nil)
            d = desc ? data.reverse : data
            d.map do |row|
              meta = {}
              meta[:id] = row.id.to_s
              meta[:value] = row.value
              if fields.include?("all")
                if Calibredb.fields.many_books_to_many.to_sym.include?(category) ||
                    Calibredb.fields.one_to_many_books.to_sym.include?(category)
                  meta[:book_ids] = row.books_dataset.map(:id)
                  meta[:total_books] = row.books_dataset.count
                end
              end
              meta
            end
          end
        end
      end
    end
  end
end
