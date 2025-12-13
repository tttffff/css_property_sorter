# frozen_string_literal: true

require_relative "lib/css_property_sorter/version"

Gem::Specification.new do |spec|
  spec.name = "css_property_sorter"
  spec.version = CssPropertySorter::VERSION
  spec.authors = ["tttffff"]
  spec.email = ["tristanfellows@icloud.com"]

  spec.summary = "Sort your CSS properties alphabetically."
  spec.description = "Inconsistent ordering of CSS properties generally has no value. Sorting alphabetically reduces comprehension time."
  spec.homepage = "http://www.me.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |file_path|
      (file_path == gemspec) || file_path.start_with?(*%w[.git .github Gemfile])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "rake"
  spec.add_dependency "css_parser"
  spec.add_dependency "git"
end
