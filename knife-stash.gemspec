# -*- encoding: utf-8 -*-
require File.expand_path('../lib/knife-stash/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian Flad"]
  gem.email         = ["bflad417@gmail.com"]
  gem.description   = %q{A knife plugin for Atlassian Stash.}
  gem.summary       = gem.summary
  gem.homepage      = "https://github.com/bflad/knife-stash"

  gem.add_runtime_dependency "faraday"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "knife-stash"
  gem.require_paths = ["lib"]
  gem.version       = Knife::Stash::VERSION
end
