# frozen_string_literal: true

class Mnemonic
  module Metric
    class RSS < Base
      require 'mnemonic/metric/rss/ps'
      require 'mnemonic/metric/rss/proc_fs'

      def name
        'RSS'
      end

      def kind
        :bytes
      end
    end
  end
end
