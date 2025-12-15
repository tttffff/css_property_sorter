# frozen_string_literal: true

module CssPropertySorter
  module Utils
    class FixViolation
      BREAKDOWN_MESSAGE = <<~MESSAGE
        Our simple method of splitting the CSS ruleset was unsuccesfull.
        Please raise an issue on GitHub and include the CSS. #{CssPropertySorter::REPO}
      MESSAGE
      STRUCTURE_MISMATCH_MESSAGE = <<~MESSAGE
        Could not update the ruleset in a safe manner.
        Look for missing semi-colons or extra white-space, then re-run after fixing these.
        Rulesets that include comments need manually sorting.
      MESSAGE

      ISSUE_MESSAGES = {
        breakdown: BREAKDOWN_MESSAGE,
        structure_mismatch: STRUCTURE_MISMATCH_MESSAGE
      }

      def self.call(violation)
        new(violation).tap(&:fix)
      end

      attr_reader :issue, :violation, :issue_messages

      def initialize(violation, issue_messages: ISSUE_MESSAGES)
        @violation, @issue_messages = violation, issue_messages
      end

      def issue?
        @issue
      end

      def fix
        RulesetIo.new(violation).io do |css_section, ruleset_writer|
          simple_breakdown = css_section.match(/\A(.*?\{+\n)(.*)(\n\s*\}\n)\Z/m)
          break set_issue_info(:breakdown, css_section) unless simple_breakdown
          selector_line, properties, closing_line = simple_breakdown.captures
          indent = properties[/\s+/] # Take the indent from the first item
          new_properties = expected_properties(indent)
          new_css_section = selector_line + new_properties + closing_line
          break set_issue_info(:structure_mismatch, css_section) unless css_section.size == new_css_section.size
          ruleset_writer.call(new_css_section)
        end
      end

      private

      def set_issue_info(issue_type, css_section)
        @issue = {file_path: violation.file_path, message: "#{issue_messages[issue_type]}\n#{css_section}"}
      end

      def expected_properties(indent)
        violation.properties_in_desired_order.map { indent + _1 }.join("\n")
      end
    end
  end
end
