module Calibredb
  module Book
    module Helpers
      module Formats
        extend self

        def cover
          cover? ? File.join(book.path, "cover.jpg") : ""
        end

        def cover?
          book.has_cover == true
        end

        def absolute
          File.join(Calibredb.libraries[library].path, path.get)
        end

        def relative
          File.join(library, path.get)
        end

        def has_format?(ext)
          extensions.include?(ext.to_s)
        end

        def extensions
          data.map {|f| f.value.downcase}
        end
        
        def as_hash(book_ids: nil, book_total: nil)
          format_dataset.map do |r|
            hash = hashify(r)
            hash[:book_ids] = [r[:book]] if book_ids
            hash[:book_total] = 1 if book_total
            hash
          end
        end

        def hashify(row)
          meta = {}
          meta[:id] = row.id
          meta[:value] = row.value.downcase
          return meta
        end
      end
    end
  end
end
