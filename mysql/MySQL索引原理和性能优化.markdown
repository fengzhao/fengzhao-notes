# 索引基本概念

数据库中的索引，就像是书籍中的目录一样。

或者是我们去图书馆看书时，通常在图书馆网络上查找到想看的书的索书号，然后根据图书馆分类索引去查找对应的书架找到书籍。

在数据库中的索引，也是这个概念。

为了根据给定 ID 检索一条 *student* 记录，数据库系统会先查找索引，找到记录所在的磁盘块，然后读取所需的 *student* 记录。

索引是一种典型的 **空间换取时间** 的算法思想，在磁盘中存储一些额外的索引文件，来提高查找效率。

这里的查找，并不是简单的查询，无论是增删改查，都需要查找相应的位置进行插入，或者找到相应的记录再进行删除和修改。



**所以索引提高的并不仅仅只是查询效率。**



根据索引的作用：无论是增删改查，都是要先查找到相应的记录，**而且在增删改时也要修改索引数据。索引也会带来一些额外的维护开销**。

**评价索引性能大概有如下几种因素**：

- **访问类型**：索引能够支持的访问类型，主要的访问类型包括：特定记录的查找（等值查找），范围查找 。
- **访问时间**：在查询中，使用索引技术查找到记录的时间。
- **插入时间**：插入新数据项的时间，包括找到正确的位置插入数据项和更新索引所需要的时间。
- **删除时间**：删除数据项的时间，包括找到要被删除的项和更新索引所需要的时间。
- **空间开销**：索引结构占用的额外的空间开销





# 索引的基本数据结构

根据索引的数据结构分类，有两种基本的索引类型：

**散列索引（哈希索引）**

- 散列索引主要的数据结构就是哈希表。只有精确匹配索引的所有列的查询才有效。

  - 对于每一行数据，存储引擎都会对所有的索引列计算一个哈希码，哈希码是一个较小的值，并且不同键值的行计算出来的哈希码也不一样（也可能有哈希冲突）。
  - 哈希索引将所有的哈希码存储在索引中，同时在哈希表中保存指向每个数据行的指针。
  - **也就是说，由于哈希查找比起B-Tree索引，其本身对于单行查询的时间复杂度更低，有了哈希索引后明显可加快单行查询速度。**

  - **哈希索引不是按照索引值顺序存储的，所以也就无法用于排序查找。**
  - **散列索引仅支持  仅能满足 "=","IN"和"<=>"查询，不能使用范围查询，例如 " where price > 100"（注意 "<=>" 和 "<" ,">" 是不同的运算符。）**
  - 其检索效率非常高，索引的检索可以一次定位，不像B-Tree 索引需要从根节点到枝节点，最后才能访问到页节点这样多次的IO访问。所以 Hash 索引的查询效率要远高于 B-Tree 索引。
  - MySQL 的 InnoDB 存储引擎中有个功能叫 **自适应哈希索引( adaptive hash index)**，当 InnoDB 注意到某些索引值使用的非常频繁时，它会在内存中基于 B -Tree 索引之上再创建一个哈希索引，这样就让 B-Tree 也具有哈希索引的一些优点，比如快速查找，这是一个自动的、内部的行为，用户无法控制或配置，不过如果有必要，可以自己关掉。

  

**顺序索引**

顺序索引的主要数据结构是 B-Tree 。将索引列的数据



索引项是由索引码值和指向具有该索引码的一条或多条记录的指针组成。

## 稠密索引

索引是连续的，即在要索引列的每一行中，都有索引项。索引项包括

稠密索引的特点是占用空间大，搜索效率高。

## 稀疏索引

索引是非连续的。

在稀疏索引中，只为搜索码的某些值建立索引项。只有当数据是按照

考虑一本字典，每一页的页眉都顺序的列出了该页中按字母顺序出现的第一个单词，这个字典所有页的页眉构成了这个字典的稀疏索引。



显然，稠密索引是可以快速定位一条记录的。

但是稀疏索引的优点在于：

- 占用更少的空间。
- 插入和删除时的开销更小。

系统设计者必须在存取时间和空间开销之间权衡。尽管有关这一权衡的决定依赖于具体的应用，但是为每个块建立稀疏索引是比较好的折中。**设计索引的粒度很重要**



**处理数据库查询的开销，主要是把块从磁盘读取到内存中的时间。一旦块被读入内存，扫描整个块的时间几乎是可以忽略的。**

（磁盘被读取到内存是以块为单位，一个数据块中的可以存取多条记录）



## 多级索引

假设要在 100 000 000 行数据上建立了稠密索引，1个 4KB 的数据块可以容纳 100 条索引项。这样索引文件就需要占用 1 000 000 个数据块。即 4GB。

这个索引文件以顺序的方式存储在磁盘中。

如果索引小到可以放到内存中。那么搜索一个索引项的时间非常小。（即使索引比内存小，也不可能全部读入内存，内存还需要处理其他任务）

在索引文件中，用二分查找法来进行搜索。



多级索引其实就是索引的索引。 



## 索引的更新

无论采用什么形式的索引，每当有记录插入或者删除时，索引都需要更新。

如果有记录更新，任何该记录上的搜索码受影响的索引也必须更新。

例如，如果一个教师的系发生了变化，那么 instructor 上的 dept_name 列上的索引也必须相应的更新。

索引的更新可以认为是删除旧的索引，随后插入对应的新记录。因此，只需要考虑索引的插入和删除。











# 索引类型

按照索引的数据结构，MySQL 中的**索引方法**可以分为

- 哈希索引（HASH）

- BTREE索引（BREE）

按照索引类型，可以分为：

- 普通索引（NORMAL）
- 唯一索引（UNIQUE）
- 全文索引（FULLTEXT）（MySQL8.0）
- 地理索引（SPATIAL）





```sql

-- 索引语法：ALTER TABLE table1 ADD (UNIQUE| SPATIAL | FULLTEXT )INDEX idx_name(column(length)) USING  BTREE |HASH ;
-- 索引语法：ALTER TABLE table1 ADD INDEX idx_name(column) USING  BTREE |HASH ;

-- 添加普通的B-tree索引
ALTER TABLE t1   ADD INDEX idx_name(column(10)) USING BTREE;
-- 添加unique的B-tree索引
ALTER TABLE t1   ADD INDEX unique idx_name(column(10)) USING BTREE;




```





## 隐藏索引

MySQL 8.0.19 中新增了三种索引方式：隐藏索引、降序索引、函数索引



**隐藏索引概述**

MySQL 8.0.19 及以上支持隐藏索引（invisible index），也称为不可见索引。**隐藏索引不会默认被优化器使用。主键不能设置为隐藏（包括显式设置或隐式设置）**

实际上，通过这种方式创建的索引，索引文件还是存在的，只是默认不会被优化器使用。

**这个功能在测试评估索引有效性时非常有用。DBA对希望删除的索引开启该功能，经过完整验证，确认之后，可以放心删除索引。**



所有的索引默认是可见的，可以在 CREATE TABLE, CREATE INDEX,  ALTER TABLE的时候，对新索引设置为不可见。使用方法如下：

```sql
CREATE TABLE t1 (
  i INT,
  j INT,
  k INT,
  INDEX i_idx (i) INVISIBLE  -- 隐藏索引
) ENGINE = InnoDB;
CREATE INDEX j_idx ON t1 (j) INVISIBLE;  -- 隐藏索引
ALTER TABLE t1 ADD INDEX k_idx (k) INVISIBLE; -- 隐藏索引

-- 隐藏索引与可见索引的转换
ALTER TABLE t1 ALTER INDEX i_idx INVISIBLE;
ALTER TABLE t1 ALTER INDEX i_idx VISIBLE;

-- 查看表中索引是否为隐藏索引 show index from t1;
	
SELECT INDEX_NAME, IS_VISIBLE
       FROM INFORMATION_SCHEMA.STATISTICS
       WHERE TABLE_SCHEMA = 'db1' AND TABLE_NAME = 't1';

+------------+------------+
| INDEX_NAME | IS_VISIBLE |
+------------+------------+
| i_idx      | YES        |
| j_idx      | NO         |
| k_idx      | NO         |
+------------+------------+
```



当将索引设置为不可见时，可以通过下面几个方法确认优化器是否需要使用到该索引：

- 使用到该索引的索引提示语句会发生错误。(index hint)

- 查询的执行计划和之前的不同

- 查询出现在慢日志中

- Performance Schema里面相关的查询工作量会增加



**隐藏索引的相关说明**

- 除了主键，其他索引都可以设置为隐藏索引。
- 对于唯一键：例外情况: 没有主键的情况下，第一个唯一键 不可隐藏，第二个唯一键可隐藏。
  -  **MySQL在没有主键的情况下 是把第一个唯一建做为主键。**

- 系统变量 optimizer_switch 的 use_invisible_indexes 值控制了优化器构建执行计划时是否使用隐藏索引。
  - 如果设置为 off （默认值），优化器将会忽略隐藏索引（与引入该属性之前的行为相同）。
  - 如果设置为 on，隐藏索引仍然不可见，但是优化器在构建执行计划时将会考虑这些索引。



**总结**

不可见索引特性可以用于测试删除某个索引对于查询性能的影响，同时又不需要真正删除索引，也就避免了错误删除之后的索引重建。

对于一个大表上的索引进行删除重建将会非常耗时，而将其设置为不可见或可见将会非常简单快捷。





## 全文索引



## 降序索引

MySQL8.0开始真正支持降序索引，只有 InnoDB 引擎支持降序索引，且必须是 BTREE 降序索引，MySQL8.0 不再对 group by 操作进行隐式排序。

MySQL 支持降序索引：索引定义中的 DESC 不再被忽略，而是按降序存储键值。以前，可以以相反的顺序扫描索引，但是会导致性能损失。



```sql
-- 同一个建表语句
create table slowtech.t1(c1 int,c2 int,index idx_c1_c2(c1,c2 desc));

-- MySQL5.7  
mysql> show create table slowtech.t1\G
*************************** 1. row ***************************
      Table: t1
Create Table: CREATE TABLE `t1` (
  `c1` int(11) DEFAULT NULL,
  `c2` int(11) DEFAULT NULL,
  KEY `idx_c1_c2` (`c1`,`c2`)  -- 虽然c2列指定了desc，但在实际的建表语句中还是将其忽略了
) ENGINE=InnoDB DEFAULT CHARSET=latin1
1 row in set (0.00 sec)

-- MySQL8.0
mysql> show create table slowtech.t1\G
*************************** 1. row ***************************
      Table: t1
Create Table: CREATE TABLE `t1` (
  `c1` int(11) DEFAULT NULL,
  `c2` int(11) DEFAULT NULL,
  KEY `idx_c1_c2` (`c1`,`c2` DESC) --保留了desc子句
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
1 row in set (0.00 sec)

```



### 降序索引的意义

https://juejin.cn/post/6844903874424209415



如果一个查询，需要对多个列进行排序，且顺序要求不一致。在这种场景下，要想避免数据库额外的排序- "filesort"，只能使用降序索引。

比如，先按 c1 升序，然后按照 c2 降序

还是上面这张表，来看看有降序索引和没降序索引区别。

```sql
-- mysql5.7
mysql> explain select * from slowtech.t1 order by c1,c2 desc;
+----+-------------+-------+------------+-------+---------------+-----------+---------+------+------+----------+-----------------------------+
| id | select_type | table | partitions | type  | possible_keys | key      | key_len | ref  | rows | filtered | Extra                      |
+----+-------------+-------+------------+-------+---------------+-----------+---------+------+------+----------+-----------------------------+
|  1 | SIMPLE      | t1    | NULL      | index | NULL          | idx_c1_c2 | 10      | NULL |    1 |  100.00 | Using index; Using filesort |
+----+-------------+-------+------------+-------+---------------+-----------+---------+------+------+----------+-----------------------------+
1 row in set, 1 warning (0.00 sec)
```



### MySQL group by 隐式排序

**从 5.7 升级到 8.0 的注意事项**

在 MySQL5.7 中，group by 子句会隐式排序。

默认情况下 GROUP BY 会隐式排序（即 group by id 后面没有 asc 和 desc 关键字）。但是 group by 自己会排序

- 不推荐 **GROUP BY隐式排序（group by id）**  或 **GROUP BY显式排序( group by id desc)**。

- 要生成给定的排序 ORDER，请显示提供 ORDER BY 子句。`group by id order by id `

```sql
 CREATE TABLE t (id INTEGER,  cnt INTEGER);
 
INSERT INTO t VALUES (4,1),(3,2),(1,4),(2,2),(1,1),(1,5),(2,6),(2,1),(1,3),(3,4),(4,5),(3,6);

-- 在MySQL5.7中，下面这三条sql看起来执行的效果是一样的

-- 推荐，5.7和8.0效果一致
select id, SUM(cnt) from t group by id order by id; 
-- 不推荐  --8.0中不会排序
select id, SUM(cnt) from t group by id ; 
-- 不推荐  --8.0中直接报错
select id, SUM(cnt) from t group by id  asc; 

+------+----------+
| id   | SUM(cnt) |
+------+----------+
|    1 |       13 |
|    2 |        9 |
|    3 |       12 |
|    4 |        6 |
+------+----------+
4 rows in set (0.00 sec)

-- 从 MySQL8.0 开始，不支持 GROUP BY隐式排序 和 GROUP BY显式排序
```



 

# 索引组织表



目前的流行的 MySQL 存储引擎中，InnoDB 是最优先的引擎选型，我们在部署和规划的过程中，应该首选为 InnoDB 作为存储引擎的首选。

在 InnoDB 存储引擎中，因为表都是按照主键的顺序进行存放的，我们称之为索引组织表(index organized table ，IOT)

因为在 InnoDB 中，数据文件本身就是根据主键索引排序的B+Tree的数据结构，叶节点包含了完整的数据记录。



> 
>
> clustered index
>
> The InnoDB term for a primary key index. InnoDB table storage is organized based on the values of the
>
> primary key columns, to speed up queries and sorts involving the primary key columns. For best performance,
>
> choose the primary key columns carefully based on the most performance-critical queries. Because modifying
>
> the columns of the clustered index is an expensive operation, choose primary columns that are rarely or never updated.
>
> In the Oracle Database product, this type of table is known as an index-organized table.
>
> See Also index, primary key, secondary index.





## 聚集索引(clustered index)



**innodb 表中的主键，就是聚簇索引。**

主键索引的叶子节点存的是整行数据。由于表里的数据行只能按照一颗B+树排序，因此**一张表只能有一个聚簇索引。**

- **如果在建表时没有主键，会用一个不为空的唯一索引列做为主键，成为此表的聚簇索引。**

- **如果在建表时也没有索引，InnoDB会隐式定义使用 UUID 形式一个主键来作为聚簇索引。**

**一般建议在建表的时候显式指定主键（这样MySQL就自动根据这个主键索引去存储数据）。**

**在InnoDB中，聚簇索引默认就是主键索引**。

**如果在建表后，并且表中已经有大量数据时，再为这个表创建主键索引或者修改主键索引的代价是很高的。这个操作其实就是重建表。**

```sql
-- 重建表
alter table T engine=InnoDB;

```





对于联合主键和索引组织表的理解

```sql
CREATE TABLE `geek` (
  `a` int(11) NOT NULL,
  `b` int(11) NOT NULL,
  `c` int(11) NOT NULL,
  `d` int(11) NOT NULL,
  PRIMARY KEY (`a`,`b`),
  KEY `c` (`c`),
  KEY `ca` (`c`,`a`),
  KEY `cb` (`c`,`b`)
) ENGINE=InnoDB;


-- 主键 a，b的聚簇索引组织顺序相当于 order by a,b ，也就是先按a排序，再按b排序，c无序。
–a--|–b--|–c--|–d--
1 2 3 d
1 3 2 d
1 4 3 d
2 1 3 d
2 2 2 d
2 3 4 d
```



## **非聚集索引(secondary index)**

非主键索引，其实是另外一颗单独的 B+Tree，叶子结点中只存放主键索引的值。

通过非主键索引查找数据时，先去查找索引所在的 B+树上进行查找。然后再根据索引的值，再去主键索引的 B+ 树上进行查找。

第二个过程被称为**回表查询，**即要查询的列不在非主键索引中。

```sql
-- 查看表中的索引详情
SHOW INDEX FROM table_name;
-- 创建唯一索引
ALTER TABLE table_name ADD UNIQUE (column);
```



### Multi-Range Read（MRR）

------

在 secondary index 上进行范围查询或等值查询时，返回的主键索引值可能是无序的。后续的回表查询就变成了随机读。

MRR 要把主键排序，这样之后对磁盘的操作就是由顺序读代替之前的随机读。

从资源的使用情况上来看就是让 CPU 和内存多做点事，来换磁盘的顺序读。然而排序是需要内存的，这块内存的大小就由参数 read_rnd_buffer_size 来控制。

MRR在通过二级索引获取到主键ID后，将ID值放入read_rnd_buffer中，然后对其进行排序，利用排序后的ID数组遍历主键索引查找记录并返回结果集，优化了回表性能。

read_rnd_buffer_size  这是一个内存中的buffer用于分配给每个客户端用的。默认值是 0.25MB，最大值为 2GB

所以不能设置 global 全局变量太大，所以只能客户端自己运行大查询时进行设置。







## **索引覆盖**

索引覆盖（index covering），故名思义，要查询的数据列都在索引树上查询完成了，不需要再回主键的这颗二叉树上进行**回表查询**。

> An index that provides all the necessary results for a query is called a covering index.

**由于覆盖索引可以减少树的搜索次数，显著提升查询性能，所以使用覆盖索引是一个常用的性能优化手段。**

**通常使用联合索引来提升查询性能。**比如有一个市民信息表，身份证号是市民的唯一标识：

```sql
CREATE TABLE `tuser` (
  `id` int(11) NOT NULL,
  `id_card` varchar(32) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `ismale` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_card` (`id_card`),
  KEY `name_age` (`name`,`age`)
) ENGINE=In
```



如果要根据市民身份证号查询市民信息的需求，在身份证号字段上建立索引就够了。

现在如果有一个高频请求，要根据市民的身份证号查询他的姓名，就可以建立



### 联合索引

------

MySQL可以创建联合索引（即在多列上创建索引，一个索引可以包含最多16列。）

联合索引的好处：

- 建一个联合索引 `(col1,col2,col3)`，实际相当于建了 `(col1)`，`(col1,col2)`，`(col1,col2,col3)` 三个索引。每多一个索引，都会增加写操作的开销和磁盘空间的开销。对于大量数据的表，使用联合索引会大大的减少开销！
- 





#### 最左前缀匹配原则

关于最左前缀匹配，有如下原则：

顺序扫描索引

```sql
CREATE TABLE test (
	id INT NOT NULL,
	last_name CHAR(30) NOT NULL,
	first_name CHAR(30) NOT NULL,
	age INT NULL ,    
	PRIMARY KEY (id),
	INDEX name (last_name,first_name,age)
);

-- name 是一个包含了 last_name 和 first_name 列的联合索引。

-- 对于这个表，使用 (last_name) 和 (last_name,first_name) (last_name,first_name,age) 这样的条件才可以走索引

SELECT * FROM test WHERE last_name='Jones';
SELECT * FROM test WHERE last_name='Jones' AND first_name='John';
SELECT * FROM test WHERE last_name='Jones' AND (first_name='John' OR first_name='Jon');
SELECT * FROM test WHERE last_name='Jones' AND first_name >='M' AND first_name < 'N';
select * FROM test where last_name like '张%' and age=10 ;

-- 下面的查询无法用到这个索引
SELECT * FROM test WHERE first_name='John';
SELECT * FROM test WHERE last_name='Jones' OR first_name='John';
```





## 前缀索引

我们在给一个字段加索引的时候，实际上仅可以针对字段的前 n 位加索引。使用 `col_name(N)` 这样的格式。

**在 varchar , blob , text 等类型的字段上建立索引时，必须指定索引长度，没必要对全字段建立索引，根据实际文本区分度决定索引长度即可。**

**索引长度和区分度其实是相互矛盾的。**

索引长度过短，那么区分度就很低，查找时扫描的行越多，把索引长度加长，区分度就高，但是索引占用空间大，因此要掌握一个平衡点。

索引其实都是排好序的数据结构，若是区分度高排序越快，区分度越低，排序慢；

举个例子： （张，张三，张三哥），如果索引长度取1的话，那么每一行的索引都是 张 这个字，完全没有区分度，你让它怎么排序？

结果这样三行完全是随机排的，因为索引都一样；

如果长度取2，那么排序的时候至少前两个是排对了的，如果取3，区分度达到100%，排序完全正确；

等等，那你说是不是索引越长越好？ 答案肯定是错的。

比如 (张,李,王) 和 （张三啦啦啦，张三呵呵呵，张三呼呼呼）；

前者在内存中排序占得空间少，排序也快，后者明显更慢更占内存，在大数据应用中这一点点都是很恐怖的；



### 前缀索引优化原则

------

索引长度的判断公式：

test是要加索引的字段，5是索引长度，

```sql
-- 查询表中某个字段最长的记录
select  `字段`, length(`字段`)  from 表名  where  length(`字段`) = ( select max(length(`字段`)) from 表名  )
-- 查询表中某个字段最短的记录
select  `字段`, length(`字段`)  from 表名  where  length(`字段`) = ( select min(length(`字段`)) from 表名  )

-- left函数取test字段的前5位，对前5位去重，这个
select count(distinct left(test,5))/count(*) from table;  

-- 随着索引字段长度的扩大，这个区分度的值是越来越趋近于1，等于1即表示


-- 给字段指定前10位加索引
CREATE TABLE test (blob_col BLOB, INDEX(blob_col(10)));


```



## 索引基数

了解前缀索引之后，了解一下索引基数

**索引基数**（cardinality）：索引中不重复的索引值的数量；

例如，例如，某个数据列包含值1、3、7、4、7、3，	那么它的**索引基数**就是4。

**索引基数相对于数据表行数较高（也就是说，列中包含很多不同的值，重复的值很少，值很分散）的时候，它的工作效果最好。**

- 如果某数据列含有很多不同的年龄，索引会很快地分辨数据行。

- 如果某个数据列用于记录性别（只有”M”和”F”两种值），那么索引的用处就不大。

- 如果值出现的几率几乎相等，那么无论搜索哪个值都可能得到一半的数据行。

  在这些情况下，最好根本不要使用索引，因为查询优化器发现某个值出现在表的数据行中的百分比很高的时候。

  它一般会忽略索引，进行全表扫描。惯用的百分比界线是”30%”。



使用 show index from table 语句，





## **索引维护的代价**

索引维护，B+树为了维护索引有序性，在插入新值的时候需要做必要的维护。

如果你的主键的值是不连续的，那么在插入索引的时候，就要有移动B+树上节点的操作。

如果插入值时父节点所在的数据页已经满了，根据B+树的算法，这时候需要申请一个新的数据页，然后挪动部分数据过去。

**这个过程称为页分裂。在这种情况下，性能自然会受影响。**

除了性能外，页分裂操作还影响数据页的利用率。原本放在一个页的数据，现在分到两个页中，整体空间利用率降低大约50%。

**当然有分裂就有合并。当相邻两个页由于删除了数据，利用率很低之后，会将数据页做合并。合并的过程，可以认为是分裂过程的逆过程。**



### 自增主键

------



自增主键是指自增列上定义的主键，在建表语句中一般是这么定义的：

```sql
`rid` int(11)  NOT NULL  AUTO_INCREMENT,
PRIMARY KEY (`id`),
```

插入新记录的时候可以不指定 ID 的值，系统会获取当前 ID 最大值加 1 作为下一条记录的 ID 值。

也就是说，自增主键的插入数据模式，正符合了我们前面提到的递增插入的场景。

每次插入一条新记录，都是追加操作，都不涉及到挪动其他记录，也不会触发叶子节点的分裂。

而用业务逻辑的字段做主键，则往往不容易保证有序插入，这样写数据成本相对较高。

除了性能外，还可以从存储空间来看，假设表中确实有一个唯一字段。

比如字符串类型的身份证号，那应该用身份证号做主键，还是用自增字段做主键呢？



**为什么不建议过长的字段做主键？**

由于每个非主键索引的叶子节点上都是主键的值。如果用身份证号做主键，

那么每个二级索引的叶子节点占用约20个字节，而如果用整型做主键，则只要4个字节，如果是长整型（bigint）则是8个字节。

**显然，主键长度越小，普通索引的叶子节点就越小，普通索引占用的空间也就越小。**

**所以从性能和存储来看，自增主键往往是更合适的选择。**











## 索引下推（ICP）

在联合索引的最左前缀匹配时，以 INDEX name (last_name,first_name,age) 这个索引为例。有如下查询

```sql
select * FROM test where last_name like '张%' and age=10 ;
```

在 5.6 之前，这个语句在搜索索引树的时候，使用第一个字段的条件去匹配。找到所有匹配的行，逐行去主键索引上找到数据行，对比后面的条件。

在 5.6 之后，MySQL 引入了**索引下推**优化，可以在索引遍历的过程中，对索引包含的字段先做判断，过滤掉不满足要求的行，减少回表次数。



# 优化器提示（Optimizer Hints）



# 索引提示(index hint)



MySQL 可以使用索引提示（Index Hints）， 用于告诉**查询优化器**在查询中如何选择索引。

索引提示只能用于 select 和 update 语句中。MySQL 共有三种索引提示，分别是：USE INDEX、IGNORE INDEX和FORCE INDEX。

- use index(index_list)  告诉MySQL用索引列表中的其中一个索引去做本次查询

  - ```sql
    -- 强制使用这两个索引去进行查找
    SELECT * FROM table1 USE INDEX (col1_index,col2_index)
      WHERE col1=1 AND col2=2 AND col3=3;
    ```

- ignore index：ignore index告诉mysql不要使用某些索引去做本次查询

  - ```sql
    SELECT * FROM table1 IGNORE INDEX (col3_index)
    WHERE col1=1 AND col2=2 AND col3=3;
    ```

- force index：force index和use index功能类似，都是告诉mySQL去使用某些索引。

  - force index 和 use index 的区别是，如果使用force index，那么全表扫描就会被假定为需要很高代价，除非不能使用索引，否则不会考虑全表扫描；
  
  - 而使用 use index 的话，如果MySQL觉得全表扫描代价更低的话，仍然会使用全表扫描。
  
  - ```sql
    SELECT * FROM table1 FORCE INDEX (col3_index)
    WHERE col1=1 AND col2=2 AND col3=3;
    ```





### 索引提示的用途

可以在索引提示的后边使用FOR语句指定提示的范围，索引提示共有三种适用范围，分别是FOR JOIN、FOR ORDER BY、FOR GROUP BY：

  

# MySQL优化器开关



```sql
SELECT @@optimizer_switch;

index_merge=on,
index_merge_union=on,
index_merge_sort_union=on,
index_merge_intersection=on,
engine_condition_pushdown=on
index_condition_pushdown=on,
mrr=on,
mrr_cost_based=on,
block_nested_loop=on,
batched_key_access=off,
materialization=on,
semijoin=on,
loosescan=on,
firstmatch=on,
duplicateweedout=on,
subquery_materialization_cost_based=on,
use_index_extensions=on,
condition_fanout_filter=on,
derived_merge=on,
use_invisible_indexes=off,
skip_scan=on,
hash_join=on


-- 修改优化器
SET [GLOBAL|SESSION] optimizer_switch='command[,command]...';

-- command语法如下：
-- default          --重置为默认
-- opt_name=default	--选项默认 
-- opt_name=off	    --关掉某项优化
-- opt_name=on	    --开启某项优化

```









# 尽量避免全表扫描

https://cloud.tencent.com/developer/article/1404687

http://zhongmingmao.me/2019/03/08/mysql-full-table-scan/

在 expain 查看一个 SQL 的执行计划时，如果 type 字段是 ALL ，则会进行全表扫描。

SQL 优化的一条最基本的原则就是，当真正出现性能问题时或者影响到业务时，才考虑优化。



全表扫描的情况：

- 表足够小，数据量足够少，全表扫描的速度甚至比索引查找还要快。通常是 10 行之内的表。
- on 连接的字段，或者 where 条件的字段没有索引列，或者根本不带 where 条件。
- 





# MySQL优化准则

https://github.com/kekobin/blog/issues/87



https://github.com/Snailclimb/JavaGuide/blob/master/docs/database/MySQL%E9%AB%98%E6%80%A7%E8%83%BD%E4%BC%98%E5%8C%96%E8%A7%84%E8%8C%83%E5%BB%BA%E8%AE%AE.md





# 性能优化概述

数据库性能优化在数据库层面有很多因素，例如，表，查询语句，数据库配置等。

数据库操作最终是作用在硬件层面的CPU和磁盘的IO操作上。所以要尽可能让开销足够小。





## 数据库层面的优化



- 表结构设计是否合理？是否满足三范式？范式和反范式的设计？https://www.zhihu.com/question/19900437
  - 字段的数据类型是否合适？
  - 经常更新的应用应该设计为多个表，很少列。数据分析的应该设计为大宽表。
- 索引设计是否合理？

- 是否选用合适的存储引擎？

- 表是否有正确的row格式？

## 顺序索引

为了快速随机访问文件中的记录，可以使用索引结构，每个索引结构与一个特定的搜索码关联。

被索引的文件











# 索引失效的原因



- 索引列字段数据类型不一致
  - 

- 字符集不一致





# MySQL 多表连接



驱动表的概念是指多表关联查询时，第一个被处理的表，使用此表的记录去关联其他表。驱动表的确定很关键，会直接影响多表连接的关联顺序，也决定了后续关联时的查询性能。



驱动表的选择遵循一个原则：**`在对最终结果集没影响的前提下，优先选择结果集最小的那张表作为驱动表`**。

改变驱动表就意味着改变连接顺序，只有在不会改变最终输出结果的前提下才可以对驱动表做优化选择。



https://blog.csdn.net/lkforce/article/details/102940091



## 连接查询

写过或者学过 SQL 的人应该都知道 left join，知道 left join 的实现的效果，就是保留左表的全部信息，然后把右表往左表上拼接，如果拼不上就是 null。

除了 left join 以外，还有 inner join、outer join、right join，这些不同的 join 能达到的什么样的效果，大家应该都了解了，如果不了解的可以看看网上的帖子或者随便一本 SQL 书都有讲的。

今天我们不讲这些 join 能达到什么效果，我们主要讲这些 join 的底层原理是怎么实现的，也就是具体的效果是怎么呈现出来的。



join 主要有 Nested Loop、Hash Join、Merge Join 这三种算法方式，我们这里先讲最普遍的，也是最好的理解的 Nested Loop join 。

Nested Loop join 翻译过来就是**嵌套循环连接**的意思，那什么又是嵌套循环呢？嵌套大家应该都能理解，就是一层套一层；那循环呢，你可以理解成是 for 循环。

Nested Loop 里面又有三种细分的连接方式，分别是 Simple Nested-Loop Join、Index Nested-Loop Join、Block Nested-Loop Join，接下来我们就分别去看一下这三种细分的连接方式。



在正式开始之前，先介绍两个概念：

驱动表（也叫外表）和被驱动表（也叫非驱动表，还可以叫匹配表，亦可叫内表），简单来说，驱动表就是主表，left join 中的左表就是驱动表，right join 中的右表是驱动表。

一个是驱动表，那另一个就只能是非驱动表了，在 join 的过程中，其实就是从驱动表里面依次（注意理解这里面的依次）取出每一个值，然后去非驱动表里面进行匹配，那具体是怎么匹配的呢？这就是我们接下来讲的这三种连接方式。









## Simple Nested-Loop Join



Simple Nested-Loop Join 是这三种方法里面最简单，最好理解，也是最符合大家认知的一种连接方式，现在有两张表 table A 和 table B，我们让 **table A left join table B**，如果是用第一种连接方式去实现的话，会是怎么去匹配的呢？直接上图：



![img](assets/1153954-20201210195552830-1911874625.png)



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

1. 使用场景：只有内层表 join 的列有索引时，才能用到 Index Nested-LoopJoin 进行连接。
2. 由于用到索引，如果索引是辅助索引而且返回的数据还包括内层表的其他数据，则会回内层表查询数据，多了一些IO操作。
3. 





MySQL8.0正式引入了Hash Join 的连接方式。





## 实例



```sql
-- 建表t2
CREATE TABLE `t2` (
  `id` int(11) NOT NULL,
  `a` int(11) DEFAULT NULL,
  `b` int(11) DEFAULT NULL,
  `c` int(11) DEFAULT NULL,
  `d` int(11) DEFAULT NULL, 
  PRIMARY KEY (`id`),
  KEY `a` (`a`),
  KEY `b` (`b`),
  KEY `c` (`c`),
  KEY `d` (`d`)
) ENGINE=InnoDB;


-- t2测试数据
delimiter ;;
create procedure idata2()
begin
  declare i int;
  set i=1;
  while(i<=1000)do
    insert into t2 values(i, i+1, i+2, i+2, i+4);
    set i=i+1;
  end while;
end;;

delimiter ;

-- 调用存储过程
call idata2();


-- 建表t1
create table t1 like t2;
insert into t1 (select * from t2 where id<=100);


-- t1的存储过程，插入数据
delimiter ;;
create procedure idata()
begin
  declare i int;
  set i=2000;
  while(i<=3000)do
    insert into t1 values(i, i, i);
    set i=i+1;
  end while;
end;;

delimiter ;

-- 调用存储过程
call idata();




-- t1 的数据  1-100  2000-3000  一共是1101条数据
-- t2 的数据  1-1000  一共是1000条数据

-- 直接多表查询，笛卡尔积：1101*1000 条数据，一般很少有这样的查询
select *  from t1 , t2   



-- 连表查询，匹配到了1-100这100行数据
select count(*)  from t1  join t2 on  t1.id=t2.id

-- 查看执行计划
explain select count(*)  from t1  join t2 on  t1.id=t2.id

-- 对于t2



```



















