# frozen_string_literal: true

module CssPropertySorter
  module Utils
    class Inflector
      INFLECTIONS_KLASS = Struct.new('Inflection', :size, :have, :s, :es)
      SINGULAR = ["has", "", ""]
      PLURAL = ["have", "s", "es"]

      def self.[](items, &block)
        puts new(items).inflect(&block)
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
