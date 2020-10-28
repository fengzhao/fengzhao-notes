# 锁和MVCC





1、读写锁

读锁是共享的，是互相不阻塞的，多个客户在同一时间读取同一资源，互不干扰。

写锁是排他的，会阻塞其他的写锁和读锁，写锁有更高的优先级。（即我在写资源的时候，其他用户无法读写）



一种提高共享资源并发性的方式就是让锁定对象更有选择性。尽量只锁定需要修改的部分数据，而不是所有的资源，锁定的资源越少，系统的并发性更好。





## 锁的粒度

根据锁定对象的粒度，我们可以分为：

- 表锁（table lock）
- 行锁 （row lock）



## 读锁写锁

读锁写锁也被称为共享锁和排他锁



- 读锁是共享的，是互相不阻塞的，多个客户在同一时间读取同一资源，互不干扰。（即我在读资源的时候，其他人只能读不能写）
- 写锁是排他的，会阻塞其他的写锁和读锁，写锁有更高的优先级。（即我在写资源的时候，其他用户无法读写）



允许不同事务之前共享加锁读取，但不允许其它事务修改或者加入排他锁。

如果有修改必须等待一个事务提交完成，才可以执行，容易出现死锁





**隐式加锁**：InnoDB，在执行事务过程中会自动加锁，除非执行 COMMIT 或 ROLLBACK 时锁会自动释放。

**显式加锁**：可以使用 SELECT...LOCK IN SHARE MODE || SELECT...FOR UPDATE 生成锁





### 共享锁事务之间的读取

```sql
-- session1:
start transaction;
select * from test where id = 1 lock in share mode;


-- session2:
start transaction;
select * from test where id = 1 lock in share mode;


-- 此时 session1 和 session2 都可以正常获取结果，那么再加入 session3 排他锁读取尝试

-- session3:
start transaction;
select * from test where id = 1 for update;
-- Lock wait timeout exceeded; try restarting transaction -- 在 session3 中则无法获取数据，直到超时或其它事物 commit


-- 通过 information_schema.INNODB_TRX.trx_mysql_thread_id 可以找到锁表的线程ID，再回 information_schema.`PROCESSLIST` 表里面去查，就可以找到响应的连接。
SELECT * FROM information_schema.INNODB_TRX

```

### 共享锁事务之间的更新

```sql

-- session1:
start transaction;
select * from test where id = 1 lock in share mode;

-- session2:
start transaction;
select * from test where id = 1 lock in share mode;

-- 回到session1:
update emp set ename = 'ALLEN1111' where ename='ALLEN' ;
-- 这个时候，session1已经无法更新这个数据了。
select * from emp 

-- 回到session2:



```



### 共享锁的总结





### 写锁

当一个事物加入排他锁后，不允许其他事务加共享锁或者排它锁读取，更加不允许其他事务修改加锁的行。

```sql

-- session1:
-- session对资源添加写锁
start transaction;
select * from test where id = 1 for update;


-- session2:
-- session2超时
start transaction;
select * from test where id = 1 for update;





```



start transaction;
select * from test where id = 1 for update;



## 乐观锁





乐观锁和悲观锁是两种思想，用于解决并发场景下的数据竞争问题。

- 乐观锁：乐观锁在操作数据时非常乐观，认为别人不会同时修改数据。因此乐观锁不会上锁，只是在执行更新的时候判断一下在此期间别人是否修改了数据：如果别人修改了数据则放弃操作，否则执行操作。
- 悲观锁：悲观锁在操作数据时比较悲观，认为别人会同时修改数据。因此操作数据时直接把数据锁住，直到操作完成后才会释放锁；上锁期间其他人不能修改数据。



实现方式：



在说明实现方式之前，需要明确：**乐观锁和悲观锁是两种思想，它们的使用是非常广泛的，不局限于某种编程语言或数据库。**

悲观锁的实现方式是加锁，加锁既可以是对代码块加锁（如 Java 的 synchronized 关键字），也可以是对数据加锁（如 MySQL 中的排它锁）。

乐观锁的实现方式主要有两种：CAS 机制和版本号机制，下面详细介绍。

### 