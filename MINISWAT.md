MINISWAT is a built in debugger to speed up GEOS development for MEGA65.

Is it initially loaded in the memory area $6000-$8000 of physical bank 0. On
panic this is mapped in and processed via the debuggers implemention. Some kind
of continue command will map the area back.