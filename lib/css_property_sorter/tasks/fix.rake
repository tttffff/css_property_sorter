# frozen_string_literal: true

CssPropertySorter::RakeHelpers[self, "Look for violations and attempt to fix them.", :fix] do
  file_paths_enum = CssPropertySorter::Utils::FilePathsEnumerator.call
  violations_enum = CssPropertySorter::Utils::ViolationsEnumerator.call(file_paths_enum)
  violation_fixes = violations_enum.map { CssPropertySorter::Utils::FixViolation.call(_1) }
  failures, fixes = violation_fixes.partition(&:issue?) # We collect on the enum here.

  if failures.any?
    error = CssPropertySorter::Utils::Error.new(failures.map(&:issue))
    raise_on_error = ENV.fetch("CPS_RAISE", "false") == "true"
    raise_on_error ? raise(error) : puts(error.message)
  end

  CssPropertySorter::Utils::Inflector[fixes] { "\nThere #{have} been: #{size} fix#{es}" }
  CssPropertySorter::Utils::Inflector[failures] { "There #{have} been: #{size} failure#{s}\n\n" }
end
