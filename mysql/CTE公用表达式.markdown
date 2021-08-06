## 子查询

在数据库中，我们经常使用子查询和派生表来进行查询。

```sql
-- 子查询

-- 在另一个查询(外部查询)中嵌套另一个查询语句(内部查询)，并使用内部查询的结果值作为外部查询条件。
-- 子查询在where中
-- where条件比对的值是从其他表查出来的。

SELECT 
       customerNumber, checkNumber, amount
FROM
   　　 payments
WHERE
 　　   amount = (SELECT  MAX(amount) FROMpayments);


-- 标量子查询 （一行一列）
-- 那些只返回一个单一值的子查询称之为标量子查询：子查询里面的查询结果只返回一行一列一个值的情况。
SELECT (SELECT m1 FROM e1 LIMIT 1);
SELECT * FROM e1 WHERE m1 = (SELECT MIN(m2) FROM e2);
SELECT * FROM e1 WHERE m1 < (SELECT MIN(m2) FROM e2);


-- 行子查询（一行多列）
-- 顾名思义，就是返回一条记录的子查询，不过这条记录需要包含多个列（只包含一个列就成了标量子查询了）。
-- 其中的(SELECT m2, n2 FROM e2 LIMIT 1)就是一个行子查询
-- 整条语句的含义就是要从 e1 表中找一些记录，这些记录的 m1 和 n1 列分别等于子查询结果中的 m2 和 n2 列
SELECT * FROM e1 WHERE (m1, n1) = (SELECT m2, n2 FROM e2 LIMIT 1);

-- 列子查询（一列数据）
-- 列子查询自然就是查询出一个列的数据，不过这个列的数据需要包含多条记录
-- 其中的(SELECT m2 FROM e2)就是一个列子查询，表明查询出 e2 表的 m2 列 的所有值作为外层查询 IN 语句的参数。
SELECT * FROM e1 WHERE m1 IN (SELECT m2 FROM e2);

-- 表子查询（二维多行多列）
-- 顾名思义，就是子查询的结果既包含很多条记录，又包含很多个列
-- 其中的(SELECT m2, n2 FROM e2)就是一个表子查询、此sql必须要在m1，n1都满足的条件下方可成立
SELECT * FROM e1 WHERE (m1, n1) IN (SELECT m2, n2 FROM e2);


-- From子句中的子查询
-- 派生表（子查询）
-- from后面跟的表是通过其他查询查出来的，这叫派生表，派生表必须要有别名，以便稍后在查询中引用其名称。
-- 派生表是从 select 语句中返回的虚拟表。
SELECT 
    column_list
FROM
    (SELECT column_list ... FROM table_1) derived_table_name
WHERE derived_table_name.c1 > 0;







-- WITH AS短语，也叫做子查询部分（subquery factoring），可以让你做很多事情，定义一个SQL片断，该SQL片断会被整个SQL语句所用到。
-- 有的时候，是为了让SQL语句的可读性更高些，也有可能是在UNION ALL的不同部分，作为提供数据的部分。
-- 因为UNION ALL的每个部分可能相同，但是如果每个部分都去执行一遍的话，则成本太高，所以可以使用WITH AS短语，则只要执行一遍即可。
-- 如果WITH AS短语所定义的表名被调用两次以上，则优化器会自动将WITH AS短语所获取的数据放入一个TEMP表里，如果只是被调用一次，则不会。
-- 而提示materialize则是强制将WITH AS短语里的数据放入一个全局临时表里。很多查询通过这种方法都可以提高速度。


-- 看一个简单的子查询

select * from person.StateProvince where CountryRegionCode in
         (select CountryRegionCode from person.CountryRegion where Name like 'C%')

 

-- 上面的查询语句使用了一个子查询。虽然这条SQL语句并不复杂，但如果嵌套的层次过多，会使SQL语句非常难以阅读和维护。
-- 因此，也可以使用表变量的方式来解决这个问题，SQL语句如下：

declare @t table(CountryRegionCode nvarchar(3))
insert into @t(CountryRegionCode)  (select CountryRegionCode from person.CountryRegion where Name like 'C%')

select * from person.StateProvince where CountryRegionCode
                     in (select * from @t)
-- 虽然上面的SQL语句要比第一种方式更复杂，但却将子查询放在了表变量@t中，这样做将使SQL语句更容易维护，但又会带来另一个问题，就是性能的损失。
-- 由于表变量实际上使用了临时表，从而增加了额外的I/O开销，因此，表变量的方式并不太适合数据量大且频繁查询的情况


-- CTE写法，将子查询语句前置到最前面

with cr as (
    select CountryRegionCode from person.CountryRegion where Name like 'C%'
)
select * from person.StateProvince where CountryRegionCode in (select * from cr)


-- 子查询的CTE写法
-- CTE 将子查询的结果集用 with 语句提到最前面，取一个别名，再在后面的语句中使用
with derived(...) as (
	subquery
) 
select ... from derived, table_name1 ……;


-- CTE 可以引用其他CTE
with derived_one as (
	subquery
),
derived_two as (
	select …… from derived_one
)
select …… from derived_one, derived_two ……;



```



## CTE通用表达式

Common table expression简称CTE，由SQL:1999标准引入。

可以认为是在单个 SELECT、INSERT、UPDATE、DELETE 或 CREATE VIEW 语句的执行范围内定义的临时结果集。

CTE 与派生表类似，具体表现在不存储为对象，并且只在查询期间有效。与派生表的不同之处在于，CTE 可自引用，还可在同一查询中引用多次。



MySQL 8.0 引入CTE(Common Table Expression)功能，CTE除了替代派生表以外，还有一个重要的功能，实现递归查询。



- 



通用表达式使用`WITH`子句进行定义，该子句可以包含一个或多个逗号分隔的从句。

每个从句包含一个子查询，以及指定的名称。以下示例在`WITH`子句中定义了两个 CTE：cte1 和 cte2，然后在顶层`SELECT`中进行引用

```sql

WITH
  cte1 AS (SELECT a, b FROM table1),
  cte2 AS (SELECT c, d FROM table2)
SELECT b, d FROM cte1 JOIN cte2
WHERE cte1.a = cte2.c;


-- 列表中的名称数量必须与查询结果中的字段数量相同
WITH cte (col1, col2) AS
(
  SELECT 1, 2
  UNION ALL
  SELECT 3, 4
)
SELECT * FROM cte;


-- 如果with定义表时没有字段，则表字段名称由 AS (subquery) 中的第一个SELECT语句决定
WITH cte AS
(
  SELECT 1 AS col1, 2 AS col2
  UNION ALL
  SELECT 3, 4
)
SELECT col1, col2 FROM cte;


-- 在同一个语句级别中只允许存在一个WITH子句，有效的语法格式是为一个WITH子句定义多个从句，使用逗号进行分隔：





-- 在包含WITH子句的查询中，可以使用CTE的名称访问相应 CTE 的结果集。
-- 前面定义的CTE可以在其他的CTE中进行引用，因此 CTE 可以基于前面的 CTE 进行定义。
-- 引用自己的 CTE 被称为递归 CTE。递归 CTE 的使用场景包括生成序列，遍历层次数据或树状结构的数据。
-- 通用表表达式属于 DML 语句的可选部分。




```



CTE  相较于派生表有 4 个明显的优势：

- 更好的可读性

  - ```sql
    SELECT ...
    FROM t1 LEFT JOIN ((SELECT ... FROM ...) AS dt JOIN t2 ON ...) ON ...
    
    
    WITH dt AS (SELECT ... FROM ...)
    SELECT ...
    FROM t1 LEFT JOIN (dt JOIN t2 ON ...) ON ...
    ```

    

- 可以被多次引用

  - ```sql
    -- 传统派生表子查询写法：每个子查询都要写完成SQL
    
    SELECT ...
    FROM (SELECT a, b, SUM(c) s FROM t1 GROUP BY a, b) AS d1
    JOIN (SELECT a, b, SUM(c) s FROM t1 GROUP BY a, b) AS d2 ON d1.b = d2.a;
    
    -- CTE写法：一次生成，多次引用
    
    WITH d AS (SELECT a, b, SUM(c) s FROM t1 GROUP BY a, b)
    SELECT ... FROM d AS d1 JOIN d AS d2 ON d1.b = d2.a;
    ```

    

- 可以引用其他的 CTE

  - ```sql
    -- 传统这种不行，会报表不存在，要用更复杂的子查询
    SELECT ...
    FROM (SELECT ... FROM ...) AS d1, (SELECT ... FROM d1 ...) AS d2 ...
    
    
    -- 派生表写法
    WITH d1 AS (SELECT ... FROM ...),
    d2 AS (SELECT ... FROM d1 ...)
    SELECT
    FROM d1, d2 ...
    ```

  - 

- 性能的提升



### 递归CTE

递归 CTE 是一种特殊的 CTE，其子查询会引用自己的名字。

`WITH`子句必须以`WITH RECURSIVE`开头。

递归CTE子查询包括两部分：`seed查询`和`recursive查询`，由`UNION[ALL]`或`UNION DISTINCT`分隔。



```sql
-- 递归CTE
with recursive derived(n) as (
 select 1  
 union all 
 select n + 1 from derived where n < 5  
)
 select * from derived;

-- 以上语句的执行结果是一个连续的数字序列：1,2,3,4,5

-- 如果在WITH子句中引用了自己，WITH子句必须使用WITH RECURSIVE。（如果没有 CTE 引用自己，也可以使用RECURSIVE，但不强制。）

-- 递归 CTE 的子查询由两部分组成，中间使用UNION [ALL]或者UNION DISTINCT进行连接：

-- 第一个SELECT语句用于生成初始数据行，该语句不会引用 CTE 自身。
-- 第二个SELECT语句在它的FROM子句中引用了 CTE自身，通过递归产生更多的结果。
-- 当第二个语句不会产生更多的新数据时结束递归。因此，递归 CTE由一个非递归的SELECT语句和一个递归的SELECT语句组成。
-- CTE最终结果中的字段类型由非递归的SELECT语句决定，所有字段都可以为空。查询结果的字段类型与递归SELECT语句无关。
-- 如果递归部分和非递归部分使用UNION DISTINCT进行连接，查询结果将会排除重复的数据行。
-- 这种方式可以用于执行传递闭包（transitive closure，例如两个地点之间的乘车路线）的查询，防止无限循环。

-- 递归部分的每次迭代只针对上次迭代生成的新数据行进行操作。
-- 如果递归部分包含多个查询块，迭代时每个查询块的执行顺序不固定，每个查询块基于它自己前一次迭代的结果，或者上次迭代结束后其他查询块生成的结果进行操作。


-- 前面递归 CTE 示例中的非递归语句如下，它会产生一条初始化的数据：
SELECT 1
-- 它的递归部分如下：
SELECT n + 1 FROM cte WHERE n < 5
-- 每次迭代时，SELECT语句将会产生一个比上一次结果中的 n 大 1 的新值。
-- 第一次迭代基于初始值（1）进行操作，生成 1+1=2；
-- 第二次迭代基于第一次迭代的结果（2），生成 2+1=3；如此等等。
-- 迭代一直执行到递归结束，此处为 n 的值大于或等于 5。

-- 如果递归部分产生的结果比非递归部分的字段长度更大，需要在非递归部分指定一个更宽的字段类型，避免数据被截断。












-- 假设用树形结构来描述一个部门的组织架构

-- DDL  用id来标识一个人，用manager_id来表示向上一个人汇报
CREATE TABLE db_test.employees_mgr (
	id INT PRIMARY KEY NOT NULL,
	name VARCHAR ( 100 ) NOT NULL,
	manager_id INT NULL,
	INDEX ( manager_id ),
	FOREIGN KEY ( manager_id ) REFERENCES employees_mgr ( id ) 
);


-- test data
insert into db_test.employees_mgr values 
(333, "Yasmina", null), /* Yasmina is the CEO (manager_id is null) */
(198, "John", 333),     /* John has id 198 and reports to 333 (Yasmina) */
(692, "Tarek", 333),    /* Tarek has id 692 and reports to 333 (Yasmina) */
(29, "Pedro ", 198),    /* Pedro has id 29 and reports to 198 (John) */
(4610, "Sarah", 29);    /* Sarah has id 4610 and reports to 29 (Pedro) */


-- 要查询出如下这种树形结果
                       
+------+---------+--------------------+                                                                                                                                                                          
| id   | name    | path               |                                                                                               
+------+---------+--------------------+                                                                
|  333 | Yasmina | 333                |                                                                                           
|  198 | John    | 333->198           |                                                                                            
|  692 | Tarek   | 333->692           |                                                                                           
|   29 | Pedro   | 333->198->29       |                                                                                              
| 4610 | Sarah   | 333->198->29->4610 |                                                                                             
+------+---------+--------------------+                                                                                                 
5 rows in set (0.00 sec)                                                                                              
mysql>   




-- MySQL8.0中支持with子句
-- 通过递归CTE来查询用户的层级关系
-- 规划一个ID，name，path这样的一个层级临时表
 with recursive employee_paths (id, name, path) as (
     --先查最顶层节点
     select id, name, cast(id as char(200))
     from db_test.employees_mgr
     where manager_id is null
     union all
     -- 递归查询
     select e.id, e.name, concat(ep.path, '->', e.id)
     from employee_paths as ep
     join db_test.employees_mgr as e
     on ep.id = e.manager_id
    )
     select * from employee_paths;




```







比如有

订单表（*订单编号，下单日期，要求送达日期，实际送达日期，订单状态，备注，客户名称）

订单详情表（*订单编号，\*产品编号，产品数量，销售单价，）





产品表（产品编号，产品名称，生产线，生产比例，生产厂商，产品描述，库存数量，进货价，建议零售价）

订单表和订单详情表是一对多的关系，订单详情表中的一行记录是一个订单中的一类产品。



获取2013年销售收入最高的前五名产品



```sql
-- 首先，让订单表跟订单详情表关联查出2013的订单详情数据
-- 订单详情表里面记录了产品编码，产品数量，产品单价
-- 所以先对订单详情表按照产品编号分组，然后给产品销售额求和
-- 最后desc排序，找到销售收入最高的前五名的产品编号
-- 再将该结果与产品表关联查询，查出产品详细情况

-- 第一步
SELECT
	* 
FROM
	orderdetails
	INNER JOIN orders USING ( orderNumber ) 
WHERE
	YEAR ( shippedDate ) = 2013
		

-- 第二步
SELECT 
    productCode, 
    ROUND(SUM(quantityOrdered * priceEach)) sales
FROM
    orderdetails
        INNER JOIN
    orders USING (orderNumber)
WHERE
    YEAR(shippedDate) = 2013
GROUP BY productCode
ORDER BY sales DESC
LIMIT 5;

-- 第三步
SELECT 
    productName, sales
FROM
    (SELECT 
        productCode, 
        ROUND(SUM(quantityOrdered * priceEach)) sales
    FROM
        orderdetails
    INNER JOIN orders USING (orderNumber)
    WHERE
        YEAR(shippedDate) = 2013
    GROUP BY productCode
    ORDER BY sales DESC
    LIMIT 5) top5products2013
INNER JOIN
    products USING (productCode);




```



















