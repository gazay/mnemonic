# frozen_string_literal: true

require 'mnemonic'

file_name = './tmp.csv'

mnemonic = Mnemonic.new do |config|
  config.time_milliseconds
  config.objects_size(:TOTAL)
  config.objects_count(:TOTAL)
end

mnemonic.attach_csv(file_name)

foo = []
3.times do |n|
  foo << n.to_s
  mnemonic.trigger!
end
foo

mnemonic.detach_all
puts File.read(file_name)

mnemonic.attach_csv(file_name)

foo = []
3.times do |n|
  mnemonic.trigger! do
    foo << n.to_s
  end
end
foo

mnemonic.detach_all
puts File.read(file_name)
