module Calibredb
  module Dataset
    module Book
      #order :default, :sort
      #order :modified, :last_modified
      #order :pubdate, :pubdate
      #order :added, :timestamp
          def query(query, sort = :default)
            opts = {all_patterns: true, case_insensitive: true}
            query = query.split(" ").map {|q| "%#{q}%"}
            #results =
            #  if library.audiobooks == true
            #    audiobooks(query, opts, sort)
            #  else
            #    ebooks(query, opts, sort)
            #  end
          end
      
      
    end
  end
end
