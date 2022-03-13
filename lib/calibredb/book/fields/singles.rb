
module URbooks
  module Data
    module Fields
      class Singles
        include URbooks::Data::Helpers
        include URbooks::Data::Helpers::Dataset
        include URbooks::Data::Helpers::Associations

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
