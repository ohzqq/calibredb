module Calibredb
  module Book
    class Convert
      def initialize(book)
        @book = book
      end

      def all_fields
        Calibredb.fields.book.associations.custom_columns.to_sym
      end

      def editable
        Calibredb.fields.editable.to_sym
      end

      def calibre(fields = nil)
        fields ||= editable
        calibre = []
        fields.each do |field|
          next unless fields.include?(field)
          next unless @book.class.method_defined?(field)
          val = @book.send(field)
          next unless val
          next if val.get.empty?
          field = "##{field}" if Calibredb.fields.custom_field?(field)
          calibre << "#{field}:#{val.get}"
        end
        return calibre
      end

      def ini
        ini = {}
        ffmeta = ";FFMETADATA\n"
        ini[:title] = @book.title.join
        ini[:album] = @book.title.join
        ini[:artist] = @book.authors.get
        ini[:composer] = @book.narrators.get
        ini[:genre] = @book.tags.get
        ini[:comment] = @book.comments.get
        ini.each {|k,v| ffmeta << "#{k}=#{v}\n"}
        return ffmeta
      end

      def yml
        hash(plain: true).slice(*editable).to_yaml
      end

      def raw(field)
        @book.send(field).as_hash
      end

      def plain(field)
        if @book.send(field).class.method_defined?(:map)
          @book.send(field).map
        else
          @book.send(field).get
        end
      end

      def hash(plain: nil)
        b = {}
        all_fields.each do |field|
          next unless @book.class.method_defined?(field)
          val = @book.send(field)
          next unless val
          b[field] = plain ? plain(field) : raw(field)
        end
        return b
      end
    end
  end
end
