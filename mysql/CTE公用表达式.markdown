## 公用表达式

MySQL 8.0 引入CTE(Common Table Expression)功能，CTE除了替代派生表以外，还有一个重要的功能，实现递归查询。

在数据库中，我们经常使用子查询和派生表来进行查询。

```sql
-- 派生表（子查询）

-- from后面跟的表是通过其他查询查出来的，这叫派生表，派生表必须要有别名，以便稍后在查询中引用其名称。
-- 派生表是从 select 语句中返回的虚拟表。
SELECT 
    column_list
FROM
    (SELECT 
        column_list ...
    FROM
        table_1) derived_table_name;
WHERE derived_table_name.c1 > 0;


-- 子查询的CTE写法
-- CTE 将子查询的结果集用 with 语句提出来，取一个别名，再在后面的语句中使用
with derived(...) as (
	subquery
) 
select ... from derived, table_name ……;


-- CTE 可以引用其他CTE
with derived_one as (
	subquery
),
derived_two as (
	select …… from derived_one
)
select …… from derived_one, derived_two ……;



```



### 递归CTE

递归 CTE 是一种特殊的 CTE，其子查询会引用自己的名字。

`WITH`子句必须以`WITH RECURSIVE`开头。

递归CTE子查询包括两部分：`seed查询`和`recursive查询`，由`UNION[ALL]`或`UNION DISTINCT`分隔。



```sql
-- 语法
with recursive derived(n) as (
 select 1  
 union all 
 select n + 1 from derived where n < 5  
)
 select * from derived;



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
     select id, name, cast(id as char(200))
     from db_test.employees_mgr
     where manager_id is null
     union all
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



















