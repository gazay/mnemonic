file_name = './tmp.csv'

mnemonic = Mnemonic.new do |config|
  config.time_milliseconds
  config.objects_count(:T_HASH)
  config.objects_size(:T_HASH)
end

mnemonic.attach_csv(file_name)

100.times do
  Hash.new
  mnemonic.trigger!
end

mnemonic.detach_all

puts File.read(file_name)

puts
puts "WITH EXTRA COLUMN"
puts

mnemonic = Mnemonic.new do |config|
  config.time_milliseconds
  config.objects_count(:T_HASH)
  config.objects_size(:T_HASH)
end

mnemonic.attach_csv(file_name, extra: true)

100.times do |i|
  Hash.new
  mnemonic.trigger!(2 ** i)
end

mnemonic.detach_all

puts File.read(file_name)
