module Calibredb
  class Associations
    def initialize(library)
      @library = library
    end

    def books
      book = Model::Book.new(@library)
      book.associations
      book.dataset_module
    end

    def authors
      author = Model::Author.new(@library)
      author.associations
      author.dataset_module
    end

    def ratings
      author = Model::Author.new(@library)
      author.associations
      author.dataset_module
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
    end

    def data
    end

    def identifiers
    end

    def languages
    end

    def series
      series = Model::Series.new(@library)
      series.associations
      series.dataset_module
    end
  end
end
