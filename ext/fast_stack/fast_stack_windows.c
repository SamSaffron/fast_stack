#ifdef HAVE_CREATETIMERQUEUETIMER

#include "fast_stack.h"

static VALUE handler_proc;
static HANDLE timer = NULL;

VALUE rb_profile_start_native(VALUE module, VALUE usec, VALUE fd)
{
    rb_raise(rb_eNotImpError, "Not implemented on Windows");
    return Qnil;
}

VALUE rb_profile_stop_native(VALUE module)
{
    rb_raise(rb_eNotImpError, "Not implemented on Windows");
    return Qnil;
}

static void CALLBACK timer_handler(void* handler, BOOLEAN from_timer)
{
    raise(SIGINT);
}

VALUE rb_profile_start(VALUE module, VALUE usec)
{
    DWORD interval;

    interval = NUM2LONG(usec) / 1000; /* Windows resolution is in milliseconds */

    timeBeginPeriod(1);
    if (!CreateTimerQueueTimer(&timer, NULL, &timer_handler, (void*)handler_proc,
        interval, interval, WT_EXECUTEDEFAULT))
    {
        rb_raise(rb_eRuntimeError, "Cannot start timer: %d", GetLastError());
    }

    return Qnil;
}

VALUE rb_profile_stop(VALUE module)
{
    if (timer)
    {
        DeleteTimerQueueTimer(NULL, timer, NULL);
        timer = NULL;
    }
    timeEndPeriod(1);

    return Qnil;
}

VALUE rb_profile_signal(VALUE module)
{
    return rb_str_new_cstr("INT");
}

#endif // HAVE_CREATETIMERQUEUETIMER
