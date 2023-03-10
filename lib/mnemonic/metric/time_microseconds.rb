# frozen_string_literal: true

class Mnemonic
  module Metric
    class TimeMicroseconds < Base
      def name
        'Time(μs)'
      end

      def kind
        :number
      end

      private

      def current_value
        (::Time.now.to_f * 1000000).to_i
      end
    end
  end
end
