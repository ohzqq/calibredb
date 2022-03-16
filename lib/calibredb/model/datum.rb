
module Calibredb
  module Model
    class Datum
      include Calibredb::DatasetMethods::Associations

      def initialize(library)
        @library = library.models
        @model = library.models[:data]
      end

      def associations
        @model.many_to_one(
          :book,
          key: :book,
          class: @library[:books]
        )
      end

      def dataset_module
        all_associations
        @model.def_column_alias(:value, :format)
        @model.dataset_module do
          order :default, :format
          
          def extensions
            map {|f| :"#{f.format.downcase}"}.uniq
          end
          
          def children
            map {|f| Pathname.new("#{f.name}.#{f.format.downcase}")}
          end
          
          def basename
            "#{first.name}.#{first.format.downcase}"
          end
          
          def book
            b = map {|f| f[:book]}.uniq.first
            Calibredb.libraries[library.name].db.books[b]
          end
          
          def category
            :formats
          end
        end
      end
    end
  end
end
