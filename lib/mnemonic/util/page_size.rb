# frozen_string_literal: true

class Mnemonic
  module Util
    module PageSize
      class << self
        def value
          @value ||= _value
        end

        private

        def _strategies
          [
            -> { require 'etc'; Etc.sysconf(Etc::SC_PAGE_SIZE) },
            -> { `getconf PAGE_SIZE`.to_i },
            -> { 0x1000 }
          ]
        end

        def _value
          _strategies.each do |strategy|
            return strategy.call
          rescue StandardError
            next
          end
        end
      end
    end
  end
end
