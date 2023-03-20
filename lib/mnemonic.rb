# frozen_string_literal: true

require 'objspace'
require 'monitor'
require 'set'
require 'mnemonic/version'
require 'mnemonic/config'
require 'mnemonic/metric'
require 'mnemonic/sink'
require 'mnemonic/util'

class Mnemonic
  include MonitorMixin

  attr_reader :root_metrics, :metrics, :metric_names, :enabled

  # rubocop: disable Metrics/MethodLength
  # rubocop: disable Metrics/AbcSize
  def initialize
    super

    config = Mnemonic::Config.new
    yield config

    @root_metrics = config.metrics.map do |metric|
      metric.klass.new(**metric.args)
    rescue StandardError => e
      puts e
    end.compact

    @metrics = @root_metrics.flat_map do |metric|
      metric.to_enum(:each_submetric).to_a
    end

    @root_metrics.each(&:start!)
    @metric_names = @metrics.map(&:name)
    @sinks = Set.new
    @enabled = true
  end
  # rubocop: enable Metrics/AbcSize
  # rubocop: enable Metrics/MethodLength

  def trigger!(extra = nil)
    return unless enabled

    synchronize do
      @root_metrics.each(&:refresh!)
      @sinks.each { |s| s.drop!(extra) }
    end
  end

  def disable!
    @enabled = false
  end

  def enable!
    @enabled = true
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
