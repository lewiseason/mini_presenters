lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'mini_presenters/version'

Gem::Specification.new do |spec|
  spec.name = 'mini_serializers'
  spec.version = MiniPresenters::VERSION
  spec.authors = ['Lewis Eason']
  spec.summary = 'mini_serializers is a tiny model serialization library'

  spec.files = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
