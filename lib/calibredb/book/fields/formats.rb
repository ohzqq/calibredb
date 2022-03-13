module URbooks
  module Data
    module Fields
      class Formats
        include URbooks::Data::Helpers
        include URbooks::Data::Helpers::Dataset
        include URbooks::Data::Helpers::Formats

        attr_accessor :book, :data

        def initialize(book, data)
          @book = book
          @data = data
        end

        def map
          extensions
        end

        def get(format = nil)
          if map.include?(format.to_s)
            format_data(@book, format.to_s)
          elsif format.to_s == "audiobook"
            audiobook
          else
            extensions.join(", ")
          end
        end
      end
    end
  end
end
