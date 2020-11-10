# MySQL-XA 事务



MySQL XA 事务通常用于分布式事务处理当中。

比如在分库分表的场景下，当遇到一个用户事务跨了多个分区，需要使用XA事务来完成整个事务的正确的提交和回滚，即保证全局事务的一致性。







下图是个典型的分库分表场景，前端是一个 Proxy 后面带若干个 MySQL 实例，每个实例是一个分区。



假设一个表test定义如下，Proxy根据主键 ”a” 计算 Hash 决定一条记录应该分布在哪个节点上：

```sql
create table test(a int primay key, b int) engine = innodb;
```





应用发到Proxy的一个事务如下：

```sql
begin;
insert into test values (1, 1);
update test set b = 1 where a = 10;
commit;
```



**Proxy 收到这个事务需要将它转成 XA 事务发送到后端的数据库以保证这个事务能够安全的提交或回滚，一般的 Proxy 的处理步骤 如下：**



1. Proxy 先收到 begin，它只需要设置一下自己的状态不需要向后端数据库发送
2. 当收到 insert 语句时 Proxy 会解析语句，根据“a”的值计算出该条记录应该位于哪个节点上，这里假设是“分库1”
3. Proxy就会向分库1上发送语句 xa start ‘xid1’，开启一个 XA 事务，这里 xid1 是 Proxy 自动生成的一个全局事务ID；
4. 同时原来 的insert语句insert into values(1,1)也会一并发送到分库1上。
5. 这时Proxy遇到了update语句，Proxy会解析 where条件主键的值来决定该条语句会被发送到哪个节点上，这里假设是“分库2”
6. Proxy就会向分库2上发送语句xa start ‘xid1’，开启一个XA事务，这里xid1是Proxy之前已经生成的一个全局事务ID；同时原来 的update语句update test set b = 1 where a = 10也会一并发送到分库2上。
7. 最后当Proxy解析到commit语句时，就知道一个用户事务已经结束了，就开启提交流程
8. Proxy会向分库1和分库2发送 xa end ‘xid1’;xa prepare ‘xid1’语句，当收到执行都成功回复后，则继续进行到下一步，如果任何一个分 库返回失败，则向分库1和分库2 发送 xa rollback ‘xid1’，回滚整个事务
9. 当 xa prepare ‘xid1’都返回成功，那么 proxy会向分库1和分库2上发送 xa commit ‘xid1’，来最终提交事务。