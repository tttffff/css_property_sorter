# frozen_string_literal: true

module CssPropertySorter
  module RakeHelpers
    module_function

    # Load .rake files so that the user can run them in their own project.
    def load_tasks
      tasks_path = File.join(File.dirname(__FILE__), "tasks", "*.rake")
      Dir.glob(tasks_path).each { |file| load file }
    end

    # Method used by .rake fiels to add rake task's
    def [](context, description, name, &block)
      context.instance_eval do
        desc description
        namespace :css_property_sorter do
          task name do
            puts "==CSS Property Sorter has started with task #{name}=="
            block.call
            puts "==CSS Property Sorter has ended with task #{name}=="
          end
        end
      end
    end
  end
end
