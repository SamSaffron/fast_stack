#include "fast_stack.h"

void Init_fast_stack( void )
{
  VALUE rb_mFastStack = rb_define_module("FastStack");
  rb_define_module_function(rb_mFastStack, "start", rb_profile_start, 1);
  rb_define_module_function(rb_mFastStack, "stop", rb_profile_stop, 0);
  rb_define_module_function(rb_mFastStack, "signal", rb_profile_signal, 0);

  rb_define_module_function(rb_mFastStack, "start_native", rb_profile_start_native, 2);
  rb_define_module_function(rb_mFastStack, "stop_native", rb_profile_stop_native, 0);
}
