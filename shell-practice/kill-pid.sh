
 #!/bin/bash

 # 这个脚本第一次运行时，把进程号重定向到pid文件中，休息300秒，模拟守护进程不退出。
 # 下次运行时，先杀掉之前这个进程，然后再把新的进程号输出到文件中。
 # 主要应用在需要频繁运行的定时任务之类的脚本中，永远只能有一个进程存在。

PIDPATH=/tmp/demo.pid
if [ -f "$PIDPATH" ]then
    kill `cat $PIDPATH` > /dev/null 2>&1
    rm -rf $PIDPATH
fi
echo $$ > $PIDPATH
sleep 300
