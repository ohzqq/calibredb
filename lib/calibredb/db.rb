module CalibreAPI
  class DB
    attr_reader :db

    def initialize(table = :books, library = lib.current.name)
      @library = library
      @table = table.to_s
      @db = lib.current.db[@table]
      @data = @db.data
      @sort = :default
    end

    def data
      @data
    end

    def data=(data)
      @data = data
    end

    def in(table)
      @updated = true
      @table = table.to_s
      @db = lib.current.db[@table]
      self.data = @db.data
      self
    end

    def from(library)
      @updated = true
      @library = library
      lib.update = library
      @db = lib.current.db[@table.to_s]
      self.data = @db.data
      self
    end

    def letter(alpha)
      @updated = true
      @alpha = alpha
      self.data = @data.where(Sequel.ilike(:value, "#{alpha}%"))
      self
    end

    def find(ids)
      @updated = true
      @ids = ids
      self.data = @data.where(id: @ids)
      self
    end

    def results
      self.from(@library) if @library
      self.in(@table) if @table
      self.find(@ids) if @ids
      self.by(@sort) && @sort = nil if @sort
      self.query(@query) if @query
      self.letter(@alpha) if @alpha
      self.desc && @order = false if @order
      self
    end

    def query(q)
      @updated = true
      @query = q
      @db = @db.query(q, @sort)
      self.data = @db.data
      self
    end
    
    def desc
      @updated = true
      @order = true
      self.data = @data.reverse
      self
    end

    def by(sort = "default")
      @updated = true
      @sort = sort.to_s
      self.data = sort_books if books?
      self
    end

    def books?
      @table == "books"
    end

    def sort_books
      ["modified", "added", "pubdate"]
        .include?(@sort) ? @data.send(@sort.to_sym) : @data
    end

    def meta
      results if @updated
      @updated = false
      books? ? Book.new(@data, @library) : Association.new(@table, @data, @library)
    end
  end
end
