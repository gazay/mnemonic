# frozen_string_literal: true

class Mnemonic
  module Metric
    class Time < Base
      def name
        'Time'
      end

      def kind
        :time
      end

      private

      def current_value
        ::Time.now
      end
    end
  end
end
