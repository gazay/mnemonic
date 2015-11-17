class Mnemonic
  module Sink
    class Pretty
      def initialize(mnemonic, to = STDOUT)
        @mnemonic = mnemonic
        @io = if to.kind_of? String
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
        add "#{format_name('Extra'.freeze)}#{extra}" unless extra.nil?
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

      def format_metric(m)
        fvalue = format_value(m.kind, m.value)
        fdiff = format_value(m.kind, m.diff)
        fdiff_start = format_value(m.kind, m.diff_from_start)
        "#{format_name(m.name)}#{fvalue}#{' ' * (24 - fvalue.length)}#{fdiff}#{' ' * (21 - fdiff.length)}#{fdiff_start}"
      end

      def format_name(name)
        "  #{name}:   #{' ' * (@max_name_length - name.length)}"
      end

      def format_value(k, v)
        case k
        when :bytes
          postfix = :B
          neg = v < 0
          n = v.abs
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
          if v.is_a? Time
            v.strftime('%Y%m%d%H%M%S')
          elsif v.is_a? Float # diff
            "#{v.round(3)} sec"
          else
            v.to_s
          end
        else
          v.to_s
        end
      end
    end
  end
end
