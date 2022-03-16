module Calibredb
  module Model
    class Book
      include Calibredb::Model

      def initialize(library)
        @library = library.models
        @model = library.models[:books]
      end

      def associations
        one_to_many
        many_to_many
      end

      def dataset_module
        @model.def_column_alias(:added, :timestamp)
        @model.dataset_module do
          order :default, :sort
          order :modified, :last_modified
          order :pubdate, :pubdate
          order :added, :timestamp
      
          def data
            default
          end

          def library
            Calibredb
              .libraries
              .to_h
              .slice(*Calibredb.libraries.list.map(&:to_sym))
              .values
              .select do |l|
              l.db.values.include?(self.model)
            end.first
          end
          
          def meta
            Calibredb::Book::Books.new(self, library.name)
          end
          
          #def meta(*associations, desc: nil, format: "hash")
          #  fields = [:authors] + associations
          #  d = desc ? data.reverse : data
          #  self.send(:"as_#{format}", d, fields)
          #end
          
          def as_string(dataset, fields)
            dataset.map do |row|
              meta = {}
              meta[:id] = row.id.to_s
              meta[:title] =
                if row.series_dataset.count == 0
                  row.title
                else
                  "#{row.title} [#{row.series.first.value}, Book #{row.series_index}]"
                end
              meta[:series_index] = row.series_index.to_s if fields.include?(:series)
              fields.each do |a|
                next if a == :series_index

                if dataset.columns.include?(a) && !Calibredb.fields.dates_and_times.to_sym.include?(a)
                  meta[a] = row.send(a).to_s
                elsif Calibredb.fields.dates_and_times.to_sym.include?(a)
                  a = a == "added" ? "timestamp" : a
                  meta[a] = row.send(a).strftime("%F")
                else
                  d = a == :formats ? :data_dataset : :"#{a}_dataset"
                  books = nil
                  meta[a] = row.send(d).as_string
                end
              end
              meta
            end
          end

          def as_json(dataset, fields)
            as_hash(dataset, fields).to_json
          end
          
          def metadata
            map {|b| Calibredb::Meta.new(b, library)}
          end

          def as_hash(*associations, desc: nil, format: "hash")
            fields = [:authors] + associations
            dataset = desc ? data.reverse : data
            dataset.map do |row|
              meta = {}
              meta[:id] = row.id
              meta[:title] = row.title
              meta[:series_index] = row.series_index if fields.include?(:series)

              fields.each do |a|
                next if a == :series_index

                if dataset.columns.include?(a)
                  meta[a] = row.send(a)
                else
                  d = a == :formats ? :data_dataset : :"#{a}_dataset"
                  books = nil
                  meta[a] = row.send(d).as_hash(books)
                end
              end
              meta
            end
          end

          def category
            :books
          end

          def query(query, sort = :default)
            opts = {all_patterns: true, case_insensitive: true}
            query = query.split(" ").map {|q| "%#{q}%"}
            results =
              if library.audiobooks == true
                audiobooks(query, opts, sort)
              else
                ebooks(query, opts, sort)
              end
          end

          def ebooks(query, opts, sort)
            data
              .grep(:title, query, opts)
              .or(tags: library.db[:tags].grep(:name, query, opts))
              .or(authors: library.db[:authors].grep(:name, query, opts))
              .or(comments: library.db[:comments].grep(:text, query, opts))
              .or(series: library.db[:series].grep(:name, query, opts))
          end

          def audiobooks(query, opts, sort)
            data
              .grep(:title, query, opts)
              .or(tags: library.db[:tags].grep(:name, query, opts))
              .or(authors: library.db[:authors].grep(:name, query, opts))
              .or(comments: library.db[:comments].grep(:text, query, opts))
              .or(series: library.db[:series].grep(:name, query, opts))
              .or(narrators: library.db[:narrators].grep(:value, query, opts))
          end
        end
      end

      def many_to_many
        %w[author publisher tag rating].each do |association|
          @model.many_to_many(
            :"#{association}s",
            join_table: :"books_#{association}s_link",
            left_key: :book,
            right_key: association.to_sym,
            class: @library[:"#{association}s"]
          )
        end

        @model.many_to_many(
          :series,
          left_key: :book,
          right_key: :series,
          join_table: :books_series_link,
          class: @library[:series],
          order: :sort
        )

        @model.many_to_many(
          :languages,
          left_key: :book,
          right_key: :lang_code,
          join_table: :books_languages_link,
          class: @library[:languages]
        )
      end

      def one_to_many
        @model.one_to_many(
          :data,
          key: :book,
          class: @library[:data]
        )

        @model.one_to_many(
          :comments,
          key: :book,
          class: @library[:comments]
        )

        @model.one_to_many(
          :identifiers,
          key: :book,
          class: @library[:identifiers]
        )

      end
    end
  end
end
