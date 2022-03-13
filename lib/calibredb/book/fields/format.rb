module URbooks
  module Data
    module Fields
      class Format
        include URbooks::Data::Helpers
        include URbooks::Data::Helpers::Dataset
        include URbooks::Data::Helpers::Formats

        attr_accessor :book, :ext, :data

        def initialize(book, data, ext)
          @book = book
          @data = data
          @ext = ext
          @path = File.join(book.path, name)
        end

        def path
          self
        end

        def get
          @path
        end

        def name
          "#{row.name}.#{@ext}"
        end

        def download
          File.join(lib.server.library_path, @path)
        end

        def url
          build_url
        end

        def length
          URbooks::Audiobooks::Helpers.duration(absolute)
        end

        def duration
          if audiofiles.include?(@ext)
            @book.duration.first.nil? ? length : @book.duration.first.value
          else
            raise TypeError, "Not an audiobook"
          end
        rescue TypeError => error
          puts error.message
        end
      end
    end
  end
end
