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
        @entries = 0
      end

      def drop!(extra)
        @entries += 1
        add "ENTRY #{@entries}"
        add_break
        add legend
        add_break
        @mnemonic.metrics.each do |metric|
          add format_metric(metric)
        end
        add "#{format_name('Extra')}#{extra}" unless extra.nil?
        add_break
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

      def legend
        "  METRIC #{' ' * (@max_name_length - 6)}   CURRENT#{' ' * 10} diff: PREVIOUS#{' ' * 10} | BEGIN"
      end

      # rubocop: disable Metrics/AbcSize
      def format_metric(metric)
        name = format_name(metric.name)
        value = format_value(metric.kind, metric.value)
        diff = format_value(metric.kind, metric.diff)
        start = format_value(metric.kind, metric.diff_from_start)
        "#{name}#{value}#{' ' * (24 - value.length)}#{diff}#{' ' * (21 - diff.length)}#{start}"
      end
      # rubocop: enable Metrics/AbcSize

      def format_name(name)
        "  #{name}:   #{' ' * (@max_name_length - name.length)}"
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
