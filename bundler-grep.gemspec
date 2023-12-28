# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundler/grep/version'

Gem::Specification.new do |spec|
  spec.name          = "bundler-grep"
  spec.version       = Bundler::Grep::VERSION
  spec.authors       = ["takkanm"]
  spec.email         = ["takkanm@gmail.com"]

  spec.summary       = %q{bundle grep subcommand}
  spec.description   = %q{grep bundle gems}
  spec.homepage      = "https://github.com/takkanm/bundler-grep"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
