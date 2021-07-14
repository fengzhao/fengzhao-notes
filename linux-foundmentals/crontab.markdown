## crontab 简介



通过 crontab 命令，我们可以在固定的间隔时间执行指定的系统指令或 shell script脚本。

时间间隔的单位可以是分钟、小时、日、月、周及以上的任意组合。

这个命令非常适合周期性的日志分析或数据备份等工作。



crond 是linux下用来周期性的执行某种任务或等待处理某些事件的一个守护进程。

Linux下的任务调度分为两类，系统任务调度和用户任务调度：

系统任务调度：系统周期性所要执行的工作，比如写缓存数据到硬盘、日志清理等。/etc/crontab 文件就是系统任务调度的配置文件。

```shell

# cat /etc/crontab
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=HOME=/
# run-parts
51 * * * * root run-parts /etc/cron.hourly
24 7 * * * root run-parts /etc/cron.daily
22 4 * * 0 root run-parts /etc/cron.weekly
42 4 1 * * root run-parts /etc/cron.monthly
```



```shell
# 前四行是用来配置crond任务运行的环境变量

# 第一行SHELL变量指定了系统要使用哪个shell，这里是bash，
# 第二行PATH变量指定了系统执行命令的路径，
# 第三行MAILTO变量指定了crond的任务执行信息将通过电子邮件发送给root用户，如果MAILTO为空则不发送
# 第四行的HOME变量指定了在执行命令或者脚本时使用的主目录。
```

