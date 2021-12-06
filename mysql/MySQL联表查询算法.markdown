https://blog.csdn.net/lkforce/article/details/102940091







# 连接查询



写过或者学过 SQL 的人应该都知道 left join，知道 left join 的实现的效果，就是保留左表的全部信息，然后把右表往左表上拼接，如果拼不上就是 null。

除了 left join 以外，还有 inner join、outer join、right join，这些不同的 join 能达到的什么样的效果，大家应该都了解了，如果不了解的可以看看网上的帖子或者随便一本 SQL 书都有讲的。

今天我们不讲这些 join 能达到什么效果，我们主要讲这些 join 的底层原理是怎么实现的，也就是具体的效果是怎么呈现出来的。



join 主要有 Nested Loop、Hash Join、Merge Join 这三种方式，我们这里只讲最普遍的，也是最好的理解的 Nested Loop join 。

Nested Loop join 翻译过来就是**嵌套循环连接**的意思，那什么又是嵌套循环呢？嵌套大家应该都能理解，就是一层套一层；那循环呢，你可以理解成是 for 循环。

Nested Loop 里面又有三种细分的连接方式，分别是 Simple Nested-Loop Join、Index Nested-Loop Join、Block Nested-Loop Join，接下来我们就分别去看一下这三种细分的连接方式。



在正式开始之前，先介绍两个概念：

驱动表（也叫外表）和被驱动表（也叫非驱动表，还可以叫匹配表，亦可叫内表），简单来说，驱动表就是主表，left join 中的左表就是驱动表，right join 中的右表是驱动表。

- **驱动表**，在一次连接查询中，先从**驱动表**中逐行取出数据。
- 然后根据连接字段，去相应的表中逐行查询匹配。
- 将查询到的结果输出。

一个是驱动表，那另一个就只能是非驱动表了，在 join 的过程中，其实就是从驱动表里面依次（注意理解这里面的依次）取出每一个值，然后去非驱动表里面进行匹配，那具体是怎么匹配的呢？这就是我们接下来讲的这三种连接方式。









## Simple Nested-Loop Join





Simple Nested-Loop Join 是这三种方法里面最简单，最好理解，也是最符合大家认知的一种连接方式，现在有两张表 table A 和 table B，我们让 **table A left join table B**，如果是用第一种连接方式去实现的话，会是怎么去匹配的呢？直接上图：



![img](MySQL联表查询算法.assets/1153954-20201210195552830-1911874625.png)



这种 join 会从驱动表 table A 中**依次取出**每一个值。（在第一个循环中）

然后去非驱动表 table B 中从**上往下依次匹配**，然后把匹配到的值进行返回，最后把所有返回值进行合并，这样我们就查找到了 table A left join table B 的结果。

连接双方在连接字段上都没有索引，所以此算法没有什么套路，从驱动表取出记录，按照join的条件在被驱动表中查询，找到可连接的记录，把数据连接并返回。

利用这种方法，如果  t1 有 100 行，t1 有 100 行，总共需要执行 100 x 100 = 10000 次查找。

这种暴力匹配的方式在数据库中一般不使用。

```sql
-- 在实际 inner join 中，数据库引擎会自动选取数量小的表做为驱动表
-- 驱动表是 t2，被驱动表是 t1。

-- 先执行查找的就是驱动表(执行计划结果的id如果一样则按从上到下顺序执行sql);

-- 优化器一般会优先选择小表做驱动表。所以使用 inner join 时，排在前面的表并不一定就是驱动表。
-- 当使用left join时，左表是驱动表，右表是被驱动表，当使用right join时，右表时驱动表，左表是被驱动表， 当使用join时，mysql会选择数据量比较小的表作为驱动表，大表作为被驱动表。
-- 使用了 NLJ算法。一般 join 语句中，如果执行计划 Extra 中未出现 Using join buffer 则表示使用的 join 算 法是 NLJ
select * from t1 inner join t2 on t1.id=t2.tid

-- 从表 t2 中读取一行数据(如果t2表有查询过滤条件的，会从过滤结果里取出一行数据);
```



```java
//伪代码表示：
List<Row> result = new ArrayList<>();
for(Row r1 in List<Row> t1){
	for(Row r2 in List<Row> t2){
		if(r1.id = r2.tid){
			result.add(r1.join(r2));
		}
	}
}
```









## Index Nested-Loop Join

Index Nested-Loop Join  翻译成中文叫 **索引嵌套循环连接查询**

join 查询的优化思路就是小表驱动大表，而且在大表上创建索引(也就是被驱动表创建索引)，如果驱动表创建了索引，MySQL是不会使用的

这个 Index 是要求非驱动表上要有索引，有了索引以后可以减少匹配次数，匹配次数减少了就可以提高查询的效率了。

为什么会有了索引以后可以减少查询的次数呢？这个其实就涉及到数据结构里面的一些知识了，给大家举个例子就清楚了



索引嵌套循环连接是基于索引进行连接的算法，索引是基于内层表的，通过外层表匹配条件直接与内层表索引进行匹配，避免和内层表的每条记录进行比较， 从而利用索引的查询减少了对内层表的匹配次数，优势极大的提升了 join的性能：

> 原来的匹配次数 = 外层表行数 * 内层表行数
> 优化后的匹配次数= 外层表的行数 * 内层表索引的高度

1. 使用场景：只有内层表join的列有索引时，才能用到Index Nested-LoopJoin进行连接。
2. 由于用到索引，如果索引是辅助索引而且返回的数据还包括内层表的其他数据，则会回内层表查询数据，多了一些IO操作





MySQL8.0正式引入了Hash Join 的连接方式。











## **基于块的嵌套循环连接 Block Nested Loop Join 算法（BNL）**



把驱动表的数据读入到 **join_buffer** 中，然后扫描被驱动表，**把被驱动表每一行取出来跟 join_buffer 中的数据做对比。**



```sql
explain select * from t1 inner join t2 on t1.b= t2.b;
--查询计划中的 extra 的类型是 Using join buffer (Block Nested Loop) 则说明使用了BNL算法

-- 这段sql的大致流程如下:
-- 1.把 t2 的所有数据放入到 join_buffer 中
-- 2.把表 t1 中每一行取出来，跟 join_buffer 中的数据做对比 
-- 3. 返回满足 join 条件的数据


```



整个过程对表 t1 和 t2 都做了一次全表扫描，因此扫描的总行数为10000(表 t1 的数据总量) + 100(表 t2 的数据总量) = 10100。

并且 join_buffer 里的数据是无序的，因此对表 t1 中的每一行，都要做 100 次判断，所以内存中的判断次数是 100 * 10000= 100 万次。


这个例子里表 t2 才 100 行，要是表 t2 是一个大表，join_buffer 放不下怎么办呢?



> join_buffer 的大小是由参数 join_buffer_size 设定的，默认值是 256k。如果放不下表 t2 的所有数据话，策略很简单， 就是分段放。
>
> 比如 t2 表有1000 行记录， join_buffer 一次只能放 800 行数据，那么执行过程就是先往 join_buffer 里放800行记录，然 后从 t1 表里取数据跟 join_buffer 中数据对比得到部分结果。
>
> 然后清空 join_buffer ，再放入 t2 表剩余200行记录，再 次从 t1 表里取数据跟 join_buffer 中数据对比。所以就多扫了一次 t1 表。
> 

> 被驱动表的关联字段没索引为什么要选择使用 BNL 算法而不使用 Nested-Loop Join 呢?
>
> 针对这种情况，如果使用 Nested-Loop Join 算法，那么扫描行数为 100 * 10000 = 100万次，这个是磁盘扫描。
>
> 很显然，用BNL磁盘扫描次数少很多，相比于磁盘扫描，BNL的内存计算会快得多。 因此MySQL对于被驱动表的关联字段没索引的关联查询，一般都会使用 BNL 算法。
>
> 如果有索引一般选择 NLJ 算法，有 索引的情况下 NLJ 算法比 BNL算法性能更高



**总结**

- **嵌套循环连接（NJL）算法**是驱动表和被驱动表均在**磁盘中进行匹配**，磁盘读写性能差。
- **基于块的嵌套循环连接（BNL）算法**，**引入了一个join_buffer的内存区域**，使得大量的计算挪到内存中进行，内存性能远远大于磁盘，所以整体性能提升比较大。
- 整体思路还是用内存操作替代磁盘操作以提高性能。
- 表连接字段有索引的SQL扫描的行数远远小于表连接字段的扫描行数，所以**表连接尽量给连接字段加索引。**
- 使用小表驱动大表，可以使用 straight_join 指定驱动表（其实有些鸡肋的，inner join MySQL的查询优化器会自动选择小表做驱动，left join 和 right join 实际已经指定了驱动表）
  - 尽可能让优化器去判断，因为大部分情况下mysql优化器是比人要聪明的。使用 straight_join 一定要慎重，因 为部分情况下人为指定的执行顺序并不一定会比优化引擎要靠谱。



## Hash join 算法



MySQL 一直被人诟病没有实现 Hash Join，在 MySQL 8.0.18 已经带上了这个功能，令人欣喜。

有时候在想，MySQL 为什么一直不支持 HashJoin 呢？我想可能是因为 MySQL 多用于简单的 OLTP 场景，并且在互联网应用居多，需求没那么紧急。

另一方面可能是因为以前完全靠社区，这种演进速度毕竟有限，Oracle 收购 MySQL 后，MySQL 的发版演进速度明显加快了很多。



通常情况下，hash join 效率比 nested loop join 快（当 join 中的某一张表数据量小，可以完全缓存到内存中时，hash join 效率是最好的）。



先简单介绍一下哈希表这种数据结构



> 哈希表（Hash Table）也叫做散列表，根据关键码值（key value）可以快速存取访问的一种空间换时间的数据结构。
>
> 它通过把**关键码值通过映射函数计算到表中一个位置来访问记录，可以加快查找速度**。这个映射函数叫做散列数（Hash Function），存放记录的数组叫做哈希表（或散列表）。
>
> 举个例子比如我们想想在14亿个身份证号码中找出其中一个身份证号，我们肯定不可能一个个去找，而我们可以将14亿条数据存放在哈希表中，然后根据哈希表结构就可以快速找到要找的数据。
>
> 所以哈希表就是这种能够通过给定的关键字的值直接访问到具体对应的值的一个数据结构。也就是说把关键字映射到一个表中的位置来直接访问记录，以加快访问速度。
>
> **数组的特点是：寻址容易，插入和删除困难；**
>
> **而链表的特点是：寻址困难，插入和删除容易。**
>
> 哈希表优缺点
>
> - 优点：不论哈希表中有多少数据，查找、插入、删除（有时包括删除）只需要接近常量的时间即0(1）的时间级。实际上，这只需要几条机器指令。
>
>   哈希表运算得非常快，在计算机程序中，如果需要在一秒种内查找上千条记录通常使用哈希表（例如拼写检查器)哈希表的速度明显比树快，树的操作通常需要O(N)的时间级。哈希表不仅速度快，编程实现也相对容易。
>
>   如果不需要有序遍历数据，并且可以提前预测数据量的大小。那么哈希表在速度和易用性方面是无与伦比的。
>
> - 缺点：它是基于数组的，数组创建后难于扩展，某些哈希表被基本填满时，性能下降得非常严重，所以程序员必须要清楚表中将要存储多少数据（或者准备好定期地把数据转移到更大的哈希表中，这是个费时的过程）。
>   



HashJoin 是针对 equal-join 场景的优化，基本思想是，将外表数据 load 到内存，并根据 key 建立 hash 表，这样只需要遍历一遍内表，就可以完成 join 操作，输出匹配的记录。

如果数据能全部 load 到内存当然好，逻辑也简单，一般称这种 join 为**CHJ(Classic Hash Join)**，之前MariaDB就已经实现了这种 HashJoi n算法。如果数据不能全部 load 到内存，就需要分批 load 进内存，然后分批 join。



```sql
-- 以这段SQL为例
SELECT
  given_name, country_name
FROM
  persons JOIN countries ON persons.country_id = countries.country_id;
  
-- 在构建hash 表时，mysql 将 join 中的某一张数据表的数据缓存到此 hash 表中。通常情况下，优化器会选择数据量较小的表来构建 hash 表（因为这样在内存中需要缓存的数据量相对较小）。 
-- hash 表使用 join 使用的 join 中的此表使用的条件作为 hash key.
```



**Hash join 不需要索引的支持。大多数情况下，hash join 比之前的 Block Nested-Loop 算法在没有索引时的等值连接更加高效。**

```sql
-- 创建三张测试表
CREATE TABLE t1 (c1 INT, c2 INT);
CREATE TABLE t2 (c1 INT, c2 INT);
CREATE TABLE t3 (c1 INT, c2 INT);

-- 使用EXPLAIN FORMAT=TREE命令可以看到执行计划中的 hash join
EXPLAIN FORMAT=TREE  SELECT *  FROM t1  JOIN t2  ON t1.c1=t2.c1

-- 必须使用 EXPLAIN 命令的 FORMAT=TREE 选项才能看到节点中的 hash join。
-- 另外，EXPLAIN ANALYZE命令也可以显示 hash join 的使用信息。这也是MySQL8.0.18版本后新增的一个功能。

-- 多个表之间使用等值连接的的查询也会进行这种优化
SELECT * 
    FROM t1
    JOIN t2 
        ON (t1.c1 = t2.c1 AND t1.c2 < t2.c2)
    JOIN t3 
        ON (t2.c1 = t3.c1);
        
-- 默认配置时，MySQL 所有可能的情况下都会使用 hash join。同时提供了两种控制是否使用 hash join 的方法
-- 在全局或者会话级别设置服务器系统变量 optimizer_switch 中的 hash_join=on 或者 hash_join=off 选项。默认为 hash_join=on。
-- 在语句级别为特定的连接指定优化器提示 HASH_JOIN 或者 NO_HASH_JOIN

-- 可以通过系统变量 join_buffer_size 控制 hash join 允许使用的内存数量；hash join 不会使用超过该变量设置的内存数量。
-- 如果 hash join 所需的内存超过该阈值，MySQL 将会在磁盘中执行操作。
-- 需要注意的是，如果 hash join 无法在内存中完成，并且打开的文件数量超过系统变量 open_files_limit 的值，连接操作可能会失败。

-- 接下来我们比较一下 hash join 和 block nested loop 的性能，首先分别为 t1、t2 和 t3 生成 1000000 条记录：


set join_buffer_size=2097152000;

SET @@cte_max_recursion_depth = 99999999;

INSERT INTO t1
-- INSERT INTO t2
-- INSERT INTO t3
WITH RECURSIVE t AS (
  SELECT 1 AS c1, 1 AS c2
  UNION ALL
  SELECT t.c1 + 1, t.c1 * 2
    FROM t
   WHERE t.c1 < 1000000
)
SELECT *
  FROM t;



```





- 再增加一个 Oracle 12c 中无索引时 hash join 结果：1.282 s。

- 再增加一个 PostgreSQL 11.5 中无索引时 hash join 结果：6.234 s。

- 再增加一个 SQL 2017 中无索引时 hash join 结果：5.207 s。



参考 https://blog.csdn.net/horses/article/details/102690076

## 实例



```sql
-- 建表t2
CREATE TABLE `t2` (
  `id` int(11) NOT NULL,
  `a` int(11) DEFAULT NULL,
  `b` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `a` (`a`)
) ENGINE=InnoDB;



delimiter ;;
create procedure idata()
begin
  declare i int;
  set i=1;
  while(i<=1000)do
    insert into t2 values(i, i, i);
    set i=i+1;
  end while;
end;;

delimiter ;

call idata();


-- 建表t1
create table t1 like t2;
insert into t1 (select * from t2 where id<=100)


-- t1的存储过程，插入数据
delimiter ;;
create procedure idata2()
begin
  declare i int;
  set i=2000;
  while(i<=3000)do
    insert into t1 values(i, i, i);
    set i=i+1;
  end while;
end;;

delimiter ;

call idata2();




-- t1 的数据  1-100  2000-3000  一共是1101条数据
-- t2 的数据  1-1000  一共是1000条数据

-- 直接多表查询，笛卡尔积：1101*1000 条数据，很少有这样的查询
select *  from t1 , t2   






```





