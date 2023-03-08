# frozen_string_literal: true

class Mnemonic
  module Metric
    class ObjectsSize < HashMetric
      def initialize(*keys)
        keys = DEFAULT_KEYS if keys.empty?
        super
      end

      def name
        'Size'
      end

      def kind
        :bytes
      end

      private

      def refresh_hash!
        ObjectSpace.count_objects_size(@current_hash_value)
      end

      KIND_TABLE = {
        T_OBJECT: :bytes,
        T_CLASS: :bytes,
        T_MODULE: :bytes,
        T_FLOAT: :bytes,
        T_STRING: :bytes,
        T_REGEXP: :bytes,
        T_ARRAY: :bytes,
        T_HASH: :bytes,
        T_STRUCT: :bytes,
        T_BIGNUM: :bytes,
        T_FILE: :bytes,
        T_DATA: :bytes,
        T_MATCH: :bytes,
        T_COMPLEX: :bytes,
        T_RATIONAL: :bytes,
        T_SYMBOL: :bytes,
        T_ICLASS: :bytes,
        TOTAL: :bytes
      }.freeze
      DEFAULT_KEYS = KIND_TABLE.keys
    end
  end
end
