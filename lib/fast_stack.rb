require 'fast_stack/fast_stack'
module FastStack
  def self.profile(millisecs=1, &blk)
    stacks = []
    thread = Thread.current

    trap('PROF') do
      stacks << thread.backtrace_locations
    end

    profile_block(millisecs * 1000, &blk)

    stacks
  end
end
