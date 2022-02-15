module Calibredb
  module Associations
    attr_accessor :models
    
    def custom_column_models(lib_db, db, library)
      lib_db.const_get(:CustomColumn).each do |custom_column|
        custom_column_model = constantize(custom_column.label)
        add_to_models(custom_column.label, lib_db)
        col = :"custom_column_#{custom_column.id}"
        klass = Class.new(Sequel::Model)
        lib_db.const_set(custom_column_model, klass)
        lib_db.const_get(custom_column_model).dataset = db[col]

        case custom_column.is_multiple
        when true
          custom_column_many_to_many(lib_db, col, custom_column.label)
        when false
          custom_column_one_to_many(lib_db, col, custom_column.label)
        end
      end
    end

    def add_to_models(label, library)
      custom = {label => constantize(label)}
      #lib = Calibredb.libraries[library]
      library.custom_columns = library.custom_columns.merge(custom)
      library.models = library.models.merge(custom)
      #Calibredb::CUSTOM_COLUMNS[label] = constant
    end

    def custom_column_many_to_many(model, col, label)
      model.const_get(constantize(label)).many_to_many(
        :books,
        left_key: :value, 
        right_key: :book, 
        join_table: :"books_#{col}_link",
        class: model.const_get(:Book),
        order: :sort
      )

      model.const_get(:Book).many_to_many(
        label.to_sym,
        join_table: :"books_#{col}_link",
        left_key: :book,
        right_key: :value,
        class:  model.const_get(constantize(label.capitalize))
      )
    end

    def custom_column_one_to_many(model, col, label)
      model.const_get(constantize(label)).many_to_one(
        :book,
        key: :book,
        class: model.const_get(:Book)
      )

      model.const_get(:Book).one_to_many(
        label.to_sym,
        key: :book,
        class:  model.const_get(constantize(label))
      )
    end

    def book_associations(model)
      model.const_get(:Book).one_to_many(
        :data,
        key: :book,
        class: model.const_get(:Datum)
      )

      model.const_get(:Book).one_to_many(
        :comments,
        key: :book,
        class: model.const_get(:Comment)
      )

      model.const_get(:Book).one_to_many(
        :identifiers,
        key: :book,
        class: model.const_get(:Identifier)
      )

      %w[author publisher tag rating].each do |association|
        model.const_get(:Book).many_to_many(
          :"#{association}s",
          join_table: :"books_#{association}s_link",
          left_key: :book,
          right_key: association.to_sym,
          class: model.const_get(association.capitalize.to_sym)
        )
      end

      model.const_get(:Book).many_to_many(
        :series,
        left_key: :book,
        right_key: :series,
        join_table: :books_series_link,
        class: model.const_get(:Series),
        order: :sort
      )

      model.const_get(:Book).many_to_many(
        :languages,
        left_key: :book,
        right_key: :lang_code,
        join_table: :books_languages_link,
        class: model.const_get(:Language)
      )
    end

    def author_associations(model)
      model.const_get(:Author).many_to_many(
        :books,
        left_key: :author, 
        right_key: :book, 
        join_table: :books_authors_link,
        class: model.const_get(:Book),
        order: :sort
      )
    end

    def rating_associations(model)
      model.const_get(:Rating).many_to_many(
        :books,
        left_key: :rating, 
        right_key: :book, 
        join_table: :books_ratings_link,
        class: model.const_get(:Book),
      )
    end

    def tag_associations(model)
      model.const_get(:Tag).many_to_many(
        :books,
        left_key: :tag, 
        right_key: :book, 
        join_table: :books_tags_link,
        class: model.const_get(:Book),
        order: :sort
      )
    end

    def publisher_associations(model)
      model.const_get(:Publisher).many_to_many(
        :books,
        left_key: :publisher, 
        right_key: :book, 
        join_table: :books_publishers_link,
        class: model.const_get(:Book)
      )
    end

    def comment_associations(model)
      model.const_get(:Comment).many_to_one(
        :book,
        key: :book,
        class: model.const_get(:Book)
      )
    end

    def data_associations(model)
      model.const_get(:Datum).many_to_one(
        :book,
        key: :book,
        class: model.const_get(:Book)
      )
    end

    def identifier_associations(model)
      model.const_get(:Identifier).many_to_one(
        :book,
        key: :book,
        class: model.const_get(:Book)
      )
    end

    def language_associations(model)
      model.const_get(:Language).many_to_many(
        :books,
        left_key: :lang_code, 
        right_key: :book, 
        join_table: :books_languages_link,
        class: model.const_get(:Book)
      )
    end

    def series_associations(model)
      model.const_get(:Series).many_to_many(
        :books,
        left_key: :series, 
        right_key: :book, 
        join_table: :books_series_link,
        class: model.const_get(:Book),
        order: :sort
      )
    end
  end
end
