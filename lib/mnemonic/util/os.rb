class Mnemonic
  module Util
    module OS
      class << self
        def type
          @type ||= _get_type
        end

        private

        def _get_type
          require 'rbconfig'
          case RbConfig::CONFIG['host_os']
          when /linux/
            :linux
          when /darwin|mac os/
            :macosx
          when /solaris|bsd/
            :unix
          when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
            :windows
          end
        end
      end
    end
  end
end
