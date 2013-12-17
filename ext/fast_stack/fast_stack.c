#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <ruby.h>
#include <ruby/encoding.h>
#include <signal.h>
#include <execinfo.h>

struct sigaction old_alrm;
int backtrace_fd;

static void alrm_handler(int signum)
{
   static void *trace[1024];
   int n = backtrace(trace, 1024);

   backtrace_symbols_fd(trace, n, backtrace_fd);
   write(backtrace_fd,"__END__\n",8);
}

static VALUE
rb_profile_start_native(VALUE module, VALUE usec, VALUE fd)
{
    struct itimerval timer;
    struct sigaction sa;

    backtrace_fd = NUM2INT(fd);
    sigaction(SIGALRM, NULL, &old_alrm);

    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = alrm_handler;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGALRM, &sa, NULL);

    timer.it_interval.tv_sec = 0;
    timer.it_interval.tv_usec = (suseconds_t)NUM2LONG(usec);
    timer.it_value = timer.it_interval;
    setitimer(ITIMER_REAL, &timer, 0);

    return Qnil;
}

static VALUE
rb_profile_stop_native(VALUE module)
{
    struct itimerval timer;

    sigaction(SIGALRM, &old_alrm, NULL);

    memset(&timer, 0, sizeof(timer));
    setitimer(ITIMER_REAL, &timer, 0);

    return Qnil;
}

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


void Init_fast_stack( void )
{
  VALUE rb_mFastStack = rb_define_module("FastStack");
  rb_define_module_function(rb_mFastStack, "start", rb_profile_start, 1);
  rb_define_module_function(rb_mFastStack, "stop", rb_profile_stop, 0);

  rb_define_module_function(rb_mFastStack, "start_native", rb_profile_start_native, 2);
  rb_define_module_function(rb_mFastStack, "stop_native", rb_profile_stop_native, 0);
}
