
module URbooks
  module Data
    module Fields
      class Names
        include URbooks::Data::Helpers
        include URbooks::Data::Helpers::Dataset
        include URbooks::Data::Helpers::Associations

        attr_accessor :data

        def initialize(data)
          @data = data
        end
        
        def get(val = nil)
          val ? data_get(val) : map.join(" & ")
        end
      end
    end
  end
end
