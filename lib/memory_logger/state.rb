class MemoryLogger
  STATE_DEFAULTS = {
    entries: 0,
    mem: 0,
    init_mem: 0,
    obj_cnt: 0,
    init_obj_cnt: 0,
    obj_size: 0,
    init_obj_size: 0,
    old_objects: 0,
    init_old_objects: 0,
    heap_live_slots: 0,
    init_heap_live_slots: 0,
    heap_available_slots: 0,
    init_heap_available_slots: 0,
    objects: {},
    init_objects: {}
  }
  STATE_METHODS = Hash[
    *STATE_DEFAULTS.keys.map { |k| [k, "#{k}=".to_sym] }.flatten
  ]

  class State < Struct.new(*STATE_DEFAULTS.keys)

    def initialize(opts={})
      vals = STATE_DEFAULTS.keys.map { |k| opts.fetch(k, STATE_DEFAULTS[k]) }
      super(*vals)
    end

    def bulk_update(params={})
      params.each do |k, v|
        next unless STATE_DEFAULTS.keys.include? k
        self.send(STATE_METHODS[k], v)
      end
    end

  end
end
