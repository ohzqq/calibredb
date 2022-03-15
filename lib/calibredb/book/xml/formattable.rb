module Calibredb
  module Book
    module XML
      module Formattable
        extend self
        
        def as_xml
          t = @file_name ? @file_name : template
          formatter.format(t)
        end

        def render(file_name, object, options)
          @file_name = file_name
          formatter.render(file_name, object, options)
        end

        def formatter
          @formatter ||= Calibredb::Book::XML::Formatter.new(self)
        end
      end
    end
  end
end
