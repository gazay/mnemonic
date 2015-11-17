class Mnemonic
  module Metric
    class Base
      attr_reader :name
      attr_reader :start_value, :prev_value, :value
      attr_reader :diff, :diff_from_start

      def start!
        @start_value = @value = current_value
      end

      def refresh!
        @prev_value = @value
        @value = current_value
        @diff = @value - @prev_value
        @diff_from_start = @value - @start_value
      end

      def each_submetric
        yield self
      end

      private

      def current_value
        raise NotImplementedError
      end
    end
  end
end
