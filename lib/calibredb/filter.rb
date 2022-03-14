module Calibredb
  class Filter
    attr_reader :db

    def initialize(table = :books, library = Calibredb.libraries.current.name)
      @options = {}
      @library = library
      @table = table.to_s
      @db = Calibredb.libraries.current.db[@table]
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
      @db = Calibredb.libraries.current.db[@table]
      self.data = @db.data
      self
    end

    def from(library)
      @updated = true
      @library = library
      Calibredb.libraries.update = library
      @db = Calibredb.libraries.current.db[@table.to_s]
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

    def query(q)
      @updated = true
      @query = q
      @db = @db.query(q, @sort)
      self.data = @db.data
      self
    end
    
    def desc
      @updated = true
      @desc = :desc
      self.data = data.reverse
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

    def filter
      self.from(@library) if @library
      self.in(@table) if @table
      self.query(@query) if @query
      self.find(@ids) if @ids
      self.by(@sort) && @sort = nil if @sort
      self.letter(@alpha) if @alpha
      self.desc if @desc
      self
    end

    def results(cmd: nil, args: nil, options: {})
      @updated = true
      @options = options
      @library = options.fetch("library").to_sym if options.key?("library")
      @table = options.fetch("category").to_sym if options.key?("category")
      @fields = options.fetch("fields").split(",") if options.key?("fields")
      @sort = options.fetch("sort").to_sym if options.key?("sort")
      @desc = :desc if options.key?("desc")

      @ids =
        if cmd == :list
          args.first if args
        elsif options.key?("ids")
          options.fetch("ids").split(",")
        end

      @query =
        if cmd == :search
          args.join(" ") if args
        elsif options.key?("q")
          options.fetch("q")
        end

      filtered =
        if @options.key?("format")
          update.meta(*@fields, desc: @desc, format: @options.fetch("format"))
        else
          update
        end

      return @library, @table, filtered
    end

    def update
      filter if @updated
      @updated = false
      @data
    end
  end
end
