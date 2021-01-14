# Performance Schema



**MySQL的 performance schema 是一个用于监控MySQL server在一个较低级别的运行过程中的资源消耗、资源等待等情况的schema。**

**主要用于看MySQL内部的资源使用情况。**

**在配置文件中通过** performance_schema=ON|OFF（5.7之后默认开启，该参数不可动态修改） **参数来控制。**



```sql
--  查看当前实例是否支持 PERFORMANCE_SCHEMA 存储引擎 
SELECT * FROM INFORMATION_SCHEMA.ENGINES WHERE ENGINE ='PERFORMANCE_SCHEMA';
-- 查看当前实例是否启用 PERFORMANCE_SCHEMA 
show variables like 'performance_schema';

-- performance_schema有哪些启动选项
mysqld --verbose --help |grep performance-schema |grep -v '\-\-' |sed '1d' |sed '/[0-9]\+/d'
```









# performance_schema表的分类





performance_schema库下的表可以按照监视不同的纬度进行了分组，

例如：

- 或按照不同数据库对象进行分组，
- 或按照不同的事件类型进行分组，
- 或在按照事件类型分组之后，再进一步按照帐号、主机、程序、线程、用户等，





### 语句事件记录表



这些表记录了语句事件信息：

- 当前语句事件表events_statements_current
- 历史语句事件表events_statements_history
- 长语句历史事件表events_statements_history_long、
- 聚合后的摘要表summary，其中，summary表还可以根据帐号(account)，主机(host)，程序(program)，线程(thread)，用户(user)和全局(global)再进行细分)

```sql
show tables like 'events_statement%';


events_statements_current
events_statements_histogram_by_digest
events_statements_histogram_global
events_statements_history
events_statements_history_long
events_statements_summary_by_account_by_event_name
events_statements_summary_by_digest
events_statements_summary_by_host_by_event_name
events_statements_summary_by_program
events_statements_summary_by_thread_by_event_name
events_statements_summary_by_user_by_event_name
events_statements_summary_global_by_event_name
```





### 等待事件记录表

```sql
show tables like 'events_wait%';


```



### 阶段事件记录表





### 事务事件记录表





### 监视文件系统层调用的表





### 监视内存使用的表





### 动态配置表



# performance_schema简单配置与使用



数据库刚刚初始化并启动时，并非所有instruments(事件采集项，在采集项的配置表中每一项都有一个开关字段，或为YES，或为NO)和consumers(与采集项类似，也有一个对应的事件类型保存表配置项，为YES就表示对应的表保存性能数据，为NO就表示对应的表不保存性能数据)都启用了，所以默认不会收集所有的事件，可能你需要检测的事件并没有打开，需要进行设置，可以使用如下两个语句打开对应的instruments和consumers（行计数可能会因MySQL版本而异），例如，我们以配置监测等待事件数据为例进行说明：



```sql
 UPDATE setup_instruments SET ENABLED = 'YES', TIMED = 'YES' where name like 'wait%';;
```



