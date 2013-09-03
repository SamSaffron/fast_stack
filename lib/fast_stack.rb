require 'fast_stack/fast_stack'
module FastStack
  def self.profile(millisecs=1, &blk)
    done = false
    stacks = []
    thread = Thread.current
    delta = millisecs / 1000.0
    last_time = Time.new

    new_api = thread.respond_to?(:backtrace_locations)

    # NOTE not extracting to another method to avoid adding a frame
    #  to the stack

    # this thread catches stuff fast stack does not
    # the main case is catching sleeping threads
    profile_thread = Thread.new do
      until done
        start = Time.new
        if last_time < start - delta
          last_time = start
          stacks << (new_api ? thread.backtrace_locations : thread.backtrace)
        end

        sleep(delta)
      end
    end

    trap('PROF') do
      start = Time.new
      if last_time < start - delta
        last_time = start
        stacks << (new_api ? thread.backtrace_locations : thread.backtrace)
      end
    end

    begin
      profile_block(millisecs * 1000, &blk)
    ensure
      done = true
      profile_thread.join
    end

    stacks
  end
end
