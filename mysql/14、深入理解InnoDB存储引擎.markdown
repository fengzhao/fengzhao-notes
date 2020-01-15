## 内存

### 缓冲池

InnoDB 存储引擎是基于磁盘存储的，并将其中的记录按照页的方式进管理，因此可以将其视为基于磁盘的数据库系统。在数据库系统中，由于 CPU 和磁盘交换速度的差距，基于磁盘的数据库系统通常使用缓冲池技术来提高数据库的整体性能。

缓冲池简单说就是一块内存区域，通过内存的速度来弥补磁盘的速度，在数据库中读取页时，首先将磁盘读到的页放到缓冲池中，这个过程称为将页 fix 到缓冲池，下次再读取相关的页时，下次再读取相同的页时，先判断是否在缓冲池中，若在，则称为该页在缓冲池被命中。

对于修改数据，同样首先修改缓冲池中的页，然后在以一定的频率刷新到磁盘。通过一种 checkpoint 的机制刷回磁盘。







### LRU List

通常，数据库中的缓冲池是通过 LRU (Latest Recent Used) 算法来管理的，即最频繁使用的页在 LRU 最前端。

在 buffer pool 中的的数据页可以认为是一个 LIST 列表，分为两个子列表 （New Sublist） （ Old Sublist）

```shell
# 这个参数控制着 New Sublist 和 Old Sublist 的比例
innodb_old_blocks_pct=37
```



可以简单理解为 New Sublist 中的页都是最活跃的热点数据页。

当





![](../resources/InnoDB-buffer-pool.png)

MySQL默认在InnoDB缓冲池（而不是整个缓冲池）中仅保留最频繁访问页的25%  。

在多数使用场景下，合理的选择是：保留最有用的数据页，比加载所有的页(很多页可能在后续的工作中并没有访问到)在缓冲池中要更快。



### **缓冲池相关参数**

```shell
# 缓冲池实例数量，默认为1，不可以动态调整
innodb_buffer_pool_instances=1
# 缓冲池总大小，默认是128MB，一般设置为物理内存的70%左右。MySQL5.7.5之后可以动态调整，繁忙时不要动态调整。
innodb_buffer_pool_size=134217728
# 缓冲池配置时的基本单位，以块的形式配置，指明块大小，innodb_buffer_pool_size=innodb_buffer_pool_chunk_size * innodb_buffer_pool_instances * n 
innodb_buffer_pool_chunk_size=128M # 默认内存块是128M，可以以1MB为单位(1048576 字节)增加或减少


```

### 缓冲池预热



**缓冲池中的数据**

具体来看，缓冲池中的页类型有：数据页，索引页，undo页，插入缓冲，自适应哈希索引，InnoDB存储的锁信息，数据字典信息等。不能简单的认为，缓冲池只是缓冲索引和数据页。



## 刷脏

**脏页**

当事务提交后，数据刷到磁盘之前，此时内存中的数据页和磁盘中的数据是不一致的，我们把此时内存中的这些数据页成为脏页。

**刷脏**





### 多线程刷脏

- 5.6版本以前，脏页的清理工作交由 master thread的；

- Page cleaner thread是 5.6.2 引入的一个新线程（单线程），从master线程中卸下buffer pool刷脏页的工作独立出来的线程(默认是启一个线程)；

- 5.7开始支持多线程刷脏页；



## 两阶段提交

redo-log 和 binlog 是 两阶段提交的重点，

- 当未开启 binlog 时，InnoDB 通过 redo 和 undo 日志来恢复数据库 (safe crash recovery)：

  当**数据恢复（指事务已经提交成功，但是数据还没有刷回磁盘时重启的这种情况）**时：

  - 所有已经在存储引擎内部提交的事务应用 redo log 恢复。
  - 所有已经 prepared 但是没有 commit 的事务则会通过 undo log 做回滚

- 开启 binlog 时，两阶段的流程：
  - InnoDB 的事务 Prepare 阶段，即 SQL 已经成功执行并生成 redo 和 undo 的内存日志；
  - binlog 提交，通过 write() 将 binlog 内存日志数据写入文件系统缓存；
  - sync() 将 binlog 文件系统缓存日志数据永久写入磁盘；（这一步就可以给客户端返回事务提交成功）
  - InnoDB 内部提交，commit 阶段在存储引擎内提交，通过 innodb_flush_log_at_trx_commit 参数控制，使 undo 和 redo 永久写入磁盘。
  
  



**Prepare阶段：写 redo-log , 此时redo log处于prepare状态。注意这里可能只是写  innodb_log_buffer （这是内存中的重做日志缓冲区）**

**Commit阶段：innodb释放锁，释放回滚段，设置提交状态，binlog持久化到磁盘，然后存储引擎层提交**

![](../resources/prepare.png)





![](../resources/commit.png)



## 组提交

### 背景

- 操作系统使用 **缓存** 来填补内存和磁盘访问的差距，对磁盘文件的写入会先写入道页面缓存中。

- 在一些 GNU/Linux 和 UNIX 中，使用  Unix fsync()  系统调用来把数据刷到磁盘（InnoDB默认使用 *fsyn*c 这个）

- 数据库在事务提交过程中调用 fsync 将数据持久化到磁盘，才满足**ACID**中的**D（持久化）**

- fsync是昂贵的操作，对于普通磁盘，每秒能完成几百次fsync

- MySQL 中使用了两阶段提交协议，为了满足D(持久化) ，一次事务提交最多会导致**3次fsync**

  - 提交的事务在存储引擎内部（redo log）中准备好，**一次fsync**；（写 redo-log 到磁盘）

  - 事务写入到binlog中并刷盘持久化，**一次fsync**；（写binlog到磁盘）

  - 事务在存储引擎内部提交，**一次fsync**（写数据文件到磁盘，可以省略，存储引擎准备好的事务可以通过binlog来恢复）

虽然上面说的这些 redo log 的刷盘可以通过  innodb_flush_log_at_trx_commit  ，binlog 刷盘通过 sync_binlog  参数来控制。

但是 binlog 和 redo log 的刷盘还是会成为最大的开销。通过组提交，将多个事务的 binlog，最大化每次刷盘的收益，弱化磁盘瓶颈，提高性能。



### 组提交原理

组提交，就好像我们平时渡船时，一般要等到人坐满后，一次性开船。

组提交将事务分为三个阶段(Flush 阶段、Sync 阶段、Commit 阶段)

每个阶段都会维护一个队列。



- Flush阶段：

  - 将 binlog 数据写入文件，当然此时只是写入文件系统的内存缓冲，并不能保证数据库崩溃时binlog不丢失。

  - **Flush阶段队列的作用是提供了 Redo log 的组提交**

  - 如果在这一步完成后数据库崩溃，由于协调者 binlog 中不保证有该组事务的记录，所以 MySQL 可能会在重启后回滚该组事务


- Sync阶段：
  - 











































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





































































