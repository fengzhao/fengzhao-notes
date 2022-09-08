# 传入容器名称

ContainerName = "stxz-php-fpm stxz-redis stxz-elasticsearch stxz-mysql stxz-webserver"

# 当前时间
currTime=`date +"%Y-%m-%d %H:%M:%S"`

# 创建crontab日志文件
# mkdir -p /qhdata/monitor_log
# touch /qhdata/monitor_log/docker-monitor-crontab.log
# touch /qhdata/monitor_log/docker_monitor.log

# 查看进程是否存在
for i in ${ContainerName}
do
    exist=`docker inspect --format '{{.State.Running}}' ${i}`
    if [ "${exist}" != "true" ]; then
        docker start ${i}
        echo "${currTime} 重启docker容器，容器名称：${i}"  >>  /qhdata/monitor_log/docker_monitor.log
    fi
done



# crontab -e,添加如下内容每十秒钟执行一次监控，输出 crontab 日志到文件中
# */1 * * * * sleep 10; /qhdata/docker_monitor.sh   >>  /qhdata/monitor_log/docker-monitor-crontab.log   2>&1
