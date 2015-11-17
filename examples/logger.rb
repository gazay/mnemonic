require 'mnemonic/logger_proxy'

file_name = './tmp.log'
logger = Mnemonic::LoggerProxy.new(Logger.new(file_name)) do |config|
  config.objects_count(:T_HASH)
  config.objects_size(:T_HASH)
  config.objects_count(:T_ARRAY)
  config.objects_size(:T_ARRAY)
end

10.times do
  {}; {[] => []}; [] # +3 arrays, +2 hashes
  logger.info 'hello with logging enabled!'
end

logger.disable_mnemonic!

10.times do
  logger.info 'hello with logging disabled!'
end

logger.enable_mnemonic!

10.times do
  logger.info 'hello with logging re-enabled!'
end



puts File.read(file_name)
