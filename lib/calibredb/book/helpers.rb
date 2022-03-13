module URbooks
  module Data
    module Helpers
      autoload :Dataset, 'urbooks/data/helpers/dataset'
      autoload :Associations, 'urbooks/data/helpers/associations'
      autoload :Columns, 'urbooks/data/helpers/columns'
      autoload :Formats, 'urbooks/data/helpers/formats'

      extend self

      def fields(lib = nil)
        lib ||= library
        URbooks::Book.fields(lib)
      end

      def library
        if dataset?
          data.library.name
        else
          Calibredb.const_get(data.class.name.split("::")[1]).name
        end
      end

      def row?
        data.class.name.include?("Calibredb")
      end

      def dataset?
        data.class.name == "Sequel::SQLite::Dataset" 
      end

      def is_book?
        data.class.name.include?("Book")
      end

      def custom_is_multiple?(library, column)
        Calibredb.db(library).from("custom_columns").is_multiple?(column)
      end
      
      def custom_is_names?(library, column)
        Calibredb.db(library).from("custom_columns").is_names?(column)
      end
      
      def constantize(name)
        name.gsub(/[[:punct:]]/, " ")
          .titlecase
          .delete(" ")
          .to_sym
      end
    end
  end
end
