module Calibredb
  module Model
    class Author
      include Calibredb::Model::NameColumn

      def initialize(library)
        @library = library
        @model = library.authors
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :author, 
          right_key: :book, 
          join_table: :books_authors_link,
          class: @library.books,
          order: :sort
        )
      end
    end
  end
end
