# MySQL字符集



## 字符集和校验规则



### 1.1、二进制

binary 。计算机底层存储数据只是一大堆二进制的0和1。

### 1.2、字符

character 。现在有各种各样的字符，包括英文字母，英文数字，中文，emoji 等等。

### 1.3、字符集

character set 。想要把各种人类可以理解的字符存储到计算机中，就需要建立字符与二进制数字的映射关系。

字符集就是这样的一种映射关系，不同的字符集表示的字符数量不同，字符集越大，所能表示的字符越多，需要占用的二进制位更多，需要的磁盘空间就越大。

MySQL中所支持的字符集存在 `information_schema.CHARACTER_SETS` 表中。

utf8 是 MySQL 中的一种字符集，只支持最长三个字节的 UTF-8 字符，也就是 Unicode 中的基本多文本平面。

其中 utf8mb4 字符集兼容性最好，它可以存各种语言的字符，包括 emoji 表情等。一般都可以直接使用 utf8mb4  字符集。

```shell
CREATE TABLE `article` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(120) NOT NULL DEFAULT '' COMMENT '标题',
  `abstract` varchar(600) NOT NULL DEFAULT '' COMMENT '摘要',
  `created_at` int(11) NOT NULL DEFAULT '0',
  `updated_at` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='文章表'



INSERT INTO article (title) VALUES ('😄');

```



**MySQL中常见的字符集**

- utf8mb4         **在 MySQL 中，uft8mb4 字符集就是国际上的 `UTF-8`，最多每字符最多占四个字节。**   

- gbk/gb2312   

 



### 1.4、校验规则(排序规则)

collation 。检验规则，又称排序规则，是用于比较字符和排序的一套规则，即字符的排序规则。比如有的规则区分大小写，有的则无视。

如果指定校验规则为"不区分大小写"，那么a和A，e和E就是等价的。

世界上的文字很多，所以才会有“不区分音调”的要求，这时候e、ē、é、ě、è就是等价的。

那么假设我们要进行拼音查找，只要按e去找就可以全部列出来，很方便。甚至，它们也和ê、ë也是等价的，这样就更方便了。

每种字符集都可能有多种检验规则，并且都有一个默认的检验规则(information_schema. CHARACTER_SETS.DEFAULT_COLLATE_NAME)

**每个校验规则只能用于一个字符集，因此字符集与校验规则是一对多的关系。**

校验规则存储在  information_schema. COLLATIONS 表中。一般使用  utf8mb4_general_ci 排序规则。

排序规则命名惯例：字符集名\_对应的语言排序规则_ai/as/ci/cs/ks/bin

​	

- ai  口音不敏感（accent-sensitive ）（）
- 口音不敏感
- 大写敏感
- 小写敏感
- 

​	语言名一般都是用 general 	

​	其中ci表示大小写不敏感性，cs表示大小写敏感性，bin表示二进制。

​	按字母排序，或者按照二进制排序



utf8mb4_tr_0900_ai_ci

utf8mb4_hu_0900_ai_ci

utf8mb4_turkish_ci

utf8mb4_hungarian_ci

## 英文排序规则





## 中文字段排序和比较

要进行中文排序，比如通讯录里面的排序列表。啊XX 排到 曾XX 等等。

如果存储汉字的字段编码使用的是GBK字符集，因为GBK内码编码时本身就采用了拼音排序的方法

（常用一级汉字3755个采用拼音排序，二级汉字就不是了，但考虑到人名等都是常用汉字，因此只是针对一级汉字能正确排序也够用了）.

直接在查询语句后面添加 `ORDER BY name ASC`，查询结果将按照姓氏的升序排序；



如果存储字段的不是采用 GBK 编码 。需要在排序的时候对字段进行转码，对应的 SQL 是 `ORDER BY convert(name using gbk) ASC `





```sql
mysql root@localhost:information_schema> select count(*) from `COLLATIONS`;
+----------+
| count(*) |
+----------+
| 219      |
+----------+
1 row in set
Time: 0.026s
mysql root@localhost:information_schema>
mysql root@localhost:information_schema>
mysql root@localhost:information_schema> select count(*) from `CHARACTER_SETS`;
+----------+
| count(*) |
+----------+
| 40       |
+----------+
1 row in set
Time: 0.026s
mysql root@localhost:information_schema> 
```

### 1.5、字符集和排序规则继承

MySQL的字符集和排序规则分为实例级别，数据库级别，表级别，列级别



## 2、查看字符集



### 2.1、查看服务器支持的字符集

```sql
mysql> show character set;
mysql> select * from information_schema.character_sets;
```

### 2.2、查看字符集的校验规则

```sql
mysql> show collation;
mysql> show collation like 'utf8';
mysql> select * from information_schema.collations where collation_name like 'utf8%';
```

### 2.3、查看当前数据库的字符集

```sql
mysql root@localhost:(none)> use information_schema;
You are now connected to database "information_schema" as user "root"
Time: 0.001s
mysql root@localhost:information_schema> show variables like 'character%';
+--------------------------+----------------------------------+
| Variable_name            | Value                            |
+--------------------------+----------------------------------+
| character_set_client     | utf8                             |
| character_set_connection | utf8                             |
| character_set_database   | utf8                             |
| character_set_filesystem | binary                           |
| character_set_results    | utf8                             |
| character_set_server     | utf8                             |
| character_set_system     | utf8                             |
| character_sets_dir       | /usr/local/mysql/share/charsets/ |
+--------------------------+----------------------------------+
8 rows in set
Time: 0.028s
mysql root@localhost:information_schema> use db_explorer;
You are now connected to database "db_explorer" as user "root"
Time: 0.001s
mysql root@localhost:db_explorer> show variables like 'character%';
+--------------------------+----------------------------------+
| Variable_name            | Value                            |
+--------------------------+----------------------------------+
| character_set_client     | utf8                             |
| character_set_connection | utf8                             |
| character_set_database   | utf8mb4                          |
| character_set_filesystem | binary                           |
| character_set_results    | utf8                             |
| character_set_server     | utf8                             |
| character_set_system     | utf8                             |
| character_sets_dir       | /usr/local/mysql/share/charsets/ |
+--------------------------+----------------------------------+
8 rows in set
Time: 0.021s

```

character_set_client：客户端请求数据的字符集
character_set_connection：客户机/服务器的连接字符集
character_set_database：当前选中库的字符集
character_set_filesystem：把os上文件名转化成此字符集，即把 character_set_client转换character_set_filesystem， 默认binary是不做任何转换的

character_set_results：结果集，返回给客户端的字符集
character_set_server：数据库服务器的默认字符集
character_set_system：系统字符集，这个值总是utf8，不需要设置。这个字符集用于数据库对象（如表和列）的名字，也用于存储在目录表中的函数的名字。







MySQL字符集转换过程









# 参考



https://www.lifesailor.me/archives/2676.html