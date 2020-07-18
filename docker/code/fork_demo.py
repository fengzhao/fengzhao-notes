
#!/usr/bin/env python

import os

print('当前进程:%s 启动中 ....' % os.getpid())
# 在 Linux 版本的 python 中，os模块才支持fork函数去调用操作系统的fork()函数。
pid = os.fork()
if pid == 0:
    print('子进程:%s,父进程是:%s' % (os.getpid(), os.getppid()))
else:
    print('进程:%s 创建了子进程:%s' % (os.getpid(),pid ))
