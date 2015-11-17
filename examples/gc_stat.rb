mnemonic = Mnemonic.new do |config|
  config.gc_stat :minor_gc_count, :major_gc_count
end

mnemonic.attach_pretty(STDOUT)

# 5 major GCs!
10.times do |i|
  GC.start if i.odd?
  mnemonic.trigger!(i.odd? ? 'major!' : 'no major')
end

mnemonic.detach_all
