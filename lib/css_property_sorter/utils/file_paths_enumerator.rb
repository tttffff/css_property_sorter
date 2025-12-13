# frozen_string_literal: true

module CssPropertySorter
  module Utils
    class FilePathsEnumerator
      WANTED_EXTENSIONS = %w[css scss sass less].freeze

      def self.call
        new.git_file_paths_enumerator
      end

      attr_reader :wanted_extensions

      def initialize(wanted_extensions = WANTED_EXTENSIONS)
        @wanted_extensions = wanted_extensions
      end

      def git_file_paths_enumerator
        git = Git.open(Dir.pwd)
        git
          .status # All files known to git.
          .lazy # Lazy so we only loop once (and get a file completed at a time.)
          .map(&:path) # We only want the file paths.
          .select(&method(:has_wanted_extension?)) # Only want ones with a CSS extension.
          .map(&method(:print_message_and_return)) # Have to map to maintain as a enum.
      end

      private

      def has_wanted_extension?(path)
        exetension_no_dot = File.extname(path)[1..]
        wanted_extensions.include?(exetension_no_dot)
      end

      def print_message_and_return(path)
        puts "Found: #{path}"
        path
      end
    end
  end
end
