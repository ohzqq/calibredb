module Calibredb
  module Model
    class Preference
      include Calibredb::Model

      def initialize(library)
        @library = library.models
        @model = library.models[:preferences]
      end
    end
  end
end
