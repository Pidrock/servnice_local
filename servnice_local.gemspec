# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'servnice_local/version'

Gem::Specification.new do |spec|
  spec.name          = "servnice_local"
  spec.version       = ServniceLocal::VERSION
  spec.authors       = ["Kasper Grubbe"]
  spec.email         = ["kawsper@gmail.com"]
  spec.summary       = %q{Write a short summary. Required.}
  spec.description   = %q{Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["servnice_server"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"

  spec.add_dependency "sinatra"
  spec.add_dependency "mini_magick"
end
