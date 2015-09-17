class MemoryLogger
  CONFIG_DEFAULTS = {
    # Config
    enabled:        true,
    with_entry_num: true,
    key_length:     12,
    stat_length:    12,
    diff_length:    10,
    separator:      "\n\n".freeze,

    # Stats
    memory:               true,
    obj_count:            true,
    obj_size:             true,
    old_objects:          true,
    heap_live_slots:      true,
    heap_available_slots: true,
    objects:              true
  }

  class Config < Struct.new(*CONFIG_DEFAULTS.keys)

    CONFIG_DEFAULTS.each do |k, v|
      next unless v.is_a?(Boolean)
      define_method("#{k}?") do
        self.send(k)
      end
    end

    def initialize(opts={})
      vals = CONFIG_DEFAULTS.keys.map { |k| opts.fetch(k, CONFIG_DEFAULTS[k]) }
      super(*vals)
    end

  end
end
