module Calibredb
  module Model
    class Book
      def initialize(library)
        @library = library
        @model = library.const_get(:Book)
      end

      def associations
        one_to_many
        many_to_many
      end

      def dataset_module
        @model.dataset_module do
          order :default, :sort
          order :modified, :last_modified
          order :pubdate, :pubdate
          order :added, :timestamp

          def query(query, sort = :default)
            opts = {all_patterns: true, case_insensitive: true}
            query = query.split(" ").map {|q| "%#{q}%"}
            results =
              if Calibredb.libraries[lib.current.name].audiobooks == true
                audiobooks(query, opts, sort)
              else
                ebooks(query, opts, sort)
              end
          end

          def ebooks(query, opts, sort)
            data(sort)
              .grep(:title, query, opts)
              .or(tags: lib.current.db["tags"].grep(:name, query, opts))
              .or(authors: lib.current.db["authors"].grep(:name, query, opts))
              .or(comments: lib.current.db["comments"].grep(:text, query, opts))
              .or(series: lib.current.db["series"].grep(:name, query, opts))
          end

          def audiobooks(query, opts, sort)
            data
              .grep(:title, query, opts)
              .or(tags: lib.current.db["tags"].grep(:name, query, opts))
              .or(authors: lib.current.db["authors"].grep(:name, query, opts))
              .or(comments: lib.current.db["comments"].grep(:text, query, opts))
              .or(series: lib.current.db["series"].grep(:name, query, opts))
              .or(narrators: lib.current.db["narrators"].grep(:value, query, opts))
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
            class: @library.const_get(association.capitalize.to_sym)
          )
        end

        @model.many_to_many(
          :series,
          left_key: :book,
          right_key: :series,
          join_table: :books_series_link,
          class: @library.const_get(:Series),
          order: :sort
        )

        @model.many_to_many(
          :languages,
          left_key: :book,
          right_key: :lang_code,
          join_table: :books_languages_link,
          class: @library.const_get(:Language)
        )
      end

      def one_to_many
        @model.one_to_many(
          :data,
          key: :book,
          class: @library.const_get(:Datum)
        )

        @model.one_to_many(
          :comments,
          key: :book,
          class: @library.const_get(:Comment)
        )

        @model.one_to_many(
          :identifiers,
          key: :book,
          class: @library.const_get(:Identifier)
        )

      end
    end
  end
end
