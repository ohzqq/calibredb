
module Calibredb
  module Book
    module Fields
      class Singles
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Dataset
        include Calibredb::Book::Helpers::Associations

        attr_accessor :data

        def initialize(data)
          @data = data
        end

        def get(val = :value)
          data.first ? data.first.public_send(val).smart_format : ""
        end
      end
    end
  end
end
