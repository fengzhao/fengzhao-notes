# MySQL8.0数据库备份

开源软件 Percona Xtrabackup 可以用于对数据库进行备份恢复

MySQL8 数据库热备份相关



## 版本要求

xtrabackup8 仅支持 MySQL8 及以上 ，支持 MySQL8.0.20 ，不支持低版本MySQL。MySQL5.7要用 5.7 版的xtrabackup 

备份软件版本： xtrabackup version 8.0.13

https://www.percona.com/doc/percona-xtrabackup/8.0/release-notes.html

https://www.percona.com/doc/percona-xtrabackup/LATEST/release-notes/8.0/8.0.13.html

https://www.percona.com/blog/2020/07/21/new-mysql-8-0-21-and-percona-xtrabackup-8-0-13-issues/

https://www.percona.com/blog/2020/04/28/percona-xtrabackup-8-x-and-mysql-8-0-20/



## 相关规划

```shell
# 查看一下数据库目录所在路径

mysql> show variables like 'datadir' ;
+---------------+-------------------+
| Variable_name | Value             |
+---------------+-------------------+
| datadir       | /data/mysql/data/ |
+---------------+-------------------+
1 row in set (0.00 sec)

# 查看一下整个数据库的大小
du -sh /data/mysql/data/
491G

# 准备备份空间

# 数据目录规划为 800G ，所以需要给备份专用的存储空间要规划为2T


# 可选备份种类

# 1.在本地服务器进行备份，备份文件存放在本地服务器上的其他磁盘或目录

# 2.除了上述方式，还要再远程传输备份到外部其他服务器或备份环境



```





## 备份工具安装



```shell
# CentOS7 
yum -y install  perl-Digest-MD5  libev  perl-DBI perl-DBD-MySQL perl-Time-HiRes perl-IO-Socket-SSL rsync 

cd /usr/local/src/ 

wget https://www.percona.com/downloads/Percona-XtraBackup-8.0/Percona-XtraBackup-8.0.13/binary/redhat/7/x86_64/percona-xtrabackup-80-8.0.13-1.el7.x86_64.rpm 

# 安装
rpm -ivh percona-xtrabackup-80-8.0.13-1.el7.x86_64.rpm  


# 查看xtrabackup版本
xtrabackup --version
```



```shell
# Ubuntu20.04 

apt install perl -y

apt list --installed | grep -i perl

perl -v

apt install libdbd-mysql-perl  -y

# 下载 
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb

dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb

percona-release setup ps80

sudo apt-get install percona-xtrabackup-80


https://downloads.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.23-16/binary/debian/bionic/x86_64/percona-xtrabackup-dbg-80_8.0.23-16-1.bionic_amd64.deb

```







```shell

# 进行一次完整的在线热全备测试 

xtrabackup  --backup  -u root --port=20197 -p'QHdata@0630' --socket=/data/mysql/mysql.sock --target-dir=/data/mysql_bak/20200828

# 最后的输出应该可以看到 xtrabackup: Transaction log of lsn (6673345540161) to (6673345540181) was copied.


# 第二种方式，加 ddl 锁，备份期间会阻塞DDL，详见 https://www.cnblogs.com/shengdimaya/p/11529200.html
xtrabackup --defaults-file=/etc/my.cnf --backup --lock-ddl --user=root  --password=QHdata@0630  --socket=/data/mysql/mysql.sock  --no-timestamp  --target-dir=/data/mysql_bak/20200827

# 华为-qhdb，基于上次全备进行增量备份
xtrabackup --defaults-file=/etc/my.cnf --backup --user=root --lock-ddl --password=QHdata@0630  --port=20197 --socket=/data/mysql/mysql.sock --no-timestamp  --incremental  --target-dir=/data/mysql_bak/xtra_inc_20200831 --incremental-basedir=/data/mysql_bak/xtra_base_20200830

```



```shell

#!/bin/bash
# filename      : /script/xtrabackup.sh
# Author        : fengzhao
# 备份策略： 每周日全备，周一周二增量备份，周三全备，周四周五周六增量备份，仅仅最近一周的备份文件
# 备份文件基路径 /qhdata/mysql_bak/


# 星期格式：0 1 2 3 4 5 6 
day=`date +%w`
# 日期格式：20200324
dt=`date +%Y%m%d`
# 前一天日期：20200323
lastday=`date -d '1 days ago' +%Y%m%d`
user=root
pwd='sj36668182'
socket=/var/lib/mysql/mysql.sock
#socket=/qhdata/mysql/mysql.sock
# 备份文件基路径
base_dir=/qhdata/mysql_bak

log=/qhdata/mysql_bak/log/backuplog.`date +%Y%m%d`

# 远程服务器的
remote_host=10.10.10.14
remote_user=root
remote_port=port
remote_dir=/data/mysql_bak/


case $day in  
    0)  
        # Sunday Full backup
        find $base_dir -name "xtra_*" -mtime +4 -exec rm -rf {} \;
        xtrabackup --defaults-file=/etc/my.cnf --backup --lock-ddl --user=$user --password=$pwd  --socket=$socket --no-timestamp  --target-dir=$base_dir/xtra_base_$dt > $log 2>&1
        ;;
        # 将备份文件传输到远程主机
        #  rsync -av -e 'ssh -p 2234' $base_dir/xtra_base_$dt user@${remote_host}:/${remote_dir}
    1)  
        # Monday Relatively Sunday's incremental backup  
        xtrabackup --defaults-file=/etc/my.cnf --backup --lock-ddl --user=$user --password=$pwd  --socket=$socket --no-timestamp  --incremental  --target-dir=$base_dir/xtra_inc_$dt --incremental-basedir=$base_dir/xtra_base_$lastday > $log 2>&1  
        ;;  
    2)  
        # Tuesday Compared with Monday's incremental backup  
        xtrabackup --defaults-file=/etc/my.cnf --backup --user=$user --lock-ddl --password=$pwd --socket=$socket  --no-timestamp  --incremental  --target-dir=$base_dir/xtra_inc_$dt --incremental-basedir=/$base_dir/xtra_inc_$lastday > $log 2>&1     
        ;;  
    3)  
        # Wednesday Full backup
        find $base_dir -name "xtra_*" -mtime +4 -exec rm -rf {} \;
        xtrabackup --defaults-file=/etc/my.cnf --backcup --user=$user --lock-ddl --password=$pwd --socket=$socket --no-timestamp --target-dir=$base_dir/xtra_base_$dt > $log 2>&1   
        ;;  
    4)  
        # Thursday  Relatively Wednesday's incremental backup  
        xtrabackup --defaults-file=/etc/my.cnf --backup --user=$user --lock-ddl --password=$pwd --socket=$socket  --no-timestamp  --incremental  --target-dir=$base_dir/xtra_inc_$dt --incremental-basedir=$base_dir/xtra_base_$lastday > $log 2>&1    
        ;;  
    5)  
        # Friday Compared with Thursday's incremental backup  
        xtrabackup --defaults-file=/etc/my.cnf --backup --user=$user --lock-ddl --password=$pwd --socket=$socket --no-timestamp  --incremental  --target-dir=$base_dir/xtra_inc_$dt --incremental-basedir=$base_dir/xtra_inc_$lastday > $log 2>&1    
        ;;  
    6)  
        # Saturday Compared with Friday's incremental backup  
        xtrabackup --defaults-file=/etc/my.cnf --backup --user=$user --lock-ddl --password=$pwd --socket=$socket  --no-timestamp  --incremental  --target-dir=$base_dir/xtra_inc_$dt --incremental-basedir=$base_dir/xtra_inc_$lastday > $log 2>&1   
        ;;  
esac 

# 删除老备份日志
find /qhdata/mysql_bak/log/ -mtime +6 -type f -name 'backuplog.*' -exec rm -rf {} \;


```



### 部分备份

```shell
# 当  innodb_file_per_table=enable 时，xtrabackup可以使用部分备份，大概有三种方式进行部分备份：
# 1. 用正则表达式匹配表名
# 2. 将表名写在一个文本文件中
# 3. 提供一个库名清单

# 如果备份期间，其中的一些库名被删除，备份即会失败停止

# 备份test库里面的所有表 （使用正则表达式备份匹配到的表）
xtrabackup --backup --datadir=/var/lib/mysql --target-dir=/data/backups/ --tables="^test[.].*"

# 备份test库里面的t1这个表
xtrabackup --backup --datadir=/var/lib/mysql --target-dir=/data/backups/ --tables="^test[.]t1"


# 使用 --tables-file 这个选项来备份多个表，后面参数是一个文本文件，databasename.tablename 这种格式，一行一个表
# 库名.表名 是精准匹配
xtrabackup --backup --tables-file file.txt --datadir=/var/lib/mysql --target-dir=/data/backups/ 




##### 部分备份的恢复

# 准备一个部分备份
xtrabackup --prepare --export --target-dir=/path/to/partial/backup

```





## 定时任务



```shell
# 每天凌晨一点执行备份脚本
0 1 * * * /script/xtrabackup.sh  >> /data/backup/log/crontab.log  2>&1 &
```





### 备份文件结构

```shell

备份文件夹是一个日期文件夹，格式大概是这样：2020-08-22_23-00-02，其中除了数据文件外，还包含如下文件：

1) xtrabackup_checkpoints   备份类型(如完全或增量)、备份状态(如是否已经为prepared状态)和LSN(日志序列号)范围信息

2)xtrabackup_binlog_info    mysql服务器当前正在使用的二进制日志文件及备份这一刻位置二进制日志时间的位置。

3)xtrabackup_binlog_pos_innodb  --  二进制日志文件及用于InnoDB或XtraDB表的二进制日志文件的当前position。



```





## 备份恢复



一般情况下，在备份完成后，数据尚且不能直接用于恢复，因为备份的数据中可能会包含尚未提交的事务或者已经提交但尚未同步至数据文件中的事务。

因此，此时数据文件仍处于不一致状态。"准备"的主要作用正是通过回滚未提交的事务及同步已经提交的事务至数据文件也使用得数据文件处于一致性状态。

可以在任意机器上执行恢复。并不一定非要在原始机器上执行，可以把数据拷到其他机器上然后执行恢复。



在 xtrabackup 中，可以用 xtrabackup  --prepare 这个命令来操作。

```shell
# 全量备份的prepare，指定备份文件路径
xtrabackup --prepare  --use-memory=  --target-dir=/data/backups/
...
...
InnoDB: Shutdown completed; log sequence number 137345046
160906 11:21:01 completed OK!

# 当执行结束后，会出现 completed OK ,即表示 prepare 完毕。
# 建议：prepare阶段不要轻易中断，中断有可能损坏备份文件。

# prepare完毕后，最后会输出 completed OK!，这样这份数据文件就可以直接用于启动MySQL了

# 准备一份配置文件，一份prepare好的数据文件，就直接启动MySQL进行恢复。
# （注意文件权限）

# 增量备份恢复



```



### 单表备份与恢复

```shell
# 从一个完整的xtrabackup全量备份中恢复单表或者少量表

# 如果全库数据量比较小，可以直接恢复全库，prepare之后，用mysqld_mutli启动一个新实例，然后用mysqldump导出表。

# 如果数据量比较大，


# 方法一：直接备份单表，并恢复单表
mysql> use test;
Database changed
mysql> checksum table sp_fixed_invest_month_bak;
+--------------------------------------------+------------+
| Table                                      | Checksum   |
+--------------------------------------------+------------+
| test.sbtest2 								 | 1295857934 |
+--------------------------------------------+------------+
1 row in set (0.05 sec)

mysql>
mysql>

# 备份单表
xtrabackup --user=backup --password='Bspass!4%' -S /data/mysql/mysql.sock  --datadir=/data/mysql/data  --backup\
		   --tables=sbtest2  --target-dir=/data/mysql_bak/test/
		   
		   
# 正则匹配备份多个表
xtrabackup --user=backup --password='Bspass!4%' -S /data/mysql/mysql.sock  --datadir=/data/mysql/data  --backup\
		   --tables="^test[.].*"  --target-dir=/data/mysql_bak/test/


# prepare阶段
xtrabackup --prepare --export --target-dir=/data/mysql_bak/test/

# prepare完成后，备份目录会生成两个文件sbtest2.ibd和sbtest2.cfg文件

# 然后把这两份文件拷贝到原数据库的数据目录中。注意拷贝之前，要关闭selinux，并且修改文件所属用户和用户组

# 导入表
ALTER TABLE sbtest2 IMPORT TABLESPACE;

# 检查表的完整性

mysql> test;
Database changed
mysql> checksum table sp_fixed_invest_month_bak;
+--------------------------------------------+------------+
| Table                                      | Checksum   |
+--------------------------------------------+------------+
| test.sbtest2 								 | 1295857934 |
+--------------------------------------------+------------+
1 row in set (0.05 sec)


# 方法二：全库备份只恢复单表






```



------









## 增量备份



xtrabackup 支持增量备份，这意味着，它可以只备份自动上次全量备份之后改变过的内容。



一个全量备份后可以有多个增量备份，可以选择多种备份策略：

- 每周一全备，每天一增备
- 每天全备，每小时增备









增量备份实际上并不是完全跟上次完整全备的比较。

如果知道 lsn 号，可以用 --incremental-lsn 来指定相对的 lsn 号做增量备份。













## 压缩备份



为了在备份期间，直接对备份文件进行压缩，可以使用  --compress 选项。

```shell
 xtrabackup --backup --compress --target-dir=/data/compressed 
 
 # 如果想加速压缩过程。可以用--compress-threads
 xtrabackup --backup --compress --compress-threads=4 --target-dir=/data/compressed/
```







## 流备份