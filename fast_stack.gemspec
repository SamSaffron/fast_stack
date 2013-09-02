Gem::Specification.new do |s|
  s.name = 'fast_stack'
  s.version = '0.0.1'
  s.date = '2013-09-02'
  s.summary = 'Fast String blank? implementation'
  s.description = 'Provides a C-optimized method for determining if a string is blank'

  s.authors = ['Sam Saffron']
  s.email = 'sam.saffron@gmail.com'
  s.homepage = ''

  s.extensions = ['ext/fast_stack/extconf.rb']
  s.require_paths = ['lib']
  s.files = [
    'MIT-LICENSE',
    'README.md',
    'lib/fast_stack.rb',
    'ext/fast_stack/fast_stack.c',
    'ext/fast_stack/extconf.rb',
  ]
  s.test_files = Dir['spec/**/*_spec.rb']

  s.platform = Gem::Platform::RUBY
  s.rubygems_version = '1.3.7'

  s.add_dependency 'rake'
  s.add_dependency 'rake-compiler'

  s.add_development_dependency 'rspec'
end

