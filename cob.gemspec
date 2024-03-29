# frozen_string_literal: true

require_relative './lib/version'

Gem::Specification.new do |s|
  s.name        = 'cob'
  s.version     = Cob::VERSION
  s.date        = '2019-09-03'
  s.summary     = 'Checkout github branches with style'
  s.description = 'Format and checkout your branches'
  s.authors     = ['Yan']
  s.email       = 'yan@shiyason.com'
  s.files       = Dir['lib/*.rb']
  s.executables << 'cob'
  s.homepage    = 'https://github.com/yanshiyason/cob'
  s.license     = 'MIT'
  s.add_runtime_dependency 'fileutils', '~> 1.5'
  s.add_runtime_dependency 'json', '~> 2.5', '>= 2.5.1'
  s.add_runtime_dependency 'tty-prompt', '~> 0.23.1'
end
