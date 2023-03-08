# frozen_string_literal: true

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
          when /linux/ then :linux
          when /darwin|mac os/ then :macosx
          when /solaris|bsd/ then :unix
          when /mswin|msys|mingw|cygwin|bccwin|wince|emc/ then :windows
          end
        end
      end
    end
  end
end
