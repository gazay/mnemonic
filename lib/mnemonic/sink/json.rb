# frozen_string_literal: true

require 'json'

class Mnemonic
  module Sink
    class JSON
      def initialize(mnemonic, to = $stdout, options = {})
        @mnemonic = mnemonic
        @need_close = to.is_a?(String)
        @io = to.is_a?(String) ? File.open(to, 'w') : to
        @extra_enabled = options.delete(:extra)
        @row = {}
        @first = true
      end

      def drop!(extra)
        @mnemonic.metrics.each { |metric| @row[metric.name] = metric.value }
        @row['extra'] = extra if @extra_enabled
        @io << (@first ? '[' : ',') << ::JSON.dump(@row)
        @first = false
      end

      def close
        @io << ']'
        @io.close if @need_close
      end
    end
  end
end
