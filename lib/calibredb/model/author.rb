module Calibredb
  module Models
    def authors
      Class.new(Sequel::Model) do
        many_to_many(
          :books,
          left_key: :author, 
          right_key: :book, 
          join_table: :books_authors_link,
          class: model.const_get(:Book),
          order: :sort
        )
      end
    end
  end
end
