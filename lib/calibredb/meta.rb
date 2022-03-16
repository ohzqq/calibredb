module Calibredb
  class Meta
    attr_accessor :data, :library, :authors, :tags, :languages, :ratings, :comments, :publishers, :identifiers, :series, :title, :pubdate, :added, :last_modified, :cover, :formats, :path, :series_index, :id, :sort, :author_sort, :lccn, :isbn, :uuid

    def initialize(dataset, library)
      @data = row(dataset)
      @lib = library
      @library = library.name

      @added = added_data
      @author_sort = author_sort_data
      @authors = authors_data
      @comments = comments_data
      @cover = cover_data
      @formats = formats_data
      @id = id_data
      @identifiers = identifiers_data
      @isbn = isbn_data
      @languages = languages_data
      @last_modified = last_modified_data
      @lccn = lccn_data
      @path = path_data
      @pubdate = pubdate_data
      @publishers = publishers_data
      @ratings = ratings_data
      @series = series_data
      @series_index = series_index_data
      @title = title_data
      @sort = sort_data
      @tags = tags_data
      @uuid = uuid_data
      custom
    end

    def row(meta)
      dataset?(meta) ? meta.first : meta
    end
    
    def dataset?(meta)
      meta.class.name == "Sequel::SQLite::Dataset" 
    end

    def authors_data
      @data.authors_dataset
    end

    def tags_data
      @data.tags_dataset
    end
    
    def languages_data
      @data.languages_dataset
    end

    def ratings_data
      @data.ratings_dataset
    end

    def identifiers_data
      @data.identifiers_dataset
    end
    
    def dates
      Struct.new(:date) do
        def to_s
          date == null ? "" : date.strftime("%F")
        end

        def null
          Time.parse('0101-01-01 00:00:00 +0000')
        end
      end
    end

    def pubdate_data
      d = dates.new
      d.date = @data.pubdate
      d
    end

    def added_data
      d = dates.new
      d.date = @data.added
      d
    end

    def last_modified_data
      d = dates.new
      d.date = @data.last_modified
      d
    end

    def path_data
      Pathname.new(@data.path)
    end

    def cover_data
      formats_data.get(:cover)
    end

    def formats_data
      Calibredb::DatasetMethods::Format.new(@data, @lib)
    end

    def comments_data
      @data.comments_dataset
    end

    def publishers_data
      @data.publishers_dataset
    end

    def series_data
      @data.series_dataset
    end

    def title_data
      t = Struct.new(:book) do
        def to_s
          book.title
        end

        def join
          if book.series_dataset.count == 0
            book.title
          else
            "#{book.title} [#{book.series.first.value}, Book #{book.series_index}]"
          end
        end
      end
      t.new(@data)
      #title_series_index.title
    end

    def series_index_data
      @data.series_index.to_s
    end

    def title_series_index
      Calibredb::Book::Fields::TitleSeriesIndex.new(
        title: Book::Fields::BookColumn.new(@library, @data, :title),
        series: Book::Fields::Singles.new(@data, :series),
        series_index: Book::Fields::BookColumn.new(@library, @data, :series_index)
      )
    end

    def sort_data
      @data.sort
    end

    def id_data
      @data.id.to_s
    end

    def author_sort_data
      @data.author_sort
    end

    def lccn_data
      @data.lccn
    end

    def isbn_data
      @data.isbn
    end

    def uuid_data
      @data.isbn
    end

    def custom
      Calibredb.libraries[@library].custom_columns.each do |col|
        self.class.send(:define_method, col) do
          @data.send(:"#{col}_dataset")
        end
      end
    end

    def as_hash(*associations, desc: nil)
      h = {}
      Calibredb.fields.associations.to_sym.each do |a|
        h[a] = self.send(a).as_hash
      end
      Calibredb.fields.book.to_sym.each do |c|
        h[c] = self.send(c)
      end
      Calibredb.fields.dates_and_times.to_sym.each do |d|
        h[d] = self.send(d).to_s
      end
      h[:title] = h[:title].to_s
      h[:path] = h[:path].to_path
      h
    end

    def as_ini
      Calibredb::Book.convert(self).ini
    end

    def as_yml
      Calibredb::Book.convert(self).yml
    end

    def as_calibre
      Calibredb::Book.convert(self).calibre
    end

    def book_to_hash(type)
      Calibredb::Book.convert(self).hash(plain: type)
    end
  end
end
