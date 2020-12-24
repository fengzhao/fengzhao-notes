# Select 优化



# range优化





# 索引合并优化





当单表使用了多个索引，每个索引都可能返回一个结果集，mysql会将其求交集或者并集，或者是交集和并集的组合。也就是说一次查询中可以使用多个索引。



```sql
SELECT * FROM tbl_name WHERE key1 = 10 OR key2 = 20;

SELECT * FROM tbl_name
  WHERE (key1 = 10 OR key2 = 20) AND non_key = 30;

SELECT * FROM t1, t2
  WHERE (t1.key1 IN (1,2) OR t1.key2 LIKE 'value%')
  AND t2.key1 = t1.some_col;
  
  
-- 对于第一条语句：使用索引并集访问算法，得到key1=10的主键有序集合，得到key2=20的主键有序集合，再进行求并集；最后回表

-- 对于第二条语句：先丢弃non_key=30,因为它使用不到索引，where语句就变成了where key10 or key2=20,使用索引先根据索引合并并集访问算法

-- 
```







### index merge intersection access algorithm（索引合并交集访问算法）



对于每一个使用到的索引进行查询，查询主键值集合，然后进行合并，求交集，也就是and运算。下面是使用到该算法的两种必要条件：



- **在二级索引列上进行等值查询**；如果是组合索引，组合索引的每一位都必须覆盖到，不能只是部分

  ```sql
  key_part1 = const1 AND key_part2 = const2 ... AND key_partN = constN
  ```

  

- InnoDB表上的主键范围查询条件



```sql
-- 例子

-- 主键可以是范围查询，二级索引只能是等值查询

SELECT * FROM innodb_table
  WHERE primary_key < 10 AND key_col1 = 20;

-- 没有主键的情况
SELECT * FROM tbl_name
  WHERE key1_part1 = 1 AND key1_part2 = 2 AND key2 = 2;
```





