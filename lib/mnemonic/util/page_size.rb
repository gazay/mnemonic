# frozen_string_literal: true

class Mnemonic
  module Util
    module PageSize
      class << self
        def value
          @value ||= _value
        end

        private

        def _value
          [
            -> { require 'etc'; Etc.sysconf(Etc::SC_PAGE_SIZE) },
            -> { `getconf PAGE_SIZE`.to_i },
            -> { 0x1000 }
          ].each do |strategy|
            page_size = begin
              strategy.call
            rescue StandardError
              next
            end
            return page_size
          end
        end
      end
    end
  end
end
