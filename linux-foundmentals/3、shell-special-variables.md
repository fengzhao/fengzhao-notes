## shell 脚本中的特殊变量

这篇文章总结一下 shell 脚本中的特殊变量。



| 变量名称 |                           变量含义                           |
| :------: | :----------------------------------------------------------: |
|    $0    | 当前执行的 shell 脚本文件名，如果执行时包含路径，那么变量也带路径 |
|    $n    | 当前脚本执行的第 n 个参数，如果 n > 9 ，那使用时用大括号引起来，{$10} |
|    $#    |              当前脚本执行时传递的参数总个数              |
|    $@    |                      当前脚本执行时传递的所有参数，                                        |
|    $$    |              当前执行的 shell 脚本的进程号（PID）               |
|    $_    |                 获得上一个命令的最后一个参数                 |
|    $!    |                  获取上一次执行脚本的进程号                  |
|    $?    |                                                              |



















当我们执行脚本的时候，可以是绝对路径执行，也可以是相对路径执行。

```shell
/usr/local/src/apache-zookeeper-3.7.0-bin/bin/zkServer.sh start /usr/local/src/apache-zookeeper-3.7.0-bin/zk1/zoo1.cfg


cd /usr/local/src/apache-zookeeper-3.7.0-bin/

./bin/zkServer.sh start  zk1/zoo1.cfg 



```





