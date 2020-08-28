这是最新版 redis6.0 的源代码





### 单机版redis安装

```shell
######  与redis 相关的重要的Linux内存参数配置

# vim  /etc/sysctl.conf 设置内存参数
# 内核参数overcommit_memory:内存分配策略，在Ubuntu和CentOS中这个参数值默认是0
# 查看 cat /proc/sys/vm/overcommit_memory
# 可选值：0、1、2。
# 0， 表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存，内存申请允许；否则，内存申请失败，并把错误返回给应用进程。
# 1， 表示内核允许分配所有的物理内存，而不管当前的内存状态如何。
# 2， 表示内核允许分配超过所有物理内存和交换空间总和的内存
vm.overcommit_memory = 1





# 源码包安装 6.0

## 准备gcc环境
# centos7 默认的 gcc 版本为：4.8.5 < 5.3 无法编译

sudo yum -y install centos-release-scl
sudo yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils
# 临时有效，退出 shell 或重启会恢复原 gcc 版本
sudo scl enable devtoolset-9 bash
# 长期有效
sudo echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile



cd /usr/local/src/
# 从公司git下载源码包
git clone git@git.qh-1.cn:fengzhao/redis.git
# 从github下载源码包
git clone -b 6.0 https://github.com/redis/redis.git  /usr/local/src/
# 从redis官网下载源码包
wget http://download.redis.io/releases/redis-6.0.5.tar.gz  -O  /usr/local/src/redis-6.0.5.tar.gz

# 解压编译安装
# redis可执行文件会被复制到/usr/local/bin目录下
tar xf redis-6.0.5.tar.gz
cd redis-6.0.5
make
sudo make install


# 修改配置文件 redis.conf 
bind 127.0.0.1     #根据情况是否需要远程访问去掉注释
requirepass 123456  #修改密码
# 复制配置文件到/etc/ 目录
sudo mkdir /etc/redis
sudo cp redis.conf /etc/redis/


#  配置开机启动服务管理文件 sudo vim /etc/systemd/system/redis.service
[Unit]
Description=Redis
After=network.target

[Service]
# 注意Type=forking不注释掉 服务无法启动
# Type=forking
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecReload=/usr/local/bin/redis-server -s reload
ExecStop=/usr/local/bin/redis-server -s stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target


# 使服务自动运行
sudo systemctl daemon-reload
sudo systemctl enable redis
# 启动服务
sudo systemctl restart redis
sudo systemctl status redis
```





### redis集群

`redis` 集群一般由 多个节点 组成，节点数量至少为 `6` 个，才能保证组成 完整高可用 的集群。

每个节点需要 开启配置 `cluster-enabled yes`，让 `redis` 运行在 集群模式 下。

准备三台服务器H1、H2、H3，每台服务器分别启用 7000 和 7002 两个端口的 redis 节点，搭建三主三从的集群

我们的集群由 A、B、C 三个 master 节点和 A1、B1、C1 三个 slave 节点组成。

节点 B1 是 B 的副本，如果 B 失败了，集群会将 B1 提升为新的 master，从而继续提供服务。然而，如果 B 和 B1 同时挂了，那么整个集群将不可用。

```
172.26.237.83 H1
172.26.237.84 H2
172.26.237.85 H3
```





```shell
#########################分别在三台机器上进行环境准备
## 准备gcc环境
# centos7 默认的 gcc 版本为：4.8.5 < 5.3 无法编译

sudo yum -y install centos-release-scl
sudo yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils
# 临时有效，退出 shell 或重启会恢复原 gcc 版本
sudo scl enable devtoolset-9 bash
# 长期有效
sudo echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile



# 分别在三台机器下载redis源码包
cd /usr/local/src/
git clone git@git.qh-1.cn:fengzhao/redis.git

# 解压编译安装
# redis可执行文件会被复制到/usr/local/bin目录下
tar xf redis-6.0.5.tar.gz
cd redis-6.0.5
make
sudo make install


# 配置ssh免密登陆
# 在H1服务器设置SSH免密登录；在H1生成RSA公钥和私钥（在H1操作）
ssh-keygen -t rsa 
ssh-copy-id 172.26.237.83
ssh-copy-id 172.26.237.84
ssh-copy-id 172.26.237.85

# 分别在H1，H2，H3上添加域名解析
cat > /root/env/hosts.txt <<EOF
172.26.237.83 H1
172.26.237.84 H2
172.26.237.85 H3
EOF

cat /root/env/hosts.txt
cat /root/env/hosts.txt >> /etc/hosts


# 在H1上测试是否能正常ssh到H2和H3
ssh H2

# 在三台主机分别建立相关目录，并启动redis实例
mkdir -p  /root/soft/{7000,7001}
cp -R redis-env-7000.conf  /root/soft/7000/redis.conf
cp -R redis-env-7001.conf  /root/soft/7001/redis.conf

/usr/local/bin/redis-server /root/soft/7000/redis.conf
/usr/local/bin/redis-server /root/soft/7001/redis.conf

# 检查redis状态
ps -ef |grep redis


# 在H1上执行，检查与其他各节点的通讯
# 各节点启动后，节点启动以后是相互独立的，并不知道其他节点存在；
# 使用cluster meet ip port与各节点握手，是集群通信的第一步（关键步骤1：集群搭建－与各节点握手）
[root@bogon redis-gitlab]#                                                                               
[root@bogon redis-gitlab]# redis-cli  -p 7000                                                       
127.0.0.1:7000> ping                                   
PONG                                                            
127.0.0.1:7000> cluster meet 127.0.0.1  7001                                                                            
OK                                    
127.0.0.1:7000>  

# 检查通过，集群处理下线状态，所有读写被禁止
127.0.0.1:7000> set a 1
(error) CLUSTERDOWN Hash slot not served
127.0.0.1:7000>
127.0.0.1:7000>

# 集群创建，在H1上执行
# 三台服务器，启动6个实例，形成三主三从，其中存储相同数据的主从节点不能落在同一台机器上，目的是防止部署redis的服务器宕机从而造成主从节点全部失效
# 为了使用主从节点不落在同一台机器上，使用如下命令：每台ip+port交叉（没有找到命令指定主从节点的关系的方法）.

/usr/local/bin/redis-cli  --cluster create --cluster-replicas 1 172.26.237.83:7000 172.26.237.84:7001 172.26.237.84:7000 172.26.237.85:7001 172.26.237.85:7000 172.26.237.83:7001

# 根据提示输入yes,集群创建成功


# 客户端与 redis 节点直连，不需要 proxy 层，客户端不需要连接所有集群节点，只需要连接其中一个节点即可。
# 按照 redis 官方规范，一个 Redis 客户端可以向集群中的任意节点（包括从节点）发送命令请求。
# 节点会对命令请求进行分析，如果该命令是集群可以执行的命令，那么节点会查找这个命令所要处理的键所在的槽。
# 如果处理该命令的槽位于当前节点，那么命令可以顺利执行，否则当前节点会返回 MOVED 错误（重定向），让客户端到另一个节点执行该命令
# redis 官方规范要求所有客户端都应处理 MOVED 错误，从而实现对用户的透明。
# 我们上面看到的错误就是 MOVED 错误：
# 它表示，该执行该命令所需要的 slot 是 866 号哈希槽，负责该槽的节点是 172.21.16.4:6379

```



### 集群管理

redis 集群架构的特点：

- 所有的 redis 节点彼此互联（ping-pong机制），内部使用二进制协议优化传输速度和带宽。
- 节点的 fail 是通过彼此集群中超过半数的节点检测时才失效。
- 客户端与 redis 节点直连，不需要 proxy 层，客户端不需要连接所有集群节点，只需要连接其中一个节点即可。

集群选举容错：



```shell
# 集群客户端命令（redis-cli -c -p port）

# 集群
cluster info ：打印集群的信息
cluster nodes ：列出集群当前已知的所有节点（ node），以及这些节点的相关信息。
# 节点
cluster meet <ip> <port> ：将 ip 和 port 所指定的节点添加到集群当中，让它成为集群的一份子。
cluster forget <node_id> ：从集群中移除 node_id 指定的节点。
cluster replicate <node_id> ：将当前节点设置为 node_id 指定的节点的从节点。
cluster saveconfig ：将节点的配置文件保存到硬盘里面。
# 槽(slot)
cluster addslots <slot> [slot ...] ：将一个或多个槽（ slot）指派（ assign）给当前节点。
cluster delslots <slot> [slot ...] ：移除一个或多个槽对当前节点的指派。
cluster flushslots ：移除指派给当前节点的所有槽，让当前节点变成一个没有指派任何槽的节点。
cluster setslot <slot> node <node_id> ：将槽 slot 指派给 node_id 指定的节点，如果槽已经指派给另一个节点，那么先让另一个节点删除该槽>，然后再进行指派。
cluster setslot <slot> migrating <node_id> ：将本节点的槽 slot 迁移到 node_id 指定的节点中。
cluster setslot <slot> importing <node_id> ：从 node_id 指定的节点中导入槽 slot 到本节点。
cluster setslot <slot> stable ：取消对槽 slot 的导入（ import）或者迁移（ migrate）。
# 键
cluster keyslot <key> ：计算键 key 应该被放置在哪个槽上。
cluster countkeysinslot <slot> ：返回槽 slot 目前包含的键值对数量。
cluster getkeysinslot <slot> <count> ：返回 count 个 slot 槽中的键 
```

