# frozen_string_literal: true

class Mnemonic
  class Metric::RSS::PS < Metric::RSS
    private

    def current_value
      `ps -o rss -p #{$PID}`.strip.split.last.to_i * 1024
    end
  end
end
