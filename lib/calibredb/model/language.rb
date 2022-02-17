
module Calibredb
  module Model
    class Language
      include Calibredb::Model::Shared

      def initialize(library)
        @library = library
        @model = library.const_get(:Language)
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :lang_code, 
          right_key: :book, 
          join_table: :books_languages_link,
          class: @library.const_get(:Book)
        )
      end

      def dataset_module
        @model.def_column_alias(:value, :lang_code)

        @model.dataset_module do
          order :default, :lang_code
        end
      end
    end
  end
end
