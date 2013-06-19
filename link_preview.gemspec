# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'link_preview/version'

Gem::Specification.new do |spec|
  spec.name          = "link_preview"
  spec.version       = LinkPreview::VERSION
  spec.authors       = ["Tomas D'Stefano"]
  spec.email         = ["tomas_stefano@successoft.com"]
  spec.description   = %q{Link Preview parser feature.}
  spec.summary       = %q{Link Preview parser feature.}
  spec.homepage      = "https://github.com/tomas-stefano/link_preview"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency 'rspec'
end
