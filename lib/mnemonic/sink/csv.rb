require 'csv'

class Mnemonic
  module Sink
    class CSV
      def initialize(mnemonic, to = STDOUT, options = {})
        @mnemonic = mnemonic

        col_count = mnemonic.metrics.length
        headers = mnemonic.metric_names

        @extra_column = options.delete(:extra)
        if @extra_column
          col_count += 1
          headers = headers.dup << 'Extra'.freeze
        end

        options[:headers] = headers
        options[:write_headers] = true
        @io = if to.kind_of? String
                @need_close = true
                File.open(to, 'w')
              else
                to
              end
        @csv = ::CSV.new(@io, options)
        @row = Array.new(col_count)
      end

      def drop!(extra)
        @mnemonic.metrics.each_with_index do |metric, i|
          @row[i] = metric.value
        end
        @row[-1] = extra if @extra_column
        @csv << @row
      end

      def close
        @io.close if @need_close
      end
    end
  end
end
