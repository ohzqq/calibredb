module CalibreAPI
  class Book
    def initialize(dataset, library)
      @books = dataset
      @library = library
    end
    
    def as_json(*associations)
      as_hash(*associations).to_json
    end

    def as_hash(*associations)
      fields = [:authors] + associations
      @books.map do |row|
        meta = {}
        meta[:id] = row.id
        meta[:title] = row.title
        meta[:sort] = row.sort
        meta[:timestamp] = row.timestamp
        meta[:pubdate] = row.pubdate
        meta[:series_index] = row.series_index if fields.include?(:series)
        meta[:author_sort] = row.author_sort
        meta[:isbn] = row.isbn
        meta[:lccn] = row.lccn
        meta[:path] = row.path
        meta[:uuid] = row.uuid
        meta[:has_cover] = row.has_cover
        meta[:last_modified] = row.last_modified
        meta[:url] = "/#{@library}/books/#{row.id}"
        fields.each do |a|
          dataset = a == :formats ? :data_dataset : :"#{a}_dataset"
          meta[a] = Association.new(a, row.send(dataset), @library).as_hash
        end
        meta
      end
    end
  end
end
