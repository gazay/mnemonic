class Mnemonic
  module Metric
    class HashMetric
      class Submetric < Base
        attr_reader :kind

        def initialize(parent, key, kind)
          @parent = parent
          @key = key
          @name = "#{parent.name}(#{key.inspect})"
          @kind = kind
        end

        private

        def current_value
          @parent[@key]
        end
      end

      def initialize(*keys)
        @current_hash_value = {}
        kind_table = self.class.const_get(:KIND_TABLE)
        @submetrics = keys.map do |key|
          Submetric.new(self, key, kind_table[key])
        end
      end

      def start!
        refresh_hash!
        @submetrics.each(&:start!)
      end

      def refresh!
        refresh_hash!
        @submetrics.each(&:refresh!)
      end

      def each_submetric(&block)
        @submetrics.each(&block)
      end

      def [](key)
        @current_hash_value[key]
      end

      private

      def refresh_hash!
        raise NotImplementedError
      end
    end
  end
end
