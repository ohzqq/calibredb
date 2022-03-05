module CalibreAPI
  class Association
    def initialize(name, dataset, library)
      @data = dataset
      @name = name
      @library = library
    end
    
    def as_json
      as_hash.to_json
    end

    def as_hash
      @data.map do |row|
        meta = {}
        meta[:value] = row.value
        meta[:id] = row.id
        if CalibreAPI.fields.many_books_to_many.to_sym.include?(@name) ||
            CalibreAPI.fields.one_to_many_books.to_sym.include?(@name)
          meta[:book_ids] = row.books_dataset.map(:id)
          meta[:total_books] = row.books_dataset.count
        end
        meta[:url] = "/#{@library}/#{@name}/#{row.id}"
        meta
      end
    end
  end
end

