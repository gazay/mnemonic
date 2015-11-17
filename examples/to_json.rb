file_name = './tmp.json'

mnemonic = Mnemonic.new do |config|
  config.time_milliseconds
  config.objects_count(:T_HASH, :T_ARRAY)
end

mnemonic.attach_json(file_name)

10.times do
  {}; {[] => []}; [] # +3 arrays, +2 hashes
  mnemonic.trigger!
end

mnemonic.detach_all

puts JSON.pretty_generate(JSON.load(File.read(file_name)))
