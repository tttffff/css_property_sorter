# frozen_string_literal: true

module CssPropertySorter
  module Utils
    class FixViolation
      def self.call(violation)
        new(violation).tap(&:fix)
      end

      attr_reader :issue_info

      def initialize(violation)
        @violation = violation
      end

      def issue?
        @issue_info
      end

      def fix
        File.open(@violation.file_path, "rb+") do |css_file|
          css_file.seek(@violation.start_byte)
          css_section = css_file.read(@violation.number_of_bytes)
          simple_breakdown = css_section.match(/\A([^\n]+\n)(.*)(\n\}\n)\Z/m)
          break set_issue_info("Couldn't breakdown CSS structure", css_section) unless simple_breakdown
          selector_line, properties, closing_line = simple_breakdown.captures
          indent = properties[/\s+/] # Take the indent from the first item
          new_properties = expected_properties(indent)
          new_css_section = selector_line + new_properties + closing_line
          break set_issue_info("Couldn't replace CSS structure", css_section) unless css_section.size == new_css_section.size
          css_file.seek(@violation.start_byte)
          css_file.write(new_css_section)
        end
      end

      private

      def set_issue_info(message, css_section)
        @issue_info = {message:, css_section:}
      end

      def expected_properties(indent)
        @violation.properties_in_desired_order.map { indent + _1 }.join("\n")
      end
    end
  end
end
