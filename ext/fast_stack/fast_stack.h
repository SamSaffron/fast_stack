#ifndef FAST_STACK_H__
#define FAST_STACK_H__

#include <ruby.h>
#include <ruby/encoding.h>

VALUE rb_profile_start_native(VALUE module, VALUE usec, VALUE fd);
VALUE rb_profile_stop_native(VALUE module);
VALUE rb_profile_start(VALUE module, VALUE usec);
VALUE rb_profile_stop(VALUE module);
VALUE rb_profile_signal(VALUE module);

#endif
