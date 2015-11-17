class Mnemonic
  module Metric
    class GCStat < HashMetric
      def initialize(*keys)
        keys = DEFAULT_KEYS if keys.empty?
        super
      end

      def name
        'GCStat'.freeze
      end

      private

      def refresh_hash!
        GC.stat(@current_hash_value)
      end

      KIND_TABLE = {
        :count => :number,
        :heap_allocated_pages => :number,
        :heap_sorted_length => :number,
        :heap_allocatable_pages => :number,
        :heap_available_slots => :number,
        :heap_live_slots => :number,
        :heap_free_slots => :number,
        :heap_final_slots => :number,
        :heap_marked_slots => :number,
        :heap_swept_slots => :number,
        :heap_eden_pages => :number,
        :heap_tomb_pages => :number,
        :total_allocated_pages => :number,
        :total_freed_pages => :number,
        :total_allocated_objects => :number,
        :total_freed_objects => :number,
        :malloc_increase_bytes => :bytes,
        :malloc_increase_bytes_limit => :bytes,
        :minor_gc_count => :number,
        :major_gc_count => :number,
        :remembered_wb_unprotected_objects => :number,
        :remembered_wb_unprotected_objects_limit => :number,
        :old_objects => :bytes,
        :old_objects_limit => :bytes,
        :oldmalloc_increase_bytes => :number,
        :oldmalloc_increase_bytes_limit => :number
      }
      DEFAULT_KEYS = KIND_TABLE.keys
    end
  end
end
