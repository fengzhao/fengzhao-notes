## SQL连接



## 笛卡尔积

所有可能组合。

假定 player 表的数据是集合X,  SELECT * FROM player

假定 team 表的数据是集合Y,  SELECT * FROM team

SELECT  *  FROM player, team  的结果行数就是 X*Y 







## 自然连接



对于两个表，自然连接是先找出两个表所有共用的属性，然后在**共用属性上做匹配，找出属性相等的行进行连接。（一定要注意连接谓词是所有的共有属性集合，即两个表上所有相同的列名）**

```sql
-- 写法一 
select user_name,dept_name from user natural join dept ;

-- 写法二
select user_name,dept_name from  user, dept where user.id = dept.id  ...  -- 所有共有属性都连接起来。

-- 写法一和写法二是等价的

-- select name , id , title from A1 natural join A2 natural join A3
-- select name , id , title from A1 natural join A2 , A3 where A2.id = A3.id 
-- 这两个写法的结果可能不一样，
-- 第一个可以认为将A1 A2进行自然连接的结果，再与A3进行自然连接
-- 第二个可以认为将A1 A2进行自然连接的结果，再与A3进行等值连接 
```





## 等值连接



对两个表，等值连接是**明确一组属性**上进行匹配。然后进行连接。(**连接谓词是在选定的属性集合**)，所以自然连接是一种特殊的等值连接（**自然连接是所有属性都要匹配**）。

这种用法不常见。

```sql
-- 当两个表上有多个列名相同时，用 using 可以指定部分列的匹配。
-- 使用 using 语法 ， select ... from T1 join T2 using(A1,A2,A3 ...)
select  a.user_name, b.dept_name from user a  join dept b  using(id);
-- 使用 join on 关键字，on条件允许在参与连接的关系上设置连接谓词。
select  user_name,dept_name from user join dept on user.id = dept.id and  ;


```



## 内连接



上面这些连接，都是常规连接，都可以理解成内连接，两个表中的列互相匹配时，只按照少的那个表匹配。

当 join 子句中没有 outer 前缀 ，就默认是 inner join 。

```sql
-- tb1 inner join tb1 on something

select  a.user_name, b.dept_name from user a  inner  join dept b on a.dep_id = b.id ;
select  a.user_name, b.dept_name from user a 	     join dept b on a.dep_id = b.id ;

select  a.user_name, b.dept_name from user a 	     join dept b  using(id);



```





## 全外连接

对于两个表，

保留出现在两个关系中的元组，即求两个集合的并集，没有匹配到列为 null 



```sql
-- 显示 Comp.Sci 系所有学生，以及他们在2009年春季选修的所有课程段的列表。2019年春季的所有课程都必须显示，即使没有 Comp.Sci 系的学生选。

-- 很明显这就是一个全外连接的查询，第一个查询集是  Comp.Sci 系所有学生 ，第二个查询集是  2019年春季的所有课程
select * from (select * from students where dept_name='Comp.Sci') natural outer full 


```



## 左外连接

只保留出现在左外连接运算之前的关系中的元组，即左表有多少行符合条件就匹配多少行。左表存在的，右表都返回 Null 。



```sql
-- 在学生表和选课表的例子中，找出所有学生和他们的选课情况。如果有学生没选课，那么从这个学生的选课情况就为null，即学生表有多少行就匹配多少行
select *  from students natural left outer join on takes; 

-- 在学生表和选课表的例子中，找出所有一门课也没有选的学生情况
select * from  students natural left outer join on takes where course_id=null;
```

