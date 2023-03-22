# frozen_string_literal: true

class Mnemonic
  module Metric
    class Base
      attr_reader :name, :diff

      def start!
        @value = current_value
        @diff = 0
      end

      def refresh!
        prev = @value
        @value = current_value
        @diff += @value - prev
      end

      def update!
        @value = current_value
      end

      def each_submetric
        yield self
      end

      private

      def initialize(**); end

      def current_value
        raise NotImplementedError
      end
    end
  end
end
