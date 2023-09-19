# frozen_string_literal: true

require 'logger'
require 'monitor'
require 'forwardable'

class Mnemonic
  class LoggerProxy
    extend Forwardable

    def initialize(logger, mnemonic = Mnemonic.new(&proc))
      super()
      @monitor = Monitor.new
      @logger = logger
      @mnemonic = mnemonic
      enable_mnemonic!
    end

    def enable_mnemonic!
      @monitor.synchronize do
        @sink = @mnemonic.attach_pretty(@logger)
      end
    end

    def disable_mnemonic!
      @monitor.synchronize do
        @mnemonic.detach(@sink)
        @sink = nil
      end
    end

    def mnemonic_enabled?
      @monitor.synchronize { !!@sink }
    end

    def_delegators :@logger,
                   :level,
                   :level=,
                   :formatter,
                   :formatter=,
                   :datetime_format,
                   :datetime_format=

    %i[debug info warn error fatal unknown].each do |name|
      severity = Logger.const_get(name.to_s.upcase)
      define_method(name) do |progname = nil, &block|
        add(severity, nil, progname, &block)
      end
      def_delegator :@logger, "#{name}?"
    end

    def add(severity, message = nil, progname = nil, &block)
      @monitor.synchronize do
        @logger.add(severity, message, progname, &block).tap do |result|
          @mnemonic.trigger! if result && @sink && severity >= @logger.level
        end
      end
    end
    alias_method :log, :add

    def <<(msg)
      @monitor.synchronize do
        @logger << msg
      end
    end

    def close
      @monitor.synchronize do
        disable_mnemonic!
        @logger.close
      end
    end

    def respond_to_missing?(method_name, _)
      @logger.respond_to?(method_name)
    end

    def method_missing(method_name, ...)
      if @logger.respond_to? method_name
        @logger.send(method_name, ...)
      else
        super
      end
    end

    def respond_to?(method_name, _)
      @logger.respond_to?(method_name) || super
    end
  end
end
