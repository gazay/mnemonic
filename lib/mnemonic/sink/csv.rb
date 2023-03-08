# frozen_string_literal: true

require 'csv'

class Mnemonic
  module Sink
    class CSV
      # rubocop: disable Metrics/AbcSize
      # rubocop: disable Metrics/MethodLength
      def initialize(mnemonic, to = $stdout, options = {})
        @mnemonic = mnemonic

        col_count = mnemonic.metrics.length
        headers = mnemonic.metric_names

        @extra_column = options.delete(:extra)
        if @extra_column
          col_count += 1
          headers = headers.dup << 'Extra'
        end

        options[:headers] = headers
        options[:write_headers] = true

        @need_close = to.is_a?(String)
        @io = to.is_a?(String) ? File.open(to, 'w') : to
        @csv = ::CSV.new(@io, **options)
        @row = Array.new(col_count)
      end
      # rubocop: enable Metrics/MethodLength
      # rubocop: enable Metrics/AbcSize

      def drop!(extra)
        @mnemonic.metrics.each_with_index { |metric, i| @row[i] = metric.value }
        @row[-1] = extra if @extra_column
        @csv << @row
      end

      def close
        @io.close if @need_close
      end
    end
  end
end
