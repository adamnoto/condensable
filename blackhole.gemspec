# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'condensable/version'

Gem::Specification.new do |spec|
  spec.name          = "condensable"
  spec.version       = Condensable::VERSION
  spec.authors       = ["Adam Pahlevi"]
  spec.email         = ["adam.pahlevi@gmail.com"]

  spec.summary       = 'Think of it like a Hash, but instead, access and assign a value by using dot notation.'
  spec.description   = %q{Hash values are set/retrieved using a number, a string, symbol or other hashable object.
                          If the value is almost always stored as a string/symbol,
                          retrieving from hash is quite ambiguous because Ruby
                          treat symbol and string differently, which is good.
                          Condensable class allow creating accessor on demand.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
end
