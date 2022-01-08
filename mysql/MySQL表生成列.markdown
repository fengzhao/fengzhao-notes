# 生成列简介

https://blog.csdn.net/qq_32392597/article/details/108200778

**在 SQL 数据库中，生成列（Generated Column）是指由表中其他字段计算得到的列，因此也称为计算列（Computed Column）**。

在 SQL 建表语句支持指定的生成列，列的取值由其定义计算出来的。



MySQL 5.7 引入了生成列，支持虚拟和存储两种类型的生成列。

- Virtual（虚拟）：这个类型的列会在读取表记录时自动计算此列的结果并返回。
- Stored（存储）：这个类型的列会在表中插入一条数据时自动计算对应的值，并插入到这个列中，那么这个列会作为一个常规列存在表中。

默认创建的是`VIRTUAL`生成列。

```sql

-- 通过sidea和sideb列中直角三角形的边的长度 ，并计算下斜边的长度 sidec（其他边的平方和的平方根）

-- 建表定义直角三角形（长边，短边，斜边（斜边是计算出来的））
CREATE TABLE triangle (
  sidea DOUBLE,
  sideb DOUBLE,
  sidec DOUBLE AS (SQRT(sidea * sidea + sideb * sideb))
);

-- 测试数据
INSERT INTO triangle (sidea, sideb) VALUES(1,1),(3,4),(6,8);


mysql> SELECT * FROM triangle;
+-------+-------+--------------------+
| sidea | sideb | sidec              |
+-------+-------+--------------------+
|     1 |     1 | 1.4142135623730951 |
|     3 |     4 |                  5 |
|     6 |     8 |                 10 |
+-------+-------+--------------------+


-- 表生成列语法
col_name data_type [GENERATED ALWAYS] AS (expr)
  [VIRTUAL | STORED] [NOT NULL | NULL]
  [UNIQUE [KEY]] [[PRIMARY] KEY]
  [COMMENT 'string']
  
-- 其中，GENERATED ALWAYS可以省略；
-- AS定义了生成列的表达式；
-- VIRTUAL表示创建虚拟生成列，虚拟列的值不会存储，而是在读取时BEFORE触发器之后立即计算；
-- STORED表示存储生成列；默认创建的是VIRTUAL生成列。
```









