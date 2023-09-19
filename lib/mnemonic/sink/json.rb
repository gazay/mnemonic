# frozen_string_literal: true

require 'json'

class Mnemonic
  module Sink
    class JSON
      def initialize(mnemonic, to = $stdout, options = {})
        @mnemonic = mnemonic
        @io = if to.is_a? String
                @need_close = true
                File.open(to, 'w')
              else
                to
              end
        @extra_enabled = options.delete(:extra)
        @row = {}
        @first = true
      end

      def drop!(extra)
        @mnemonic.metrics.each do |metric|
          @row[metric.name] = metric.value
        end
        @row['extra'] = extra if @extra_enabled
        json_row = ::JSON.dump(@row)
        if @first
          @io << '['
          @io << json_row
          @first = false
        else
          @io << ','
          @io << json_row
        end
      end

      def close
        @io << ']'
        @io.close if @need_close
      end
    end
  end
end
