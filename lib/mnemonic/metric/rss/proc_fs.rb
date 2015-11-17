class Mnemonic
  class Metric::RSS::ProcFS < Metric::RSS
    def initialize
      @io = File.open("/proc/#{$$}/statm", 'r')
    end

    private

    def current_value
      @io.seek(0)
      @io.gets.split(/\s/)[1].to_i * Util::PageSize.value
    end
  end
end
