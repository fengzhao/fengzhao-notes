# MySQL备份

mysql备份类型：逻辑备份和物理备份，全备份和增量备份等等



### 1、备份分类

按照是否能够继续提供服务，将数据库备份类型划分为：

- 热备份：在线备份，能读能写
- 温备份：能读不能写
- 冷备份：离线备份

按照备份数据库对象分类：

- 物理备份：直接复制数据文件
- 逻辑备份：将数据导出至文件中，必要时将其还原(也包括备份成sql语句的方式)

按照是否备份整个数据集分为：

- 完全备份：备份从开始到某段时间的全部数据
- 差异备份：备份自完全备份以来变化的数据
- 增量备份：备份自上次增量备份以来变化的数据

分类方式不同，不同分类的备份没有冲突的关系，它们可以任意组合。



### 物理备份

物理备份，即直接备份磁盘上的物理数据文件。（即直接拷贝备份）

物理备份由源文件组成，这种备份适合紧急情况时，大的，重要的需要尽快恢复的数据库。



物理备份有如下特点：

​    1、备份文件由数据库目录和文件组成，**通常是整个数据目录的备份。**

​    2、物理备份方法通常更快，因为只是涉及到文件拷贝。

​    3、备份和恢复的颗粒度从整个数据目录到单个文件。到表级别的颗粒度，这取决于数据库引擎。

​		  例如，InnoDB 表可以是独立表空间。也可以是共享表空间。每一个MyISAN表对应一组独一的文件。

​    4、除了数据库，备份也包括其他相关的文件，比如日志文件和配置文件。

​    5、内存表中的数据比较难以备份，因为他们不存在磁盘中。（可以通过Mysql企业版来完成备份）

​    6、备份文件只能用在类似配置的机器上。

​    7、备份可以在mysql关闭后进行，如果mysql在运行中，那么考虑要适当加锁，保证备份过程中，数据不会变。

​	8、



### 逻辑备份

逻辑备份保存了代表数据库逻辑结构（建库建表语句）和内容（插入语句）。这种备份适合小型数据库。

逻辑备份有如下特点：

​    1、备份是通过查询mysql服务器来获取表结构和表数据来完成的。

​    2、比物理备份慢一点，因为需要访问数据库获取数据信息转换成逻辑格式。如果数据在客户端写入，那么服务端必须把它送到 backup 程序中。

​    3、输出比物理备份大，特别是保存成文件格式。

​    4、备份和恢复的颗粒可以从服务层（所有的库）和数据库层（某个库中的表），与引擎无关。

​    5、不包括日志文件和配置文件的备份。

​    6、备份文件以逻辑格式存储，机器独立，并且高可用。

​    7、服务可以不停，保存运行。

对于 InnoDB 的表，可以实现在线备份而且不需要对表加锁，通过在 mysqldump 上添加 single-transaction 参数。



逻辑备份可以使用  mysqldump 或 select ... into outfile  语句。

然后使用 mysqlimport 或 load data 等语句来恢复数据。

```shell
# 优点： 恢复速度非常快，比insert的插入速度快很多。
# 缺点：只能备份表数据，并不能包含表结构；如果表被drop，是无法恢复数据的。

# select into outfile 导出表
select col1， col2 from table-name into outfile  '/path/备份文件名称'
// 将tt表数据备份到tmp目录下的tt.sql文件
select * from tt into outfile '/tmp/tt.sql
// 如果tt.sql文件存在，会报错文件以及存在


LOAD DATA INFILE '/path/备份文件' into table database.tt
// 将tmp下的tt.sql文件恢复到tt表
load data infile '/tmp/tt.sql' into table db.tt


# load data与insert速度对比
# 以插入10万条数据为例，load data需要大概1.4s，insert大概需要12.2s，大概是insert的12倍。
```





### MySQL 快速导入数据

在很多场景，我们需要临时快速导入大量数据到某个新数据库。













http://mysql.taobao.org/monthly/2020/08/03/







### 热备份 VS 冷备份

热备就是不停机备份，备份期间，数据库服务并不会关闭。整个实例还可以对外提供服务。

冷备就是停库备份，备份期间，数据库服务关闭，直接拷贝文件和数据目录的方式进行备份。



### 2、备份内容和备份工具

需要备份的内容：文件、二进制日志、事务日志、配置文件、操作系统上和 MySQL 相关的配置（如 sudo，定时任务）。


常用备份工具：

- mysqldump：mysql自带备份工具。要求 MySQL 服务在线。MyISAM(温备)，InnoDB（热备）。
- XtraBackup：Percona开源组件。MyISAM（温备），InnoDB（热备），速度较快。

mysqldump 可以从表中逐行的取出数据，也可以在导出之前从表中取出全部数据缓存到内存中，对于大表缓存到内存可能会有问题，对于逐行备份，使用 --quick 选项，这是默认的。使用 --skip-quick 允许内存缓存。

### 2.1、mysqldump 语法

mysqldump 大致有三种用法，可以用来导出某些库中的某些表，或者是整个 MySQL Server。

```shell
$ mysqldump [options] db_name [tbl_name ...]
$ mysqldump [options] --databases db_name ...
$ mysqldump [options] --all-databases
```

mysqldump 有很多选项，可以配置文件或者命令行中指定。

#### 连接选项

与 mysql 命令一样，mysqldump 也是登陆到 MySQL Server 中去执行操作，所以有一些连接选项，来指定如何连接 MySQL Server.

- --bind-address=ip_address                         指定目标主机的网络接口
- --compress, -C                                               压缩服务端和客户端的通信数据
- --host=host_name, -h host_name              指定目标主机，默认是本地 
- --user=user_name, -u user_name              用户名
- --password[=password], -p[password]      密码
- --port=port_num, -P port_num                    端口号

#### 过滤选项

过滤选项用来控制导哪些 schema，哪些表。甚至可以通过 where 语句过滤部分行。

- --all-databases, -A  所有库的所有表，等价于  --databases 后接所有库名

- --databases, -B  后接需要导的库，在每个库前会导出 CREATE DATABASE 和 USE 语句。

- --events, -E 导出事件调度器，不会导出调度器的时间戳，恢复时，这些被设为当前时间，用导 mysql.event表的方法的方法可以时间调度器的时间戳元数据。

- --ignore-error=error[,error]... 忽略错误， --force 忽略所有错误， --force优先级更高

- --ignore-table=db_name.tbl_name  忽略部分表，必须是库名.表名格式。如果多个表，可以指定多次。

- --no-data, -d 只导出表结构，不导出表数据

- --routines, -R 导出存储过程和函数，与事件调度器一样，也不会导出元数据，用 mysql.proc 来导元数据。

- --tables 重写--databases规则，这个选项后接的所有参数都被视为表名。

- --where='where_condition', -w 'where_condition' 

  仅导出部分符合条件的行，例如

  ```shell
  --where="user='jimf'"
  -w"userid>1"
  -w"userid<1"
  ```

#### DDL 选项

mysqldump 其实是把数据库中的数据对象转储为 sql 文件。这其中就包括很多 DDL 语句。



标准的建库语句，use语句，建表语句，插入语句。

- --add-drop-database  在每个 CREATE DATABASE 之前都带 DROP DATABASE
- --add-drop-table 在每个 CREATE TABLE 都带 DROP TABLE

#### 性能选项

下面这些选项与数据还原操作性能有关，对于大数据集，还原数据（执行dump_file文件中的 insert 语句）是最耗费时间。对于还原时间的考虑，需要在备份之前就要计划和测试。







# MySQL 热备



## MySQL8.0热备

MySQL8 数据库热备份规范

## 版本要求

xtrabackup8 仅支持 MySQL8 及以上 ，支持 MySQL8.0.20 ，不支持低版本MySQL。MySQL5.7要用 5.7 版的xtrabackup 。

备份软件版本： xtrabackup version 8.0.13

https://www.percona.com/doc/percona-xtrabackup/8.0/release-notes.html

https://www.percona.com/doc/percona-xtrabackup/LATEST/release-notes/8.0/8.0.13.html

https://www.percona.com/blog/2020/07/21/new-mysql-8-0-21-and-percona-xtrabackup-8-0-13-issues/



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
```





## 手动执行一次全备



```shell
# 进行一次完整的全备测试 

xtrabackup  --backup  -u root --port=20197 -p'QHdata@0630' --socket=/data/mysql/mysql.sock --target-dir=/data/mysql_bak/20200828

# 第二种方式，加 ddl 锁，详见 https://www.cnblogs.com/shengdimaya/p/11529200.html
xtrabackup --defaults-file=/etc/my.cnf --backup --lock-ddl --user=root  --password=QHdata@0630  --socket=/data/mysql/mysql.sock  --no-timestamp  --target-dir=/data/mysql_bak/20200827

# 华为-qhdb，基于上次全备进行增量备份
xtrabackup --defaults-file=/etc/my.cnf --backup --user=root --lock-ddl --password=QHdata@0630  --port=20197 --socket=/data/mysql/mysql.sock --no-timestamp  --incremental  --target-dir=/data/mysql_bak/xtra_inc_20200831 --incremental-basedir=/data/mysql_bak/xtra_base_20200830



```



## 全量备份脚本



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


case $day in  
    0)  
        # Sunday Full backup
        find $base_dir -name "xtra_*" -mtime +4 -exec rm -rf {} \;
        xtrabackup --defaults-file=/etc/my.cnf --backup --lock-ddl --user=$user --password=$pwd  --socket=$socket --no-timestamp  --target-dir=$base_dir/xtra_base_$dt > $log 2>&1
        ;;  
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


find /qhdata/mysql_bak/log/ -mtime +6 -type f -name 'backuplog.*' -exec rm -rf {} \;


```



## 部分备份



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

