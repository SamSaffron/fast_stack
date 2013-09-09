require 'mkmf'
require 'rbconfig'
require 'fileutils'

# work around ruby 2.0 p0 bug
FileUtils.mkdir_p(File.expand_path('../../../lib/fast_stack',__FILE__))

create_makefile('fast_stack/fast_stack')
