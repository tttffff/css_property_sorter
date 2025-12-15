# frozen_string_literal: true

CssPropertySorter::RakeHelpers[self, "Look for violations and report them.", :report] do
  file_paths_enum = CssPropertySorter::Utils::FilePathsEnumerator.call
  violations_enum = CssPropertySorter::Utils::ViolationsEnumerator.call(file_paths_enum)
  issues_enum = violations_enum.map do |violation|
    CssPropertySorter::Utils::RulesetIo.new(violation).io do |css_section|
      {file_path: violation.file_path, message: "Ruleset properties out of order.\n\n#{css_section}"}
    end
  end
  issues = issues_enum.to_a

  if issues.any?
    error = CssPropertySorter::Utils::Error.new(issues)
    raise_on_error = ENV.fetch("CPS_RAISE", "true") == "true"
    raise_on_error ? raise(error) : puts(error.message)
  else
    puts "No issues found"
  end
end
