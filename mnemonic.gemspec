# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mnemonic/version'

Gem::Specification.new do |spec|
  spec.name          = "mnemonic"
  spec.version       = Mnemonic::VERSION
  spec.authors       = ["Vladimir Kochnev", "Alexey Gaziev"]
  spec.email         = ["hashtable@yandex.ru", "alex.gaziev@gmail.com"]

  spec.summary       = %q{The best tool to find leakage}
  spec.description   = %q{The best tool to find leakage}
  spec.homepage      = "https://github.com/gazay/mnemonic"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
end
