### Fast stack

Very efficient collection of ruby backtraces, even under heavy CPU load

### How do you use it?

    require 'fast_stack'

### Usage


```
  def fib( n )
    return  n  if ( 0..1 ).include? n
    ( fib( n - 1 ) + fib( n - 2 ) )
  end

  stacks = FastStack.profile do
    fib(30)
  end
  
  puts stacks.count
  # 30 
  
```

### Notes

Ruby 2.0 only, uses #backtrace_locations 

(gem template based on https://github.com/CodeMonkeySteve/fast_xor )
