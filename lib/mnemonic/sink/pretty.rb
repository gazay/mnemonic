# frozen_string_literal: true

class Mnemonic
  module Sink
    class Pretty
      def initialize(mnemonic, to = $stdout)
        @mnemonic = mnemonic
        @io = if to.is_a? String
                @need_close = true
                File.open(to, 'w')
              else
                to
              end
        @max_name_length = (mnemonic.metric_names.map(&:length) << 6).max
        @max_value_length = 24
        @entries = 0
      end

      def drop!(extra)
        @entries += 1
        add "ENTRY #{@entries}"
        add divider
        add legend
        add divider
        @mnemonic.metrics.each { |metric| add format_metric(metric) }
        add format_row('Extra', extra, '') unless extra.nil?
        add divider
      end

      def close
        @io.close if @need_close
      end

      private

      def add(msg)
        @io << "#{msg}\n"
      end

      def add_break
        add ''
      end

      def format_row(name, diff)
        format(" %-#{@max_name_length}s | %-#{@max_value_length}s ", name, diff)
      end

      def divider
        ('-' * (@max_name_length + 2)) << '+' << ('-' * (@max_value_length + 2))
      end

      def legend
        format_row('METRIC', 'DIFF')
      end

      def format_metric(metric)
        diff = format_value(metric.kind, metric.diff)
        format_row(metric.name, diff)
      end

      def format_value(key, val)
        case key
        when :bytes then format_bytes(val)
        when :time then format_time(val)
        else val.to_s
        end
      end

      # rubocop: disable Metrics/MethodLength
      def format_bytes(val)
        postfix = :B
        neg = val.negative?
        n = val.abs
        if n >= 1024
          n /= 1024.0
          postfix = :KB
        end
        if n >= 1024
          n /= 1024.0
          postfix = :MB
        end
        n = n.round(3)
        n = n.to_i if n == n.to_i
        "#{'-' if neg}#{n} #{postfix}"
      end
      # rubocop: enable Metrics/MethodLength

      def format_time(val)
        case val
        when Time then val.strftime('%Y%m%d%H%M%S')
        when Float then "#{val.round(3)} sec"
        else val.to_s
        end
      end
    end
  end
end
