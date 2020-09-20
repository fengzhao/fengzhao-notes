## fork炸弹



Jaromil 在 2002 年设计了最为精简的一个 Linux Fork 炸弹，整个代码只有13个字符，在 shell 中运行后几秒后系统就会宕机 。



```shell
:(){:|:&};:
```



```shell
:()
{
    :|:&
};
:
```



```shell
bomb()
{
    bomb|bomb&
};
bomb
```



因为shell中函数可以省略 `function` 关键字，所以上面的十三个字符是功能是定义一个函数与调用这个函数，

函数的名称为`:`，主要的核心代码是`:|:&`，可以看出这是一个函数本身的递归调用，通过`&`实现在后台开启新进程运行，通过管道实现进程呈几何形式增长，最后再通过`:`来调用函数引爆炸弹。

因此，几秒钟系统就会因为处理不过来太多的进程而死机，解决的唯一办法就是重启。





## 预防方式



当然，Fork炸弹没有那么可怕，用其它语言也可以分分钟写出来一个，例如，python版：



```python
import os
     while True: 
     os.fork()
```



Fork炸弹的本质无非就是靠创建进程来抢占系统资源，在Linux中，我们可以通过`ulimit`命令来限制用户的某些行为，运行`ulimit -a`可以查看我们能做哪些限制：

```shell
ubuntu@10-10-57-151:~$ ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 7782
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 7782
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```



可以看到，`-u`参数可以限制用户创建进程数，因此，我们可以使用`ulimit -u 20`来允许用户最多创建20个进程。这样就可以预防bomb炸弹。

但这样是不彻底的，关闭终端后这个命令就失效了。我们可以通过修改`/etc/security/limits.conf`文件来进行更深层次的预防，在文件里添加如下一行（ubuntu需更换为你的用户名）：

```shell
ubuntu - nproc 20
```

这样，退出后重新登录，就会发现最大进程数已经更改为20了。



这个时候我们再次运行炸弹就不会报内存不足了，而是提示`-bash: fork: retry: No child processes`，说明Linux限制了炸弹创建进程。