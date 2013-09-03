require 'fast_stack/fast_stack'
module FastStack
  def self.profile(millisecs=1, &blk)
    stacks = []
    thread = Thread.current
    last_time = Time.new

    new_api = thread.respond_to?(:backtrace_locations)

    trap('ALRM') do
      stack = (new_api ? thread.backtrace_locations : thread.backtrace)
      # I am not sure if this is ensured to run in the thread
      # though in my samples it does
      if thread == Thread.current
        stack = stack[2..-1]
        # since we are in the same thread, might as well remove
        #  our overhead
        start = Time.new
      end
      stacks << stack
    end

    profile_block(millisecs * 1000, &blk)

    stacks
  end
end
