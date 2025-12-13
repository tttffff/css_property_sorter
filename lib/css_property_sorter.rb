# frozen_string_literal: true

require "git"
require "css_parser"

require_relative "css_property_sorter/version"
require_relative "css_property_sorter/utils/file_paths_enumerator"
require_relative "css_property_sorter/utils/violations_enumerator"
require_relative "css_property_sorter/utils/fix_violation"
require_relative "css_property_sorter/utils/inflector"
require_relative "css_property_sorter/utils/error"
require_relative "css_property_sorter/rake_helpers"

module CssPropertySorter
  require_relative "css_property_sorter/railtie" if defined?(Rails)
end
