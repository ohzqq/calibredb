module Calibredb
  module Book
    module Helpers
      autoload :Dataset, 'calibredb/book/helpers/dataset'
      autoload :Associations, 'calibredb/book/helpers/associations'
      autoload :Formats, 'calibredb/book/helpers/formats'

      extend self

      def fields(lib = nil)
        lib ||= library
        Calibredb.fields(lib)
      end

      def library
        data.library.name
      end

      def dataset?
        data.class.name == "Sequel::SQLite::Dataset" 
      end

      def custom_is_multiple?(library, column)
        Calibredb.db(library).from("custom_columns").is_multiple?(column)
      end
      
      def custom_is_names?(library, column)
        Calibredb.db(library).from("custom_columns").is_names?(column)
      end
    end
  end
end
