# mysql安装指南


mysql下载地址，官网

https://dev.mysql.com/downloads/mysql/

选择相应的操作系统和位数，windows选择免安装版本（mysql-5.7.24-winx64.zip），linux选择源代码版本（mysql-5.7.24-linux-glibc2.12-x86_64.tar.gz）。


## 1、windows 安装过程


下载mysql文件并解压到D:/mysql目录中，添加d:/mysql/bin 到PATH环境变量。在根目录创建 my.ini 配置文件，内容如下：

``` shell
[client]
    port = 3306 # 设置mysql客户端连接服务端时默认使用的端口
[mysql]
    default-character-set=utf8 # 设置mysql客户端默认字符集   
[mysqld]
port=3306 #mysql服务端默认监听(listen on)的TCP/IP端口
 
basedir="D:\mysql" #解压根目录，基准路径，其他路径都相对于这个路径
 
datadir="D:\mysql\data" # mysql数据库文件所在目录
 
character-set-server=utfmb4 # 服务端使用的字符集 
 
default-storage-engine=INNODB # 创建新表时将使用的默认存储引擎
 
sql-mode=STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION # SQL模式为strict模式
 
max_connections=1024 # mysql服务器支持的最大并发连接数（用户数）。但总会预留其中的一个连接给管理员使用超级权限登录，即使连接数目达到最大限制。如果设置得过小而用户比较多，会经常出现“Too many connections”错误。
 
query_cache_size=0 # 查询缓存大小，用于缓存SELECT查询结果。如果有许多返回相同查询结果的SELECT查询，并且很少改变表，可以设置query_cache_size大于0，可以极大改善查询效率。而如果表数据频繁变化，就不要使用这个，会适得其反
 
tmp_table_size=34M # 内存中的每个临时表允许的最大大小。如果临时表大小超过该值，临时表将自动转为基于磁盘的表（Disk Based Table）。
 
thread_cache_size=8 # 缓存的最大线程数。当客户端连接断开时，如果客户端总连接数小于该值，则处理客户端任务的线程放回缓存。在高并发情况下，如果该值设置得太小，就会有很多线程频繁创建，线程创建的开销会变大，查询效率也会下降。一般来说如果在应用端有良好的多线程处理，这个参数对性能不会有太大的提高。

```


以管理员身份启动 cmd ,并输入 mysqld --initialize-insecure --user=mysql  来初始化.


输入 mysqld -install MySQL --defaults-file="D:\mysql\my.ini" 安装


输入 net start mysql 启动服务.

登陆 mysql -u root -p

``` sql 
use mysql;
update user set authentication_string=PASSWORD("123456AWS!@#") where user="root";
flush privileges;
quit;
```



## 2、Linux 安装过程

### 2.1 编译安装


下载

``` shell

mkdir /tmp/

wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.24-linux-glibc2.12-x86_64.tar.gz

```

