require 'fast_stack/fast_stack'
require 'tempfile'
module FastStack

  def self.profile(millisecs=1, mode=:ruby, &blk)

    return profile_native(millisecs, &blk) if mode == :c

    stacks = []
    thread = Thread.current

    new_api = thread.respond_to?(:backtrace_locations)

    handler do
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

  def self.handler(&block)
    trap(signal, &block)
  end

  def self.profile_native(millisecs)
    temp = Tempfile.new('stacks')
    stacks = nil

    begin
      FastStack.start_native(millisecs*1000, temp.fileno)
      yield
    ensure
      FastStack.stop_native
    end

    temp.flush
    temp.close
    temp.open
    stacks = []
    stack = []
    temp.each_line do |line|
      if line.strip == "__SEP__"
        stacks << stack
        stack = []
      else
        stack << line.strip
      end
    end
    temp.close
    temp.unlink

    resolve_frames!(stacks)
    stacks
  end

  def self.resolve_frames!(stacks)
    frames = {}
    resolved = {}
    stacks.each do |stack|
      stack.map! do |frame|
        frames[frame] ||= resolve_frame(frame,resolved)
      end
    end
  end

  def self.process_name
    @name ||= File.readlink("/proc/#{Process.pid}/exe")
  end

  def self.pmap
    @pmap ||= begin

      result = []

      unparsed  = `pmap #{Process.pid} | awk '{ printf $1; for(i=4;i<=10;i++) printf " %s ",$i; print "" }'`.split("\n")
      unparsed[1..-1].each do |line|
        split = line.split(" ")
        if split[0] != "total"
          result << [split[0].hex, split[1..-1].join(" ").strip]
        end
      end

      result
    end
  end

  def self.parse_frame(frame)
    matches = frame.match(/(.*)\((.*)\)\[(.*)\]/)
    {exe: matches[1], local: matches[2], global: matches[3]}
  rescue
    {exe: "unknown", local: "0", global: "0"}
  end

  def self.global_to_local(global)
    prev = 0
    pmap.each do |location, e|
      if location > global
        return global - prev
      end
      prev = location
    end

    0
  end

  def self.resolve_frame(frame,resolved)
    resolved[frame] ||= begin

      parsed = parse_frame(frame)

      resolved_location = global_to_local(parsed[:global].hex)

       info = `addr2line -f -C -e #{process_name} 0x#{resolved_location.to_s(16)}`.split("\n")
       parsed[:fn] = info[0].strip
       parsed[:file], parsed[:line] = info[1].strip.split(":")

       file = parsed[:file] == "??" ? parsed[:exe] : parsed[:file]
       fn = parsed[:fn] == "??" ? parsed[:local] : parsed[:fn]

       "#{file}:#{parsed[:line]}:in `#{fn}'"
    end
  end

end
