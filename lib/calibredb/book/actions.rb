module Calibredb
  module DData
    module Actions
      extend self
      
      def new_library(path, **opts)
        db = File.join(path, "metadata.db")
        Calibredb::CLI::Helpers.spinner(msg: "New library") { initialize_calibre_db(db: db) }
        if opts.key?(:audiobooks)
          add_narrator_column(path, **opts)
          add_duration_column(path, **opts)
        end
      end

      def add_narrator_column(path, **opts)
        cmd = "calibredb --with-library '#{path}' "\
          "add_custom_column narrators Narrators text "\
          "--is-multiple "\
          "--display '{\"is_names\": true, \"description\": \"narrators\"}'"
        Calibredb::CLI::Helpers.execute(cmd)
      end

      def add_duration_column(path, **opts)
        cmd = "calibredb --with-library '#{path}' "\
          "add_custom_column duration Duration comments "\
          "--display "\
          "{\"heading_position\": \"side\", \"interpret_as\": \"long-text\", \"description\": \"Duration of audio file\"}"
        Calibredb::CLI::Helpers.execute(cmd)
      end

      def initialize_calibre_db(db:)
        migration = File.join(File.absolute_path(__dir__), "migrations")
        Sequel.extension :migration
        Sequel.sqlite(db) do |database|
          Sequel::Migrator.run(database, migration)
        end
      end
    end
  end
end
