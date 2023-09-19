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

      def format_metric(metric)
        format(
          '%<metric>s%<value>-24s%<diff>-21s%<total_diff>s',
          metric: format_name(metric.name),
          value: format_value(metric.kind, metric.value),
          diff: format_value(metric.kind, metric.diff),
          total_diff: format_value(metric.kind, metric.diff_from_start)
        )
      end

      def format_name(name)
        "  #{name}:   #{' ' * (@max_name_length - name.length)}"
      end

      def format_value(key, value)
        case key
        when :bytes
          postfix = :B
          neg = value.negative?
          n = value.abs
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
        when :time
          if value.is_a? Time
            value.strftime('%Y%m%d%H%M%S')
          elsif value.is_a? Float # diff
            "#{value.round(3)} sec"
          else
            value.to_s
          end
        else
          value.to_s
        end
      end
    end
  end
end
