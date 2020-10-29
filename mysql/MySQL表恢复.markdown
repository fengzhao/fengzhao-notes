



在平时运维 MySQL 的过程中，由于各种原因，可能以前的库可能起不来了。

这个时候想要恢复数据，还是有点麻烦的。





### 从 frm 文件中解析表结构



```shell
wget https://cdn.mysql.com/archives/mysql-utilities/mysql-utilities-1.6.5.tar.g

cd mysql-utilities-1.6.5

python setup.py build

python setup.py install



mysqlfrm --diagnostic /data/sakila/actor.frm

```

