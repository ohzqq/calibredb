
module Calibredb
  module Model
    class Tag
      include Calibredb::Model::NameColumn

      def initialize(library)
        @library = library
        @model = library.const_get(:Tag)
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :tag, 
          right_key: :book, 
          join_table: :books_tags_link,
          class: @library.const_get(:Book),
          order: :sort
        )
      end
    end
  end
end
