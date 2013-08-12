# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blue/version'

Gem::Specification.new do |spec|
  spec.name          = "blue"
  spec.version       = Blue::VERSION
  spec.authors       = ["Josh Sharpe"]
  spec.email         = ["josh.m.sharpe@gmail.com"]
  spec.description   = %q{A deployment framework for rails apps}
  spec.summary       = %q{Helps manage all aspects of your cloud infrastructure. Install services, deploy code, restart processes, monitor, etc...}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'hashie'
  spec.add_dependency 'shadow_puppet'
  spec.add_dependency 'capistrano'
  spec.add_dependency 'puppet'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

