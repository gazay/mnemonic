# frozen_string_literal: true

class Mnemonic
  module Metric
    class TimeSeconds < Base
      def name
        'Time(s)'
      end

      def kind
        :number
      end

      private

      def current_value
        ::Time.now.to_i
      end
    end
  end
end
