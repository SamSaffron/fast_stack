require 'fast_stack/fast_stack'
module FastStack
  def self.profile(millisecs=1, &blk)
    stacks = []
    thread = Thread.current

    new_api = thread.respond_to?(:backtrace_locations)

    trap('PROF') do
      stacks << (new_api ? thread.backtrace_locations : thread.backtrace)
    end

    profile_block(millisecs * 1000, &blk)

    stacks
  end
end
