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

### Changelog

0.1.0 - 17-Sep - Bugfix - deep callstacks could lead to an infinite loop

### Notes

This technique was conceived by https://github.com/tmm1 , big thank you.

Ruby 2.0 uses #backtrace_locations, 1.9.3 uses #backtrace

(gem template based on https://github.com/CodeMonkeySteve/fast_xor )
