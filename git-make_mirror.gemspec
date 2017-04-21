# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git/make_mirror/version'

Gem::Specification.new do |spec|
  spec.name          = "git-make_mirror"
  spec.version       = Git::MakeMirror::VERSION
  spec.authors       = ["Nathan Reed"]
  spec.email         = ["reednj@gmail.com"]

  spec.summary       = "Create a non-bare remote ready to accept pushes for deployment"
  spec.homepage      = "https://github.com/reednj/git-make_mirror"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency  'trollop'
end
