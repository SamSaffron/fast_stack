#ifdef HAVE_BACKTRACE_SYMBOLS_FD

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <signal.h>
#include <execinfo.h>

#include "fast_stack.h"

struct sigaction old_alrm;
int backtrace_fd;

static void alrm_handler(int signum)
{
   static void *trace[2048];
   int n = backtrace(trace, 2048);

   if(n>2){
       backtrace_symbols_fd(trace + sizeof(void*)*2 , n-2, backtrace_fd);
       write(backtrace_fd, "__SEP__\n", 8);
   }
}

VALUE rb_profile_start_native(VALUE module, VALUE usec, VALUE fd)
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


VALUE rb_profile_stop_native(VALUE module)
{
    struct itimerval timer;

    sigaction(SIGALRM, &old_alrm, NULL);

    memset(&timer, 0, sizeof(timer));
    setitimer(ITIMER_REAL, &timer, 0);

    return Qnil;
}

VALUE rb_profile_start(VALUE module, VALUE usec)
{
    struct itimerval timer;

    timer.it_interval.tv_sec = 0;
    timer.it_interval.tv_usec = (suseconds_t)NUM2LONG(usec);
    timer.it_value = timer.it_interval;
    setitimer(ITIMER_REAL, &timer, 0);

    return Qnil;
}

VALUE rb_profile_stop(VALUE module)
{
    struct itimerval timer;
    memset(&timer, 0, sizeof(timer));
    setitimer(ITIMER_REAL, &timer, 0);

    return Qnil;
}

VALUE rb_profile_signal(VALUE module)
{
    return rb_str_new_cstr("ALRM");
}

#endif // HAVE_BACKTRACE_SYMBOLS_FD
