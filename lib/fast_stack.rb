require 'fast_stack/fast_stack'
require 'tempfile'
module FastStack

  def self.profile(millisecs=1, mode=:ruby, &blk)

    return profile_native(millisecs, &blk) if mode == :c

    stacks = []
    thread = Thread.current

    new_api = thread.respond_to?(:backtrace_locations)

    trap('ALRM') do
      FastStack.stop
      stack = (new_api ? thread.backtrace_locations : thread.backtrace)
      # I am not sure if this is ensured to run in the thread
      # though in my samples it always does
      if thread == Thread.current
        stack = stack[2..-1]
      end
      stacks << stack
      FastStack.start(millisecs*1000)
    end

    begin
      FastStack.start(millisecs*1000)
      blk.call
    ensure
      FastStack.stop
    end

    stacks
  end


  private

  def self.profile_native(millisecs)
    temp = Tempfile.new('stacks')

    begin
      FastStack.start_native(millisecs*1000, temp.fileno)
      yield
    ensure
      FastStack.stop_native
    end

    temp.flush
    temp.close
    temp.open

    lines = temp.readlines
    stacks = []
    stack = []
    lines.each do |line|
      if line == "__END__\n"
        stacks << stack[2..-1]
        stack = []
      else
        stack << line
      end
    end

    temp.close
    temp.unlink


    stacks

  end

end
