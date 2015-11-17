class Mnemonic
  module Metric
    class ObjectsCount < HashMetric
      def initialize(*keys)
        keys = DEFAULT_KEYS if keys.empty?
        super
      end

      def name
        'Count'.freeze
      end

      def kind
        :number
      end

      private

      def refresh_hash!
        ObjectSpace.count_objects(@current_hash_value)
      end

      KIND_TABLE = {
        :TOTAL => :number,
        :FREE => :number,
        :T_OBJECT => :number,
        :T_CLASS => :number,
        :T_MODULE => :number,
        :T_FLOAT => :number,
        :T_STRING => :number,
        :T_REGEXP => :number,
        :T_ARRAY => :number,
        :T_HASH => :number,
        :T_STRUCT => :number,
        :T_BIGNUM => :number,
        :T_FILE => :number,
        :T_DATA => :number,
        :T_MATCH => :number,
        :T_COMPLEX => :number,
        :T_RATIONAL => :number,
        :T_SYMBOL => :number,
        :T_NODE => :number,
        :T_ICLASS => :number
      }
      DEFAULT_KEYS = KIND_TABLE.keys
    end
  end
end
