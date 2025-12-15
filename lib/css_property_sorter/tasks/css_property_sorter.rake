# frozen_string_literal: true

CssPropertySorter::RakeHelpers[self, "Look for violations and attempt to fix them.", :fix] do
  file_paths_enum = CssPropertySorter::Utils::FilePathsEnumerator.call
  violations_enum = CssPropertySorter::Utils::ViolationsEnumerator.call(file_paths_enum)
  violation_fixes = violations_enum.map { CssPropertySorter::Utils::FixViolation.call(_1) }
  issues, fixes = violation_fixes.partition(&:issue?) # We collect on the enum here.

  if issues.any?
    error = CssPropertySorter::Utils::Error.new(issues)
    raise_on_error = ENV.fetch("CPS_RAISE", "false") == "true"
    raise_on_error ? raise(error) : puts(error.message)
  end

  CssPropertySorter::Utils::Inflector[fixes] { "\nThere #{have} been: #{size} fix#{es}" }
  CssPropertySorter::Utils::Inflector[issues] { "There #{have} been: #{size} issue#{s}\n\n" }
end

# git add .
# git commit --amend -m "wip"
# gem build css_property_sorter.gemspec
# gem install ./css_property_sorter-0.1.0.gem

# require 'css_property_sorter'

# spec = Gem::Specification.find_by_name 'css_property_sorter'
# rakefile = "#{spec.gem_dir}/lib/css_property_sorter/Rakefile"
# load rakefile
