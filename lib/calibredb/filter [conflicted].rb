module Calibredb
  class Filter
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

    def filter(cmd = nil, table = nil, args = nil, options = nil)
      @table = table if table
      @fields = options.fetch(:fields) if options.key?(:fields)
      @fields = options.fetch(:) if options.key?(:fields)

      if options.key?(:ids)
        puts data.data.map(:id).join(",")
      else
        fields = options.fetch(:fields).split(",") if options.key?(:fields)
        case cmd
        when :list
          @ids = args.first || options.fetch(:ids)
        when :search
        end
        @query =
          if cmd == :search
            args.join(" ")
          elsif options.key?(:q)
            options.fetch(:q)
          end

        data = CalibreAPI[table]
        data = data.find(ids.split(",")) if ids
        data = data.query(query) if query
        data = data.by(options.fetch(:sort)) if options.key?(:sort)
        data = data.desc if options.key?(:desc)

        #puts args.inspect
        puts data.meta.as_json(*fields)
      end
    end

    def meta
      results if @updated
      @updated = false
    end
  end
end
