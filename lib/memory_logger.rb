require 'objspace'
require 'memory_logger/config'
require 'memory_logger/state'
require 'memory_logger/formatter'

class MemoryLogger

  attr_reader :config, :state, :fmt

  def initialize(output, options={})
    configure(options)

    @output = output
    @state  = MemoryLogger::State.new(options)
    @fmt    = options.fetch(:formatter, MemoryLogger::Formatter.new(@config))
  end

  def configure(opts={})
    @config = MemoryLogger::Config.new(opts)
    yield @config if block_given?
  end

  def enable!
    config.enabled = true
  end

  def disable!
    config.enabled = false
  end

  def log(*args)
    return unless config.enabled?
    force_log!(*args)
  end

  def force_log!(*args)
    result_string = []
    result_string << entry_string(args)
    @@prev[:entries] += 1
    puts "\nENTRY #{@@prev[:entries]} :: [#{Time.now}]: #{args.join(', ')}"
    puts "\n#{legend}\n\n"
    puts "  MAIN_STATS:\n\n#{["    #{mem_str}", size_str, obj_str].join("\n    ")}\n\n"
    puts "  GC_STATS:\n\n#{gc_stats_str}\n\n"
    puts "  OBJECTS:\n\n#{objects_str}\n"
  end

  def entry_string(args)
    result = "[#{Time.now}]: #{args.join(', ')}"
    if config.with_entry_num?
      state.entries += 1
      "ENTRY #{state.entries} :: #{result}"
    else
      result
    end
  end

  def self.enable!
    @@prev[:enabled] = true
  end

  def self.disable!
    @@prev[:enabled] = false
  end

  def self.clear
    @@prev[:entries] = 0
    @@prev[:begin_size] = (ObjectSpace.count_objects_size[:TOTAL] / 1048576.0).round(3)
    @@prev[:begin_obj] = ObjectSpace.count_objects.values.sum
    @@prev[:begin_mem] = (`ps -o rss -p #{$$}`.strip.split.last.to_i / 1024.0).round(3)
    @@prev[:begin_old_objects] = GC.stat[:old_objects]
    @@prev[:begin_heap_live_slots] = GC.stat[:heap_live_slots]
    @@prev[:begin_heap_available_slots] = GC.stat[:heap_available_slots]
    @@prev[:begin_objects] = ObjectSpace.count_objects
  end

  def self.gc_stats_str
    [
      "    #{gc_str}",
      gc_stat_str(:old_objects, 'OLD_OBJ'),
      gc_stat_str(:heap_live_slots, 'HEAP_LIVE'),
      gc_stat_str(:heap_available_slots, 'HEAP_AVLBL'),
      malloc_inc_str
    ].join("\n    ")
  end

  def self.legend
    '    STAT NAME          CURRENT diff:  PREVIOUS|     BEGIN'
  end

  def self.gc_str
    "GC (m/M):#{' ' * 11} #{GC.stat[:minor_gc_count]}/#{GC.stat[:major_gc_count]}"
  end

  def self.gc_stat_str(stat_sym, stat_name)
    stat = GC.stat[stat_sym]
    stat_diff = stat - @@prev[stat_sym]
    stat_diff_begin = stat - @@prev["begin_#{stat_sym}".to_sym]
    @@prev[stat_sym] = stat
    "#{stat_name}:#{' ' * (KEY_LEN - stat_name.length)} #{spaces(stat) + stat.to_s} #{format_diff(stat_diff, stat_diff_begin)}"
  end

  def self.malloc_inc_str
    stat = (GC.stat[:malloc_increase_bytes] / 1048576.0).round(3)
    "MALLOC_INC:#{' ' * (KEY_LEN - 10)} #{spaces(stat) + stat.to_s}#{' ' * 28}MB"
  end

  def self.size_str
    size = (ObjectSpace.count_objects_size[:TOTAL] / 1048576.0).round(3)
    sizediff = (size - @@prev[:size]).round(3)
    sizediff_gl = (size - @@prev[:begin_size]).round(3)
    @@prev[:size] = size
    "OBJ_SIZE:#{' ' * (KEY_LEN - 8)} #{spaces(size) + size.to_s} #{format_diff(sizediff, sizediff_gl)} MB"
  end

  def self.obj_str
    obj = ObjectSpace.count_objects.values.sum
    objdiff = obj - @@prev[:obj]
    objdiff_gl = obj - @@prev[:begin_obj]
    @@prev[:obj] = obj
    "OBJ_CNT:#{' ' * (KEY_LEN - 7)} #{spaces(obj) + obj.to_s} #{format_diff(objdiff, objdiff_gl)}"
  end

  def self.mem_str
    mem = (`ps -o rss -p #{$$}`.strip.split.last.to_i / 1024.0).round(3)
    memdiff = (mem - @@prev[:mem]).round(3)
    memdiff_gl = (mem - @@prev[:begin_mem]).round(3)
    @@prev[:mem] = mem
    "MEM:#{' ' * (KEY_LEN - 3)} #{spaces(mem) + mem.to_s} #{format_diff(memdiff, memdiff_gl)} MB"
  end

  def self.objects_str
    stats = ObjectSpace.count_objects
    stats_diff = {}
    stats_diff_gl = {}
    stats_str = stats.map do |k, v|
      stats_diff[k] = stats[k] - @@prev[:objects][k].to_i
      stats_diff_gl[k] = stats[k] - @@prev[:begin_objects][k].to_i
      @@prev[:objects][k] = stats[k]
      [k, stats_diff[k], "    #{k}:#{' ' * (KEY_LEN - k.length)} #{spaces(stats[k]) + stats[k].to_s} #{format_diff(stats_diff[k], stats_diff_gl[k])}"]
    end.sort_by {|it| it[1]}.reverse
    main_stats_str = stats_str.select { |it| [:TOTAL, :FREE].include?(it[0]) }
    other_str = stats_str - main_stats_str
    main_stats_str = main_stats_str.map {|it| it[2]}.join("\n")
    other_str = other_str.map {|it| it[2]}.join("\n")
    "#{main_stats_str}\n\n#{other_str}"
  end

  def self.format_diff(diff, diff_gl)
    diff_str = diff > 0 ? "+#{diff}" : diff
    diff_gl_str = diff_gl > 0 ? "+#{diff_gl}" : diff_gl
    "diff:#{spaces(diff_str, :diff)}#{diff_str}|#{spaces(diff_gl_str, :diff)}#{diff_gl_str}"
  end

  def self.spaces(num, type=:stat)
    if type == :diff
      ' ' * (DIFF_LEN - num.to_s.length)
    else
      ' ' * (STAT_LEN - num.to_s.length)
    end
  end
end

PL.disable!
PL.clear
