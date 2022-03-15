require 'builder'
require 'tilt'
module Calibredb
  module Book
    module XML
      class Formatter
        attr_reader :formattable

        def initialize(formattable)
          @formattable = formattable
          @xml = Builder::XmlMarkup.new(indent: 2)
        end

        def format(file_name)
          render(file_name, formattable, xml: @xml)
        end

        def render(file_name, object, options)
          file = "#{template_path}/#{file_name}.builder"
          Tilt.new(file).render(object, options)
        end

        def template_path
          File.join(__dir__, "templates")
        end
      end
    end
  end
end
