# frozen_string_literal: true

class Mnemonic
  module Metric
    class TimeMilliseconds < Base
      def name
        'Time(ms)'
      end

      def kind
        :number
      end

      private

      def current_value
        (::Time.now.to_f * 1000).to_i
      end
    end
  end
end
