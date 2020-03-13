# mysql安装指南


mysql下载地址，官网

https://dev.mysql.com/downloads/mysql/

Windows 系统下载的安装文件：

- 免安装方式（推荐）
  - 5.7：[mysql-5.7.28-winx64.zip]( https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.28-winx64.zip  )
  - 8.0：[mysql-8.0.18-winx64.zip](https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.18-winx64.zip)

- msi安装方式

  - 下载MSI Installer文件，下一步下一步式安装。

Linux 系统下载的文件：一般推荐用 **Linux - Generic**  这种源格式的安装文件。

- 5.7：[mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz](https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz) 
- 8.0：[mysql-8.0.18-linux-glibc2.12-x86_64.tar.xz](https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.18-linux-glibc2.12-x86_64.tar.xz) 


​    


## 1、windows 安装过程


下载mysql文件并解压到 D:/mysql 目录中，添加 D:/mysql/bin 到 PATH 系统环境变量中。在根目录创建 my.ini 配置文件，内容如下：

``` shell
[client]
# 设置mysql客户端连接服务端时默认使用的端口
port = 3306 
[mysql]
# 设置mysql客户端默认字符集   
default-character-set=utf8 
[mysqld]
# mysql服务端默认监听(listen on)的TCP/IP端口号
port=3306 
# 基准路径，其他路径都相对于这个路径 
basedir="D:\mysql" 
# mysql数据库文件所在目录
datadir="D:\mysql\data" 
# 默认字符集 
character-set-server=utf8mb4
# 默认存储引擎
default-storage-engine=INNODB
# SQL模式为strict模式
# sql-mode=STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION 
# mysql服务器支持的最大并发连接数（用户数）。如果设置得过小而用户比较多，会经常出现“Too many connections”错误。
max_connections=1024
# 禁用查询缓存，这个参数在5.7.20后已经Deprecated
# query_cache_size=0 
# 内存中的每个临时表允许的最大大小。如果临时表大小超过该值，临时表将自动转为基于磁盘的表（Disk Based Table）。
tmp_table_size=34M 
# 缓存的最大线程数。当客户端连接断开时，如果客户端总连接数小于该值，则处理客户端任务的线程放回缓存。在高并发情况下，如果该值设置得太小，就会有很多线程频繁创建，线程创建的开销会变大，查询效率也会下降。一般来说如果在应用端有良好的多线程处理，这个参数对性能不会有太大的提高。
thread_cache_size=8 
```

以管理员身份启动 cmd , 进行数据初始化：

> mysql_install_db 这个程序在 MySQL 5.7.6 中已经弃用，因为它的功能已经集成在 mysqld 中了，所以在安装 5.7 及以后版本时，直接使用  mysqld --initialize  或者  mysqld  --initialize-insecure 就可以直接初始化。在 5.7.5 之前，mysql_install_db 这个程序是用 perl 脚本写的，所以需要安装 perl ，5.7.5 之后，改为用 C++ 写的，并且可以直接做为二进制文件执行。

```shell
# 不安全的初始化，默认root密码为空，需要登陆后自己设置一个密码
mysqld --initialize-insecure --console
# 直接初始化，为root生成一个随机密码，密码打印在控制台中
mysqld --initialize --console

```

安装系统服务

```shell
mysqld -install MySQL --defaults-file="D:\mysql\my.ini" 
```

启动系统服务

```shell
net start mysql 
```

登陆并设置密码

``` sql  
mysql -u root -p
use mysql;
update user set authentication_string=PASSWORD("123456AWS!@#") where user="root";
flush privileges;
quit;
```



默认地，MySQL 会创建如下用户：

```sql
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> select user,host from mysql.user;
+------------------+-----------+
| user             | host      |
+------------------+-----------+
| mysql.infoschema | localhost |
| mysql.session    | localhost |
| mysql.sys        | localhost |
| root             | localhost |
+------------------+-----------+
4 rows in set (0.05 sec)

mysql>


```

### 用户管理

我们在创建数据库用户的时候都会指定host，即一个完整的用户可描述为 'username'@'host' 。

创建用户时不显式指定host则默认为%，%代表所有 ip 段都可以使用这个用户，我们也可以指定host为某个ip或ip段，这样会仅允许在指定的ip主机使用该数据库用户。

不过你也应该明白 'username'@'%' 和 'username'@'192.168.6.%' 是两个毫无关联的用户，这两个用户可以有不同的密码和权限，这里不建议创建多个同名不同host的用户，还有不要轻易更改用户的host



## 2、Linux 安装过程

### 2.1 二进制安装

#### 环境

- GNU/Linux-x86_64
- gcc 运行时环境

#### 安装规范

| 配置项               | 值或路径                    |
| -------------------- | --------------------------- |
| base目录           | /usr/local/mysql            |
| socket套接字文件     | /data/mysql/mysql.sock      |
| 错误日志（启动日志） | /data/mysql/error.log       |
| 进程文件             | /data/mysql/mysql.pid       |
| 数据目录             | /data/mysql/                |
| 字符集和排序规则     | utf8mb4和utf8mb4_unicode_ci |

#### 用户和数据目录创建

```shell 
$ groupadd mysql
$ useradd -r -g mysql -s /bin/false mysql
$ mkdir -p /data/mysql 
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
#skip-grant-tables
log_timestamps=SYSTEM
user = mysql
port = 3306
basedir = /usr/local/mysql
log_error = /data/mysql/
datadir = /data/mysql/
socket = /data/mysql/mysql.sock
pid-file = /data/mysql/db.pid
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
skip_name_resolve = 1
open_files_limit    = 65535
back_log = 1024
```

#### 下载

``` shell
$ cd /tmp/

# 5.7
$ wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.24-linux-glibc2.12-x86_64.tar.gz

# 8.0
$ wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.18-linux-glibc2.12-x86_64.tar.xz


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

### 2.2 包管理器安装

包管理器也是一种简单的安装方式，但是自由性没有那么好，自定义程度也没有那么好。常用的 Linux 包管理器有 yum 和 apt 

#### 2.2.1、yum 安装

1. 添加 MySQL Yum 仓库到系统仓库列表中

```shell
   $ wget -P /tmp https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
   $ wget -P /tmp https://dev.mysql.com/get/mysql80-community-release-el6-1.noarch.rpm
   $ rpm -Uvh platform-and-version-specific-package-name.rpm
```

2. 选择版本

默认地，Yum 包安装的是最新的 GA 版本（标准发布版），如果这正是你需要的，可以跳过这一步。

在 MySQL Yum 仓库中，不同的发行版在不同的子仓库中，默认当前是当前最新的 GA 版本（8.0），5.7 系列默认是被禁用的，使用下面的命令来查看所有 MySQL 子仓库，看看哪些被启用，哪些被禁用

```shell
$ yum repolist all | grep mysql
$ dnf repolist all | grep mysql
```

如果要安装 5.7 系列的，需要禁用最新的 GA 版本子仓库，启用 5.7 系列版本子仓库。

``` shell
$ sudo yum-config-manager --disable mysql80-community
$ sudo yum-config-manager --enable mysql57-community
```
这两行命令，其实是修改 /etc/yum.repos.d/mysql-community.repo 这个文件里面的内容，通过 enabled 字段来控制启用和禁用。

``` shell
[mysql80-community]
name=MySQL 8.0 Community Server
baseurl=http://repo.mysql.com/yum/mysql-8.0-community/el/6/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

# Enable to use MySQL 5.7
[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/6/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
```

验证当前子仓库的可用性

``` shell
 $ yum repolist enabled | grep mysql
```

3. 安装 MySQL

``` shell
$ sudo yum install mysql-community-server
```

4. 启动 MySQL
``` shell

$ sudo service mysqld start
$ sudo systemctl start mysqld.service
$ sudo service mysqld status
$ sudo service mysqld status
```

对于 5.7 ，root账号会随机生成一个密码存在日志文件中，通过 sudo grep 'temporary password' /var/log/mysqld.log 命令来查看。


密码要求如下：至少一个大写字母、至少一个小写字母、至少一个数字、至少一个特殊符号、字符总长度不小于8。


