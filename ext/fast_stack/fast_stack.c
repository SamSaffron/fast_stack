#include <stdio.h>
#include <sys/time.h>
#include <ruby.h>
#include <ruby/encoding.h>

static VALUE
rb_profile_start(VALUE module, VALUE usec)
{
    struct itimerval timer;
    timer.it_interval.tv_sec = 0;
    timer.it_interval.tv_usec = (suseconds_t)NUM2LONG(usec);
    timer.it_value = timer.it_interval;
    setitimer(ITIMER_REAL, &timer, 0);

    return Qnil;
}

static VALUE
rb_profile_stop(VALUE module)
{
    struct itimerval timer;
    memset(&timer, 0, sizeof(timer));
    setitimer(ITIMER_REAL, &timer, 0);

    return Qnil;
}

static VALUE
rb_profile_block(VALUE module, VALUE usec)
{
    rb_need_block();

    rb_profile_start(module, usec);
    rb_yield(Qundef);
    rb_profile_stop(module);

    return Qnil;
}

void Init_fast_stack( void )
{
  VALUE rb_mFastStack = rb_define_module("FastStack");
  rb_define_module_function(rb_mFastStack, "profile_block", rb_profile_block, 1);
  rb_define_module_function(rb_mFastStack, "stop", rb_profile_stop, 0);
  rb_define_module_function(rb_mFastStack, "start", rb_profile_start, 1);
}
