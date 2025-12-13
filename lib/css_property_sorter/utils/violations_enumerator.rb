# frozen_string_literal: true

module CssPropertySorter
  module Utils
    class ViolationsEnumerator
      VIOLATION_KLASS = Struct.new('Violation', :file_path, :start_byte, :number_of_bytes, :properties_in_desired_order)

      def self.call(file_paths_enumerator)
        new(file_paths_enumerator).get_violations_enumerator
      end

      attr_reader :file_paths_enumerator, :violation_klass

      def initialize(file_paths_enumerator, violation_klass: VIOLATION_KLASS)
        @file_paths_enumerator, @violation_klass = file_paths_enumerator, violation_klass
      end

      # Bit naughty to go into the bowels of css_parser to get what I want out.
      # Also, sorry for not documentating what is going on here.
      # At least the mess is contained in this one file.
      def get_violations_enumerator
        file_paths_enumerator.flat_map do |file_path|
          css_parser = CssParser::Parser.new
          css_parser.load_file!(file_path, capture_offsets: true)
          rule_sets = css_parser.instance_variable_get(:@rules).map { _1[:rules] }
          voilations = rule_sets.filter_map do |rule_set|
            declerations = rule_set.instance_variable_get(:@declarations).instance_variable_get(:@declarations)
            current_order = declerations.keys
            expected_order = current_order.sort
            next if current_order == expected_order
            violation_klass.new(
              rule_set.filename, rule_set.offset.begin, rule_set.offset.size, properties_in_expected_order(expected_order, declerations)
            )
          end
          voilations.tap(&method(:print_message))
        end
      end

      private

      def properties_in_expected_order(expected_order, declerations)
        expected_order.map do |property_name|
          dec_value = declerations[property_name]
          importance = dec_value.important ? ' !important' : ''
          "#{property_name}: #{dec_value.value}#{importance};"
        end
      end

      def print_message(violations)
        Inflector[violations] { "\t#{size} violation#{s}" }
      end
    end
  end
end
