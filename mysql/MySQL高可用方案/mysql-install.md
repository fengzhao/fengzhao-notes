



## Linux 安装MySQL

### 二进制安装

#### 环境

- GNU/Linux-x86_64
- gcc 运行时环境
- 

#### 安装规范

| 配置项               | 值或路径                    |
| -------------------- | --------------------------- |
| base目录           | /usr/local/mysql            |
| socket套接字文件     | /data/mysql/mysql.sock      |
| 错误日志（启动日志） | /data/mysql/mysql.err |
| 进程文件             | /data/mysql/mysql.pid       |
| 数据目录             | /data/mysql/data/          |
| 字符集和排序规则     | utf8mb4和utf8mb4_general_ci |



### 目录规划



利津服务器，三台服务器如下：

- 10.147.91.113:1222      root/Huawei12#$
- 10.147.91.113:1222      root/Huawei12#$
- 10.147.91.113:1222      root/Huawei12#$

分别是 100G  200G  1000G 三块硬盘。规划为 1000G 的磁盘用于存储 MySQL 数据库

```shell
# 执行lsblk查看1000G是哪块硬盘，比如是/dev/vdc 
lsblk


# 使用 parted 对磁盘进行分区，以 /dev/sdb 为例
parted /dev/vdc

# 建立磁盘标签
(parted) mklabel GPT

# 如果没有任何分区，它查看磁盘可用空间，当分区后，它会打印出分区情况
(parted) print

# 创建主分区，n 为要分的分区占整个磁盘的百分比
(parted) mkpart primary 0% 100%

#  分区完后，直接 quit 即可，不像 fdisk 分区的时候，还需要保存一下，这个不用
(parted) quit

# 让内核知道添加新分区
partprobe

# 格式化
mkfs.ext4 /dev/vdc1

# 挂载分区
mkdir /data
mount /dev/sdb1 /data







```









#### 用户和数据目录创建

```shell 
$ groupadd mysql
$ useradd -r -g mysql -s /bin/false mysql
$ mkdir -p /data/mysql/{binlog,data,relaylog}
$ chown -R mysql:mysql /data/mysql
```

#### 创建 /etc/my.cnf文件

这是最基本的配置文件，更详细的配置，可以参考相关mysql优化文档

``` shell 
[client]
port = 3306
socket = /data/mysql/mysql.sock
# default-character-set　=　utf8mb4

[mysql]
no-auto-rehash
default-character-set = utf8mb4

[mysqld]

########################################基础配置，共用########################################################################
# skip-grant-tables
log_timestamps=SYSTEM
user = mysql
port = 3306
basedir = /usr/local/mysql
log_error = /data/mysql/mysql.err
datadir = /data/mysql/data/
socket = /data/mysql/mysql.sock
pid-file = /data/mysql/db.pid
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci
skip_name_resolve = 1
open_files_limit    = 65535
back_log = 1024
time_zone='+8:00'
default_authentication_plugin=mysql_native_password
########################################################################################################################



################################################ 主库配置 #########################################################

# 主从复制关键参数，主从集群中每个实例的ID必须唯一	
server-id=110

# binlog相关参数
# 路径
log_bin=/data/3306/binlog/3306-bin.log
# 格式
binlog_format=row
binlog_row_image=full
# binlog过期时间  7天
# expire_logs_days=15;
binlog_expire_logs_seconds=604800
# 开启gtid，与下面这个参数一起用
gtid_mode=on
# gtid持久化
enforce_gtid_consistency=on


# 开启半同步复制，主库等待超过10s，变为异步复制
rpl_semi_sync_master_enabled=1
rpl_semi_sync_master_timeout=1000
rpl_semi_sync_slave_enabled=1

# relaylog相关：relaylog路径，relaylog索引，不自动清理relaylog
relay_log_purge=0
relay-log = /data/3306/relaylog/3306-bin.log
relay-log-index = slave-relay-bin.index

master_info_repository=TABLE
binlog_transaction_dependency_tracking  = WRITESET 
transaction_write_set_extraction = XXHASH64
###################################################################################################################




############################################### 从库1配置 ############################################################

# 主从复制关键参数，主从集群中每个实例的ID必须唯一	
server-id=111
# binlog配置
log_bin=/data/3306/binlog/3306-bin.log
binlog_format=row
# 半同步复制相关参数
rpl_semi_sync_master_enabled=1
rpl_semi_sync_master_timeout=1000
rpl_semi_sync_slave_enabled=1

# relaylog相关：relaylog路径，relaylog文件索引，不自动清理relaylog
relay_log_purge=0
relay-log = /data/3306/relaylog/3306-bin.log
relay-log-index = slave-relay-bin.index

# 多线程并发复制
slave_parallel_type=logical_clock
slave_parallel_workers=8







```

#### 下载

``` shell
$ cd /usr/local/src/

# 5.7
$ wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.24-linux-glibc2.12-x86_64.tar.gz

# 8.0
$ wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.22-linux-glibc2.12-x86_64.tar.xz


```

#### 解压并安装

``` shell
$ tar  -zxvf  /tmp/mysql-5.7.24-linux-glibc2.12-x86_64.tar.gz -C /usr/local
$ mv  /usr/local/mysql-5.7.24-linux-glibc2.12-x86_64  /usr/local/mysql
$ cd  /usr/local/mysql
$ ./bin/mysqld   --initialize-insecure  --basedir=/usr/local/mysql --datadir=/data/mysql  --user=mysql  --pid-file=/data/mysql/mysql.pid
$ ./support-files/mysql.server start
$ ./support-files/mysql.server status
```

> 5.6与5.7在初始化的时候有一些区别，在 5.7.6 以前都用 mysql_install_db 来初始化数据库，在这之后的版本，由于 mysqld 程序已经集成了初始化数据库功能， mysql_install_db  这个功能在未来的版本中可能会被去掉。所以建议直接使用  mysqld   --initialize-insecure 这样的方法来进行数据初始化。
>
> 



#### 添加到系统服务和开机自启

``` shell
$ cp /usr/local/mysql/support-files/mysql.server  /etc/init.d/mysql
$ chkconfig --add mysql
$ chkconfig mysql on
```

#### 设置root密码，并开启任意IP登陆

``` sql
/usr/local/mysql/bin/mysql -u root -p  
# 5.7
UPDATE mysql.user SET authentication_string=PASSWORD("QH@123456") WHERE user='root';

# 8.0
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'QH@123456';


grant all privileges on *.* to 'root' @'%' identified by '123456';
flush privileges;
```

#### 设置 mysql 环境变量

```shell
$ vim /etc/profile
```
在最底下加上 export PATH=$PATH:/usr/local/mysql/bin 
```shell
source /etc/profile
```

#### mysql服务管理

``` shell
$ systemctl status mysql
$ systemctl start mysql
$ systemctl stop mysql
$ systemctl restart mysql
```


