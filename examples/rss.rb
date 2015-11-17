mnemonic = Mnemonic.new do |config|
  config.rss
end

mnemonic.attach_pretty(STDOUT)

# 5 major GCs!
10.times do |i|
  '!' * 1_000_000
  mnemonic.trigger!
end

mnemonic.detach_all
