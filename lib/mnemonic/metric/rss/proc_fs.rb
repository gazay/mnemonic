# frozen_string_literal: true

require 'English'
class Mnemonic
  module Metric
    class RSS
      class ProcFS < self
        def initialize
          @io = File.open("/proc/#{$PROCESS_ID}/statm", 'r')
          super
        end

        private

        def current_value
          @io.seek(0)
          @io.gets.split(/\s/)[1].to_i * Util::PageSize.value
        end
      end
    end
  end
end
