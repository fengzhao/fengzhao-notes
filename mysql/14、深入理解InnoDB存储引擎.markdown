## InnoDB存储引擎概述



InnoDB 是事务安全的 MySQL 存储引擎，设计上采用了类似于Oracle数据库的架构。通常来说，InnoDB 存储引擎时 OLTP 应用中核心表的首选存储引擎。

同样，也正是因为 InnoDB 的存在，才使 MySQL 数据库变得更有魅力。目前 InnoDB 属于 MySQL 默认存储引擎，并且**在MySQL 8.0开始，包括元数据表也都是使用InnoDB存储引擎，**



InnoDB 存储引擎的创始人 Heikki Tuuri，1964年出生于芬兰赫尔辛基，与著名的Linux创始人Linus同时芬兰赫尔辛基大学校友，同时MySQL创始人Monty也是芬兰人，很传奇。

他在 1995 年成立 Innobase Oy 公司并担任CEO。InnoDB 最初就由 Innobase Oy 公司开发，后来被包括在 MySQL 所有的二进制发行版本中，也是 MySQL 5.5.8 开始默认的存储引擎。

该存储引擎是一个支持 ACID 事务，行锁设计，支持 MVCC 功能，提供类似于 Oracle 风格的一致性非锁定读，支持外键，被设计用来最有效地利用内存和CPU。

并且实现了 SQL 标准的 4 种隔离级别，其默认级别是 REPEATABLE READ。并通过一种被称为 netxt-key locking的策略来避免幻读。

MySQL 在 2008 年被 SUN 公司收购，最后 SUN 又被 Oracle 收购，自然 MySQL 也就到了 Oracle 手里。现在 Oracle 拥有 MySQL 数据库及 InnoDB 存储引擎， Oracle 收购 MySQL 后，推出 5.6、5.7、8.0 几个大版本。

做了大量的优化和功能，并且在 8.0 大量重构了 InnoDB 存储引擎，性能大幅度提升。可以说目前能大量重构 InnoDB 存储引擎的人估计也只有 Oracle 官方团队可以了，包括 InnoDB 创始人目前也在 Oracle 公司。

如果不出现 MySQL 被闭源的情况，那么 Oracle 官方MySQL 可以说是前途一片大好。







![InnoDB architecture diagram showing in-memory and on-disk structures. In-memory structures include the buffer pool, adaptive hash index, change buffer, and log buffer. On-disk structures include tablespaces, redo logs, and doublewrite buffer files.](assets/innodb-architecture.png)

<center>InnoDB体系架构</center>







## 内存

### 内存缓冲池（buffer pool）

**InnoDB 存储引擎是基于磁盘存储的，并将其中的记录按照页的方式进管理，因此可以将其视为基于磁盘的数据库系统。**

在数据库系统中，由于 CPU 和磁盘交换速度的差距，基于磁盘的数据库系统通常使用缓冲池技术来提高数据库的整体性能。

内存缓冲池简单说就是 MySQL 进程向操作系统申请一块内存区域，通过内存的速度来弥补磁盘的速度，在数据库中读取页时，首先将磁盘读到的页放到缓冲池中，这个过程称为将页 fix 到缓冲池。

下次再读取相关的页时，下次再读取相同的页时，先判断是否在缓冲池中，若在，则称为该页在缓冲池被命中。

对于修改数据（增删改），同样首先修改缓冲池中的页，然后在以一定的频率刷新到磁盘。**通过一种被称作 checkpoint 的机制刷回磁盘。**



### 关键概念——数据页

在MySQL中，innodb表以 tablename.ibd 格式的文件存放在磁盘中。

数据页是 MySQL 抽象出来的数据单位，磁盘文件中就是存放了很多数据页，每个数据页里存放了很多行数据。**默认情况下，数据页的大小是 16KB。**

对应的，在 `Buffer Pool` 中，也是以数据页为数据单位，存放着很多数据。但是通常被叫做缓存页，因为 `Buffer Pool` 是一个缓冲池，并且里面的数据都是从磁盘文件中缓存到内存中。

所以，默认情况下缓存页的大小也是 16kb，因为它和磁盘文件中数据页是一一对应的。

缓冲池和磁盘之间的数据交换的单位是数据页，包括从磁盘中读取数据到缓冲池和缓冲池中数据刷回磁盘中。



**缓冲池中基本概念**

缓冲池是 MySQL 向操作系统申请的一块内存区域，操作系统是以页为单位对内存进行管理。

缓冲池是 InnoDB 存储引擎中最重要的组件。为了提高 MySQL 的并发性能，使用到的数据都会缓存在缓冲池中，然后所有的增删改查操作都将在缓冲池中执行。

每个更新请求，尽量就是**只更新内存，然后往磁盘顺序写日志文件**。

更新内存的性能是极高的，然后顺序写磁盘上的日志文件的性能也是比较高的，因为顺序写磁盘文件，他的性能要远高于随机读写磁盘文件。



具体来看，缓冲池中的页类型有：

- **数据页**
- **索引页**
- **undo页**
- **插入缓冲**
- **自适应哈希索引**
- **InnoDB存储的锁信息**
- **数据字典信息等。**

**不能简单的认为，缓冲池只是缓冲索引和数据页。它们只是占内存缓冲池很大的一部分而已**



> 在 Linux 中，操作系统以页为单位管理内存，无论是将磁盘中的数据加载到内存中，还是将内存中的数据写回磁盘，操作系统都会以页面为单位进行操作。
>
> 哪怕我们只向磁盘中写入一个字节的数据，我们也需要将整个页面中的全部数据刷入磁盘中。
>
> 在操作系统层面，每个进程都有自己独立的地址空间，看到的都是操作系统虚拟出来的地址空间，虚拟地址最终还是要落在实际内存的物理地址上进行操作的。
>
> 操作系统就会通过页表的机制来实现进程的虚拟地址到物理地址。其中每一页的大小都是固定的。
>
> ```shell
> ####X86：
> [root@ens8 ~]# getconf PAGESIZE
> 4096
> ####ARM：
> root@ens8ARM:~# getconf PAGESIZE
> 65536
> ```
>
> 
>
> Linux 同时支持正常大小的内存页和大内存页（Huge Page）
>
> **绝大多数处理器上的内存页（page）的默认大小都是 4KB**，虽然部分处理器会使用 8KB、16KB 或者 64KB 作为默认的页面大小，但是 4KB 的页面仍然是操作系统默认内存页配置的主流；
>
> [为什么 Linux 默认页大小是 4KB](https://draveness.me/whys-the-design-linux-default-page/) 



innodb_page_size 作为 innodb 和 OS 交互单位。文件系统对文件的 buffer IO，也是 page 为单位进行处理的。

InnoDB 缓冲池中的数据访问是以 Page 为单位的，每个 Page 的大小默认为 16KB，Buffer Pool 是用来管理和缓存这些 Page 的。



#### 内存缓冲池相关参数配置

```shell
# 内存缓冲池总大小，默认是128M，应当适当设置调大buffer_pool_size,一般设置为服务器内存60%。通常实际占用的内存会比配置的还要大10%
# MySQL5.7.5之后可以动态调整。在调整innodb_buffer_pool_size 期间，用户的请求将会阻塞，直到调整完毕，所以请勿在白天调整，在凌晨3-4点低峰期调整。
innodb_buffer_pool_size=8G 
# 内存缓冲池实例数，默认是1，通过将buffer pool 分成多个区，每个区用独立的锁保护，这样就减少了访问buffer_pool时需要上锁的粒度，以提高并发能力和性能。
# 
innodb_buffer_pool_instances=16
# innodb页大小，默认是16KB，一般设置为16KB或64KB
innodb_page_size=16KB
# 在调整内存缓冲池总大小时，内部把数据页移动到一个新的位置，单位是块。如果想增加移动的速度，需要调整innodb_buffer_pool_chunk_size参数的大小，默认是128M。
# 缓冲池配置时的基本单位，以块的形式配置，指明块大小。
# innodb_buffer_pool_size=innodb_buffer_pool_chunk_size * innodb_buffer_pool_instances * n 
innodb_buffer_pool_chunk_size=128MB

```





### 什么是 LRU 算法

LRU 就是一种很常见的缓存淘汰策略。按照英文的直接原义就是 Least Recently Used，最近最久未使用。

**利用好 LRU 算法，我们能够提高对热点数据的缓存效率，进而提升缓存服务的内存使用率。**



一般计算机内存容量有限，操作系统分配给 MySQL 的内存缓存池容量自然也有限，如果缓存池满了就要删除一些内容，给新内容腾位置。

但问题是，删除哪些内容呢？我们肯定希望删掉哪些没什么用的缓存，而把有用的数据继续留在缓存里，方便之后继续使用。

那么，什么样的数据，我们判定为「有用的」的数据呢？

LRU 缓存淘汰算法就是一种常用策略。LRU 的全称是 Least Recently Used，也就是说我们认为最近使用过的数据应该是是「有用的」，很久都没用过的数据应该是无用的，内存满了就优先删那些很久没用过的数据。

它是按照一个非常著名的计算机操作系统基础理论得来的：**最近使用的页面数据会在未来一段时期内仍然被使用,已经很久没有使用的页面很有可能在未来较长的一段时间内仍然不会被使用**。

基于这个思想，会存在一种缓存淘汰机制，每次从内存中找到**最久未使用的数据然后置换出来**，从而存入新的数据！



LRU 的主要衡量指标是**使用的时间**。附加指标是**使用的次数**。

在计算机中大量使用了这个机制，它的合理性在于**优先筛选热点数据**，所谓热点数据，就是**最近最多使用的数据**！



### LRU List

通常，数据库中的缓冲池是通过 LRU (Latest Recent Used) 算法来管理的，即最频繁使用的页在 LRU 最前端。

但是 MySQL InnoDB 对传统的 LRU 算法做了一些优化。

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



```shell
# INFORMATION_SCHEMA中有几个缓冲池表提供有关InnoDB缓冲池中页面的缓冲池状态信息和元数据。

############ 查询INNODB_BUFFER_PAGE表可能会影响性能。 除非您了解性能影响并确定其可接受，否则请勿在生产系统上查询此表。 为避免影响生产系统的性能，请重现要调查的问题并在测试实例上查询缓冲池统计信息。

mysql> SHOW TABLES FROM INFORMATION_SCHEMA LIKE 'INNODB_BUFFER%';
+-----------------------------------------------+
| Tables_in_INFORMATION_SCHEMA (INNODB_BUFFER%) |
+-----------------------------------------------+
| INNODB_BUFFER_PAGE_LRU                        |
| INNODB_BUFFER_PAGE                            |
| INNODB_BUFFER_POOL_STATS                      |
+-----------------------------------------------+

# INNODB_BUFFER_PAGE：保存InnoDB缓冲池中每个页面的信息。

# INNODB_BUFFER_PAGE_LRU：保存有关InnoDB缓冲池中页面的信息，特别是它们在LRU列表中的排序方式，确定哪些页面在缓冲池变满时从缓冲池中逐出。 INNODB_BUFFER_PAGE_LRU表与INNODB_BUFFER_PAGE表具有相同的列。
# 但INNODB_BUFFER_PAGE_LRU表具有LRU_POSITION列而不是BLOCK_ID列。
# INNODB_BUFFER_POOL_STATS：提供缓冲池状态信息。许多相同的信息由SHOW ENGINE INNODB STATUS输出提供，或者可以使用InnoDB缓冲池服务器状态变量获得。
```







### 缓冲池预热



**缓冲池中的数据**

具体来看，缓冲池中的页类型有：数据页，索引页，undo页，插入缓冲，自适应哈希索引，InnoDB存储的锁信息，数据字典信息等。

不能简单的认为，缓冲池只是缓冲索引和数据页。



在生产中，重启 MySQL 后，会发现一段时间内 SQL 性能变差，然后最终恢复到原有性能。

这是因为 MySQL 已经经常操作的热点数据都已经缓存到 InnoDB Buffer Pool 中。

重启后。需要将热点数据从磁盘中逐渐缓存到 InnoDB Buffer Pool 中，从磁盘读取数据自然没有从内存读取数据快。

**MySQL 重启后，将热点数据从磁盘逐渐缓存到 InnoDB Buffer Pool 的过程称为预热（warmup）。**

让应用系统自身慢慢通过SQL给 InnoDB Buffer Pool 预热成本很高，如果遇到高峰期极有可能带来一场性能灾难，业务卡顿不能顺利运营。



为了避免这种情况发生，MySQL 5.6 引入了数据预热机制：

- innodb_buffer_pool_dump_at_shutdown 
-  innodb_buffer_pool_load_at_startup 

这两个参数控制了预热，不过默认都是关闭的，需要开启。MySQL 5.7 则是默认开启。



```shell
# 
SET GLOBAL innodb_buffer_pool_dump_now=ON;
```





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



在 MySQL 里，如果每一次的更新操作都需要写进磁盘持久化，然后磁盘也要找到对应的那条记录，然后再更新，整个过程IO成本、查找成本都很高。

**所以有一种技术叫 WAL ，全称是 Write-Ahead Logging，它的关键点就是先写日志，再写磁盘。（日志先行）**

具体来说，当有一条记录需要更新的时候，InnoDB 引擎就会先把记录写到 redo log （磁盘中的物理文件）里面，并更新内存，这个时候更新就算完成了。

（严格说还没有 commit 成功，客户端还看不到返回成功）

**由于 redo-log 是顺序写的，所以速度比较快。redo-log 是物理日志，记录的是 “在某个数据页上做了什么修改”。**

**redo-log 是循环写的，当 redo-log 写完后，就要刷盘。把数据刷到磁盘中。（更严格地说，何时刷盘应该还是有参数控制的。）**



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


# https://blog.csdn.net/u010647035/article/details/104733939
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

热备的原理都是要备份 redolog，由于redolog 是循环写的。

**如果备份期间还是有大量的事务写入，备份速度跟不上redo log生成的速度，结果导致redo log被覆盖了，然后备份就无法保证一致性**。

就会导致备份失败。

在 MySQL 8.017 中引入了 redolog 归档功能。即写 redolog 的时候，



想要启用 redo log 归档功能，只需设置 **innodb_redo_log_archive_dirs** 选项即可，该选项可支持在线动态修改，例如：



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

InnoDB 一般都是默认存储引擎，也可以不用指定 ENGINE。使用如下语句查询 InnoDB 是否默认存储引擎。

```sql
SELECT @@default_storage_engine;
```



一个 InnoDB 表和索引，可以在 system tablespace, file-per-table tablespace, ogeneral tablespace 中创建。

默认地，InnoDB 的表都是**独立表空间**。

当 innodb_file_per_table 是 enabled 状态，它是默认的，一个 InnoDB 表被显式创建在单独的表空间中。

如果是 disabled 状态，会创建在系统表空间，如果要用通用表空间，那么使用  CREATE TABLE ... TABLESPACE  语法来创建表。



#### 主键

强烈建议为每个 innodb 表设立主键。



#### 创建外部表

有时候，可能需要创建外部表（即在 datadir 外部创建表），可能是由于空间管理，IO优化等原因。

InnoDB 支持外部表的语法：

```sql
-- 第一种情况，使用 DATA DIRECTORY 子句
CREATE TABLE t1 (c1 INT PRIMARY KEY) DATA DIRECTORY = '/external/directory';



```





#### 导入 InnoDB 表



**表空间传输特性**

- 复制数据到新实例。
- 从备份表空间中恢复数据
- 比 dump 表更快的方式（dump需要重新插入数据和重建索引）



前提：

- ` innodb_file_per_table` 变量必须开启，默认就是开启的。
- innodb_page_size 必须相等。
- 如果一个表有外键关系，在执行 `DISCARD TABLESPACE` 语句之前必须先关掉

https://blog.k4nz.com/7bbf69045e0da119a1a892e054c6d145/



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













对于 











# MySQL 线程池

https://dev.mysql.com/doc/refman/8.0/en/thread-pool.html



MySQL默认的连接控制方式采用的是每个连接使用一个线程执行客户端的请求。MySQL的线程池是包含在企业版里面的服务器插件。

使用线程池的目的是为了改善大量并发连接所带来的性能下降。

在大量并发连接的工作负载下，使用线程池可以解决无法利用CPU缓存、上下文切换开销过大以及资源争用等问题。















# MySQL逻辑架构





MySQL逻辑架构整体分为三层：

- 最上层为客户端层，并非MySQL所独有，诸如：连接处理、授权认证、安全等功能均在这一层处理。
- MySQL大多数核心服务均在中间这一层，包括查询解析、分析、优化、缓存、内置函数(比如：时间、数学、加密等函数)。所有的跨存储引擎的功能也在这一层实现：存储过程、触发器、视图等。
- 最下层为存储引擎，其负责MySQL中的数据存储和提取。和Linux下的文件系统类似，每种存储引擎都有其优势和劣势。中间的服务层通过API与存储引擎通信，这些API接口屏蔽了不同存储引擎间的差异。



每一个客户端发起一个新的请求都由服务器端的连接/线程处理工具负责接收客户端的请求并开辟一个新的内存空间，在服务器端的内存中生成一个新的线程。

当每一个用户连接到服务器端的时候就会在进程地址空间里生成一个新的线程用于响应客户端请求，用户发起的查询请求都在线程空间内运行， 结果也在这里面缓存并返回给服务器端。

线程的重用和销毁都是由连接/线程处理管理器实现的。


综上所述：用户发起请求，连接/线程处理器开辟内存空间，开始提供查询的机制。



用户总是希望MySQL能够获得更高的查询性能，最好的办法是弄清楚MySQL是如何优化和执行查询的。

一旦理解了这一点，就会发现：很多的查询优化工作实际上就是遵循一些原则让MySQL的优化器能够按照预想的合理方式运行而已。



### **客户端/服务端通信协议**

MySQL客户端/服务端**通信协议是“半双工”的：在任一时刻，要么是服务器向客户端发送数据，要么是客户端向服务器发送数据，这两个动作不能同时发生。**

一旦一端开始发送消息，另一端要接收完整个消息才能响应它，所以我们无法也无须将一个消息切成小块独立发送，也没有办法进行流量控制。



客户端用一个单独的数据包将查询请求发送给服务器，所以**当查询语句很长的时候，需要设置max_allowed_packet参数。**

但是需要注意的是，如果查询实在是太大，服务端会拒绝接收更多数据并抛出异常。



与之相反的是，服务器响应给用户的数据通常会很多，由多个数据包组成。

但是当服务器响应客户端请求时，客户端必须完整的接收整个返回结果，而不能简单的只取前面几条结果，然后让服务器停止发送。

因而在实际开发中，**尽量保持查询简单且只返回必需的数据，减小通信间数据包的大小和数量是一个非常好的习惯**。

**这也是查询中尽量避免使用SELECT *以及加上LIMIT限制的原因之一。**



### **查询缓存**

MySQL 的查询，主要处理过程都是从硬盘中读取数据加载到内存，然后通过网络发给客户端，

MySQL 之前有一个查询缓存 Query Cache，从 MySQL8.0 开始，不再使用这个查询缓存，随着技术的进步，经过时间的考验，MySQL的工程团队发现启用缓存的好处并不多。所以在 8.0 中移除了这个特性。



在解析一个查询语句前，如果查询缓存是打开的，那么MySQL会检查这个查询语句是否命中查询缓存中的数据。如果当前查询恰好命中查询缓存，在检查一次用户权限后直接返回缓存中的结果。

这种情况下，查询不会被解析，也不会生成执行计划，更不会执行。

MySQL将缓存存放在一个引用表（不要理解成table，可以认为是类似于HashMap的数据结构），通过一个哈希值索引，这个哈希值通过查询本身、当前要查询的数据库、客户端协议版本号等一些可能影响结果的信息计算得来。

所以两个查询在任何字符上的不同（例如：空格、注释），都会导致缓存不会命中。

如果查询中包含任何用户自定义函数、存储函数、用户变量、临时表、mysql库中的系统表，其查询结果都不会被缓存。

比如函数 NOW() 或者 CURRENT_DATE() 会因为不同的查询时间，返回不同的查询结果。

再比如包含 CURRENT_USER 或者 CONNECION_ID() 的查询语句会因为不同的用户而返回不同的结果，将这样的查询结果缓存起来没有任何的意义。

既然是缓存，就会失效，那查询缓存何时失效呢？MySQL的查询缓存系统会跟踪查询中涉及的每个表，如果这些表（数据或结构）发生变化，那么和这张表相关的所有缓存数据都将失效。

正因为如此，在任何的写操作时，MySQL必须将对应表的所有缓存都设置为失效。如果查询缓存非常大或者碎片很多，这个操作就可能带来很大的系统消耗，甚至导致系统僵死一会儿。

而且查询缓存对系统的额外消耗也不仅仅在写操作，读操作也不例外：

　　1. 任何的查询语句在开始之前都必须经过检查，即使这条SQL语句永远不会命中缓存
　　2. 如果查询结果可以被缓存，那么执行完成后，会将结果存入缓存，也会带来额外的系统消耗



首先，查询缓存的效果取决于缓存的命中率，只有命中缓存的查询效果才能有改善，因此无法预测其性能

其次，查询缓存的另一个大问题是它受到单个互斥锁的保护。在具有多个内核的服务器上，大量查询会导致大量的互斥锁争用。

通过基准测试发现，大多数工作负载最好禁用查询缓存（5.6的默认设置）：query_cache_type = 0

如果你认为会从查询缓存中获得好处，请按照实际情况进行测试。

- 数据写的越多，好处越少
- 缓冲池中容纳的数据越多，好处越少
- 查询越复杂，扫描范围越大，则越受益



最后的忠告是不要轻易打开查询缓存，特别是写密集型应用。

如果你实在是忍不住，可以将query_cache_type设置为DEMAND，这时只有加入SQL_CACHE的查询才会走缓存，其他查询则不会，这样可以非常自由地控制哪些查询需要被缓存。



### **语法解析和预处理**



MySQL通过关键字将SQL语句进行解析，并生成一颗对应的解析树。这个过程解析器主要通过语法规则来验证和解析。

比如SQL中是否使用了错误的关键字或者关键字的顺序是否正确等等。预处理则会根据MySQL规则进一步检查解析树是否合法。比如检查要查询的数据表和数据列是否存在等等。



### 查询优化

经过前面的步骤生成的语法树被认为是合法的了，并且由优化器将其转化成查询计划。



多数情况下，一条查询可以有很多种执行方式，最后都返回相应的结果。优化器的作用就是找到这其中最好的执行计划。

MySQL采用了基于开销的优化器，以确定处理查询的最解方式，也就是说执行查询之前，都会先选择一条自以为最优的方案，然后执行这个方案来获取结果。

在很多情况下，MySQL能够计算最佳的可能查询计划，但在某些情况下，MySQL没有关于数据的足够信息，或者是提供太多的相关数据信息，估测就不那么友好了。



**对于一些执行起来十分耗费性能的语句，MySQL 还是依据一些规则，竭尽全力的把这个很糟糕的语句转换成某种可以比较高效执行的形式，这个过程也可以被称作查询重写**。



MySQL 使用基于成本的优化器，**它尝试预测一个查询使用某种执行计划时的成本，并选择其中成本最小的一个。**

在 MySQL 可以通过查询当前会话的 last_query_cost 的值来得到其计算当前查询的成本。

```shell
mysql> select * from t_message limit 10;
...省略结果集

mysql> show status like 'last_query_cost';
+-----------------+-------------+
| Variable_name   | Value       |
+-----------------+-------------+
| Last_query_cost | 6391.799000 |
+-----------------+-------------+
————————————————
```

示例中的结果表示优化器认为大概需要做 6391 个数据页的随机查找才能完成上面的查询。

这个结果是根据一些列的统计信息计算得来的，这些统计信息包括：每张表或者索引的页面个数、索引的基数、索引和数据行的长度、索引的分布情况等等。

有非常多的原因会导致 MySQL 选择错误的执行计划，比如统计信息不准确、不会考虑不受其控制的操作成本（用户自定义函数、存储过程）。

**MySQL认为的最优跟我们想的不一样（我们希望执行时间尽可能短，但 MySQL 选择它认为成本小的，但成本小并不意味着执行时间短）等等。**



#### 优化器的功能

1. 不改变语义的情况下，重写sql。重写后的 sql 更简单，更方便制定执行计划。
2. 根据成本分析，制定执行计划。

####  条件化简

我们编写的查询语句的 where 搜索条件本质上是一个表达式，这些表达式可能比较繁杂，或者不能高效的执行，MySQL 的查询优化器会为我们简化这些表达式。



**移除不必要的括号**

有时候表达式里有许多无用的括号，比如这样一条 sql 条件：

```shell
((a = 5 AND b = c) OR ((a > c) AND (c < 5)))

# 优化器就会对其进行优化成下面这样

(a = 5 and b = c) OR (a > c AND c < 5)
```



**常量传递**

```shell
a = 5 AND b > a
```



**子查询优化**

我们查询中的 select 列 from 表 中，有时候，列和表可能是我们其他查询中出来的。这种列和表是用 select 语句表现出来的就叫子查询。外层 select 就叫外层查询。

- SELECT 子句

```sql
SELECT (SELECT m1 FROM e1 LIMIT 1);
```

- FROM 子句

```sql
-- 子查询后边的 AS t 表明这个子 查询的结果就相当于一个名称为 t 的表，这个名叫 t 的表的列就是子查询结果中的列（m和n）。
-- 这个放在 FROM 子句中的子查询本质上相当于一个表，但又和我们平常使用的表有点儿不一样，MySQL 把这种由子查询结果集组成的表称之为派生表。
SELECT m, n FROM (SELECT m2 + 1 AS m, n2 AS n FROM e2 WHERE m2 > 2) AS t;
```

- WHERE 或 ON 子句

```sql
-- 最常见的查询：整个查询语句的意思就是我们想找 e1 表中的某些记录，这 些记录的 m1 列的值能在 e2 表的 m2 列找到匹配的值。
SELECT * FROM e1 WHERE m1 IN (SELECT m2 FROM e2);
```

**子查询分类**

- 标量子查询 （一行一列）

```sql
-- 那些只返回一个单一值的子查询称之为标量子查询：子查询里面的查询结果只返回一行一列一个值的情况。
SELECT (SELECT m1 FROM e1 LIMIT 1);
SELECT * FROM e1 WHERE m1 = (SELECT MIN(m2) FROM e2);
SELECT * FROM e1 WHERE m1 < (SELECT MIN(m2) FROM e2);

```

- 行子查询（一行多列）

```sql
-- 顾名思义，就是返回一条记录的子查询，不过这条记录需要包含多个列（只包含一个列就成了标量子查询了）。
-- 其中的(SELECT m2, n2 FROM e2 LIMIT 1)就是一个行子查询
-- 整条语句的含义就是要从 e1 表中找一些记录，这些记录的 m1 和 n1 列分别等于子查询结果中的 m2 和 n2 列
SELECT * FROM e1 WHERE (m1, n1) = (SELECT m2, n2 FROM e2 LIMIT 1);
```

- 列子查询

```sql
-- 列子查询自然就是查询出一个列的数据，不过这个列的数据需要包含多条记录
-- 其中的(SELECT m2 FROM e2)就是一个列子查询，表明查询出 e2 表的 m2 列 的所有值作为外层查询 IN 语句的参数。
SELECT * FROM e1 WHERE m1 IN (SELECT m2 FROM e2);
```

- 表子查询（二维多行多列）

```sql
-- 顾名思义，就是子查询的结果既包含很多条记录，又包含很多个列
-- 其中的(SELECT m2, n2 FROM e2)就是一个表子查询、此sql必须要在m1，n1都满足的条件下方可成立
SELECT * FROM e1 WHERE (m1, n1) IN (SELECT m2, n2 FROM e2);
```



#### 子查询在 MySQL 中是怎么执行的

常规想象思维中子查询的执行方式（非实际）

```sql
-- 不相关子查询
SELECT * FROM s1 WHERE order_note IN (SELECT order_note FROM s2 WHERE order_no = 'a');

-- 我们想象中的可能是把子查询里面的这个结果集查出来放到内存中，然后做为外层查询的条件进行查询。可能会导致两个问题：
-- 1.子查询的结果集太多，可能内存中都放不下。
-- 2.对于外层查询来说，如果子查询的结果集太多，那就意味着 IN 子句中的参数特别多，由于order_note不是索引列，每个IN语句的条件都会全表扫描进行遍历。

-- 结果集过多的处理方案
-- IN子句中的结果集可能存在着大量的重复字段。这些字段对于获取最后的查询结果而言，都是浪费资源的无用功，因此，结果集过多的第一个处理方案，就是思考去重。
-- 如果结果集中确实过大，导致即使结果去重后，内存存放仍然有压力，因此转存到磁盘当中。

-- order_note不是索引，你怎么滴还能让他不进行全表扫描不成？当然，直接加索引是不成的。但是我们可以通过物化表的方式对sql进行改造，由优化器再次判断是否使用全表扫描。
-- 当IN的结果集过大时，我们会将IN子句升级为物化表。升级流程如下：

-- 1.该临时表的列就是子查询结果集中的列。
-- 2.写入临时表的记录会被去重，临时表也是个表，只要为表中记录的所有列建立主键或者唯一索引。

-- 物化表是基于磁盘的么？不，这个表在不是特别大的时候是基于内存的。
-- 一般情况下子查询结果集不会大的离谱，所以会为它建立基于内存的使用 Memory 存储引擎的临时表，而且会为该表建立哈希索引。
-- 如果子查询的结果集非常大，超过了系统变量 tmp_table_size 或者 max_heap_table_size，临时表会转而使用基于磁盘的存储引擎来保存结果集中的记录，索引类型也对应转变为 B+树索引。
-- 当我们把子查询进行物化之后，假设子查询物化表的名称为 materialized_table，该物化表存储的子查询结果集的列为 m_val，那么这个查询就相当于表 s1 和子查询物化表 materialized_table 进行内连接。
SELECT s1.* FROM s1 INNER JOIN materialized_table ON order_note = m_val




-- 驱动表算法


```

