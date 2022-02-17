
module Calibredb
  module Model
    class Publisher
      include Calibredb::Model::NameColumn

      def initialize(library)
        @library = library
        @model = library.const_get(:Publisher)
      end

      def associations
        @model.many_to_many(
          :books,
          left_key: :publisher, 
          right_key: :book, 
          join_table: :books_publishers_link,
          class: @library.const_get(:Book)
        )
      end
    end
  end
end
