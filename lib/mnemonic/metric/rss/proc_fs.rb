# frozen_string_literal: true

class Mnemonic
  class Metric::RSS::ProcFS < Metric::RSS
    def initialize
      @io = File.open("/proc/#{$PID}/statm", 'r')
      super
    end

    private

    def current_value
      @io.seek(0)
      @io.gets.split(/\s/)[1].to_i * Util::PageSize.value
    end
  end
end
