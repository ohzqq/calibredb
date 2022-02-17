module Calibredb
  module Model
    autoload :Author, 'calibredb/model/author'
    autoload :Book, 'calibredb/model/book'
    autoload :Comment, 'calibredb/model/comment'
    autoload :Datum, 'calibredb/model/datum'
    autoload :Identifier, 'calibredb/model/identifier'
    autoload :Language, 'calibredb/model/language'
    autoload :NameColumn, 'calibredb/model/name_column'
    autoload :Publisher, 'calibredb/model/publisher'
    autoload :Rating, 'calibredb/model/rating'
    autoload :Series, 'calibredb/model/series'
    autoload :Shared, 'calibredb/model/shared'
    autoload :Tag, 'calibredb/model/tag'

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

