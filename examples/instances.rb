class X
end

mnemonic = Mnemonic.new do |config|
  config.time_milliseconds
  config.instances_count(X)
  config.instances_size(X)
end

mnemonic.attach_csv(STDOUT, extra: true)

10.times do
  X.new
  mnemonic.trigger!(:without_gc)
end

10.times do
  X.new
  GC.start
  mnemonic.trigger!(:with_gc)
end

mnemonic.detach_all
