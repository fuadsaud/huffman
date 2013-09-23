# encoding: utf-8

$LOAD_PATH.unshift 'lib'

require 'huffman/version'

Gem::Specification.new do |s|
  s.name              = 'huffman'
  s.version           = Huffman::VERSION
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = 'Huffman coding utility'
  s.homepage          = 'http://github.com/fuadsaud/huffman'
  s.email             = 'fuadksd@gmail.com'
  s.authors           = 'Fuad Saud'
  s.has_rdoc          = false

  s.files             = %w( README.md Rakefile LICENSE.md )
  s.files            += Dir.glob('lib/**/*')
  s.files            += Dir.glob('bin/**/*')
  s.files            += Dir.glob('spec/**/*')

  s.executables       = %w( huffman )
  s.description       = <<-DESC
  Feed me.
DESC

  s.add_dependency 'powerpack'
  s.add_dependency 'pqueue'
  s.add_development_dependency 'rspec'
end
