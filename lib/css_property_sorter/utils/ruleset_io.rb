# frozen_string_literal: true

module CssPropertySorter
  module Utils
    class RulesetIo
      attr_reader :violation

      def initialize(violation)
        @violation = violation
      end

      def io(&block)
        File.open(violation.file_path, "rb+") do |css_file|
          css_section = read_section(css_file)
          writer = method(:write_from_section_start).curry.call(css_file)
          block.call(css_section, writer)
        end
      end

      private

      def read_section(css_file)
        css_file.seek(violation.start_byte)
        css_file.read(violation.number_of_bytes)
      end

      def write_from_section_start(css_file, new_data)
        css_file.seek(violation.start_byte)
        css_file.write(new_data)
      end
    end
  end
end
