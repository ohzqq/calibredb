module Calibredb
  module Model
    class Book
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
            map {|b| Calibredb::Book.new(b, library)}
          end
          
          def as_hash
            meta.map {|b| b.as_hash}
          end

          def to_s
            meta.map {|b| b.to_s}
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
