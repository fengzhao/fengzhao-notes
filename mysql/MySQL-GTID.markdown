## 一、Server UUID概念



MySQL数据目录中通常存在一个名为auto.cnf文件，存储了server-uuid的值，如下所示：



```shell
[auto]                                                                                                                                                       
server-uuid=f4a515bc-7956-11e9-ba16-0894ef77d734
```

```shell
show VARIABLES like '%server_uuid%'
```

MySQL启动时，会自动从data_dir/auto.cnf 文件中获取server-uuid值，并将这个值存储在全局变量server_uuid中。如果这个值或者这个文件不存在，那么将会生成一个新的uuid值，并将这个值保存在auto.cnf文件中。server-uuid与server-id一样，用于标识MySQL实例在集群中的唯一性，这两个参数在主从复制中具有重要作用，默认情况下，如果主、从库的server-uuid或者server-id的值一样，将会导致主从复制报错中断。