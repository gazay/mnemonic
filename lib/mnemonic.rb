require 'objspace'
require 'monitor.rb'
require 'set'

class Mnemonic
  require 'mnemonic/version'
  require 'mnemonic/config'
  require 'mnemonic/metric'
  require 'mnemonic/sink'
  require 'mnemonic/util'

  include MonitorMixin

  attr_reader :root_metrics, :metrics, :metric_names

  def initialize
    super
    config = Mnemonic::Config.new
    yield config

    @root_metrics = config.metrics.map do |metric|
      metric.klass.new(*metric.args)
    end

    @metrics = @root_metrics.flat_map do |metric|
      metric.to_enum(:each_submetric).to_a
    end

    @root_metrics.each(&:start!)
    @metric_names = @metrics.map(&:name)
    @sinks = Set.new
  end

  def trigger!(extra = nil)
    synchronize do
      @root_metrics.each(&:refresh!)
      @sinks.each { |s| s.drop!(extra) }
    end
  end

  def attach_csv(*args)
    attach(Sink::CSV, *args)
  end

  def attach_json(*args)
    attach(Sink::JSON, *args)
  end

  def attach_pretty(*args)
    attach(Sink::Pretty, *args)
  end

  def attach(sink_class, *args, &block)
    synchronize do
      sink_class.new(self, *args, &block).tap do |sink|
        @sinks << sink
      end
    end
  end

  def detach(sink)
    synchronize do
      sink.close
      @sinks.delete sink
    end
  end

  def detach_all
    synchronize do
      @sinks.each(&:close)
      @sinks.clear
    end
  end
end