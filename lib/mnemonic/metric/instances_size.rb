class Mnemonic
  module Metric
    class InstancesSize < Base
      def initialize(klass)
        @klass = klass
        @name = "Size(#{klass.name || klass.inspect})"
      end

      def kind
        :bytes
      end

      private

      def current_value
        ObjectSpace.memsize_of_all(@klass)
      end
    end
  end
end
