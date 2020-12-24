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

一个是驱动表，那另一个就只能是非驱动表了，在 join 的过程中，其实就是从驱动表里面依次（注意理解这里面的依次）取出每一个值，然后去非驱动表里面进行匹配，那具体是怎么匹配的呢？这就是我们接下来讲的这三种连接方式。









## Simple Nested-Loop Join



Simple Nested-Loop Join 是这三种方法里面最简单，最好理解，也是最符合大家认知的一种连接方式，现在有两张表 table A 和 table B，我们让 **table A left join table B**，如果是用第一种连接方式去实现的话，会是怎么去匹配的呢？直接上图：



![img](MySQL联表查询算法.assets/1153954-20201210195552830-1911874625.png)



上面的 left join 会从驱动表 table A 中**依次取出**每一个值。（在第一个循环中）

然后去非驱动表 table B 中从**上往下依次匹配**，然后把匹配到的值进行返回，最后把所有返回值进行合并，这样我们就查找到了 table A left join table B 的结果。



利用这种方法，如果 table A 有 100 行，table B 有 100 行，总共需要执行 10 x 10 = 100 次查询。

这种暴力匹配的方式在数据库中一般不使用。



举个例子：

select * from t1 inner join t2 on t1.id=t2.tid

（1）t1称为外层表，也可称为驱动表。
（2）t2称为内层表，也可称为被驱动表。



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



Index Nested-Loop Join 这种方法中，我们看到了 Index，大家应该都知道这个就是索引的意思。

这个 Index 是要求非驱动表上要有索引，有了索引以后可以减少匹配次数，匹配次数减少了就可以提高查询的效率了。

为什么会有了索引以后可以减少查询的次数呢？这个其实就涉及到数据结构里面的一些知识了，给大家举个例子就清楚了





1. 索引嵌套循环连接是基于索引进行连接的算法，索引是基于内层表的，通过外层表匹配条件直接与内层表索引进行匹配，避免和内层表的每条记录进行比较， 从而利用索引的查询减少了对内层表的匹配次数，优势极大的提升了 join的性能：

> 原来的匹配次数 = 外层表行数 * 内层表行数
> 优化后的匹配次数= 外层表的行数 * 内层表索引的高度

1. 使用场景：只有内层表join的列有索引时，才能用到Index Nested-LoopJoin进行连接。
2. 由于用到索引，如果索引是辅助索引而且返回的数据还包括内层表的其他数据，则会回内层表查询数据，多了一些IO操作





MySQL8.0正式引入了Hash Join 的连接方式。

































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





