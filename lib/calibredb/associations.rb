module Calibredb
  class Associations
    def initialize(library)
      @library = library
    end

    def books
      @library.const_get(:Book).one_to_many(
        :data,
        key: :book,
        class: @library.const_get(:Datum)
      )

      @library.const_get(:Book).one_to_many(
        :comments,
        key: :book,
        class: @library.const_get(:Comment)
      )

      @library.const_get(:Book).one_to_many(
        :identifiers,
        key: :book,
        class: @library.const_get(:Identifier)
      )

      %w[author publisher tag rating].each do |association|
        @library.const_get(:Book).many_to_many(
          :"#{association}s",
          join_table: :"books_#{association}s_link",
          left_key: :book,
          right_key: association.to_sym,
          class: @library.const_get(association.capitalize.to_sym)
        )
      end

      @library.const_get(:Book).many_to_many(
        :series,
        left_key: :book,
        right_key: :series,
        join_table: :books_series_link,
        class: @library.const_get(:Series),
        order: :sort
      )

      @library.const_get(:Book).many_to_many(
        :languages,
        left_key: :book,
        right_key: :lang_code,
        join_table: :books_languages_link,
        class: @library.const_get(:Language)
      )
    end

    def authors
      author = Model::Author.new(@library)
      author.associations
      author.dataset_module
    end

    def ratings
      @library.const_get(:Rating).many_to_many(
        :books,
        left_key: :rating, 
        right_key: :book, 
        join_table: :books_ratings_link,
        class: @library.const_get(:Book),
      )
    end

    def tags
      tag = Model::Tag.new(@library)
      tag.associations
      tag.dataset_module
    end

    def publishers
      publisher = Model::Publisher.new(@library)
      publisher.associations
      publisher.dataset_module
    end

    def comments
      @library.const_get(:Comment).many_to_one(
        :book,
        key: :book,
        class: @library.const_get(:Book)
      )
    end

    def data
      @library.const_get(:Datum).many_to_one(
        :book,
        key: :book,
        class: @library.const_get(:Book)
      )
    end

    def identifiers
      @library.const_get(:Identifier).many_to_one(
        :book,
        key: :book,
        class: @library.const_get(:Book)
      )
    end

    def languages
      @library.const_get(:Language).many_to_many(
        :books,
        left_key: :lang_code, 
        right_key: :book, 
        join_table: :books_languages_link,
        class: @library.const_get(:Book)
      )
    end

    def series
      series = Model::Series.new(@library)
      series.associations
      series.dataset_module
    end
  end
end
