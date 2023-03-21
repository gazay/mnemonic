# frozen_string_literal: true

class Mnemonic
  module Metric
    # Track the memory size of a specific object
    class ObjectMemsize < Base
      def initialize(object:, **)
        @object = object
        @name = "Memsize(#{object.inspect})"
        super
      end

      def kind
        :bytes
      end

      private

      def current_value
        ObjectSpace.memsize_of(@object)
      end
    end
  end
end
