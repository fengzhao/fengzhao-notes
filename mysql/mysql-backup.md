## MySQL备份

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

### 2、备份内容和备份工具

需要备份的内容：文件、二进制日志、事务日志、配置文件、操作系统上和MySQL相关的配置（如sudo，定时任务）。


备份工具：

mysqldump：mysql自带备份工具。要求mysql服务在线。MyISAM(温备)，InnoDB（热备）
XtraBackup:Percona开源组件。MyISAM（温备），InnoDB（热备），速度较快。

mysqldump 可以从表中逐行的取出数据，也可以在导出之前从表中取出全部数据缓存到内存中，对于大表缓存到内存可能会有问题，对于逐行备份，使用 --quick 选项，这是默认的。使用 --
skip-quick 允许内存缓存。

### 2.1、mysqldump 语法

mysqldump大致有三种用法，来导出某些库中的某些表，或者是整个MySQL Server。

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

mysqldump 其实是把数据库中的数据对象转储为 sql 文件。这其中就包括很多 DDL 语句，

- --add-drop-database  在每个 CREATE DATABASE 都带 DROP DATABASE
- --add-drop-table 在每个 CREATE TABLE 都带 DROP TABLE

#### 性能选项

下面这些选项与数据还原操作性能有关，对于大数据集，还原数据（执行dump_file文件中的 insert 语句）是最耗费时间。对于还原时间的考虑，需要在备份之前就要计划和测试。










