



# binlog详解



**binlog** 是 MySQL Server 层记录的二进制日志文件，用于记录 MySQL 的数据更新或者潜在更新（比如 DELETE 语句执行删除而实际并没有匹配到行）。

**select 或 show** 等不会修改数据的操作则不会记录在 binlog 中。

binlog 以事件的方式记录了数据库内容的状态，包含了数据修改，服务器重启等，以二进制的格式写入日志文件。







通常在 **binlog_format =  ROW** 的环境下，我们可以通过 binlog 获取历史的 SQL 执行记录。

前提是必须开启 **binlog_rows_query_log_events** 参数（默认关闭，建议开启）。

该参数可以通过**rows_query_event** 事件记录原始的 SQL，如果不开启的话，则只能获取 SQL 对应的行数据。



binlog 通常有三种格式：



# binlog解析



```shell
show binlog events in 'mysql-bin.000006' ;
# show binlog events 方式可以解析指定 binlog 日志，但不适宜提取大量日志，速度很慢，不建议使用。

```







mysqlbinlog 是 mysql 原生自带的 binlog 解析工具，速度快而且可以配合管道命令过滤数据，适合解析大量 binlog 文件，建议使用。



```shell
mysqlbinlog /data/mysql_data/bin.000008  –database EpointFrame  –base64-output=decode-rows -vv  –skip-gtids=true |grep  -C 1 -i “delete from  Audit_Orga_Specialtype” > /opt/sql.log
```

