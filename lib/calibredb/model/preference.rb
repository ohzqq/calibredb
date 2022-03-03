module Calibredb
  module Model
    class Preference
      include Calibredb::Model

      def initialize(library)
        @library = library
        @model = library.preferences
      end
    end
  end
end
