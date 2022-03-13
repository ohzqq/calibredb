module URbooks
  module Data
    module Helpers
      module Formats
        extend self

        def index
          data.as_hash(:format, :id).transform_keys(&:downcase)
        end

        def build_url(file = nil)
          file ||= "#{row[:book]}.#{ext}"
          if downloadable? || cover?
            URI::HTTPS.build(
              host: lib.server.host,
              path: "/dl/#{library}/books/#{file}"
            ).to_s

            #URI::HTTP.build(
            #  host: "0.0.0.0",
            #  port: 9292,
            #  path: "/dl/#{library}/books/#{file}"
            #).to_s

          end
        end

        def downloadable?
          lib[library].export.formats.include?(ext)
        end

        def cover
          cover? ? File.join(book.path, "cover.jpg") : ""
        end

        def cover?
          book.has_cover == true
        end

        def row
          data[index[ext]]
        end

        def format_dataset(ext = nil)
          ext ? data.where(id: [index[ext]]) : data
        end

        def absolute
          File.join(lib[library].path, path.get)
        end

        def relative
          File.join(library, path.get)
        end

        def has_format?(ext)
          extensions.include?(ext.to_s)
        end

        def audiobook(ext = nil)
          ext ||= audiofiles.first
          format_data(book, ext.to_s)
        end

        def audiofiles
          lib[library].audiobooks.formats.map do |format|
            next unless has_format?(format)
            format
          end.compact
        end

        def extensions
          data.map {|f| f.value.downcase}
        end

        def format_data(book, ext)
          URbooks::Data::Fields::Format.new(book, format_dataset(ext), ext)
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
