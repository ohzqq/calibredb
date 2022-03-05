module CalibreAPI
  module Commands
    autoload :List, 'calibre_api/commands/list'
    autoload :Search, 'calibre_api/commands/search'

    def data(cmd, table, args, options)
      data = CalibreAPI[table]

      if options.key?(:ids)
        puts data.data.map(:id).join(",")
      else
        fields = options.fetch(:fields).split(",") if options.key?(:fields)
        case cmd
        when :list
          ids = args.first || options.fetch(:ids)
        when :search
          query = args.join(" ")
        end

        data = CalibreAPI[table]
        data = data.find(ids.split(",")) if ids
        data = data.query(query) if query
        data = data.by(options.fetch(:sort)) if options.key?(:sort)
        data = data.desc if options.key?(:desc)

        puts data.meta.as_json(*fields)
      end
    end
  end
end
