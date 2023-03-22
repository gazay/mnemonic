# frozen_string_literal: true

require 'mnemonic'

object = []

mnemonic = Mnemonic.new do |config|
  config.memsize_of(object)
end

mnemonic.attach_pretty(STDOUT);

mnemonic.trigger! do
  10.times { object << "foo" }
end

mnemonic.detach_all
