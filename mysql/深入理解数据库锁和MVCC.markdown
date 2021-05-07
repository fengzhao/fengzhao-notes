# 数据库事务



> 数据库事务(Database Transaction)，一般是指要做的或所做的事情。在计算机术语中是指访问并可能更新数据库中各种数据项的一个程序执行单元(unit)。





一个数据库事务通常包含对数据库进行读或写的一个操作序列。它的存在有以下两个目的：

- 为数据库操作序列提供了一个从失败中恢复到正常状态的方法，同时提供了数据库即使在异常状态下仍能保持一致性的方法。
  - 







# 数据库隔离级别



### 并发控制









# 数据库锁

在 DBMS 中，当并发事务同时访问一个资源时，有可能导致在不同事务内部看到的数据不一致。

因此需要一种机制来将数据访问顺序化，以保证数据库数据的一致性。锁就是其中的一种机制。

可以简单理解为当某个事务在操作开始时，锁定某一个资源对象（比如某个表，比如某一行），在这个事务操作结束之前，不允许其他事务操作这个对象。





## 读锁写锁

读锁是共享的，是互相不阻塞的，多个数据库事务在同一时间读取同一资源，互不干扰。（读与读之间不互斥）

写锁是排他的，会阻塞其他的写锁和读锁，写锁有更高的优先级。（即我在写资源的时候，其他用户无法读写）



**一种提高共享资源并发性的方式就是让锁定对象更有选择性。尽量只锁定需要修改的部分数据，而不是所有的资源，锁定的资源越少，系统的并发性更好。**









## 锁的粒度

根据锁定对象的粒度，我们可以分为：

- 全局锁（整个实例）

- 表锁（table lock）（被锁定的资源的粒度是表）

- 行锁 （row lock）（被锁定资源的粒度是行）

  ```sql
  -- InnoDB 行级锁是通过给索引上的索引项加锁来实现的，InnoDB行级锁只有通过索引条件检索数据，才使用行级锁;
  -- 否则，InnoDB使用表锁，在不通过索引(主键)条件查询的时候，InnoDB是表锁而不是行锁。
  
  -- 如果没有使用索引或索引失效，行锁就会变成表锁
  SELECT c1 FROM t WHERE c1 = 10 FOR UPDATE;
  ```

  https://www.jianshu.com/p/1f4940c134b3



## 读锁写锁（共享锁/排他锁）

读锁写锁也被称为共享锁和排他锁

**InnoDB实现了 行级别的共享锁和排他锁。**

- **读锁是共享的，是互相不阻塞的，多个客户在同一时间读取同一资源，互不干扰。（即我在读资源的时候，其他人只能读不能写）**
- **写锁是排他的，会阻塞其他的写锁和读锁，写锁有更高的优先级。（即我在写资源的时候，其他用户无法读写）**
- 允许不同事务之间共享加锁读取，但不允许其它事务修改或者加入排他锁。





**隐式加锁**：InnoDB，在执行事务过程中会自动加锁，当事务 COMMIT 完成或 ROLLBACK 时锁会自动释放。

**显式加锁**：

```sql
-- 全局加锁，对整个数据库实例加锁
-- 整个库处于只读状态的时候，可以使用这个命令，之后其他线程的以下语句会被阻塞：
-- 数据更新语句（数据的增删改）、数据定义语句（包括建表、修改表结构等）和更新类事务的提交语句。DDL和DML都会被阻塞
Flush tables with read lock ;

-- 全局锁的使用场景：一般可以


-- 对某个对象（一般是行锁）显式加读锁，如果这行对某些行加锁的时候，其他事务还在写入，那么这行select会一直等到其他事务提交才会读到最新的数据。
SELECT ... FOR SHARE
-- 等价于 SELECT...LOCK IN SHARE MODE，后面这种写法可以兼容老版本，for share这种写法可以支持更多特性。
-- 在 MySQL8.0.22之前， SELECT ... FOR SHARE需要select权限外，还需要 DELETE, LOCK TABLES, or UPDATE 三个之一
-- 在 MySQL8.0.22， SELECT ... FOR SHARE只需要select权限

-- 显式加写锁 
SELECT...FOR UPDATE 

-- 显示加读锁或写锁
-- 如果在某个线程A中执行lock tables t1 read, t2 write; 这个语句，
-- 那么其他线程写t1、读写t2的语句都会被阻塞。同时，线程A在执行unlock tables之前，也只能执行读t1、读写t2的操作。连写t1都不允许，自然也不能访问其他表。
lock tables … read/write
-- 释放锁 unlock tables


```



### 读锁

```sql
-- 注意：这里都是显示开启事务，故意执行事务不提交。
-- session1
start transaction;
select * from test where id = 1 lock in share mode;
-- 在session1线程里面，它自己也无法获得写锁
update emp set ename = 'ALLEN1111' where ename='ALLEN' ;

-- session2
start transaction;
select * from test where id = 1 lock in share mode;

-- 此时 session1 和 session2 都可以正常获取结果，那么再加入 session3 排他锁读取尝试

-- session3:
start transaction;
-- session3的SQL可以换成任意的写语句（update,insert,delete,alter效果都是一样）
select * from test where id = 1 for update; 
-- Lock wait timeout exceeded; try restarting transaction -- 在 session3 中则无法获取数据，直到超时或其它事物 commit



-- 通过 information_schema.INNODB_TRX 表里的 trx_mysql_thread_id 可以找到锁表的线程ID
-- 再回 information_schema.`PROCESSLIST` 表里面去查，就可以找到相应的连接。
SELECT * FROM information_schema.INNODB_TRX

```





### 写锁

当一个事务加入排他锁后，不允许其他事务加共享锁或者排它锁读取，更加不允许其他事务修改加锁的行。

```sql

-- session1:
-- session对资源添加写锁
start transaction;
select * from test where id = 1 for update;

-- session2(session2对test的增删改查任何访问都会被阻塞)
-- 如果session1的事务一直不提交或回滚，那么session2超时
start transaction;
select * from test where id = 1 for update;

```



### **意向锁**

MySQL支持多种粒度的锁（表锁，行锁）。它允许`行级锁`与`表级锁`共存，而 **意向锁** 其实就是其中的一种`表锁`。

```sql
-- 表级别的锁

-- 用读锁锁表，会阻塞其他事务修改表数据。
LOCK TABLE my_tabl_name READ; 
-- 用写锁锁表，会阻塞其他事务读和写。
LOCK TABLE my_table_name WRITe; 


-- 行级别的锁（查询走索引）
-- 读锁
SELECT ... FOR SHARE
-- 写锁
SELECT ... FOR UPDATE


-- 考虑这样的一个例子：

-- 事务A锁住了表中的一行，让这一行只能读，不能写。（对某行加读锁）

-- 事务B申请整个表的写锁。（如果事务B申请成功，那么理论上它就能修改表中的任意一行，这与A持有的行锁是冲突的。）

-- 数据库需要避免这种冲突，就是说要让B的申请被阻塞，直到A释放了行锁。

-- 数据库要怎么判断这个冲突呢？（即B事务准备对全表加写锁之前的检测）

-- step1：判断表是否已被其他事务用表锁锁表。
-- step2：判断表中的每一行是否已被行锁锁住。（由于这样的效率很低，需要遍历整个表。）

-- 于是意向锁出现了，在意向锁存在的情况下，事务A必须先申请表的意向共享锁，成功后再申请一行的行锁。

-- 在意向锁存在的情况下，上面的判断可以改成

-- step1：不变
-- step2：发现表上有意向共享锁，说明表中有些行被共享行锁锁住了，因此，事务B申请表的写锁会被阻塞。

-- 注意：申请意向锁的动作是数据库完成的，就是说，事务A申请一行的行锁的时候，数据库会自动先开始申请表的意向锁，不需要我们使用代码来申请。

-- 所以准确来讲，SELECT ... FOR SHARE 持有的是 IS lock（意向读锁）  
-- 所以准确来向，SELECT ... FOR UPDATE 持有的是 IX lock（意向写锁） 

```





## MDL锁



https://help.aliyun.com/document_detail/94566.html

在MySQL使用过程中，不免有对表进行更改的`DDL`操作(alter/drop table)。

有的时候我们会发现，一条简单的对表增加字段的操作，会执行很长时间，甚至导致整个数据库挂掉。



在出现问题时查看 show processlist 的时候，可以看到简单的所谓的`Waiting for table metadata lock`之类的状态，有些情况很难排查。

其实 MDL Lock 是 MySQL 上层一个非常复杂的子系统，有自己的死锁检测机制。



**引子**



考虑如下两个session: 

|      session1      |    session2    |
| :----------------: | :------------: |
|       BEGIN        |                |
| SELECT * FROM XXX; |                |
|     sleep(60);     |                |
|                    | DROP TABLE XXX |
| SELECT * FROM XXX  |                |

- session1 显示开启事务，进行两次查询
- session2 在这两次查询之间删表



如果 DROP TABLE 成功执行了，那会话1的第二个select会出错，这明显不是我们想要的结果。



所以为了避免此类问题，MySQL5.5 版本加入了 MDL(Metadata Lock)：

- **当对一个表做CRUD操作的时候，加MDL读锁（MDL_SHARED_READ）；**
- **当要对表做结构变更操作（DDL）（alter, drop）的时候，加MDL写锁（MDL_EXCLUSIVE）。**

- **读锁之间不互斥，因此可以有多个线程同时对一张表增删改查。**
- **读写锁之间、写锁之间互斥，用来保证变更结构操作的安全性。因此，如果有两个线程要同时给一个表加字段，其中一个要等另一个执行完才能开始执行。**





#### **踩坑实战**一



|          session1          |          session2          |                 session3                 |          session4          |
| :------------------------: | :------------------------: | :--------------------------------------: | :------------------------: |
|           begin            |                            |                                          |                            |
| select * from user limit 1 |                            |                                          |                            |
|                            | select * from user limit 1 |                                          |                            |
|                            |                            | alter table user add address varchar(32) |                            |
|                            |                            |                                          | select * from user limit 1 |



- session1 执行select ，持有MDL读锁（由于显示开启事务，事务并未结束，所以一直持有MDL读锁）。
- session2 执行select，也要持有MDL读锁，由于MDL读锁不互斥，所以也可以拿到，正常执行事务完成，释放MDL读锁
- session3 要持有MDL写锁，由于session1的MDL读锁并未释放，所以 session3 被阻塞，状态是`Waiting for table metadata lock`
- session4也会被阻塞（如果有MDL写锁被阻塞，后续对这个表的所有请求都会被阻塞）
  - **原因分析：应该是 MySQL内部维护了一个MDL队列，避免MDL写锁一直请求不到。**
  - **（如果没有先来后到的话，后面的读写请求不停的过来进行查询，这个DDL会一直被阻塞）**
  - **问题注意：如果某个表上的查询语句频繁，而且客户端有重试机制，也就是说超时后会再起一个新session再请求的话，这个库的线程很快就会爆满。**



##### **排查思路**

对于这种情况，排查思路就是最简单的查看关于这个表上操作的所有进程和事务；

```sql
-- 查事务
select * from information_schema.innodb_trx  where trx_query like '%table_name%';

-- 查进程
select * from information_schema.PROCESSLIST where info like '%table_name%';
```



#### **踩坑实战二**



我们知道，如果一个事务没有提交，会阻塞后面的DDL操作。

那么，是不是我们执行 `select * from information_schema.innodb_trx` 查询不到正在执行的事务，就不会出现MDL阻塞的情况了呢?

显然不是。来看一个例子（查询一个不存在的列）：

|         session1          |                    session2                     |
| :-----------------------: | :---------------------------------------------: |
|          begin;           |                                                 |
| select unknown from user; |                                                 |
|                           | alter table user add column address varchar(20) |

我们发现，session2阻塞，等待获取MDL写锁。查看正在运行的事务，发现并没有事务在运行。

```sql
mysql> mysql> select * from information_schema.innodb_trx\G;
Empty set (0.00 sec)
```



**因为`information_schema.innodb_trx`中不会记录执行失败的事务(查询不存在的列，语句未提交等)，但是在这个执行失败的事务回滚前，这个事务它依然持有MDL，所以DDL操作依然会被阻塞。**



##### **排查思路**

这个时候我们可以通过查找`performance_schema.events_statements_current`表来找到相关的语句和会话信息，然后 kill 掉

```sql
-- 使用 sys.schema_table_lock_waits 排查的时候一定要注意认真看
select * from sys.schema_table_lock_waits ; 

SELECT * FROM PERFORMANCE_SCHEMA.events_statements_current WHERE SQL_TEXT LIKE '%dim_admin_area%' ; 



SELECT
	* 
FROM
	information_schema.`PROCESSLIST` 
WHERE
	id IN ( SELECT PROCESSLIST_id FROM PERFORMANCE_SCHEMA.threads WHERE thread_id IN ( SELECT thread_id FROM PERFORMANCE_SCHEMA.events_statements_current WHERE SQL_TEXT LIKE '%dim_admin_area%' ) )

```



### Online DDL

**在MySQL使用过程中，根据业务的需求对表结构进行变更是个普遍的运维操作，这些称为DDL操作。常见的DDL操作有在表上增加新列，或给某个列添加索引。**

给一个表加字段，或者修改字段，或者加索引，都需要扫描全表的数据。

对大表操作的时候，你肯定会特别小心，以免对线上服务造成影响。因为大表DDL往往会耗时很久。

从前面的描述可以得到一个结论：**事务中的MDL锁，在语句执行开始时申请，但是语句结束后并不会马上释放，而会等到整个事务提交后再释放。**

如何安全的给一个表进行 DDL 呢？

首先要解决的是长事务：事务不提交，就会一直占着MDL锁。在 MySQL的 information_schema.innodb_trx 中，可以查到当前执行中的事务。

如果你要做DDL变更的表刚好有长事务在执行，要考虑先暂停DDL，或者 kill 掉这个长事务。



MySQL 5.6 版本引入了**Online DDL**。

在MySQL 5.7，Online DDL在性能和稳定性上不断得到优化，比如通过 bulk load 方式来去除表重建时的 redo 日志等。

到了MySQL 8.0，Online DDL已经支持秒级加列特性，该特性来源于国内的腾讯互娱DBA团队。

**基本上，在 MySQL8.0 上，不需要再用 pt-osc 和 gh-ost 等工具，大多数情况都可以直接 online DDL 了。**

概括来说，在MySQL 8.0上，Online DDL有2种划分维度（其实就是两种参数）：

- 一是DDL期间运行的并发程度
- 二是DDL的实现方式。

先说DDL时的**业务DML操作运行程度**（Permits Concurrent DML），可以通过LOCK关键字来指定DDL期间加锁程度，可选：



- LOCK=NONE           允许查询和DML操作；
- LOCK=SHARED        允许查询，不允许DML操作；
- LOCK=DEFAULT       由系统决定，选择最宽松的模式（默认是这种）；
- LOCK=EXCLUSIVE    不允许查询和DML操作。



另一种划分方式为是否拷贝数据，可分为如下几种：

- 仅修改元数据：包括修改表名，字段名等；
- ALGORITHM=COPY：采用拷表方式进行表变更，与pt-osc/gh-ost类似；
- ALGORITHM=INPLACE：仅需要进行引擎层数据改动，不涉及Server层；
- ALGORITHM=INSTANT：与第一种方式类似，仅修改元数据。目前仅支持在表最后增加新列；
- ALGORITHM=DEFAULT：由系统决定，选择最优的算法执行DDL。 用户可以选用上述算法来执行，但本身受到DDL类型限制，如果指定的算法无法执行DDL，则ALTER操作会报错。



```sql
-- 索引的增删改查（只能新增和删除，不能直接改） 
-- 在线加索引
-- 操作期间，可以正常读写，
CREATE INDEX name ON table (col_list) ;

ALTER TABLE tbl_name ADD INDEX name (col_list) ;
-- 创建普通索引
ALTER TABLE table_name ADD INDEX index_name (column_list);
-- 创建唯一索引
ALTER TABLE table_name ADD UNIQUE (column_list);

CREATE INDEX index_name ON table_name (column_list);
CREATE UNIQUE INDEX index_name ON table_name (column_list);






-- 修改字段数据类型（修改字段长度）
-- ALTER  TABLE 表名 MODIFY [COLUMN] 字段名 新数据类型 新类型长度  新默认值  新注释;
alter table db_qhdata_policy.temp_policy_org_base  MODIFY   apprdate   varchar(50) ;
-- 即使是大表，alter线程持续 copy to tmp table 状态很长时间， alter并没有阻塞其他线程的读请求






-- 字段重命名
ALTER TABLE tbl CHANGE old_col_name new_col_name data_type, ALGORITHM=INPLACE, LOCK=NONE;

```





从流程上看，Online DDL可分为3个阶段：

- 初始化阶段，确定DDL操作支持的最优LOCK和ALGORITHM设置，并与用户指定的设置相比，若无法办到则报错；
- 执行阶段，如果需要拷表或修改引擎层数据，则该阶段是最耗时的阶段；
- 提交阶段，该阶段会加锁进行新旧表切换；



目前可用的 DDL 操作工具包括

- Percona 开源的 [pt-osc](https://www.percona.com/doc/percona-toolkit/LATEST/pt-online-schema-change.html)        
- github 开源的 [gh-ost](https://github.com/github/gh-ost)，
- MySQL 原生提供的在线修改表结构命令Online DDL。

pt-osc 和 gh-ost 均采用拷表方式实现，即创建个空的新表，通过 select+inser t将旧表中的记录逐次读取并插入到新表中。

不同之处在于处理DDL期间业务对表的DML操作（增删改）。









https://zhuanlan.zhihu.com/p/115277009

















## 乐观锁/悲观锁





乐观锁和悲观锁是两种思想，用于解决并发场景下的数据竞争问题。

- 乐观锁：乐观锁在操作数据时非常乐观，认为别人不会同时修改数据。因此乐观锁不会上锁，只是在执行更新的时候判断一下在此期间别人是否修改了数据：如果别人修改了数据则放弃操作，否则执行操作。
- 悲观锁：悲观锁在操作数据时比较悲观，认为别人会同时修改数据。因此操作数据时直接把数据锁住，直到操作完成后才会释放锁；上锁期间其他人不能修改数据。



实现方式：



在说明实现方式之前，需要明确：**乐观锁和悲观锁是两种思想，它们的使用是非常广泛的，不局限于某种编程语言或数据库。**

悲观锁的实现方式是加锁，加锁既可以是对代码块加锁（如 Java 的 synchronized 关键字），也可以是对数据加锁（如 MySQL 中的排它锁）。

乐观锁的实现方式主要有两种：CAS 机制和版本号机制，下面详细介绍。



## 死锁



https://github.com/asdbex1078/MySQL/