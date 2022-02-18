module Calibredb
  module Model
    class Preference
      include Calibredb::Model

      def initialize(library)
        @library = library
        @model = library.const_get(:Preferences)
      end
    end
  end
end
