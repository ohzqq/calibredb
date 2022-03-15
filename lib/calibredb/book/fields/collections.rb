
module Calibredb
  module Book
    module Fields
      class Collections
        include Calibredb::Book::Helpers
        include Calibredb::Book::Helpers::Dataset
        include Calibredb::Book::Helpers::Associations

        attr_accessor :data

        def initialize(data)
          @data = data
        end

        def get(val = nil)
          val ? data_get(val) : map.join(", ")
        end
      end
    end
  end
end
