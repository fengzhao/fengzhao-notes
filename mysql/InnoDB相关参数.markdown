









```shell
# 缓冲池实例数量，默认为1，不可以动态调整
innodb_buffer_pool_instances=1
# 缓冲池总大小，默认是128MB，一般设置为物理内存的70%左右。MySQL5.7.5之后可以动态调整，注意数据库繁忙时不要动态调整。
innodb_buffer_pool_size=134217728
# 缓冲池配置时的基本单位，以块的形式配置，指明块大小，innodb_buffer_pool_size=innodb_buffer_pool_chunk_size * innodb_buffer_pool_instances * n 
# 默认内存块是128M，可以以1MB为单位(1048576 字节)增加或减少
innodb_buffer_pool_chunk_size=128M




##############################binlog相关#########################################
# 控制InnoDB中写binlog时的缓存，默认是32K，该参数基于会话的，当一个线程开始事务时，分配一个binlog_cache_size的缓存。
# 当一个事务的binlog大于binlog_cache_size时，在写binlog之前就需要写到临时文件。
binlog_cache_size

#####binlog_cache status变量

########通过下面这两个变量来设置 binlog
# binlog_cache_use 记录了使用缓冲写binlog的次数
binlog_cache_use
# binlog_cache_disk_use 记录了使用临时文件写binlog的次数
binlog_cache_disk_use

# 默认的
max_binlog_size=1G

# sync_binlog 是 MySQL 的二进制日志（binary log）同步到磁盘的频率。
# MySQL server 在 binary log 每写入 N 次后，刷写到磁盘。
# 如果 autocommit 开启，每个语句都写一次 binary log，否则每次事务写一次。默认值是 0，不主动同步，而依赖操作系统本身不定期把文件内容 flush 到磁盘。
##### 设为0
	# 不主动同步，而依赖操作系统本身不定期把binlog文件内容 flush 到磁盘。

##### 设为1
	# 设为 1 最安全，在每个语句或事务后同步一次 binary log，即使在崩溃时也最多丢失一个语句或事务的日志，但因此也最慢。

##### 设为n 
	# 在 binary log 每写入 N 次后，刷写到磁盘。
	
# 大多数情况下，对数据的一致性并没有很严格的要求，所以并不会把 sync_binlog 配置成 1. 
# 为了追求高并发，提升性能，可以设置为 100 或直接用 0.
# 而和 innodb_flush_log_at_trx_commit 一样，对于支付服务这样的应用，还是比较推荐 sync_binlog = 1.










# (关闭时持久化内存中的热数据)关闭时将 InnoDB Buffer Pool 中的数据页保存到数据目录的文件中，5.7.7之后默认启用，5.7.6之前默认关闭  
innodb_buffer_pool_dump_at_shutdown=ON
# 保存的文件路径和文件名，默认在数据目录下的ib_buffer_pool
innodb_buffer_pool_filename=ib_buffer_pool
# (启动时直接从文件中读取热数据，预热)启动时将数据目录中的ib_buffer_pool加载到内存中
innodb_buffer_pool_load_at_startup=ON;
# 内存池数据持久化比例
innodb_buffer_pool_dump_pct=75
```

