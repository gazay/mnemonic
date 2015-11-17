class Mnemonic
  module Metric
    class RSS < Base
      require 'mnemonic/metric/rss/ps'
      require 'mnemonic/metric/rss/proc_fs'

      def name
        'RSS'.freeze
      end

      def kind
        :bytes
      end
    end
  end
end
