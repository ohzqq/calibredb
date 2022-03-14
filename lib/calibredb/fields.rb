module Calibredb
  class Fields
    attr_reader :fields

    def initialize(library)
      @book = Calibredb.db(library).books
      @library = library
      @all_fields = []
    end

    def list
      @all_fields.delete(@fields)
    end

    def to_s
      unite_all_fields.map(&:to_s)
    end

    def to_sym
      unite_all_fields.map(&:to_sym)
    end

    def custom_field?(field)
      custom_columns.list.map(&:to_s).include?(field.to_s)
    end

    def book_columns
      @fields = @book.columns.map(&:to_s)
      push_fields
      self
    end

    def book
      @fields = book_columns.list - %w[has_cover flags]
      @fields.delete("timestamp")
      @fields << "added"
      push_fields
      self
    end

    def misc_book
      @fields = %w[sort author_sort lccn isbn uuid]
      push_fields
      self
    end

    def associations
      @fields = @book.associations.map(&:to_s)
      @fields.delete("data")
      @fields << "formats"
      push_fields
      self
    end

    def dates_and_times
      @fields = %w[added pubdate last_modified]
      push_fields
      self
    end

    def names
      @fields = custom_columns.list.select do |c|
        Calibredb.libraries[@library].db[c].names?
      end
      @fields << "authors"
      push_fields
      self
    end

    def sortable
      @fields = dates_and_times.list.sort
      push_fields
      self
    end

    def custom_columns
      @fields = Calibredb.libraries[@library].custom_columns
      push_fields
      self
    end

    def models
      @fields = Calibredb::MODELS
      push_fields
      self
    end

    def editable
      @fields = editable_fields + custom_columns.list
      push_fields
      self
    end

    def collections
      @fields = many_books_to_many.list + one_book_to_many.list - names.list
      push_fields
      self
    end

    def singles
      @fields = one_to_many_books.one_to_one.to_s
      push_fields
      self
    end

    def one_to_many_books
      @fields = ["publishers", "series"]
      push_fields
      self
    end

    def one_to_one
      @fields = custom_columns.list.select do |c|
        !Calibredb.libraries[@library].db[c].multiple?
      end
      @fields << "comments"
      push_fields
      self
    end

    def many_books_to_many
      @fields = reflections.map do |r|
        next unless r[:type] == :many_to_many
        next if r[:name] == :series
        next if r[:name] == :publishers
        r[:name].to_s 
      end.compact
      push_fields
      self
    end

    def one_book_to_many
      @fields = reflections.map do |r|
        next if one_to_one.list.include?(r[:name].to_s)
        r[:name].to_s if r[:type] == :one_to_many
      end.compact
      @fields.delete("data")
      @fields << "formats"
      push_fields
      self
    end

    def title_and_series
      @fields = %w[title series series_index]
      push_fields
      self
    end

    def browsable
      @fields = many_books_to_many.list + one_to_many_books.list + one_book_to_many.list
      @fields << :books
      push_fields
      self
    end

    def viewable
      @fields = book.list + associations.list
      push_fields
      self
    end

    private

    def reflections
      @book.all_association_reflections.map do |a|
        a.slice(:type, :name, :class_name)
      end
    end

    def editable_fields
      %w[
        author_sort
        authors
        comments
        cover
        identifiers
        languages
        pubdate
        publisher
        rating
        series
        series_index
        sort
        tags
        title
      ]
    end
    
    def unite_all_fields
      @all_fields.flatten.uniq
    end

    def push_fields
      @all_fields << @fields unless @all_fields.include?(@fields)
    end
  end
end
