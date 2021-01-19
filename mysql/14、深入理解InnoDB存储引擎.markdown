## 内存

### 缓冲池（buffer pool）

**InnoDB 存储引擎是基于磁盘存储的，并将其中的记录按照页的方式进管理，因此可以将其视为基于磁盘的数据库系统。**

在数据库系统中，由于 CPU 和磁盘交换速度的差距，基于磁盘的数据库系统通常使用缓冲池技术来提高数据库的整体性能。

缓冲池简单说就是一块内存区域，通过内存的速度来弥补磁盘的速度，在数据库中读取页时，首先将磁盘读到的页放到缓冲池中，这个过程称为将页 fix 到缓冲池，下次再读取相关的页时，下次再读取相同的页时，先判断是否在缓冲池中，若在，则称为该页在缓冲池被命中。

对于修改数据（增删改），同样首先修改缓冲池中的页，然后在以一定的频率刷新到磁盘。通过一种 checkpoint 的机制刷回磁盘。



**缓冲池中的内容**

缓冲池是 MySQL 向操作系统申请的一块内存区域，操作系统是以页为单位对内存进行管理。

具体来看，缓冲池中的页类型有：数据页，索引页，undo页，插入缓冲，自适应哈希索引，InnoDB存储的锁信息，数据字典信息等。

**不能简单的认为，缓冲池只是缓冲索引和数据页。**



InnoDB 中的数据访问是以 Page 为单位的，每个 Page 的大小默认为 16KB，Buffer Pool 是用来管理和缓存这些 Page 的。





### 什么是 LRU 算法

就是一种缓存淘汰策略。

计算机的缓存容量有限，如果缓存满了就要删除一些内容，给新内容腾位置。但问题是，删除哪些内容呢？我们肯定希望删掉哪些没什么用的缓存，而把有用的数据继续留在缓存里，方便之后继续使用。那么，什么样的数据，我们判定为「有用的」的数据呢？

LRU 缓存淘汰算法就是一种常用策略。LRU 的全称是 Least Recently Used，也就是说我们认为最近使用过的数据应该是是「有用的」，很久都没用过的数据应该是无用的，内存满了就优先删那些很久没用过的数据。





### LRU List

通常，数据库中的缓冲池是通过 LRU (Latest Recent Used) 算法来管理的，即最频繁使用的页在 LRU 最前端。



在 buffer pool 中的的数据页可以认为是一个 LIST 列表，分为两个子列表 （New Sublist） （ Old Sublist）

```shell
# 这个参数控制着 New Sublist 和 Old Sublist 的比例 ，New Sublist占5/8，Old Sublist占3/8
innodb_old_blocks_pct=37
```



可以简单理解为 New Sublist 中的页都是最活跃的热点数据页。

当有数据页要加载到内存中，就插入到 Old Sublist 的头部，并且从 Old Sublist 尾部移除不再使用的页。

可以看到，这是一个先进先出的队列。

很明显不用一个队列来管理这些，可以避免一次大表的全表扫描，就把缓冲池中的所有数据都刷出。









![](../resources/InnoDB-buffer-pool.png)

MySQL默认在InnoDB缓冲池（而不是整个缓冲池）中仅保留最频繁访问页的25%  。

在多数使用场景下，合理的选择是：保留最有用的数据页，比加载所有的页(很多页可能在后续的工作中并没有访问到)在缓冲池中要更快。



### **缓冲池相关参数**

```shell
# 缓冲池实例数量，默认为1，不可以动态调整
innodb_buffer_pool_instances=1
# 缓冲池总大小，默认是128MB，一般设置为物理内存的70%左右。MySQL5.7.5之后可以动态调整，不要在业务繁忙的时候进行动态调整。
innodb_buffer_pool_size=134217728
# 缓冲池配置时的基本单位，以块的形式配置，指明块大小。
# innodb_buffer_pool_size=innodb_buffer_pool_chunk_size * innodb_buffer_pool_instances * n 
innodb_buffer_pool_chunk_size=128M # 默认内存块是128M，可以以1MB为单位(1048576 字节)增加或减少


```

### 缓冲池预热



**缓冲池中的数据**

具体来看，缓冲池中的页类型有：数据页，索引页，undo页，插入缓冲，自适应哈希索引，InnoDB存储的锁信息，数据字典信息等。

不能简单的认为，缓冲池只是缓冲索引和数据页。



在生产中，重启MySQL后，会发现一段时间内SQL性能变差，然后最终恢复到原有性能。

这是因为MySQL经常操作的热点数据都已经缓存到 InnoDB Buffer Pool 中。

重启后。需要将热点数据从磁盘中逐渐缓存到 InnoDB Buffer Pool 中，从磁盘读取数据自然没有从内存读取数据快。



MySQL重启后，将热点数据从磁盘逐渐缓存到 InnoDB Buffer Pool 的过程称为预热（warmup）。

让应用系统自身慢慢通过SQL给 InnoDB Buffer Pool 预热成本很高，如果遇到高峰期极有可能带来一场性能灾难，业务卡顿不能顺利运营。



为了避免这种情况发生，MySQL 5.6 引入了数据预热机制：

- innodb_buffer_pool_dump_at_shutdown 
-  innodb_buffer_pool_load_at_startup 

这两个参数控制了预热，不过默认都是关闭的，需要开启。MySQL 5.7则是默认开启。



## 刷脏

**脏页**

当事务提交后，数据刷到磁盘之前，此时内存中的数据页和磁盘中的数据是不一致的，我们把此时内存中的这些数据页成为脏页。

**刷脏**







### 多线程刷脏

- 5.6版本以前，脏页的清理工作交由 master thread的；

- Page cleaner thread是 5.6.2 引入的一个新线程（单线程），从master线程中卸下buffer pool刷脏页的工作独立出来的线程(默认是启一个线程)；

- 5.7开始支持多线程刷脏页；



## 两阶段提交

在 MySQL 中，两阶段提交有几个最重要的文件：



### 重做日志 redo log



重做日志，又叫事务日志，是 InnoDB 存储引擎层的日志。



在 MySQL 里，如果每一次的更新操作都需要写进磁盘，然后磁盘也要找到对应的那条记录，然后再更新，整个过程IO成本、查找成本都很高。

**所以有一种技术叫 WAL ，全称是 Write-Ahead Logging，它的关键点就是先写日志，再写磁盘。（日志先行）**

具体来说，当有一条记录需要更新的时候，InnoDB 引擎就会先把记录写到 redo log （磁盘中的物理文件）里面，并更新内存，这个时候更新就算完成了。

（严格说还没有 commit 成功，客户端还看不到返回成功）

**由于 redo-log 是顺序写的，所以速度比较快。redo-log 是物理日志，记录的是 “在某个数据页上做了什么修改”。**

**redo-log 是循环写的，当 redo-log 写完后，就要刷盘。把数据刷到磁盘中。**



由于内存缓冲的存在，对数据的增删改都先修改内存中的数据页，再定期 flush 落盘持久化。

在每次事务提交的时候，将该事务涉及修改的数据页全部刷回到磁盘中。但是这么做会有严重的性能问题，主要体现在两个方面：

- 因为 Innodb 是以页为单位进行磁盘交互的，而一个事务很可能只修改一个数据页里面的几个字节，这个时候将完整的数据页刷到磁盘的话，太浪费资源了。
- 一个事务可能涉及修改多个数据页，并且这些数据页在物理上并不连续，使用随机 IO 写入性能太差。



因此 MySQL 设计了 `redo log` 。具体来说就是只记录事务对数据页做了哪些修改，这样就能完美地解决性能问题了(相对而言文件更小，并且是顺序IO)。

redo log 包括两部分：

- 一个是内存中的日志缓冲（redo log buffer，内存地址空间）。（innodb_log_buffer_size）
- 另一个是磁盘上的日志文件（redo log file，物理磁盘文件）。（innodb_log_file_size）

MySQL 每执行一条 DML 语句，先将记录写入 redo log buffer ，后续某个时间点再一次性将多个操作记录写到 redo log file 。

默认情况下，redo log 在磁盘上由名为 `ib_logfile0` 和 `ib_logfile1` 的两个物理文件。



#### redolog 相关配置参数

```shell

### redo log 关键参数

redo-log 默认是在 datadir 目录下，名为 `ib_logfile1` 和 `ib_logfile2` 这样的两个文件。
# 指定redo-log的存放目录，默认是"./"，即在datadir目录下，一般不建议放在datadir下，防止IO争用
# 注意这个目录要提前创建好，并设置好正确的权限
innodb_log_group_home_dir=/data/mysql_redo_log/

# 单个redolog文件的大小，默认是48MB，最大值为512G，注意最大值指的所有redo-log文件之和
# redo-log应该尽量设置的足够大，
innodb_log_file_size=48MB

# rego-log是以一组文件的形式出现。这个参数了指定了一组里面有多少个redo log文件
innodb_log_files_in_group=2  # 默认值是2
# regolog文件的总大小就是等于 innodb_log_file_size*innodb_log_files_in_group

# redo log buffer 大小，默认16M。延迟事务日志写入磁盘，把 redo log 放到该缓冲区
# 然后根据 innodb_flush_log_at_trx_commit 参数的设置，再把日志从buffer中flush到磁盘
# innodb_log_buffer_size是会话级的，所有整个redolog buffer占用的空间应该是innodb_log_buffer_size * connections 
innodb_log_buffer_size=16M  



## 修改redo_log文件大小必须要先关闭实例后再修改。



innodb_flush_log_at_trx_commit：
# 控制 redolog 从 redolog buffer刷新到磁盘的策略:

# 默认为1。值为1，每次 commit 都会把 redo log 从 redo log buffer 写入到 system ，并fsync刷新到磁盘文件中。

# 值为2，每次事务提交时 MySQL 会把日志从 redo log buffer 写入到 system ，但只写入到 file system buffer，由系统内部来 fsync 到磁盘文件。
# 如果数据库实例 crash ，不会丢失 redo log，但是如果服务器 crash，由于 file system buffer 还来不及 fsync 到磁盘文件，所以会丢失这一部分的数据。

# 值为0，表示事务提交时不进行写入redo log操作，这个操作仅在 master thread 中完成，而在 master thread 中每1秒进行一次重做日志的 fsync 操作，因此实例 crash 最多丢失1秒钟内的事务。


# 这个参数是innodb的数据页大小单位，一般设置为
innodb_page_size=16KB
```



#### redolog 动态开关

在 MySQL 8.0.21 新版本发布中，支持了一个新特性**Redo Logging动态开关**。

借助这个功能，在新实例导数据的场景下，事务处理可以跳过记录 redolog 和 doublewrite buffer，从而加快数据的导入速度。

**同时，付出的代价是短时间牺牲了数据库的ACID保障。所以主要使用场景就是向一个新实例导入数据。**



**注意事项**

- 该特性仅用于新实例导数据场景，不可用于线上的生产环境；
- Redo logging关闭状态下，支持正常流程的关闭和重启实例；但在异常宕机情况下，可能会导致丢数据和页面损坏；Redo logging关闭后异常宕机的实例需要废弃重建，直接重启会有如下报错：[ERROR] [MY-013578] [InnoDB] Server was killed when Innodb Redo logging was disabled. Data files could be corrupt. You can try to restart the database with innodb_force_recovery=6.
- Redo logging 关闭状态下，不支持 cloning operations 和 redo log archiving 这两个功能；
- 执行过程中不支持其他并发的ALTER INSTANCE操作；





**新增内容**

- SQL语法`ALTER INSTANCE {ENABLE | DISABLE} INNODB REDO_LOG`。
- INNODB_REDO_LOG_ENABLE 权限，允许执行Redo Logging动态开关的操作。
- Innodb_redo_log_enabled的status，用于显示当前Redo Logging开关状态。



**用法**

```sql
--先赋权
GRANT INNODB_REDO_LOG_ENABLE ON *.* to 'data_load_admin';
--然后关闭redo_log
ALTER INSTANCE DISABLE INNODB REDO_LOG;
--确认是否关闭成功
SHOW GLOBAL STATUS LIKE 'Innodb_redo_log_enabled';

--开始往新实例导入数据

--重新开启redo_log
ALTER INSTANCE ENABLE INNODB REDO_LOG;
--确认是否开启成功
SHOW GLOBAL STATUS LIKE 'Innodb_redo_log_enabled';
```







#### redolog 归档

热备的原理都是要备份redolog，由于redolog是循环写的。

**如果备份期间还是有大量的事务写入，备份速度跟不上redo log生成的速度，结果导致redo log被覆盖了，然后备份就无法保证一致性**。

就会导致备份失败。

在 MySQL 8.017 中引入了 redolog 归档功能。即写 redolog 的时候，



想要启用redo log归档功能，只需设置**innodb_redo_log_archive_dirs**选项即可，该选项可支持在线动态修改，例如：



https://blog.csdn.net/qq_35246620/article/details/79345359





### 回滚日志undolog











### 二进制日志 binlog



binlog 是 MySQL 的 server 层很重要的一个文件，它的主要作用如下：

- 用于复制，在主从复制中，从库利用主库上的binlog进行重播，实现主从同步。
- 用于数据库的基于时间点的还原。



binlog 是逻辑上的日志，

### binlog 相关配置

```shell
# 相关参数

# binlog_cache是session级别的，也就是说实际binlog cache占用内存数= connections * binlog_cache。
binlog_cache_size  # 默认值是32k，写binlog之前，会先写binlog_cache

# 一般设置为row
binlog_format

# binlog是否加密，默认不加密
binlog_encryption=off

# binlog过期时间，默认是30天
binlog_expire_logs_seconds=2592000





```







redo-log 和 binlog 是 两阶段提交的重点，

- 当未开启 binlog 时，InnoDB 通过 redo 和 undo 日志来恢复数据库 (safe crash recovery)：

  当**数据恢复（指事务已经提交成功，但是数据还没有刷回磁盘时重启的这种情况）**时：

  - 所有已经在存储引擎内部提交的事务应用 redo log 恢复。
  - 所有已经 prepared 但是没有 commit 的事务则会通过 undo log 做回滚

- 开启 binlog 时，两阶段的流程：
  - InnoDB 的事务 Prepare 阶段，即 SQL 已经成功执行并生成 redo 和 undo 的内存日志；（写 redo_log_buffer）
  - binlog 提交，通过 write() 将 binlog 内存日志数据写入文件系统缓存；
  - sync() 将 binlog 文件系统缓存日志数据永久写入磁盘；（这一步就可以给客户端返回事务提交成功）
  - InnoDB 内部提交，commit 阶段在存储引擎内提交，通过 innodb_flush_log_at_trx_commit 参数控制，使 undo 和 redo 永久写入磁盘。
  
  



**Prepare阶段：写 redo-log , 此时redo log处于prepare状态。注意这里可能只是写  innodb_log_buffer （这是内存中的重做日志缓冲区）**

**Commit阶段：innodb释放锁(释放锁住的资源)，释放回滚段，设置提交状态，binlog持久化到磁盘，然后存储引擎层提交**

![](../resources/prepare.png)





![](../resources/commit.png)



https://www.cnblogs.com/xibuhaohao/p/10899586.html























## 组提交

### 背景

- 操作系统使用 **缓存** 来填补内存和磁盘访问的差距，对磁盘文件的写入会先写入到页面缓存中。

- 在一些 GNU/Linux 和 UNIX 中，使用  **Unix fsync()  系统调用**来把数据刷到磁盘（InnoDB默认使用 *fsyn*c 这个）

  - > 引自  [MySQL refman 8.5.8](https://dev.mysql.com/doc/refman/8.0/en/optimizing-innodb-diskio.html) 

- 数据库在事务提交过程中调用 fsync 将数据持久化到磁盘，才满足**ACID**中的**D（持久化）**

- fsync 是昂贵的操作，对于普通磁盘，每秒能完成几百次 fsync

- MySQL 中使用了两阶段提交协议，为了满足D(持久化) ，一次事务提交最多会导致 **3次 fsync**

  - 提交的事务在存储引擎内部（redo log）中准备好，**一次fsync**；（写 redo-log 到磁盘：/datadit/ib_logfile0）

  - 事务写入到binlog中并刷盘持久化，**一次fsync**；（写binlog到磁盘）

  - 事务在存储引擎内部提交，**一次fsync**（写数据文件到磁盘，可以省略，存储引擎准备好的事务可以通过 binlog 来恢复）

虽然上面说的这些 redo log 的刷盘可以通过  innodb_flush_log_at_trx_commit  ，binlog 刷盘通过 sync_binlog  参数来控制。

但是 binlog 和 redo log 的刷盘还是会成为最大的开销。通过组提交，将多个事务的 binlog，最大化每次刷盘的收益，弱化磁盘瓶颈，提高性能。



### 组提交原理



**组提交（group commit）：**

如果多个事务，能在同一时间内并发提交成功，那么就说明这几个事务是不冲突的，逻辑上可以认为是一组事务，在从库上可以并发 replay。

**基于 Commit_Order 的并行复制是在主数据库实例事务提交时，写入一些额外信息，从而在从机回放时，可以根据这些信息判断是否可以进行并行的回放。**



**同一组提交的事务之间是不冲突的，因此可以并行回放。**



组提交，就好像我们平时渡船时，一般要等到人坐满后，一次性开船。

组提交将事务分为三个阶段(Flush 阶段、Sync 阶段、Commit 阶段)

每个阶段都会维护一个队列。



- Flush阶段：

  - 将 binlog 数据写入文件，当然此时只是写入文件系统的内存缓冲，并不能保证数据库崩溃时 binlog 不丢失。

  - **Flush阶段队列的作用是提供了 Redo log 的组提交**。

  - 如果在这一步完成后数据库崩溃，由于协调者 binlog 中不保证有该组事务的记录，所以 MySQL 可能会在重启后回滚该组事务


- Sync阶段：
  - 

> 
>
> 参考
>
> https://www.cnblogs.com/JiangLe/p/9650728.html







































## InnoDB 磁盘结构



#### 表

创建 InnoDB 表，使用如下语句：

```sql
CREATE TABLE t1 (a INT, b CHAR (20), PRIMARY KEY (a)) ENGINE=InnoDB;
```

如果 InnoDB 是默认存储引擎，也可以不用指定 ENGINE。使用如下语句查询 InnoDB 是否默认存储引擎。

```sql
SELECT @@default_storage_engine;
```



一个 InnoDB 表和索引，可以在 system tablespace, file-per-table tablespace, ogeneral tablespace 中创建。当 innodb_file_per_table 是 enabled 状态，它是默认的，一个 InnoDB 表被显式创建在单独的表空间中，如果是 disabled 状态，会创建在系统表空间，如果要用通用表空间，那么使用  CREATE TABLE ... TABLESPACE  语法来创建表。







## 表空间





### 系统表空间

系统表空间是 change buffer 的存放区域，如果没有启用独立表空间，也会存放业务表的表空间。

系统表空间可以由多个文件组成，默认是一个，名为 ibdata1，默认放在 datadir 目录下面。



由如下参数控制

```shell
# 文件路径，默认是 datadir 下，也可以自定义路径
innodb_data_home_dir=/myibdata/

# 参数语法:文件名:文件初始大小:自增长属性：最大属性（初始大小不低于12M）
innodb_data_file_path=file_name:file_size[:autoextend[:max:max_file_size]]

# 每次自动扩展的增量大小，由innodb_autoextend_increment控制，单位为M，默认是64M
innodb_autoextend_increment=64

# 默认值如下:ibdata1:12M:自增长
innodb_data_file_path=ibdata1:12M:autoextend

# 也可以一次定义两个系统表空间文件
innodb_data_file_path=ibdata1:50M;ibdata2:50M:autoextend
```





也可以手动调整增长 ibdata 文件

```shell
# 先关停数据库

# 如果ibdata设置了自增长属性，删掉它 
```







### 单独表空间



每个表一个单独的表空间，都会













































































