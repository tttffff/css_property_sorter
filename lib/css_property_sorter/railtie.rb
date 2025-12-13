# frozen_string_literal: true

require "rails"

module CssPropertySorter
  class Railtie < Rails::Railtie
    railtie_name :css_property_sorter

    rake_tasks { CssPropertySorter::RakeHelpers.load_tasks }
  end
end
