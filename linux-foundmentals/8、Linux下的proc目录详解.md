# Linux下的proc目录详解



/proc 是Linux系统下一个很重要的目录。 它跟/etc /home等这些系统目录不同， 它不是一个真正的文件系统， 而是一个虚拟的文件系统。 它不存在于磁盘， 而是存在于系统内存中。



**它以文件系统的方式为访问系统内核数据的操作提供接口。**



**用户和应用程序可以通过proc得到系统的信息，并可以改变内核的某些参数。**

**由于系统的信息，如进程，是动态改变的，所以用户或应用程序读取proc文件时，proc文件系统是动态从系统内核读出所需信息并提交的**。

很多系统的信息， 如内存使用情况， cpu 使用情况， 进程信息等等这些信息，都可以通过查看/proc下的对应文件来获得。 proc文件系统是动态从系统内核读出所需信息的。



另外，在/proc下还有三个很重要的目录：net，scsi和sys。 Sys目录是可写的，可以通过它来访问或修改内核的参数，而net和scsi则依赖于内核配置。例如，如果系统不支持scsi，则scsi 目录不存在。

除了以上介绍的这些，还有的是一些以数字命名的目录，它们是进程目录。

系统中当前运行的每一个进程都有对应的一个目录在/proc下，以进程的 PID号为目录名，它们是读取进程信息的接口。

而 /proc/self 目录则是读取进程本身的信息接口，是一个link。



```shell
/proc/N             pid为N的进程信息

/proc/N/cmdline     进程启动命令

/proc/N/cwd         链接到进程当前工作目录

/proc/N/environ     进程环境变量列表

/proc/N/exe         链接到进程的执行命令文件

/proc/N/fd          包含进程相关的所有的文件描述符

/proc/N/maps        与进程相关的内存映射信息

/proc/N/mem         指代进程持有的内存，不可读

/proc/N/root        链接到进程的根目录

/proc/N/stat        进程的状态

/proc/N/statm       进程使用的内存的状态

/proc/N/status      进程状态信息，比stat/statm更具可读性

/proc/self          链接到当前正在运行的进程








/proc/cpuinifo        CPU的信息（型号、家族、缓存大小等）

/proc/meminfo         物理内存、交换空间

/proc/mounts          已加载的文件系统的列表

/proc/devices         可用设备的列表

/proc/filesystems     内核支持的文件系统

/proc/modules         已加载的模块

/proc/virsion         内核版本

/proc/cmdline         系统启动时输入的内核命令行参数

/proc/XXX XXX         是指以进程PID（数字编号）命名的目录，每一个目录表示一个进程（即线程组）。

/proc/swaps           要获知swap空间的使用情况

/proc/uptime          获取系统的正常运行时间

/proc/fs/nfsd/exports 列出由NFS共享的文件系统

/proc/kmsg            该文件被作为内核日志信息源，它可以被作为一个系统信息调用的接口使用

/proc/self            到当前进程/proc目录的符号链接，通过这个目录可以获取当前运行进程的信息。

/proc/pci             挂接在PCI总线上的设备

/proc/tty/driver/serial 串口配置、统计信息

/proc/version         系统版本信息

/proc/sys/kernel/ostype

/proc/sys/kernel/osrelease

/proc/sys/kernel/version

/proc/sys/kernel/hostname -- 主机名

/proc/sys/kernel/domainname -- 域名

/proc/partitions -- 硬盘设备分区信息

/proc/sys/dev/cdrom/info -- CDROM信息

/proc/locks -- 当前系统中所有的文件锁

/proc/loadavg -- 系统负荷信息

/proc/uptime -- 系统启动后的运行时间
```

