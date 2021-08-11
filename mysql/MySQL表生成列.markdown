# 生成列简介

https://blog.csdn.net/qq_32392597/article/details/108200778

SQL 建表语句支持指定的生成列，列的取值由其定义计算出来的。



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
```





- Virtual（虚拟）：这个类型的列会在读取表记录时自动计算此列的结果并返回。
- Stored（存储）：这个类型的列会在表中插入一条数据时自动计算对应的值，并插入到这个列中，那么这个列会作为一个常规列存在表中。