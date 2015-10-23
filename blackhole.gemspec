# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blackhole/version'

Gem::Specification.new do |spec|
  spec.name          = "blackhole"
  spec.version       = Blackhole::VERSION
  spec.authors       = ["Adam Pahlevi"]
  spec.email         = ["adam.pahlevi@gmail.com"]

  spec.summary       = 'Think of it like a Hash, where you access and assign value using dot notation'
  spec.description   = %q{Hash values are set/retrieved using a number, a string, symbol or other hashable object.
                          If the value is almost always stored as a string/symbol,
                          retrieving from hash is quite ambiguous because Ruby
                          treat symbol and string differently, which is good.
                          Blackhole creates an instance and allow you to define
                          its accessors on the fly the first time they are used}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
