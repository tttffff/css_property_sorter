# frozen_string_literal: true

module CssPropertySorter
  module Utils
    class Inflector
      # This approach will become a pain at some point, but it is fine at the minute.
      INFLECTIONS_KLASS = Struct.new('Inflection', :size, :have, :s, :es, :first, :all)
      PLURAL = ["have", "s", "es", "First", "All"]
      SINGULAR = ["has", "", "", "Only", "Only"]

      def self.call(items, &block)
        new(items).inflect(&block)
      end

      def self.[](items, &block)
        puts call(items, &block)
      end

      attr_reader :inflections

      def initialize(items, inflections_klass: INFLECTIONS_KLASS, singular: SINGULAR, plural: PLURAL)
        amount = items.size
        words = (amount == 1) ? singular : plural
        @inflections = inflections_klass.new(amount, *words)
      end

      def inflect(&block)
        inflections.instance_exec(&block)
      end
    end
  end
end
