# frozen_string_literal: true

class Mnemonic
  class Config
    MetricDescription = Struct.new(:klass, :args)

    attr_reader :metrics

    def initialize
      @metrics = []
    end

    def add_metric(klass, **args)
      @metrics << MetricDescription.new(klass, args)
    end

    def gc_stat(*stat_names)
      add_metric Metric::GCStat, keys: stat_names
    end

    def objects_count(*object_types)
      add_metric Metric::ObjectsCount, keys: object_types
    end

    def objects_size(*object_types)
      add_metric Metric::ObjectsSize, keys: object_types
    end

    def instances_count(*target_klass_names)
      target_klass_names.each do |klass_name|
        add_metric Metric::InstancesCount, klass: klass_name
      end
    end

    def instances_size(*target_klass_names)
      target_klass_names.each do |klass_name|
        add_metric Metric::InstancesSize, klass: klass_name
      end
    end

    def time_seconds
      add_metric Metric::TimeSeconds
    end

    def time_milliseconds
      add_metric Metric::TimeMilliseconds
    end

    def time_microseconds
      add_metric Metric::TimeMicroseconds
    end

    def time
      add_metric Metric::Time
    end

    def rss
      # TODO: finish!
      klass = case Util::OS.type
              when :linux then Metric::RSS::ProcFS
              else Metric::RSS::PS
              end

      add_metric klass
    end
  end
end
