
module URbooks
  module Data
    module Fields
      class Cover
        include URbooks::Data::Helpers
        include URbooks::Data::Helpers::Dataset
        include URbooks::Data::Helpers::Formats

        attr_accessor :book, :ext, :data

        def initialize(book)
          @book = book
          @data = book
          @ext = 'jpg'
        end

        def get
          cover
        end

        def path
          self
        end

        def url
          build_url("#{book.id}#{File.extname(cover)}")
        end
      end
    end
  end
end
