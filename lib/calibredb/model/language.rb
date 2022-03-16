
module Calibredb
  module Model
    class Language
      include Calibredb::DatasetMethods::Associations

      def initialize(library)
        @library = library.models
        @model = library.models[:languages]
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :lang_code, 
          right_key: :book, 
          join_table: :books_languages_link,
          class: @library[:books]
        )
      end

      def dataset_module
        @model.def_column_alias(:value, :lang_code)

        @model.dataset_module do
          order :default, :lang_code

          def category
            :languages
          end
        end
        all_associations
        collections
      end
    end
  end
end
