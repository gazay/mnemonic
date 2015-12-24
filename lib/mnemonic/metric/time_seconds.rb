class Mnemonic
  module Metric
    class TimeSeconds < Base
      def name
        'Time(s)'.freeze
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
