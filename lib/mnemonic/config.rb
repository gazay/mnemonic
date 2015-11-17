class Mnemonic
  class Config
    MetricDescription = Struct.new(:klass, :args)

    attr_reader :metrics

    def initialize
      @metrics = []
    end

    def add_metric(klass, args)
      @metrics << MetricDescription.new(klass, args)
    end

    def gc_stat(*names)
      add_metric Metric::GCStat, names
    end

    def objects_count(*names)
      add_metric Metric::ObjectsCount, names
    end

    def objects_size(*names)
      add_metric Metric::ObjectsSize, names
    end

    def instances_count(klass)
      add_metric Metric::InstancesCount, klass
    end

    def instances_size(klass)
      add_metric Metric::InstancesSize, klass
    end

    def time_seconds
      add_metric Metric::TimeSeconds, nil
    end

    def time_milliseconds
      add_metric Metric::TimeMilliseconds, nil
    end

    def time
      add_metric Metric::Time, nil
    end

    def rss
      # TODO: finish!
      klass = case Util::OS.type
              when :linux
                Metric::RSS::ProcFS
              else
                Metric::RSS::PS
              end
      add_metric klass, nil
    end
  end
end
