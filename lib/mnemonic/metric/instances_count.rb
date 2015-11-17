class Mnemonic
  module Metric
    class InstancesCount < Base
      def initialize(klass)
        @enum = ObjectSpace.each_object(klass)
        @name = "Count(#{klass.name || klass.inspect})"
      end

      def kind
        :number
      end

      private

      def current_value
        @enum.count
      end
    end
  end
end
