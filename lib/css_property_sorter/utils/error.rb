# frozen_string_literal: true

module CssPropertySorter
  module Utils
    class Error < StandardError
      NUMBER_OF_ISSUES_TO_SHOW = ENV.fetch("CPS_NITS", 5).to_i # Ha

      attr_reader :violation_fix_issues, :number_of_issues_to_show

      def initialize(violation_fix_issues, number_of_issues_to_show: NUMBER_OF_ISSUES_TO_SHOW)
        @violation_fix_issues, @number_of_issues_to_show = violation_fix_issues, number_of_issues_to_show
        super(pretty_issues)
      end

      private

      def pretty_issues
        issues_to_print = violation_fix_issues[0...number_of_issues_to_show]
        Inflector[issues_to_print] { "\n\nFirst #{size} issue#{s}\n\n"}
        issues_to_print.map do |issue|
          issue_info = issue.issue_info
          "#{issue_info[:message]}\n#{issue_info[:css_section]}"
        end.join("\n\n")
      end
    end
  end
end
