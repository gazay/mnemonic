# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mnemonic/version'

Gem::Specification.new do |spec|
  spec.name          = 'mnemonic'
  spec.version       = Mnemonic::VERSION
  spec.authors       = ['Vladimir Kochnev', 'Alexey Gaziev']
  spec.email         = %w[hashtable@yandex.ru alex.gaziev@gmail.com]

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.7'

  spec.summary       = 'The best tool to find leakage'
  spec.description   = 'The best tool to find leakage'
  spec.homepage      = 'https://github.com/gazay/mnemonic'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']
end
