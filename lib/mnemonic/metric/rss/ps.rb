# frozen_string_literal: true

require 'English'
class Mnemonic
  module Metric
    class RSS
      class PS < self
        private

        def current_value
          `ps -o rss -p #{$PROCESS_ID}`.strip.split.last.to_i * 1024
        end
      end
    end
  end
end
