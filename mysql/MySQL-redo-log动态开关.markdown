# 前言



我们都知道数据库利用 write-ahead logging（WAL）机制，来保证异常宕机后数据的持久性。

即提交事务之前，不仅要更新所有事务相关的Page，也要确保所有的WAL日志都写入磁盘。

在InnoDB引擎中，这个WAL就是InnoDB的redo log，一般存储在ib_logfilexxx文件中，文件数量可通过my.cnf配置。





在MySQL 8.0官方发布了新版本8.0.21中，支持了一个新特性“Redo Logging动态开关”。

借助这个功能，在新实例导数据的场景下，相关事务可以跳过记录redo日志和doublewrite buffer，从而加快数据的导入速度。

同时，付出的代价是短时间牺牲了数据库的ACID保障。



注意事项