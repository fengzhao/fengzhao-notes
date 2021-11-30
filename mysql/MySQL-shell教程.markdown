# MySQL shell 简介



[mysql-shell](https://dev.mysql.com/doc/mysql-shell/8.0/en/) 是一个新的客户端软件，与之前的 mysql 命令不同的是它支持使用 SQL 、js、 python 这三种语言与 MySQL-Server 交互。



MySQL Shell是MySQL InnoDB Cluster集群的管理工具，负责管理维护整改InnoDB Cluster，MySQL Shell是MySQL Server的高级客户端和代码编辑器。

除了提供的SQL功能，类似于 mysql，MySQL Shell还提供了JavaScript和Python的脚本功能，并包含用于 MySQL 的 API。



```shell
#打开临时目录
cd /usr/local/src/
#下载
wget https://cdn.mysql.com//Downloads/MySQL-Shell/mysql-shell-8.0.27-linux-glibc2.12-x86-64bit.tar.gz
#解压
tar -xvf mysql-shell-8.0.27-linux-glibc2.12-x86-64bit.tar.gz -C /usr/local
#给软连接
cd /usr/local/
ln -s mysql-shell-8.0.27-linux-glibc2.12-x86-64bit mysql-shell
#写入
echo 'export PATH=/usr/local/mysql-shell/bin:$PATH' >> /etc/profile 
#重启生效
source /etc/profile
```

