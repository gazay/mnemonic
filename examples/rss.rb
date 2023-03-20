# frozen_string_literal: true

require 'mnemonic'

mnemonic = Mnemonic.new do |config|
  config.rss
  config.gc_stat
end

mnemonic.attach_pretty($stdout)

# 5 major GCs!
10.times do |_i|
  '!' * 100_000_000
  mnemonic.trigger!
end

mnemonic.detach_all
