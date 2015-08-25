Gem::Specification.new do |s|
  s.name = 'fast_stack'
  s.version = '0.1.0'
  s.date = '2013-09-17'
  s.summary = 'Fast method for collecting stack traces in Ruby 2.1'
  s.description = 'Fast method for collecting stack traces in Ruby 2.1'
  s.license = 'MIT'

  s.authors = ['Sam Saffron']
  s.email = 'sam.saffron@gmail.com'
  s.homepage = 'https://github.com/SamSaffron/fast_stack'

  s.extensions = ['ext/fast_stack/extconf.rb']
  s.require_paths = ['lib']
  s.files = [
    'MIT-LICENSE',
    'README.md',
    'lib/fast_stack.rb',
    'ext/fast_stack/fast_stack.c',
    'ext/fast_stack/extconf.rb'
  ]
  s.test_files = Dir['spec/**/*_spec.rb']

  s.platform = Gem::Platform::RUBY
  s.rubygems_version = '1.3.7'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rake-compiler'

  s.add_development_dependency 'rspec'
end

