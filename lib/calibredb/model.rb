module Calibredb
  module Model
    autoload :Author, 'calibredb/model/author'
    autoload :Tag, 'calibredb/model/tag'
    autoload :Publisher, 'calibredb/model/publisher'
    autoload :Series, 'calibredb/model/series'
    autoload :NameColumn, 'calibredb/model/name_column'
    autoload :Shared, 'calibredb/model/shared'

    def sort_by_book_count(data)
      data
        .map {|d| [d.books_dataset.count, d.id]}
        .sort
        .map(&:last)
    end
        
    def sorted_book_count_map(cols, sorted)
      result = []
      sorted.each do |id|
        result << cols[id]
      end
      result
    end
  end
end

