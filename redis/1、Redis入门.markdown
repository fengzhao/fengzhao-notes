## 简介

redis 学习网站

 http://huangz.me/

http://redisguide.com/



redis labs创立于2011年，公司致力于为Redis、Memcached等流行的NoSQL开源数据库提供云托管服务。可以算是专门致力于redis云的一家专业公司。

他们的提供的软件中，除了可以连接企业私有的redis服务，也可以连接他们的redis云。

2021年8月12日，Redis Labs 宣布该公司现已注册为Redis，从其名称中删除了“Labs”。这一变化标志着该公司和 Redis 开源项目的成熟，该项目自 2011 年开始贡献并自 2015 年起赞助。

https://redislabs.com/ 网站也重定向到 https://redis.com/

更名也反映了公司继续将 Redis 作为实时数据平台发展的使命。

该公司专注于领导和指导整个社区（包括个人贡献者、客户和合作伙伴）的一致性，以提供应对技术挑战的解决方案并保持其经久不衰的受欢迎程度。

公司更名不会影响Redis开源项目的许可，它一直是并将继续是BSD许可的，也不会影响去年引入的[治理模型](https://cts.businesswire.com/ct/CT?id=smartlink&url=https%3A%2F%2Fredis.io%2Ftopics%2Fgovernance%3F_ga%3D2.186287273.1669130961.1627496529-1468736442.1609999893&esheet=52475264&newsitemid=20210811005299&lan=en-US&anchor=governance+model&index=4&md5=07bccbdea7c12e06525eaef89b3367bc)。

Redis 由 Salvatore Sanfilippo（又名antirez）于 2009 年创建，由于其速度和简单性，它很快在开发人员中流行起来。

redis labs公司在 2011 年成立后不久就开始为开源项目做出贡献。 2015 年，Sanfilippo 加入公司，成为该项目的发起人，并于 2018 年将 Redis 项目的知识产权和商标权转让给了公司。

Sanfilippo 于 2020 年 6 月不再担任该开源项目的唯一维护者，同时仍留在公司咨询委员会。

Redis 通过治理模型进行维护，该模型由公司核心人员以及对 Redis 做出长期承诺并做出重大贡献的社区成员组成。

核心团队负责主 Redis 存储库。他们还与组成 Redis 生态系统的其他项目进行协调和协作，包括客户端库、卫星项目和依赖 Redis 的主要中间件。





> Redis is an open source (BSD licensed), in-memory data structure store, used as database, cache and message broker.

这是 redis 的官方的定义，它是一个数据库，且是把数据存到内存中，能用作 cache (缓存) 和消息队列。

Redis 是完全开源免费的，遵守 BSD 协议，是一个高性能的 key-value 数据库，与其它 key/value 缓存产品相比有以下三个特点：

- Redis 支持数据的持久化，可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用。
- Redis 不仅支持 key-value 类型的数据，还提供 list，set，zset，hash 等数据结构的存储，对程序员透明，无需进行额外的抽象。
- Redis 支持数据的备份，即 master-slave 模式的数据备份
- Redis 可以存储键和五种不同类型的值之间的映射。键的类型只能为字符串，值支持五种数据类型：字符串、列表、集合、散列表、有序集合

说到数据库，可能大家用得最多的是关系型数据库，比如 MySQL，PostgreSQL 等。

这种数据库是把数据存到磁盘中的，这种能存大量的数据，然而我们的应用是经常需要访问数据库来查找数据，每次访问，无论怎样，都是需要消耗CPU和IO等待。

当应用的数据积累到很庞大时，这种性能的问题更严重，所以有一种解决方法是这样的，把经常被访问的数据放到内存中，因为内存的访问速度比磁盘快太多了。

而这部分数据可能不会是全部的数据，因为内存的价格比磁盘贵多了。

所以有了 memcached ，这种就是把数据放到内存中，但它仅支持一种最简单的数据结构，就是键值对，这种数据库又不同于传统结构型的关系型数据库，所以又被称为 nosql。

而 redis 也是 nosql 的一种，但它相比 memcached 不仅支持键值对，还支持列表，集合，排序集合等多种结构，而且它还是可持久化的。

持久化就是说在内存中的数据会以文件的形式同步到磁盘中，当下次重启时还能恢复，这点相比memcached，就能存相对重要的数据。

毕竟如果数据不能持久化，丢失了也是件麻烦的事，谁也保证不了不会出问题。

还有一个很重要的特征就是 redis 支持分布式集群，用它可以轻易地部署到多台机器中，成为一个集群。特别是 3.0 开始，redis 对集群的支持比较健全了。

redis 比较常见的作用和应用场景：

- 第一个是 cache，这是由于它的数据存在内存中，访问速度比较快，它能让数据在一定时间后过期，且又有丰富的数据结构的支持，所以它能作为一个高性能的 cache。
- 第二个是作为消息队列，用的是它的 sub/pub 的功能，能具有消息费生产者的模式，且是数据存在内存中，访问速度高。
- 做为 session 的存储，可以轻松的实现分布式 session 服务器。
- 项目中使用Redis，主要考虑 **性能**和**并发**。如果仅仅是分布式锁这些，完全可以用中间件 zookeeper 等代替。



redis 在实际项目中的应用场景：

- 记录帖子的点赞数、评论数和点击数 (hash)。

- 记录用户的帖子 ID 列表 (排序)，便于快速显示用户的帖子列表 (zset)。

- 记录帖子的标题、摘要、作者和封面信息，用于列表页展示 (hash)。

- 记录帖子的点赞用户 ID 列表，评论 ID 列表，用于显示和去重计数 (zset)。

- 缓存近期热帖内容 (帖子内容空间占用比较大)，减少数据库压力 (hash)。

- 记录帖子的相关文章 ID，根据内容推荐相关帖子 (list)。

- 如果帖子 ID 是整数自增的，可以使用 Redis 来分配帖子 ID(计数器)。

- 收藏集和帖子之间的关系 (zset)。

- 记录热榜帖子 ID 列表，总热榜和分类热榜 (zset)。

- 缓存用户行为历史，进行恶意行为过滤 (zset,hash)。



## 安装

```shell
# 源码包编译安装redis6.0


# 创建好指定运行redis的用户
groupadd redis
useradd -r -g redis -s /bin/false redis
sudo mkdir -p  /home/redis/{run,dbdata}
chown -R redis:redis /home/redis/

## 准备gcc环境
# centos7 默认的 gcc 版本为：4.8.5 < 5.3 无法编译
sudo yum -y install centos-release-scl tcl tclx tcl-devel   systemd-devel 
sudo yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils 
# 临时有效，退出 shell 或重启会恢复原 gcc 版本
sudo scl enable devtoolset-9 bash
# 长期有效
sudo echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile

# ubuntu准备相关工具
$ sudo apt-get install  gcc g++ libxml2  pkg-config  libxml2-dev libsqlite3-dev tcl tk make

# 下载源代码包
git clone -b 6.0 https://github.com/redis/redis.git  /usr/local/src/redis/
wget http://download.redis.io/releases/redis-6.0.5.tar.gz  -O  /usr/local/src/redis-6.0.5.tar.gz
wget http://download.redis.io/releases/redis-7.0.3.tar.gz  -O  /usr/local/src/redis-7.0.3.tar.gz
# 解压
tar xf redis-6.0.5.tar.gz  && cd redis-6.0.5

# 编译，，具体编译参数：
# USE_SYSTEMD=yes  支持以systemd系统服务方式来管理redis，需要包的支持：libsystemd-dev on Debian/Ubuntu or systemd-devel on CentOS
# PREFIX=/some/other/directory 指定将redis可执行文件安装到不同目录下
# BUILD_TLS=yes  开启TLS通讯，一般也不需要
# MALLOC=libc   在ubuntu使用这个参数 MALLOC=libc，一般不需要设置这个
sudo make USE_SYSTEMD=yes

# 安装，安装后，二进制文件会被复制到/usr/local/bin目录下
sudo make install


# 创建配置目录，如果多个实例，可以用/etc/redis/6379.conf,/etc/redis/6380.conf这样来配置
sudo mkdir /etc/redis

# 配置文件去掉空格和注释
grep -v '^#' redis.conf | grep -v '^$' >  /etc/redis.conf

cp utils/redis_init_script 

# 源代码包解压之后的./utils/redis_init_script 可以做为一个简单的启停脚本
# https://github.com/redis/redis/blob/unstable/utils/redis_init_script

# 源代码包解压之后的./utils/install_server.sh 可以进行一个交互式的引导用户生成配置文件，并注册成系统服务
# https://github.com/redis/redis/blob/unstable/utils/install_server.sh


# /usr/lib/systemd/system/redis.service
[Unit]
Description=Redis persistent key-value database
Wants=network-online.target
After=network.target
[Service]
ExecStart=/usr/local/bin/redis-server /etc/redis.conf --supervised systemd
ExecStop=/bin/kill -s QUIT $MAINPID
Type=notify
User=redis
Group=redis
RuntimeDirectory=redis
RuntimeDirectoryMode=0755
[Install]
WantedBy=multi-user.target



# 修改配置文件 redis.conf 

# include /path/to/local.conf 
# 像很多软件一样，include语法导入其他配置文件，将配置文件分成多块，分层管理，不支持匹配模式，必须单个导入，导入配置会覆盖导入配置之前的配置；

#　网络配置
bind  *      		# 监听多个网卡地址 　bind 192.168.1.100 10.1.0.1 ，redis尽量不要直接对公网开放
port 6379           # 监听端口号，实在要对公网开放，修改默认端口能避免被扫描。
protect-mode  yes      # 安全模式
requirepass Elw2Ea&3kvmDwv0  # redis密码是明文保存，必须要设置超高强度密码
daemonize yes       # 守护进程的方式启动

pidfile /var/run/redis_6379.pid  # pid文件
loglevel notice  # 日志级别
logfile ""       # 日志文件


# 禁用或者重命名危险命令
# Redis中线上使用keys *命令，也是非常危险的。因此线上的Redis必须考虑禁用一些危险的命令，或者尽量避免谁都可以使用这些命令，Redis没有完整的权限管理，但是也提供了一些方案。
# 重命名为"" 代表禁用命令，如想保留命令，可以重命名为不可猜测的字符串，如： rename-command FLUSHALL joYAPNXRPmcarcR4ZDgC
rename-command FLUSHALL ""
rename-command FLUSHDB  ""
rename-command CONFIG   ""
rename-command KEYS     ""
rename-command SHUTDOWN ""
rename-command DEL ""
rename-command EVAL ""







./redis-server /path/to/redis.conf
./redis-server --daemonize yes




# Install Redis Server on Ubuntu 18.04
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install redis-server
# 开机自启
sudo systemctl enable redis-server.service
# 在配置文件中修改使用systemd来做为redis的守护进程管理工具
supervised systemd



# Installing Redis Server on CentOS 7
yum install epel-release
yum install redis 


# vim  /etc/sysctl.conf 设置内存参数
# 内核参数overcommit_memory:内存分配策略，在Ubuntu和CentOS中这个参数值默认是0
# 查看 cat /proc/sys/vm/overcommit_memory
# 可选值：0、1、2。
# 0， 表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存，内存申请允许；否则，内存申请失败，并把错误返回给应用进程。
# 1， 表示内核允许分配所有的物理内存，而不管当前的内存状态如何。
# 2， 表示内核允许分配超过所有物理内存和交换空间总和的内存
vm.overcommit_memory = 1




# docker版本
docker pull redis:latest


REDIS=/home/ybd/data/docker/redis && \
docker run -p 6379:6379 --restart=always \
-v $REDIS/redis.conf:/usr/local/etc/redis/redis.conf \
-v $REDIS/data:/data \
--name redis -d redis \
redis-server /usr/local/etc/redis/redis.conf --appendonly yes




# docker-compose.yml 
version: '3'
services:
  redis:
    image: redis:latest
#    command: ["redis-server", "--appendonly", "yes"]
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"]
    restart: always
    ports:
      - "6379:6379"
    networks:
      backend-swarm:
        aliases:
         - redis
    volumes:
      - ./data:/data
      - ./config/redis.conf:/usr/local/etc/redis/redis.conf

# docker network create -d=overlay --attachable backend
networks:
  backend-swarm:
    external:
      name: backend-swarm

```





### 针对redis的内核参数优化

```shell



# vim  /etc/sysctl.conf 设置内存参数
# 内核参数overcommit_memory:内存分配策略，在Ubuntu和CentOS中这个参数值默认是0
# 查看 cat /proc/sys/vm/overcommit_memory
# 可选值：0、1、2。
# 0， 表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存，内存申请允许；否则，内存申请失败，并把错误返回给应用进程。
# 1， 表示内核允许分配所有的物理内存，而不管当前的内存状态如何。
# 2， 表示内核允许分配超过所有物理内存和交换空间总和的内存
vm.overcommit_memory = 1

# 追加这个参数到配置文件末尾
echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
# 当前临时设置生效
sysctl vm.overcommit_memory=1 


echo madvise > /sys/kernel/mm/transparent_hugepage/enabled


# WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.

#  WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect




# WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
```







### 相关文件



| 可执行文件                            | 作用                        |
| ------------------------------------- | --------------------------- |
| /usr/bin/redis-cli                    | redis客户端工具，命令行工具 |
| /usr/bin/redis-check-rdb              |                             |
| /usr/bin/redis-server                 | redis服务端守护进程         |
| /usr/bin/redis-check-aof              |                             |
| /usr/bin/redis-benchmark              | redis性能测试工具           |
| /usr/lib/systemd/system/redis.service | redis启动脚本文件           |
| /etc/redis.conf                       | redis配置文件               |



#### redis-cli 

与 MySQL 中的 mysql 二进制文件，redis-cli 也是一个客户端工具，使用 redis-cli  去登陆





## redis 基本概念

Redis默认提供了16个数据库（database），每个数据库有一个id，从0到15，他们没有名字，只有id。

可以在Redis配置文件中修改数据库个数，使用以下配置(代表启动时提供32个数据库)：

>   databases 32 

客户端登录 redis 时默认登录的是 id 为 0 的数据库。可以随时使用 SELECT 命令更换数据库。

在实际项目中则可以通过以配置文件的形式指定数据库。

```shell
# https://www.jianshu.com/p/5abbee8e4564
####单机模式#######
##redis的服务器地址
redis.host=192.168.1.20
##redis的服务端口 
redis.port=6400 

####哨兵模式
##redis的服务器地址
redis.sentinel.master.host=192.168.1.20
##redis的服务端口 
redis.sentinel.master.port=26379
redis.sentinel.slave1.host=192.168.1.21
redis.sentinel.slave1.port=26380
redis.sentinel.slave2=192.168.1.22
redis.sentinel.slave2.port=26381

####集群模式
##redis的服务器地址
redis.cluster.host1=192.168.1.20
##redis的服务端口 
redis.cluster.port1=6400
redis.cluster.host2=192.168.1.20
redis.cluster.port2=6400
redis.cluster.host3=192.168.1.20
redis.cluster.port3=6400


##redis密码
redis.pass=1234xxxxx
##redis连接数据库
redis.default.db=0
##客户端超时时间单位是毫秒  
redis.timeout=100000
##最大连接数
redis.maxActive=300
##最大空闲数
redis.maxIdle=100
##最大建立连接等待时间  
redis.maxWait=1000
##指明是否在从池中取出连接前进行检验,如果检验失败,则从池中去除连接并尝试取出另一个
redis.testOnBorrow=true
```



由于Redis不支持自定义数据库的名字，所以每个数据库都以编号命名。开发者则需要自己记录存储的数据与数据库的对应关系。

另外Redis也不支持为每个数据库设置不同的访问密码，所以一个客户端要么可以访问全部数据库，要么全部数据库都没有权限访问。

```shell
# 清空一个Redis实例中所有数据库中的数据 
redis 127.0.0.1:6379> FLUSHALL 

#　该命令可以清空实例下的所有数据库数据，这与我们所熟知的关系型数据库所不同。关系型数据库多个库常用于存储不同应用程序的数据 ，且没有方式可以同时清空实例下的所有库数据。

# redis集群模式下只有一个db0。

# 对于db正确的理解应为“命名空间”，多个应用程序不应使用同一个Redis不同库，而应一个应用程序对应一个Redis实例，不同的数据库可用于存储不同环境的数据。



```







## 数据类型 

redis 并不是简单的键值对存储服务器，它实际上是一个  ***数据结构服务器*** ，它支持多种类型的 value  。

在传统的键值存储中通常都是在 string 类型的 key 中存放 string 类型的 value 。（即 key:value 都是字符串）

在 redis 中，value 并不仅限为 string 这样的简单数据类型，value 可以是 List , Set ，Hashes 这样更加复杂的数据结构：

- Binary-safe strings  
  - 
- **Lists（列表）**：根据插入顺序排序的多个 string 元素集合，最基本的 ***linked lists（链表）***。
- **Sets（集合**）：无序且不重复的 string 元素集合
- **Sorted sets（有序集合）**：有序的 sets ，每个元素都有一个权重(score)，元素按照 score 排序。
- **Hashes（哈希）：**是一个由键值对关联起来的`map`，键和值都是字符串。对于`Ruby`和`Python`非常的友好。
- **Bit arrays (比特数组) ：**是

### Redis Keys

Redis 中的 Keys 是二进制安全的，这就意味着使用任何 **二进制序列** 都可以做为 key , 无论是像 "foo" 这样的字符串还是一个 JPEG 文件的内容，都可以做为 key 。

**甚至空 string 被认为是有效的 key 。**

**关于使用 key 的一些建议**：

- 使用非常大的 key 不是很好的选择，不仅仅是因为内存浪费，更是因为在数据集中搜索对比的时候需要耗费更多的成本。当要处理的是匹配一个非常大的值，从内存和带宽的角度来看，使用这个值的`hash`值是更好的办法（比如使用`SHA1`）。
- 特别短的key通常也是不推荐的。在写像 u100flw 这样的键的时候，有一个小小的要点，我们可以用`user:1000:followers`代替。可读性更好，对于key对象和value对象增加的空间占用与此相比来说倒是次要的。当短的key可以很明显减少空间占用的时候。**这个例子就描述了使用 redis 一个场景：计数器。如：如知乎每个问题的被浏览次数，新浪微博的用户关注数，userid 为1000 这个用户的粉丝数这个 key 就可以用 "user:1000:followers" 这样的 key 名来表示 **。
- 使用 schema 来限定域，例如使用  "object-type:id" 这种方式来表示，冒号和横线都可以用来分割域，例如  "comment:123:reply.to" or "comment:123:reply-to" 这样的格式。
- **key 的最大限制是 512 MB。**  
- 

### string类型

通过 key-value 中这样的方式时，string 是 value 中最简单的数据类型，它也是 Memcached 中唯一的数据类型，这个很简单很容易理解，值跟键一样，都是字符串。

string 数据类型在很多场景都很有用，比如缓存一些 HTML fragments 或者 pages。

```shell
root@hwsrv-512783:~# redis-cli 
127.0.0.1:6379>
127.0.0.1:6379> ping
PONG
127.0.0.1:6379> set mykey somevalue
OK
127.0.0.1:6379> get mykey
"somevalue"
127.0.0.1:6379>
127.0.0.1:6379>
# 使用 set 对已存在的 key 重新赋值，它会覆盖以前的值。
127.0.0.1:6379>
127.0.0.1:6379> set mykey anothervalue
OK
127.0.0.1:6379> get mykey
"anothervalue"
127.0.0.1:6379>
127.0.0.1:6379>
# NX - Only set the key if it does not already exist.
# XX -  Only set the key if it already exist.
# set 命令后加上 NX 参数，则先判断 key 是否存在，如果不存在则创建，如果已存在，则返回 nil 
# set key value NX 等价于 SETNX key value （其实就是 set if not exits，如果不存在则set的意思）
127.0.0.1:6379> set mykey value NX
(nil)
127.0.0.1:6379>
127.0.0.1:6379> get mykey
"anothervalue"
127.0.0.1:6379>
127.0.0.1:6379>

```



#### 介绍

- 可以保存哪些值
  - 字符串
  - 数字
  - 二进制
  - json、xml 等字符串

- 使用场景
  - 缓存
  - 计数器
  - 分布式锁
  - ...


### LIST类型

redis 中的 list 是一个**有序数组（元素都是string类型），按照插入顺序排序。可以直接插入语一个元素到列表的头部（左边）或者尾部（右边）**

-  [LPUSH](https://redis.io/commands/lpush)  命令在头部插入一个元素
-  [RPUSH](https://redis.io/commands/rpush) 命令在尾部插入一个元素

```shell
# 声明一个list, list的元素最大数量为 2^32 - 1 个 (即4294967295)
127.0.0.1:6379> rpush mylist A B C D
(integer) 4
127.0.0.1:6379>


# 插入
# 从头部插入元素
lpush [key] [value1] [value2] [value3] ...
# 往尾部插入元素
rpush [key] [value1] [value2] [value3] ...

# 删除元素
lpop # 删除index最小的元素 或者可以理解为删除栈底元素
rpop # 删除index最大的元素,或者可以理解为删除栈顶元素

# 按下标取元素 
lindex [list] [index]

# 取全部元素，第一个到最后一个元素，有点像数组切片
127.0.0.1:6379> lrange mylist 0 -1
1) "A"
2) "B"
3) "C"
4) "D"
127.0.0.1:6379>

# 遍历list
lrange [key] [startIndex] [endIndex]
# 遍历key这个list,从下表为startIndex开始,遍历到下标为endIndex的元素
# 如果endIndex=-1就表示遍历到最后一位


```



### hash类型

## redis 基本命令

  

```shell
root@pve /u/l/s/r/src# redis-cli
127.0.0.1:6379> ping
PONG
127.0.0.1:6379>
# set 语法 键 值
# set name value [EX seconds|PX milliseconds] [NX|XX] [KEEPTTL]
# EX seconds  将键的过期时间设置为seconds秒: (set mail "fengzhao@fengzhao.me"  EX 5) 5秒后失效
# PX milliseconds 毫秒

# NX:只在键不存在时， 才对键进行设置操作。
# XX:当键存在时，进行更新。（set mail2 fengzhao1124@163.com XX) (如果mail2之前存在，更新成功。否则返回nil)

# 添加键值对，根据键名获取值，获取键类型，判断键是否存在
127.0.0.1:6379>
127.0.0.1:6379> set name fengzhao
OK
127.0.0.1:6379> get name
"fengzhao"
127.0.0.1:6379>type name
string
127.0.0.1:6379>

127.0.0.1:6379> set name fengzhao
OK
127.0.0.1:6379> get name
"fengzhao"
127.0.0.1:6379>type name
string
127.0.0.1:6379>
127.0.0.1:6379>exit name
string
127.0.0.1:6379>








```









- incr 

  语法：incr KEY

  功能：key 自增 1 ，如果 key 不存在，自增后 key=1

  ```shell
  # 原子自增
  incr 命令将 key 从 string 转换为 value 类型，每执行一次则递增加1后用 set 赋值回去，还有 incrby,decr,decrby 等这些命令都是一样的。
  # 原子自增意味着递增操作都是串行化的，无法同时有两个客户端对一个 key 进行原子操作。在进行递增加1返回新值后，下一个原子递增才能开始。
  # 所以原子自增是可以用来做准确计数的。即使在海量并发情况下也不用担心。
  ```

- decr

  语法：decr KEY

  功能：key 自减 1，如果 key 不存在，自减后 key=1

- incrby

  语法：incrby KEY N

  功能：key 自增 n，如果 key 不存在，自增后 key=n

- decrby

  语法：decrby KEY N

  功能：key 自减 n，如果 key 不存在，自减后 key=-n

- set

  语法：set KEY VALUE

  功能：不管  key 是否存在，都进行设置

- setnx

  语法：setnx KEY VALUE，等价于  set KEY VALUE NX

  功能：key 不存在时，才进行设置

- set xx

  语法：set KEY VALUE xx

  功能：key存在时，才进行设置

- setex

  语法：setex KEY SECONDS VALUE

  功能：相当于如下两条命令

  ```
  SET key value
  EXPIRE key seconds
  ```

  设置1个key同时设置过期时间

- mset

  语法：mset KEY VALUE [KEY VALUE ...]

  功能：创建多个键值对

  ```shell
  # 使用 mset 和 mget 来设置或取出多个 key 的 value 是一个降低延迟的好办法
  127.0.0.1:6379> mset key1 value1 key2 value2
  OK
  # 使用 keys * 命令来获取所有的 key，线上环境这个是高危操作，一定要避免这个操作
  127.0.0.1:6379> keys *
  1) "key2"
  2) "key1"
  ```

- mget

  语法：mget KEY [KEY ...]

  功能：获取多个key， multiple keys get 

  ```shell
  # 使用 mget 来一次获取多个 key 的 value,(value组成的数组) 当 key3 不存在时则返回 nil
  127.0.0.1:6379> mget key1 key2 key3
  1) "value1"
  2) "value2"
  3) (nil)
  127.0.0.1:6379>
  
  ```

- getset

  语法：getset KEY VALUE

  将新值设置到key，并返回旧值

  ```shell
  # 使用实例：使用一个自增加1的key来记录网站的访客人数，希望每小时收集一次访客人数，那就可以使用 getset 命令收集旧值，并进行清零操作。
  ```

  

- append

  语法：append KEY VALUE

  功能：将值追加到原有字符串之后

  ```
  127.0.0.1:6380> get key1
  "haha"
  127.0.0.1:6380> append key1 haah
  (integer) 8
  127.0.0.1:6380> get key1
  "hahahaah"
  ```

- strlen

  语法：strlen KEY

  功能：返回字符串长度

  注意：中文占用2个字节

- incrbyfloat

  语法：incrbyfloat KEY N

  功能：浮点数key自增n

  ```
  127.0.0.1:6380> incrbyfloat key5 3.5
  "3.5"
  127.0.0.1:6380> get key5
  "3.5"
  ```

- getrange

  语法：getrange KEY START END

  功能：获取指定下标的值

  第1个字母的下标为0

  ```
  127.0.0.1:6380> get key2
  "value2"
  127.0.0.1:6380> getrange key2 2 3
  "lu"
  ```

- setrange

  语法：setrange KEY INDEX VALUE

  功能：将key对应的值的某个下标的值替换为新值

  ```
  127.0.0.1:6380> get key2
  "value2"
  127.0.0.1:6380> setrange key2 2 L
  (integer) 6
  127.0.0.1:6380> get key2
  "vaLue2"
  ```



### 操作和查询 key 

有些命令不是针对某个特定的数据类型的，但是和`key`空间交互的时候是非常有用的，所以，可以使用在任意类型的`key`之上。

比如：

`EXISTS`命令返回`1`或者`0`去标记一个`key`是否存在。

`DEL`命令用来删除一个 key 和他所关联的 value 值。

`TYPE`命令返回一个这个 value 的数据类型。

```shell
127.0.0.1:6379> set mykey hello
OK
127.0.0.1:6379> type mykey
string
127.0.0.1:6379>
127.0.0.1:6379> exists mykey
(integer) 1
# 可以通过 del 命令的返回值是0还是1来判断删除是否成功
127.0.0.1:6379> del mykey
(integer) 1
# 使用 del 删除不存在的 key 时，返回0表示删除失败
127.0.0.1:6379> del key6
(integer) 0
127.0.0.1:6379>
127.0.0.1:6379>
127.0.0.1:6379> exists mykey
(integer) 0
```



### Redis 过期：key 的生命周期

在接受更复杂的数据结构之前，需要先讨论另外一个数据类型无关的特性，那就是 **Redis expires**。

Redis 的数据是存储于内存之中，所以对内存的清理是非常重要的，通常可以给 key 设置一个  timeout 时间，这就限定了这个 key 的生存时间。

当时间到了，key 直接被销毁，就好像用户主动调 del 命令删除它一样。

- 可以使用毫秒（millisecond）和秒（seconds）做为 key 的生命周期
- 最短的生命周期是1毫秒（millisecond）
- 过期信息的设置是保存在磁盘中持久存在的**，这意味着（当 redis 服务停止的时候，时间也是在走的，在redis持久化中可以进一步详细讲讲）
- 

```shell
127.0.0.1:6379> set key some-value EX 15
OK

127.0.0.1:6379127.0.0.1:6379> expire key 5  # 刷新key的过期时间，有很多应用有这种业务场景，例如记录会话的session。
(integer) 1
127.0.0.1:6379> get key   # 立即取值，key还存在
"some-value"
127.0.0.1:6379> get key    # 5秒以后执行get，key已被删除
(nil)
127.0.0.1:6379> expire key time   # 更新过期时间，也是这个命令

127.0.0.1:6379> TTL key  # 查看key的剩余生存时间 -1 表示永不过期

127.0.0.1:6379> PERSIST key # 将key设置为永久key

127.0.0.1:6379> PERSIST key # 将key设置为永久key




```



### redis 过期策略的内部实现



所谓缓存，即在第一次获取到数据的时候，把它暂存在内存中。

这样下次需要这个数据的时候，就直接从内存中取，不用再去查询数据库或调用远程接口，这样可以极大地提高应用程序的性能。

如果缓存中的数据永久存在，那占用的内存就会变得越来越大。而内存是有限的，所以缓存系统在必要的时候会删除一些不必要的缓存数据以节约内存空间。



在Redis内部，每当我们设置一个键的过期时间时，Redis就会将该键带上过期时间存放到一个**过期字典**中。

当我们查询一个键时，Redis 便首先检查该键是否存在过期字典中，如果存在，那就获取其过期时间。

然后将过期时间和当前系统时间进行比对，比系统时间大，那就没有过期；反之判定该键过期。





我们来看一下 redis 内部实现数据过期的机制：

**先说结论**：redis 内部的实现，使用 **定期删除**+**惰性删除** 两者配合的过期策略。

- **定时删除（定时器）**

  - 含义：在设置 key 的过期时间的同时，为该 key 创建一个定时器，让定时器在 key 的过期时间来临时，立即对 key 进行删除。

  - 优点：保证内存被尽快释放。

  - 缺点：

    - 若过期 key 很多，删除这些key会占用很多的 CPU 时间，在 CPU 时间紧张的情况下，CPU 不能把所有的时间用来做要紧的事儿，还需要去花时间删除这些 key。CPU时间开销（CPU要去寻址，要去寻找内存地址）

    - 定时器的创建耗时，若为每一个设置过期时间的key创建一个定时器（将会有大量的定时器产生），性能影响严重。

   - **从用户角度看，看起来 redis 应该就是这样实现的。为每个 key 设置定时器，到时进行删除淘汰。**

    - **但是实际上，因为这样会严重影响 redis 性能，所以redis 内部也不会这样实现。**

      

- **定期删除**

  - redis 内部默认每隔100ms就 **随机抽取** 一些设置了过期时间的key，检测这些 key 是否过期，如果过期了就将其删掉。

    因为key太多，如果全盘扫描所有的key会非常耗性能，所以是随机抽取一些key来删除。这样就有可能删除不完，需要惰性删除配合。

  - 优点：
    - 通过限制删除操作的时长和频率，来减少删除操作对CPU时间的占用–处理”定时删除”的缺点。
    

    
  - 缺点
    
    - 在内存友好方面，不如”定时删除”（会造成一定的内存占用，但是没有惰性删除那么占用内存）
    - 在CPU时间友好方面，不如”惰性删除”（会定期的去进行比较和删除操作，cpu方面不如懒汉式，但是比定时好）
    
  - 难点
  
    - 合理设置删除操作的执行时长（每次删除执行多长时间）和执行频率（每隔多长时间做一次删除）（这个要根据服务器运行情况来定了），每次执行时间太长，或者执行频率太高对cpu都是一种压力。
  
      每次进行定期删除操作执行之后，需要记录遍历循环到了哪个标志位，以便下一次定期时间来时，从上次位置开始进行循环遍历	


- **惰性删除**
  - 惰性删除不再是Redis去主动删除，而是在客户端要获取某个key的时候，Redis再去去检测一下这个key是否已经过期，如果没有过期则返回给客户端，如果已经过期了，那么Redis会删除这个key，不会返回给客户端。

  - 优点：
    - 删除操作只发生在通过key取值的时候发生，而且只删除当前key，所以对CPU时间的占用是比较少的，而且此时的删除是已经到了非做不可的地步（如果此时还不删除的话，我们就会获取到了已经过期的key了）
    - **缺点：**若大量的key在超出超时时间后，很久一段时间内，都没有被获取过，那么可能发生内存泄露（无用的垃圾占用了大量的内存）

  - 所以惰性删除可以解决一些过期了，但没被定期删除随机抽取到的key。但有些过期的key既没有被随机抽取，也没有被客户端访问，就会一直保留在数据库，占用内存，长期下去可能会导致内存耗尽。所以Redis提供了内存淘汰机制来解决这个问题。
  - 



### redis内存淘汰机制

在配置文件 redis.conf 中，可以通过参数 `maxmemory  <bytes>`  来设定最大内存。

当现有内存大于 maxmemory 时，便会触发 redis 主动淘汰内存方式，通过设置 maxmemory-policy



- 如果大量的key没有被扫描到，且已过期，也没有被再次访问，即没有走惰性删除，这些大量过期 key 堆积在内存里，也有可能导致 redis 内存块耗尽了。

- 这就引入了内存淘汰机制，redis 内部提供了**内存淘汰机制**。有很多种算法可以实现，比较典型的算法就是 LRU 算法，这跟 MySQL 内存缓冲池中的 LRU 算法是一个道理。

  > LRU是Least Recently Used的缩写，即最近最少使用。LRU源于操作系统的一种页面置换算法，选择最近最久未使用的页面予以淘汰。
  >
  > 在Redis里，就是选择最近最久未使用的key进行删除。很多面试面经，都说遇到过手撸 LRU 算法

- redis在使用内存达到某个阈值（通过maxmemory配置)的时候，就会触发内存淘汰机制，选取一些key来删除。

  ```shell
  # maxmemory <bytes> 配置内存阈值
  # maxmemory-policy noeviction   内存淘汰策略
  
  noeviction：当内存不足以容纳新写入数据时，新写入操作会报错。默认策略
  allkeys-lru：当内存不足以容纳新写入数据时，在键空间中，移除最近最少使用的key。
  allkeys-random：当内存不足以容纳新写入数据时，在键空间中，随机移除某个key。
  volatile-lru：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，移除最近最少使用的key。
  volatile-random：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，随机移除某个key。
  volatile-ttl：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，有更早过期时间的key优先移除。
  
  # 如何选取合适的策略？比较推荐的是两种lru策略。
  # 根据自己的业务需求：
  # 如果你使用Redis只是作为缓存，不作为DB持久化，那推荐选择allkeys-lru；
  # 如果你使用Redis同时用于缓存和数据持久化，那推荐选择volatile-lru。
  
  ```



### 结论

在实际中，如果我们要自己设计过期策略，**在使用惰性删除+定期删除时，控制时长和频率这个尤为关键，需要结合服务器性能，已经并发量等情况进行调整，以致最佳。**



http://www.jiangxinlingdu.com/redis/2019/01/31/delcore.html

https://liangshuang.name/2017/06/29/redis/



## 深入理解 redis 内存模型



工欲善其事必先利其器，在说明Redis内存之前首先说明如何统计Redis使用内存的情况。

在客户端通过redis-cli连接服务器后（后面如无特殊说明，客户端一律使用redis-cli），通过 info 命令可以查看内存使用情况：

其中，info 命令可以显示 redis 服务器的许多信息，包括服务器基本信息、CPU、内存、持久化、客户端连接信息等等；

memory是参数，表示只显示内存相关的信息。

```shell
127.0.0.1:7000>infomemory
# Memory
used_memory:1536400
used_memory_human:1.47M
used_memory_rss:8212480
used_memory_rss_human:7.83M
used_memory_peak:1539032
used_memory_peak_human:1.47M
used_memory_peak_perc:99.83%
used_memory_overhead:1478258
used_memory_startup:1461272
used_memory_dataset:58142
used_memory_dataset_perc:77.39%
allocator_allocated:1538472
allocator_active:1814528
allocator_resident:4329472
total_system_memory:8185995264
total_system_memory_human:7.62G
used_memory_lua:37888
used_memory_lua_human:37.00K
used_memory_scripts:0
used_memory_scripts_human:0B
number_of_cached_scripts:0
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.18
allocator_frag_bytes:276056
allocator_rss_ratio:2.39
allocator_rss_bytes:2514944
rss_overhead_ratio:1.90
rss_overhead_bytes:3883008
mem_fragmentation_ratio:5.49
mem_fragmentation_bytes:6717096
mem_not_counted_for_evict:0
mem_replication_backlog:0
mem_clients_slaves:0
mem_clients_normal:16986
mem_aof_buffer:0
mem_allocator:jemalloc-5.1.0
active_defrag_running:0
lazyfree_pending_objects:0
127.0.0.1:7000>
127.0.0.1:7000>
```



返回结果中比较重要的几个说明如下：

（1）**used_memory**：Redis分配器分配的内存总量（单位是字节），包括使用的虚拟内存（即swap）；Redis分配器后面会介绍。used_memory_human 只是显示更友好。

（2）**used_memory_rss**：Redis进程占据操作系统的内存（单位是字节），与top及ps命令看到的值是一致的；除了分配器分配的内存之外，used_memory_rss还包括进程运行本身需要的内存、内存碎片等，但是不包括虚拟内存。

因此，used_memory和used_memory_rss，前者是从Redis角度得到的量，后者是从操作系统角度得到的量。二者之所以有所不同，一方面是因为内存碎片和Redis进程运行需要占用内存，使得前者可能比后者小，另一方面虚拟内存的存在，使得前者可能比后者大。

由于在实际应用中，Redis的数据量会比较大，此时进程运行占用的内存与Redis数据量和内存碎片相比，都会小得多；因此used_memory_rss和used_memory的比例，便成了衡量Redis内存碎片率的参数；这个参数就是 mem_fragmentation_ratio。

（3）**mem_fragmentation_ratio**：内存碎片比率，该值是 used_memory_rss / used_memory 的比值。

mem_fragmentation_ratio一般大于1，且该值越大，内存碎片比例越大。mem_fragmentation_ratio<1，说明Redis使用了虚拟内存，由于虚拟内存的媒介是磁盘，比内存速度要慢很多，当这种情况出现时，应该及时排查，如果内存不足应该及时处理，如增加Redis节点、增加Redis服务器的内存、优化应用等。

一般来说，mem_fragmentation_ratio在1.03左右是比较健康的状态（对于jemalloc来说）；上面截图中的mem_fragmentation_ratio值很大，是因为还没有向Redis中存入数据，Redis进程本身运行的内存使得used_memory_rss 比used_memory大得多。

（4）**mem_allocator****：**Redis使用的内存分配器，在编译时指定；可以是 libc 、jemalloc或者tcmalloc，默认是jemalloc；截图中使用的便是默认的jemalloc。



### redis 内存划分

redis 作为内存数据库，在内存中存储的内容主要是数据（键值对）；通过前面的叙述可以知道，除了数据以外，redis 的其他部分也会占用内存

redis 的内存占用主要可以划分为以下几个部分：

## redis 集群







### redis高可用方案

- 持久化

- 主从复制
- 哨兵
- 集群



### 主从复制原理 

主从复制，是指将一台Redis服务器的数据，复制到其他的Redis服务器。

前者称为主节点(master)，后者称为从节点(slave)；数据的复制是单向的，只能由主节点到从节点。

在默认情况的单机版下：每台Redis服务器都是主节点；且一个主节点可以有多个从节点(或没有从节点)，但一个从节点只能有一个主节点。

每当 slave 和 master 之间的连接断开时， slave 会自动重连到 master 上，并且无论这期间 master 发生了什么， slave 都将尝试让自身成为 master 的完整精确副本。

主从复制的主要作用：

- 数据冗余：主从复制实现了数据的热备份，是持久化之外的一种数据冗余方式。

- 故障恢复：当主节点出现问题时，可以由从节点提供服务，实现快速的故障恢复；实际上是一种服务的冗余。

- 负载均衡：通过主从复制和读写分离，可以由主节点提供写服务，由从节点提供读服务。

  尤其是在写少读多的场景下，通过多个从节点分担读负载，可以大大提高Redis服务器的并发。（如电商网站的商品）

- **高可用基石：除了上述作用以外，主从复制还是哨兵和集群能够实施的基础，因此说主从复制是Redis高可用的基础。**





redis 复制主要通过如下机制实现：

- 当主节点和从节点连接良好时，主节点通过发送一个命令流来保持从节点的数据更新。（包括客户端的写入和更新，key过期或被逐出，或者其他变更）
- 当主节点和从节点连接故障，比如网络超时等。
  -  slave 重新连接上 master 并会尝试进行部分**重同步**：这意味着它会尝试只获取在断开连接期间内丢失的命令流。
- 当无法进行部分重同步时， slave 会请求进行全量重同步。
  - 这会涉及到一个更复杂的过程，例如 master 需要创建所有数据的快照，将之发送给 slave ，之后在数据集更改时持续发送命令流到 slave 。



redis 复制分为两种情况：

- **部分复制**：

  用于处理在主从复制中因网络闪断等原因造成的数据丢失场景，当从节点再次连上主节点后，如果条件允许，主节点会**补发丢失数据**给从节点。

  因为补发的数据远远小于全量数据，可以有效避免全量复制的过高开销。

  如果主节点的复制积压缓冲区内存在这部分数据则直接发送给从节点，这样就可以保持主从节点复制的一致性。

  补发的这部分数据一般远远小于全量数据，所以开销很小。



​      主节点何时认为从节点挂掉？

​      主从节点之间网络出现中断时，如果超过 `repl-timeout` 时间，主节点会认为从节点故障，并中断复制连接。

​      当主从连接恢复后，由于从节点之前保存了自身已复制的偏移量和主节点的运行ID。因此会把它们当作`psync`参数发送给主节点，要求进行部分复制操作。







Redis 默认使用**异步复制**，保证了低延迟和高性能，适用于绝大数的应用场景。

从节点会异步的处理主节点发过来的数据（周期性地）。所以主节点不需要一直等待直至一个命令被从节点处理完成。

但是，如果必要，主节点是可以感知到哪些从节点已经处理了哪些数据。（也就是说主节点能够感知复制状态）

这就给了同步复制留下可能。







- redis 默认使用异步复制，
- 一主可以多从
- 可以星形复制，也可以链式复制。
- redis 在主节点上是非阻塞的。





#### 建立主从复制

**主从复制的开启，完全是在从节点发起的；不需要我们在主节点做任何事情。**

从节点开启主从复制，有3种方式：

（1）配置文件

在从服务器的配置文件中加入：slaveof <masterip> <masterport>

（2）启动命令

redis-server启动命令后加入 --slaveof <masterip> <masterport>

（3）客户端命令

Redis服务器启动后，直接通过客户端执行命令：slaveof <masterip> <masterport>，则该Redis实例成为从节点。

上述3种方式是等效的，下面以客户端命令的方式为例，看一下当执行了 slaveof 后，Redis主节点和从节点的变化。



需要注意的是，从节点默认也可以进行读写操作，但从节点的写入将会导致这部分数据不会被同步，从而造成数据不一致的问题。

可以通过指定配置来强制从节点不可写入：

```shell
replica-read-only yes
```

此时对从节点进行写入操作会报错：

```shell
(error) READONLY You can't write against a read only replica.
```

在 redis-cli 中，通过执行 info replication 可以看到集群信息

```shell
# 其中有两个标识：

#     master_replid -- 长度为41个字节的字符串，主节点标识

#     master_replid2 -- 该节点上一次连接主实例的实例 master_replid
```





#### 实例

方便起见，实验所使用的主从节点是在一台机器上的不同Redis实例，其中主节点监听6379端口，从节点监听6380端口；

从节点监听的端口号可以在配置文件中修改：









#### 复制过程

主从复制过程大体可以分为3个阶段：连接建立阶段（即准备阶段）、数据同步阶段、命令传播阶段；下面分别进行介绍。

##### 连接建立阶段

该阶段的主要作用是在主从节点之间建立连接，为数据同步做好准备。

**步骤一、保存主节点信息**

从节点服务器内部维护了两个字段，即 masterhost 和 masterport 字段，用于存储主节点的 ip 和 port 信息。

需要注意的是，**slaveof** 是异步命令，从节点完成主节点 ip 和 port 的保存后，向发送 slaveof 命令的客户端直接返回 OK。然后才开始进行复制。



**步骤二、建立 socket 连接**

从节点每秒1次调用复制定时函数 replicationCron()，如果发现了有主节点可以连接，便会根据主节点的ip和port，创建socket连接。如果连接成功，则：

从节点：为该socket建立一个专门处理复制工作的文件事件处理器，负责后续的复制工作，如接收RDB文件、接收命令传播等。

主节点：接收到从节点的socket连接后（即accept之后），为该socket创建相应的客户端状态：

**并将从节点看做是连接到主节点的一个客户端，后面的步骤会以从节点向主节点发送命令请求的形式来进行。**



**步骤三、发送 ping 命令**

从节点成为主节点的客户端之后，发送ping命令进行首次请求，目的是：检查socket连接是否可用，以及主节点当前是否能够处理请求。

从节点发送ping命令后，可能出现3种情况：

（1）返回pong：说明socket连接正常，且主节点当前可以处理请求，复制过程继续。

（2）超时：一定时间后从节点仍未收到主节点的回复，说明socket连接不可用，则从节点断开socket连接，并重连。

（3）返回pong以外的结果：如果主节点返回其他结果，如正在处理超时运行的脚本，说明主节点当前无法处理命令，则从节点断开socket连接，并重连。



**步骤四、身份验证**

如果从节点中设置了masterauth 选项，则从节点需要向主节点进行身份验证；没有设置该选项，则不需要验证。从节点进行身份验证是通过向主节点发送auth命令进行的，auth 命令的参数即为配置文件中的 masterauth 的值。

如果主节点设置密码的状态，与从节点 `masterauth` 的状态一致（一致是指都存在，且密码相同，或者都不存在），则身份验证通过，复制过程继续；如果不一致，则从节点断开 socket 连接，并重连。







### redis-cluster 教程

Redis集群提供一种方式自动将数据分布在多个Redis节点上。

> Redis Cluster provides a way to run a Redis installation where data is **automatically sharded across multiple Redis nodes**.



Redis集群是一个distribute、fault-tolerant的Redis实现，主要设计目标是达到线性可扩展性、可用性、数据一致性。



- **线性拓展** 官方推荐最大的节点数量为1000，由于Cluster架构中无Proxy层，Master与Slave之间使用异步replication。
- **数据一致性** 客户端容忍一定程度的数据丢失，集群尽可能保存 Client write 操作的数据，保证数据一致性。
- **可用性** Redis集群通过 partition 来提供一定程度的可用性，当集群中的一部分节点失效或者无法进行通讯时，集群仍可以继续提供服务。
  - **只要集群中大多数 master 可达、且失效的 master 至少有一个 slave 可达，即集群非 Fail 状态，集群都是可用的。**
  - Redis集群的 replicas migration 机制可以将拥有多个 Slave 的 master的某个 slave，迁移到没有 slave的 master下，即 slave 分布相对平衡，确保 master 都有一定数量的 slave 备份。
  - 即在  A (A1, A2) B ( B1 , B1)  C ( C1 , C2 ) 这种机制下。

#### redis-cluster基本要求

- 在构建 redis cluster 集群时，至少需要 3(Master)+3(Slave) 才能建立集群。否则会创建失败。

  Redis-Cluster 采用无中心结构，每个节点保存数据和整个集群状态，每个节点都和其他所有节点连接。

  并且，**当集群中存活的master节点数小于总节点数的一半的话，集群就无法提供服务了。**

- 一般可以规划为：7 台机器，可以三台为 master，4 台为 replica 。这样 7 台机器中可以随便挂掉任意两台。（必须是依次挂掉，不能同时挂）

- **真集群： 生产环境中一定要准备6台服务器**，6个不同的 ip 地址，都是访问 637 端口。**假集群：一台服务器存在6个redis服务**，一个ip地址 6个不同的端口。





这是一份 redis-cluster 的教程，不会讲解一些复杂的分布式系统知识，提供了安装搭建配置 redis-cluster 的教程。这份教程仅仅是从用户视角来描述 cluster 。





实际上，在 redis-cluster 中。

- 在多个节点中自动分片数据集的能力。每个 master 上放一部分数据。
- 当集群中有节点失联或者故障时，继续提供支持的能力。（除非超过一半的 mater 节点挂掉）
- redis cluster 支撑 N 个 redis master node，每个 master node 都可以挂载多个 slave node。
- 可以很轻松的横向扩容更多 master 节点，每个 master 节点就能存放更多的数据了。





#### TCP端口

每个 redis 节点都需要开放两个 tcp 端口，默认的 6379 是给客户端连接使用。

第二个高端口用于集群总线（cluster bus），这是使用二进制协议进行点对点的通讯信道。

集群总线用于节点间的故障检测，配置更新，故障转移授权(failover authorization)等。

客户端永远不会与集群总线端口通讯。而是应该使用普通的命令端口。（但是要注意在防火墙中打开集群间的总线端口）

- 集群总线端口和命令端口的偏移量始终是固定的。值为 10000 （也就是说客户端端口是 6379，那么总线端口就是 16379）

- cluster bus 用了另外一种二进制的协议，gossip 协议，用于节点间进行高效的数据交换，占用更少的网络带宽和处理时间。



#### Redis集群数据分片-sharding

https://www.cnblogs.com/zhusihua/p/11328042.html

https://www.huaweicloud.com/articles/38e2316d01880fdbdd63d62aa26b31b4.html

redis 集群没有使用**一致性哈希**。它用一种不同的分片形式，在这种形式中，每个 key 都是一个概念性（**hash slot**）的一部分。中文也叫**哈希槽** 。

Redis 集群中默认分配了 16384 个 hash slots，当我们 set 一个key 时，会对 key 用`CRC16`算法来取模得到所属的`slot`，然后将这个 key 分到哈希槽区间的节点上。

为了计算给定的 key 应该在哪个 hash slot 上，我们简单地用这个 key 的 CRC16 值来对 16384 取模。

（即：key 的 CRC16  %  16384）

Redis集群中的每个节点负责一部分 hash slots，假设你的集群有3个节点，那么：

- Node A contains hash slots from 0 to 5500
- Node B contains hash slots from 5501 to 11000
- Node C contains hash slots from 11001 to 16383

**在构建 redis cluster 集群时，master 必须大于等于3，否则会创建失败。**

并且，**当集群中存活的 master 节点数小于总节点数的一半的话，集群就无法提供服务了。**



redis cluster 还允许随时添加和删除集群节点。比如，如果你想增加一个新的节点 D，那么就需要从 A、B、C 节点上删除一些 hash slot 给到 D。

同样地，如果你想从集群中删除节点 A，那么会将 A 上面的 hash slots 移动到 B 和 C，当节点 A 上是空的时候就可以将其从集群中完全删除。

因为将 hash slots 从一个节点移动到另一个节点并不需要停止其它的操作。

添加、删除节点、更改节点所维护的 hash slots 的百分比 都不需要任何停机时间。也就是说，移动 hash slots 是并行的，移动 hash slots 不会影响其它操作。



Redis支持多个 key 操作，只要这些key在一个单个命令中执行（或者一个事务，或者Lua脚本执行），那么它们就属于相同的 hash slot。

你也可以用 hash tags 俩强制多个key都在相同的 hash slot 中。



#### redis-cluster 主从模型



当部分 master 节点挂掉，或者不能够和大多数节点通信的时候，为了保持可用，Redis 集群使用 master-slave 模型。

这样的话每个 hash slot 就有 1 到 N 个副本。

在我们的例子中，集群有 A、B、C 三个节点，如果节点 B 挂了，那么 5501-11000 之间的 hash slot 将无法提供服务。

然而，当我们给每个 master 节点添加一个 slave 节点以后，我们的集群最终会变成由 A、B、C 三个 master 节点和 A1、B1、C1 三个 slave 节点组成。

节点 B1 是 B 的副本，如果 B 失败了，集群会将 B1 提升为新的 master，从而继续提供服务。然而，如果 B 和 B1 同时挂了，那么整个集群将不可用。



#### redis集群一致性保证



Redis集群不能保证强一致性。换句话说，Redis集群可能会丢失一些写操作。

Redis集群可能丢失写的第一个原因是因为它用异步复制。



写可能是这样发生的：

- 客户端写到 master B
- master B 返回客户端OK
- master B 将这个写操作广播给它的 slaves B1、B2、B3



正如你看到的那样，B 没有等到 B1、B2、B3 确认就回复客户端了，也就是说，B 在回复客户端之前没有等待 B1、B2、B3 的确认，

这对应Redis来说是一个潜在的风险。所以，如果客户端写了一些东西，B 也确认了这个写操作，但是在它将这个写操作发给它的 slaves 之前它宕机了，

随后其中一个slave（没有收到这个写命令）可能被提升为新的master，于是这个写操作就永远丢失了。



这和大多数的关系型数据库配置为每秒刷新一次数据到磁盘的情况是一样的。你可以通过强制数据库在返回客户端之前先刷新数据。

但是这样做的结果会导致性能很低，这就相当于同步复制了。

**基本上，还是需要在性能和一致性之间做一个权衡。**

> **Basically, there is a trade-off to be made between performance and consistency.**

当需要一致性时，redis-cluster 也是支持同步写的。通过 `WAIT` 命令。

然而，需要注意的是，Redis集群没有实现强一致性，即使用同步复制，因为总是有更复杂的失败场景使得一个没有接受到这个写操作的 slave 当选为新的 master。



在  A,B,C,A1,B1,C1 的场景中， Z 是客户端，当发生网络问题时，A, C, A1, B1, C1 在一个网络分区，Z和B在一个网络分区。

Z 仍然可以向 B 写入，如果很快网络好了，集群恢复，一切正常。

如果网络分区持续较长时间，这时候Z1往B中写数据，于此同时另一边（即A、C、A1、B1、C1）认为B已经挂了，于是将B1提升为master，当分区恢复的时候，由于B1变成了master，所以B就成了slave，于是B就要丢弃它自己原有的数据而从B1那里同步数据，于是乎先去Z1写到B的数据就丢失了。

**注意，有一个最大窗口，这是Z1能够向B写的最大数量：如果时间足够的话，分区的多数的那一边已经选举完成，选择一个slave成为master，此时，所有在少数的那一边的master节点将停止接受写。**

也就是说，有一个最大窗口的设置项，它决定了Z1在那种情况下能够向B发送多数写操作：如果分隔的时间足够长，多数的那边已经选举slave成为新的master，此后少数那边的所有master节点将不再接受写操作。

在Redis集群中，这个时间数量是一个非常重要的配置指令，它被称为node timeout。在超过 node timeout 以后，一个 master 节点被认为已经失败了，并且选择它的一个副本接替 master。

类似地，如果在过了node timeout时间以后，没有一个master能够和其它大多数的master通信，那么整个集群都将停止接受写操作。





 

#### redis集群配置参数



```
cluster-enabled  <yes/no>: 如果是yes，表示启用集群，否则以单例模式启动
cluster-config-file <filename>: 可选，这不是一个用户可编辑的配置文件，这个文件是Redis集群节点自动持久化每次配置的改变，为了在启动的时候重新读取它。
cluster-node-timeout <milliseconds>: 超时时间，集群节点不可用的最大时间。如果一个master节点不可到达超过了指定时间，则认为它失败了。注意，每一个在指定时间内不能到达大多数master节点的节点将停止接受查询请求。
cluster-slave-validity-factor <factor>: 如果设置为0，则一个slave将总是尝试故障转移一个master。如果设置为一个正数，那么最大失去连接的时间是node timeout乘以这个factor。
cluster-migration-barrier <count>: 一个master和slave保持连接的最小数量（即：最少与多少个slave保持连接），也就是说至少与其它多少slave保持连接的slave才有资格成为master。
cluster-require-full-coverage <yes/no>: 如果设置为yes，这也是默认值，如果key space没有达到百分之多少时停止接受写请求。如果设置为no，将仍然接受查询请求，即使它只是请求部分key。
```



#### 创建并使用 redis 集群

为了创建 redis 集群，必须要先启动一些以 cluster mode 模式运行的实例

最小配置文件如下：

```shell
# 端口
port 7000
# 开启集群模式
cluster-enabled yes
# 每个实例都包含一个文件，这个文件存储该节点的配置，模式是nodes.conf。是Redis集群实例启动的时候生成的，并且每次在需要的时候自动更新。
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
```



**最小的集群至少需要3个master节点**。这里，我们为了测试，在一台机器上用三主三从。

```shell

mkdir cluster-test
cd cluster-test
mkdir 7000 7001 7002 7003 7004 7005
cd 7000

# 填入配置
vim  redis.conf

# 记得修改端口
cp 7000/redis.conf 7001/
cp 7000/redis.conf 7002/
cp 7000/redis.conf 7003/
cp 7000/redis.conf 7004/
cp 7000/redis.conf 7005/

# 传入redis-server二进制文件

# 打开多个终端，依次启动多个实例

cd 7000
./redis-server 7000/redis.conf

cd 7001
./redis-server 7001/redis.conf 

cd 7002
./redis-server 7002/redis.conf 

cd 7003
./redis-server 7003/redis.conf 

cd 7004
./redis-server 7004/redis.conf
```



每个Redis实例都有一个ID，这是实例在集群上下文中的唯一标识。在节点的整个生命周期中这个唯一的ID是不会变的，我们把它叫做**Node ID**

每个节点内部，都是通过 Node ID 来记住其他 node，而不是IP和端口。



**创建集群**

现在已经有一些运行中的节点了，需要创建集群。

redis5 可以使用 redis-cli 工具来管理集群。

redis3 或 redis4 可以使用 redis-trib.rb 这个工具。在 redis 源代码中的 src 目录中。

```shell
#  redis-trib.rb是一个 ruby 语言的工具，所以需要安装ruby
yum install ruby
yum install rubygems
gem install redis

# 如果提示ruby版本过低，可以使用这个
yum install -y centos-release-scl-rh rh-ruby23
scl  enable  rh-ruby23 bash
ruby -v
```



```shell
# 在 redis5 中使用redis-cli创建集群
redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 \
127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 \
--cluster-replicas 1



# 在 redis3或redis4 中使用ruby脚本来创建集群
./redis-trib.rb create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 \
127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005


# 使用 create 命令来创建集群，--cluster-replicas 1 这个选项表示为每一个master都创建一个slave节点
# 剩下的是集群中节点实例的地址
```





执行上述命令侯，redis-cli 工具会弹出交互式 prompt 来让你确认主从关系，输入 yes 确认就开始进行配置。

最终的输出如下：

```shell
[OK] All 16384 slots covered
```

这表示集群已经安装完成。



#### 使用脚本创建redis集群

在生产环境，一般都不会手动创建 redis 集群实例

在 redis 源代码的 utils/create-cluster 目录中，有一个脚本文件 create-cluster ，这是一个简单的 bash 脚本，可以直接启动三主三从节点的集群。

```shell
# create-cluster是一个快速搭建redis集群的脚本，这个脚本中定义的端口号是从30000开始
# 使用方法：
#	1.编辑修改 create-cluster 这个文件里面的端口号
#   2.调用 ./create-cluster start 来启动实例
#	3.调用 ./create-cluster create 来创建集群
#	4.集群启动成功，在当前目录下会为每个实例生成 AOF文件和日志文件


#   ./create-cluster stop 停止所有实例，
#   ./create-cluster clean 删除AOF文件和日志i文件，生成干净的新实例



create-cluster start
create-cluster create 
```



#### 玩转 redis 集群



这个阶段，缺少的是 redis 客户端库的实现。

- redis-rb-cluster  是一个 ruby 实现的脚本，它是对原生的  redis-rb 的封装。https://github.com/antirez/redis-rb-cluster
- preids 是一个很好的支持 php7.2 及以上的 reids 客户端库。
  - predis 默认不需要任何C扩展。可以跟 phpiredis 一起





使用命令行来连接 redis 集群



```shell
# -c 允许集群模式  -p 端口
$ redis-cli -c -p 7000
redis 127.0.0.1:7000> set foo bar
-> Redirected to slot [12182] located at 127.0.0.1:7002
OK
redis 127.0.0.1:7002> set hello world
-> Redirected to slot [866] located at 127.0.0.1:7000
OK
redis 127.0.0.1:7000> get foo
-> Redirected to slot [12182] located at 127.0.0.1:7002
"bar"
redis 127.0.0.1:7000> get hello
-> Redirected to slot [866] located at 127.0.0.1:7000
"world"

# 如果没有修改端口，实际可能是从 30001 开始

# 由于 redis-cli 是很基础的工具，所以 set key 直接重定向分不到不同的后端节点上。
# 实际上，对于一些客户端连接来说，其实会在hash slots间和节点间缓存 map。
# 只有在 cluster 配置变更。例如发生故障切换，以及新增删除节点调整cluster架构时，map才会被刷新。

```



#### 使用 redis-rb-cluster 连接 redis-cluster

在对 redis-cluster 管理之前，使用 ruby 搭建一个 demo 环境来连 redis-cluster 来演示 redis-cluster 的故障切换，配置更新等。

https://github.com/antirez/redis-rb-cluster





#### 集群分片

分布式系统的数据分片，可以看这篇文章 <https://www.cnblogs.com/xybaby/p/7076731.html>

redis 集群是通过分片（shard）方式， 将一个数据库划分为多个部分， 并将不同部分交给集群中的不同服务器来处理， 从而达到扩展性能的目的。

分片后，redis 集群有 16384个 哈希槽，每个 key 通过CRC16 校验后对 16384 取模来决定放置哪个槽，集群的每个节点负责一部分 hash 槽。

数据库中的每个键都属于这 16384 个槽的其中一个，集群中的每个节点可以处理 0 个或者最多 16384 个槽。

> 为什么集群中只能有 16384 个槽？
>
> <https://github.com/redis/redis/issues/2576>

集群最主要的，解决的是一个“数据分片”的问题，它能把 redis 的数据分散到不同的 slot 里，而不是都集中在一台机器的内存里。这样也就给单进程单线程、纯内存的 redis 提供了水平扩容的能力。

但是这是有代价的， 一部分命令无法跨节点执行，比如 zunionstore 等一些命令，它涉及多个 key，因此在集群状态下，需要自行保证这些 key 都在一个 slot 上；

再比如 watch exec， 在单节点或哨兵场景下可以用，但集群模式下是不能使用的。还有一些命令，在集群状态下虽能执行或有替代方案，但会丧失原子性。 比如 mget 等。



redis cluster 并没有使用一致性哈希来计算 key 对应的节点，而是通过记录一张映射表 hash slots 的方式。通过对 key 进行如下算法，来确认 key 所在节点的 slot 。

 ```shell
# 计算 slotid
slot = CRC16(key) % 16384
 ```



仅仅定位到 slotid，还需要通过 slotid 定位到 nodeid，在集群内部通过记录一张映射表（slotId->nodeId）的方式来实现的。节点之间通过 gossip 协议来广播这个关系，可以迅速收敛。

如果客户端将不属于该 node 的一个 slot 请求发送到该 node 上，redis 会通过查表，快速找到该 slot 请求本应该去的 node，然后向 client 返回 MOVED 消息。



其中， 数据库的每个部分就是一个槽（slot）， 一个槽可以包含任意多个键（key）； 而集群中的每个服务器则是一个节点（node）。

redis cluster 并没有使用一致性哈希来计算 key 对应的节点，而是通过记录一张映射表 hash slots 的方式。

通过对 key 进行如下算法，来确认 key 所在节点的 slot 

```shell

```



| 槽          | 负责的节点 |
| :---------- | :--------- |
| 0~5461      | node_a     |
| 5462~10922  | node_b     |
| 10923~16383 | node_c     |

https://redis.io/topics/client-side-caching







然后， 每当用户想要访问键 k 时， 客户端都会通过以下公式， 计算出键 key 所在的槽：

```shell
slot = CRC16(key) % 16384
```

然后客户端就可以根据 `slot` 的值以及槽分配的表格， 直接对槽所在的节点进行访问， 在这种情况下， 客户端只需要一次访问就可以获取到键 k 的值。



#### **reid-cluster 客户端实现**

按照 redis 官方规范，一个 redis 客户端可以向集群中的任意节点（包括从节点）发送命令请求。

单节点 redis 和 redis 集群的客户端的实现方式不一样，redis集群客户端的大致处理流程如下:

- 客户端初始化，随机选择一个node 通信，获取 hashslot->node 映射表和 nodes 信息；
- 向 cluster 中所有 node 建立连接，并为每个 node 创建一个连接池;
- 发送请求的时候，先在本地计算key的hashslot，再在本地映射表找到对应node;
- 若目标 node 正好持有那个 hashslot ，那么正常处理.
- 

比如这样：

节点会对命令请求进行分析，如果该命令是集群可以执行的命令，那么节点会查找这个命令所要处理的键所在的槽。

如果处理该命令的槽位于当前节点，那么命令可以顺利执行，否则当前节点会返回 MOVED 错误（重定向），让客户端到另一个节点执行该命令。

redis 官方规范要求所有客户端都应处理 MOVED 错误，从而实现对用户的透明。

我们上面看到的错误就是 MOVED 错误：

```shell
(error) MOVED 866 172.21.16.4:6379
```



他表示，该执行该命令所需要的 slot 是 866 号哈希槽，负责该槽的节点是 172.21.16.4:6379



> 在一般情况下， redis 集群的客户端都会在内部缓存集群的槽分配情况（但并不是强制）
>
> 每次 REDIS 指令操作后，客户端应该记录下正确的节点与槽之间的对应关系 -- 槽位路由表，来提升性能	

比如，redis-go-cluster 是基于 Redigo 实现的 Golang Redis 客户端。redis-go-cluster 可以在本地缓存 slot 信息，并且当集群修改的时候会自动更新。

此客户端管理每个节点连接池，使用 goroutine 来尽可能的并发执行，达到了高效，低延迟。





> github.com/go-redis/redis 是一个非常友好的 redis 的SDK










**写入安全性**

redis cluster 集群节点间使用**异步复制**传输数据，最后一次故障转移执行隐式合并动作（last failover wins implicit merge function）。

这意味着最后被选举出来的master的数据集最终会覆盖到其他 slave 副本节点。

使用异步复制的缺点就是在故障期间总会丢失一点数据，但连接到大多数 master 节点的客户端与连接到极少部分 master 节点的客户端情况完全不同。

redis 集群会尽量保存所有与大多数 master 节点连接的客户端执行的写入，但以下两种情况除外：

1、一个写入操作能到达一个master节点，但当master节点准备回复客户端时，此写入可能还未通过异步复制到它的 slave 复制节点。

若master节点在写入还未复制到slave节点时挂掉，那么此次写入就会丢失，若 master 节点不可达，就会有一个合适的 slave 被提升为新 master。

2、理论上另一种写入可能的丢失的情况：

　　　a、网络故障造成网络分区，致使 master 节点不可达

　　    b、故障转移导致 slave 节点被提升为 master

　　    c、master节点再次可达

　　    d、网络分区后 master 节点隔离，使用过时路由信息（out-of-date routing table）的客户端写入数据到旧 master 节点





#### redis 重分片

随着数据量的增多或者访问量的加大， 集群中的一个或多个节点可能会无法继续处理之前分配给它们的槽， 这时用户就需要对集群进行重分片（reshard）。

 也即是， 给集群增加更多节点， 并把之前由已有节点处理的槽分配一部分给新节点负责。



分片其实就是把 hash slots 从一组 nodes 移动到另外一组 nodes 。就像使用 redis-cli 工具创建 cluster 一样。



```shell
redis-cli --cluster reshard 127.0.0.1:7000
```



当前 redis-cli 是唯一官方支持的分片管理方式，





### redis-cli cluster 命令

https://www.cnblogs.com/zhoujinyi/p/11606935.html



### redis-cluster 规范



redis 集群不像单机 redis 那样支持多数据库功能， 集群只使用默认的 `0` 号数据库(database0)， 并且不能使用 [SELECT index](http://redisdoc.com/database/select.html#select) 命令。



#### Redis 集群协议中的客户端和服务器

Redis 集群中的节点有以下责任：

- 持有键值对数据。
- 记录集群的状态，包括键到正确节点的映射（mapping keys to right nodes）。
- 自动发现其他节点，识别工作不正常的节点，并在有需要时，在从节点中选举出新的主节点。

为了执行以上列出的任务， 集群中的每个节点都与其他节点建立起了“集群总线（cluster bus）”， 该连接是一个 TCP 连接， 使用二进制协议进行通讯。

节点之间使用 [Gossip 协议](http://en.wikipedia.org/wiki/Gossip_protocol) 来进行以下工作：

- 传播（propagate）关于集群的信息，以此来发现新的节点。
- 向其他节点发送 `PING` 数据包，以此来检查目标节点是否正常运作。
- 在特定事件发生时，发送集群信息。

除此之外， 集群连接还用于在集群中发布或订阅信息





## redis 哨兵模式

<https://www.cnblogs.com/kevingrace/p/9004460.html>

https://v2ex.com/t/696387

redis 哨兵（sentinel ）也是企业场景中最常见的高可用方案。也是官方推荐的高可用方案。

redis-sentinel 本身也是一个独立运行的进程，它能监控多个 master-slave 集群，发现 master 宕机后能进行自动切换。

当一个集群中的 master 失效之后，sentinel 可以选举出一个新的 master 用于自动接替 master 的工作。

集群中的其他 redis 服务器自动指向新的 master 同步数据。

一般建议 sentinel 采取奇数台，防止某一台 sentinel 无法连接到 master 导致误切换。其结构如下:



![img](assets/907596-20190323122922777-731412975.png)





**哨兵(sentinel) 是一个分布式系统，你可以在一个架构中运行多个哨兵(sentinel) 进程。**

这些进程使用流言协议(gossip protocols)来接收关于Master 是否下线的信息。



**Sentinel 状态持久化**

snetinel 的状态会被持久化地写入sentinel 的配置文件中。

每次当收到一个新的配置时，或者新创建一个配置时，配置会被持久化到硬盘中，并带上配置的版本戳。

**这意味着，可以安全的停止和重启sentinel进程。**



redis的哨兵(sentinel) 系统用于管理多个 redis 服务器组，该系统执行以下三个任务:

- **监控(Monitoring)**：哨兵(sentinel) 会不断地检查你的 Master 和 Slave 是否运作正常。

- **提醒(Notification)**：当被监控的某个 Redis 组出现问题时, 哨兵(sentinel) 可以通过 API 向管理员或者其他应用程序发送通知。
- **故障转移(Automatic failover)**：当一个Master不能正常工作时，哨兵(sentinel) 会开始一次自动故障迁移操作；
  - 它会将失效 Master 的其中一个 Slave 升级为新的 Master,
  -  并让失效 Master 的其他 Slave 改为复制新的 Master; 
  - 当客户端试图连接失效的 Master 时,集群也会向客户端返回新Master的地址,使得集群可以使用新 master代替失效的 Master。
  - master_redis.conf、slave_redis.conf和 sentinel.conf 的内容都会发生改变，即 master_redis.conf 中会多一行 slaveof 的配置，sentinel.conf 的监控目标会随之调换。



**Sentinel工作方式（每个Sentinel实例都执行的定时任务）**

1）每个 Sentinel 以每秒钟一次的频率向它所管理的 Master，Slave 以及其他 Sentinel 实例发送一个 PING 命令。
2）如果一个实例（instance）距离最后一次有效回复 PING 命令的时间超过 own-after-milliseconds 选项所指定的值，则这个实例会被 Sentinel 标记为主观下线。 
3）如果一个 Master 被标记为主观下线，则正在监视这个 Master 的所有 Sentinel 要以每秒一次的频率确认 Master 的确进入了主观下线状态。 
4）当有足够数量的 Sentinel（大于等于配置文件指定的值）在指定的时间范围内确认 Master 的确进入了主观下线状态，则 Master 会被标记为客观下线。
5）在一般情况下，每个 Sentinel 会以每 10 秒一次的频率向它已知的所有 Master，Slave 发送 INFO 命令。
6）当 Master 被 Sentinel 标记为客观下线时，Sentinel 向下线的 Master 的所有 Slave 发送 INFO 命令的频率会从 10 秒一次改为每秒一次。 
7）若没有足够数量的 Sentinel 同意 Master 已经下线，Master 的客观下线状态就会被移除。 若 Master 重新向 Sentinel 的 PING 命令返回有效回复，Master 的主观下线状态就会被移除。

**sentinel在内部有3个定时任务**

- 每10秒对每个sentinel会对master和slave执行info命令，这个任务达到两个目的：
  - a）发现slave节点
  - b）确认主从关系
- 每2秒每个sentinel通过master节点的channel交换信息（pub/sub）。master节点上有一个发布订阅的频道(__sentinel__:hello)。sentinel节点通过__sentinel__:hello频道进行信息交换(对节点的"看法"和自身的信息)，达成共识。
- 每1秒每个 sentinel 对其他 sentinel 和 redis 节点执行 ping 操作（相互监控），这个其实是一个心跳检测，是失败判定的依据。



**主观下线**：仅哨兵集群中的一个哨兵进程或少数哨兵进程认为实例下线。

**客观下线**：**不但哨兵自己认为节点宕机，而且该哨兵与其他哨兵沟通后，达到一定数量的哨兵都认为实例下线。**

这里的「一定数量」是一个法定数量（Quorum），是由哨兵监控配置决定的，解释一下该配置：



**Sentinel支持集群**（可以部署在多台机器上，也可以在一台物理机上通过多端口实现伪集群部署）

很显然，只使用单个 sentinel 进程来监控 redis 集群是不可靠的，当 sentinel 进程宕掉后

(sentinel 本身也有单点问题，single-point-of-failure) 整个集群系统将无法按照预期的方式运行。所以有必要将 sentinel 集群，这样有几个好处：

1）即使有一些 sentinel 进程宕掉了，依然可以进行 redis 集群的主备切换；

2）如果只有一个sentinel进程，如果这个进程运行出错，或者是网络堵塞，那么将无法实现redis集群的主备切换（单点问题）;

3）如果有多个sentinel，redis的客户端可以随意地连接任意一个 sentinel来获得关于redis集群中的信息。



redis 哨兵是如何保证高可用的



### redis 哨兵方案



在 redis 中，一主两从三哨兵，这是最经典的 redis 哨兵方案。

生产环境使用三台服务器搭建redis哨兵集群，3个redis实例（1主2从）+ 3个哨兵实例：



![img](assets/2b172a3ba4d71e7a2005e9bf4074d9adab7.jpg)



- redis.conf 配置主从
- sentinel.conf 配置哨兵







## redis 哨兵和集群的异同



Sentinel 系统用于管理多个 Redis 服务器（instance）， 该系统执行以下三个任务：

**监控（Monitoring）**： Sentinel 会不断地检查你的主服务器和从服务器是否运作正常。

**提醒（Notification）**： 当被监控的某个 Redis 服务器出现问题时， Sentinel 可以通过 API 向管理员或者其他应用程序发送通知。

**自动故障迁移（Automatic failover）**： 当一个主服务器不能正常工作时， Sentinel 会开始一次自动故障迁移操作， 它会将失效主服务器的其中一个从服务器升级为新的主服务器， 并让失效主服务器的其他从服务器改为复制新的主服务器； 当客户端试图连接失效的主服务器时， 集群也会向客户端返回新主服务器的地址， 使得集群可以使用新主服务器代替失效服务器。

客户端中不会记录redis的地址（某个IP），而是记录sentinel的地址，这样我们可以直接从sentinel获取的redis地址，因为sentinel会对所有的master、slave进行监控。

它是知道到底谁才是真正的master的，例如我们故障转移，这时候对于sentinel来说，master是变了的，然后通知客户端。

而客户端根本不用关心到底谁才是真正的master，只关心sentinel告知的master。









cluster是为了解决单机Redis容量有限的问题，将数据按一定的规则分配到多台机器。集群模式提高并发量。







### 高可用角度

哨兵： 哨兵仅仅提供故障切换能力，在这之上，对使用方来说，和单机的 redis 是完全一样的。客户端只需要连接一个IP地址。

集群： 集群最主要的，解决的是一个“数据分片”的问题，它能把 redis 的数据分散到不同的 slot 里，而不是都集中在一台机器的内存里。这样也就给单进程单线程、纯内存的 redis 提供了水平扩容的能力。

​		



### 数据分片





### 运维复杂度

集群模式显然比哨兵模式更重、需要更多的资源去运行；再就是部署运维复杂度也是更高的。

而哨兵和单节点，一般来说除了配置稍有区别以外，绝大部分业务代码是可以相容的，无需特地修改。

 而现有的代码如果使用了集群模式不支持的那些命令，那么集群模式下是无法正常工作的。所以目前哨兵模式仍然被广泛使用，没有被集群模式彻底替代。  



### 方案选择和对比



1. 集群 cluster 中,主服务器的从服务器不能读取数据，操作从服务器会发送 move 转向错误到对应的主服务器。

2. 集群 cluster 中从服务器存在意义：

   - 作为主服务器的数据备份;

   - 在 redis.config 配置允许的情况下，在主服务器故障时候会触发 [自动故障转移] ，升级为主服务器;

   - 在 redis.config 配置允许的情况下，主服务器裸奔后，可以自动从其他主服务器的从服务器中迁移一台过来成为裸奔主服务器的从服务器。

3. 哨兵 sentine 不是吃白饭的，可以监控、通知、自动故障转移，可以监控多个主从体系。数据量不是瓶颈的话 sentinel 更有保障，更省钱（生产 2 台服务器就行）











## redis 持久化

https://juejin.cn/post/6844903998986665992



持久化就是把内存的数据写到磁盘中去，防止服务宕机了内存数据丢失。



**面试题**

redis 的持久化有哪几种方式？不同的持久化机制都有什么优缺点？持久化机制具体底层是如何实现的？

**面试官心理分析**

redis 如果仅仅只是将数据缓存在内存里面，如果 redis 宕机了再重启，内存里的数据就全部都弄丢了啊。

你必须得用 redis 的持久化机制，将数据写入内存的同时，异步的慢慢的将数据写入磁盘文件里，进行持久化。

如果 redis 宕机重启，自动从磁盘上加载之前持久化的一些数据就可以了，也许会丢失少许数据，但是至少不会将所有数据都弄丢。

这个其实一样，针对的都是 redis 的生产环境可能遇到的一些问题，就是 redis 要是挂了再重启，内存里的数据不就全丢了？能不能重启的时候把数据给恢复了？

持久化主要是做灾难恢复、数据恢复，也可以归类到高可用的一个环节中去，比如你 redis 整个挂了，然后 redis 就不可用了，你要做的事情就是让 redis 变得可用，尽快变得可用。

重启 redis，尽快让它对外提供服务，如果没做数据备份，这时候 redis 启动了，也不可用啊，数据都没了。

很可能说，大量的请求过来，缓存全部无法命中，在 redis 里根本找不到数据，这个时候就死定了，出现缓存雪崩问题。

所有请求没有在 redis 命中，就会去 mysql 数据库这种数据源头中去找，一下子 mysql 承接高并发，然后就挂了...

如果你把 redis 持久化做好，备份和恢复方案做到企业级的程度，那么即使你的 redis 故障了，也可以通过备份数据，快速恢复，一旦恢复立即对外提供服务。





Redis 提供两种持久化机制 RDB（默认） 和 AOF 机制:



### RDB(快照)

RDB：是 Redis DataBase 缩写。是一种快照式的持久化方法，将某一时刻的数据持久化到磁盘中。

在客户端中执行 `save` 命令，就会触发 Redis 的持久化，但同时也是使 Redis 处于阻塞状态。

直到 RDB 持久化完成，才会响应其他客户端发来的命令，所以**在生产环境一定要慎用**。



bgsave（background save）即后台保存的意思， 它和 `save` 命令最大的区别就是 `bgsave` 会 fork() 一个子进程来执行持久化。

整个过程中只有在 fork() 子进程时有短暂的阻塞，当子进程被创建之后，Redis 的主进程就可以响应其他客户端的请求了。

相对于整个流程都阻塞的 `save` 命令来说，显然 `bgsave` 命令更适合我们使用。



RDB是Redis默认的持久化方式。按照一定的时间将内存的数据以快照的形式保存到硬盘中，对应产生的数据文件为 dump.rdb。

通过配置文件中的save参数来定义快照的周期。



![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly91cGxvYWQtaW1hZ2VzLmppYW5zaHUuaW8vdXBsb2FkX2ltYWdlcy80MDU1NjY2LWMwNzAyMjIzMTUxODUyMjkucG5n?x-oss-process=image/format,png)





RDB 就是Snapshot快照存储，是默认的持久化方式。可理解为半持久化模式，即按照一定的策略周期性的将数据保存到磁盘。对应产生的数据文件为dump.rdb，通过配置文件中的save参数来定义快照的周期。下面是默认的快照设置：

```shell
# save m n 是指在 m 秒内，如果有 n 个键发生改变，则自动触发持久化。
# 参数 m 和 n 可以在 Redis 的配置文件中找到，例如，save 60 1 则表明在 60 秒内，至少有一个键发生改变，就会触发 RDB 持久化。
# 自动触发持久化，本质是 Redis 通过判断，如果满足设置的触发条件，自动执行一次 bgsave 命令。
# save参数可以配置多组，满足在不同条件的备份要求。

save 900 1     # 当至少有一条Keys数据被改变时，900秒刷新到Disk一次
save 300 10    # 当有10条Keys数据被改变时，300秒刷新到Disk一次
save 60 10000  # 在 60 秒内，至少有一个键发生改变，就会触发 RDB 持久化刷到磁盘。
```



Redis 的 RDB 文件不会坏掉，因为其**写操作是在一个新进程中进行的**。

当生成一个新的 RDB 文件时，Redis生成的子进程会先将数据写到一个临时文件中，然后通过原子性 rename 系统调用将临时文件重命名为 RDB 文件。这样在任何时候出现故障，Redis 的 RDB 文件都总是可用的。



优点：

- 1、只有一个文件 dump.rdb，方便持久化。非常适合备份。
- 2、容灾性好，一个文件可以保存到安全的磁盘。
- 3、性能最大化，fork 子进程来完成写操作，让主进程继续处理命令，所以是 IO 最大化。使用单独子进程来进行持久化，主进程不会进行任何 IO 操作，保证了 redis 的高性能。
- 4、相对于数据集大时，比 AOF 的启动效率更高。

缺点：

- 1、数据安全性低。RDB 是间隔一段时间进行持久化，如果持久化之间 redis 发生故障，会发生数据丢失。所以这种方式更适合数据要求不严谨的时候。
- 2、AOF（Append-only file)持久化方式： 是指所有的命令行记录以 redis 命令请 求协议的格式完全持久化存储)保存为 aof 文件。





### AOF持久化

AOF日志是通过保存 Redis 写命令来记录数据库数据的。

大多数的数据库采用的是**写前日志（WAL）**，例如MySQL，通过**写前日志**和**两阶段提交**，实现数据和逻辑的一致性。

AOF日志采用**写后日志**，即先写内存，后写日志。

Redis要求高性能，采用写日志有两方面好处：

1. 避免额外的检查开销
2. 不会阻塞当前的写操作

但这种方式存在潜在风险：

1. 如果命令执行完成，写日志之前宕机了，会丢失数据。
2. 主线程写磁盘压力大，导致写盘慢，阻塞后续操作。

AOF 日志记录 Redis 的每个写命令，步骤分为：命令追加（append）、文件写入（write）和文件同步（sync）。

**命令追加**

当AOF持久化功能打开了，服务器在执行完一个写命令之后，会以协议格式将被执行的写命令追加到服务器的 `aof_buf` 缓冲区。

**文件写入和同步**

关于何时将 `aof_buf` 缓冲区的内容写入AOF文件中，Redis提供了三种写回策略：

- `Always，同步写回`：每个写命令执行完，立马同步地将日志写回磁盘；
- `Everysec，每秒写回`：每个写命令执行完，只是先把日志写到AOF文件的内存缓冲区，每隔一秒把缓冲区中的内容写入磁盘；
- `No，操作系统控制的写回`：每个写命令执行完，只是先把日志写到AOF文件的内存缓冲区，由操作系统决定何时将缓冲区内容写回磁盘。

 



上面的三种写回策略体现了一个重要原则：**trade-off，取舍，指在性能和可靠性保证之间做取舍**。

关于AOF的同步策略是涉及到操作系统的 `write` 函数和 `fsync` 函数的，在《Redis设计与实现》中是这样说明的：

> 为了提高文件写入效率，在现代操作系统中，当用户调用`write`函数，将一些数据写入文件时，操作系统通常会将数据暂存到一个内存缓冲区里。
>
> 当缓冲区的空间被填满或超过了指定时限后，才真正将缓冲区的数据写入到磁盘里。
>
> 这样的操作虽然提高了效率，但也为数据写入带来了安全问题：如果计算机停机，内存缓冲区中的数据会丢失。
>
> 为此，操作系统提供了`fsync`、`fdatasync`同步函数，可以强制操作系统立刻将缓冲区中的数据写入到硬盘里，从而确保写入数据的安全性。



#### AOF配置

默认情况下，Redis是没有开启AOF的，可以通过配置 redis.conf 文件来开启AOF持久化

```shell
# appendonly参数开启AOF持久化
appendonly no

# AOF持久化的文件名，默认是appendonly.aof
appendfilename "appendonly.aof"

# AOF文件的保存位置和RDB文件的位置相同，都是通过dir参数设置的
dir ./

# 同步策略
# appendfsync always
appendfsync everysec
# appendfsync no

# aof重写期间是否同步
no-appendfsync-on-rewrite no

# 重写触发配置
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# 加载aof出错如何处理
aof-load-truncated yes

# 文件重写策略
aof-rewrite-incremental-fsync yes
```

#### AOF重写

AOF会记录每个写命令到AOF文件，随着时间越来越长，AOF文件会变得越来越大。

如果不加以控制，会对Redis服务器，甚至对操作系统造成影响，而且AOF文件越大，数据恢复也越慢。

为了解决AOF文件体积膨胀的问题，Redis提供AOF文件重写功能来对AOF文件进行"瘦身"。

Redis通过创建一个新的AOF文件来替换现有的AOF，新旧两个AOF文件保存的数据相同，但新AOF文件没有了冗余命令。

简单来说，AOF重写就是把旧AOF日志文件的多条命令，在重写后变成新日志文件的一条命令。

[**AOF重写原理**](https://blog.csdn.net/hezhiqiang1314/article/details/69396887)

AOF重写并不需要对原有AOF文件进行任何的读取，写入，分析等操作，这个功能是通过读取服务器当前的数据库状态来实现的。



**AOF重写会阻塞吗**？AOF重写是由后台线程bgrewriteaof来完成的。

**AOF重写过程**

用一句话总结：**一个拷贝，两处日志**。一个拷贝指一份内存拷贝，两处日志分别是一处正在使用的AOF日志，另一处是新的AOF重写日志。



#### 关于AOF重写过程的潜在阻塞风险

前面提到AOF重写不会阻塞，指的是在AOF重写过程不会阻塞主线程，因为是通过后台bgrewriteaof线程来执行的。

但是在fork子进程的时候，fork这个瞬间一定是会阻塞主线程的。

fork采用的是操作系统提供的写时复制（Copy On Write）机制，避免一次性拷贝造成的阻塞。

但fork子进程需要拷贝进程必要的数据结构，其中有一项是**拷贝内存页表**（虚拟内存和物理内存的映射索引表），这个拷贝过程会消耗大量的CPU资源，在拷贝完成之前，整个进程是会阻塞的。

拷贝内存页完成后，子进程与父进程指向相同的内存地址空间，也就是说此时虽然产生了子进程，但是并没有申请与父进程相同的内存大小。

那什么时候父子进程才会真正内存分离呢？在写发生时，才真正拷贝内存的数据，这个过程中，父进程也可能会产生阻塞风险。

因为内存分配是以页为单位进行分配的，默认4K，如果父进程此时操作的是一个bigkey，重新申请大块内存耗时会变长，可能会产生阻塞风险。

另外，如果操作系统开启了内存大页机制（Huge Page，页面大小2M）。

那么父进程申请内存时阻塞的概率将会大大提高，所以**在Redis机器上需要关闭Huge Page机制。**





参考 https://www.cnblogs.com/liang24/p/14180036.html

### 文件写入和同步

## redis 实现分布式 session

传统的 session 由服务器端生成并存储，当应用进行分布式集群部署的时候，  如何保证不同服务器上session信息能够共享呢？可以使用 redis 



 Cookie 保存在客户端浏览器中，而 Session 保存在服务器上。客户端浏览器访问服务器的时候，服务器把客户端信息以某种形式记录在服务器上，这就是 Session。

客户端浏览器再次访问时只需要从该 Session 中查找该客户的状态就可以了。



 在实际工作中我们建议使用外部的缓存设备来共享 Session，避免单个服务器节点挂掉而影响服务，共享数据都会放到外部缓存容器中。





## redis 开发规范









## 关于redis的经典文章以及回答

<https://www.cnblogs.com/kevingrace/p/9004460.html>

https://v2ex.com/t/696387





# 双写一致性

> 计算机科学领域只有两件难事：缓存失效和命名东西——Phil Karlton



由于是 redis 和 db 都存放了数据，所以就出现了一致性问题。如何保证写操作的数据一致性，就是一个问题。

双写一致性的含义就是：保证缓存中的数据 和 DB中数据一致。





**低并发下的解决方案**



在并发不大，或者说对缓存和DB数据一致性要求不是很高的情况。大多数公司都可以用这种方案了。

该问题就是经典的：缓存+数据库读写（KV+DB读写）的模式，就是 **Cache Aside Pattern**

- 读的时候，先读缓存，缓存没有的话，就读数据库，取出数据后放入缓存，同时返回响应。
- 更新的时候，**先更新数据库，然后再删除缓存**。

**剖析：**

(1). 为什么更新DB后，是删除缓存，而不是更新缓存呢？

举个例子，比如该DB更新的频率很高，比如1min中内更新100次，如果每次都更新缓存，缓存也对应了更新了100次。

但缓存在这一分钟内根本没被调用，或者说该缓存10min才可能会被查询一次，那么频繁更新缓存是不是就产生了很多不必要的开销呢。

**频繁更新的数据，并不是每次更新都要读，只要要读的时候，才去缓存数据。**

这里的思路是：**用到缓存的时候，才去计算缓存。计算机领域经典的 lazy 思想。**

非常重要的优化思想：**把任务推迟到必须的时刻，好处是避免重复计算，甚至不计算**。



(2). 该方案高并发场景下是否适用？

不适用

**比如更新DB后，然后还有没有来得及删除缓存，别的请求就已经读取到缓存的数据了，此时读取的数据和DB中的实际的数据是不一致的。**



不管是先写MySQL数据库，再删除Redis缓存；还是先删除缓存，再写库，都有可能出现数据不一致的情况。





**3. 高并发下的解决方案**



**延迟双删**

在写库前后都进行 redis.del(key) 操作，并且第二次删除通过延迟的方式进行。



方案一（一种思路，不严谨）具体步骤是：

**1）先删除缓存；**

​		**（如果在删除缓存之后，写数据库之前，如果有其他进程来读进程来读，先读缓存没读到再去读数据库又缓存到redis中了）**

**2）再写数据库；（如果没有后续的延迟双删，那么此时数据库与redis数据不一致，redis为脏数据）**

**3）休眠500毫秒（根据具体的业务时间来定）；**

**4）再次删除缓存。（这时候删除缓存，就是把可能存在的脏数据刷出redis）**



问题：这个500毫秒怎么确定的，具体该休眠多久时间呢？

这种策略需要考虑的：

- 需要评估自己的项目的读数据业务逻辑的耗时。
- 这么做的目的，就是确保读请求结束，写请求可以删除读请求造成的缓存脏数据。
- 当然这种策略还要考虑redis和数据库主从同步的耗时。
- 最后的的写数据的休眠时间：则在读数据业务逻辑的耗时基础上，加几百ms即可。比如：休眠1秒。



其实延迟双删，也并不能解决多线程高并发下的绝对一致。

道理很简单，这些操作是一个线程（进程）中操作多个资源对象（redis 和 mysql）。

在高并发场景下，还是存在请求串进来的情况。99% 的人大部分情况下都遇不到这么高的并发场景，这里就简单提一个网上看到的方案：

> 
>
> https://github.com/doocs/advanced-java/issues/54
>
> 高并发下保证绝对的一致，就需要用到内存队列做异步串行化。非高并发场景，双删策略基本满足了。如果特别要求强一致性，并不适合放在redis









# 缓存雪崩

什么叫缓存雪崩？

如果所有的 `Key` 失效时间都是12小时，中午12点刷新的，我零点有个秒杀活动大量用户涌入，假设当时每秒 6000 个请求，本来缓存在可以扛住每秒 5000 个请求，但是缓存当时所有的Key都失效了。

此时 1 秒 6000 个请求全部落数据库，数据库必然扛不住，它会报一下警，真实情况可能DBA都没反应过来就直接挂了。

此时，如果没用什么特别的方案来处理这个故障，DBA 很着急，重启数据库，但是数据库立马又被新的流量给打死了。这就是我理解的缓存雪崩。

> 其实 redis 挂了，请求也是全部打到数据库
>
> 针对第一种情况，可以实现 redis 高可用：redis cluster 或 redis sentinel 模式。
>
> **雪崩的关键问题在于：大量的 key 都在同一时间失效，虽然 redis 还在，几乎就相当于 redis 挂了一样**
>
> **如果这时候是大型网站，一直处于高并发状态， 所有的请求都会打到数据库上。这时候数据库压力很大，导致系统崩溃**



**同一时间大面积失效，那一瞬间 Redis 跟没有一样，那这个数量级别的请求直接打到数据库几乎是灾难性的，你想想如果打挂的是一个用户服务的库，那其他依赖他的库所有的接口几乎都会报错。**

**如果没做熔断限流等策略基本上就是瞬间挂一片的节奏，你怎么重启用户都会把你打挂，等你能重启的时候，用户早就睡觉去了，并且对你的产品失去了信心，什么垃圾产品。**



[Redis的KEYS命令引起宕机事件](https://cloud.tencent.com/developer/article/1352502)





### 如何避免雪崩



**第一种方法：随机数**

**对key的失效时间加个随机数（不同的key，设置不同的过期时间）让缓存失效的时间点尽量均匀**



处理缓存雪崩的问题，在批量往 **Redis** 存数据的时候，把每个Key的失效时间都加个随机值就好了，这样可以保证数据不会在同一时间大面积失效，我相信，Redis 这点流量还是顶得住的。

```shell
setRedis（Key，value，time + Math.random() * 10000）；
```



**第二种方法：针对系统的一些热点数据， 可以设置缓存永不过期。 （或者定时更新）**





**第三种方法：双缓存策略**

设置两个缓存，原始缓存和备用缓存，原始缓存失效时，访问备用缓存，备用缓存失效时间设置长点。

设置二级缓存架构C1、C2，C1在前，C2在后，C1的缓存可以设置不同的过期时间，C2缓存与DB保持强一致性，实现数据同步。



**第四种方法：高可用集群**

从架构层面来说：Redis做集群，将热点数据分配在不同的master上，减轻单点压力，同时master要对应多个slave，保证高可用；  系统架构要有快速熔断策略，减轻系统的压力。 





# 缓存穿透



业务请求的数据缓存中没有，DB中也没有，导致类似请求直接跨过缓存，反复在DB中查询，与此同时缓存也**不会**得到更新。

**这种情况可以理解为大量的查询，是无效的查询，建立起大量无效数据连接。**

我们数据库的 id 都是1开始自增上去的，如发起为id值为 -1 的数据或 id 为特别大不存在的数据查询。

这时的用户很可能是攻击者，攻击会导致数据库压力过大，严重会击垮数据库。

**小点的单机系统，基本上用postman就能搞死，比如我自己买的阿里云服务**



## 如何避免缓存穿透



**接口校验和拦截**



在接口层增加校验，比如用户鉴权校验，参数做校验，不合法的参数直接代码Return，比如：id 做基础校验，id <=0 的直接拦截等。

**在开发程序的时候都要有一颗 “不信任” 的心，就是不要相信任何调用方，比如你提供了API接口出去，你有这几个参数。**

**那我觉得作为被调用方，任何可能的参数情况都应该被考虑到，做校验，因为你不相信调用你的人，你不知道他会传什么参数给你。**



从缓存取不到的数据，在数据库中也没有取到，这时也可以将对应 Key 的 Value 对写为null、位置错误、稍后重试这样的值具体取啥问产品。

或者看具体的场景，缓存有效时间可以设置短点，如30秒（设置太长会导致正常情况也没法使用）。

这样可以防止攻击用户反复用同一个id暴力攻击，但是我们要知道正常用户是不会在单秒内发起这么多次请求的，那网关层**Nginx**本渣我也记得有配置项，可以让运维大大对单个IP每秒访问次数超出阈值的IP都拉黑。





# Redis 认证和ACL

在 Redis 6.0 中引入了 ACL（Access Control List) 的支持在此前的版本中 Redis 中是没有用户的概念的。

其实这样是没有办法很好的控制权限，redis 6.0 开始支持用户，可以给每个用户分配不同的权限来控制权限。



同一个redis集群的所有开发都共享default用户，难免会出现误操作把别人的key删掉或者数据泄露的情况，那之前我们也可以使用rename command的方式给一些危险函数重命名或禁用，但是这样也防止不了自己的key被其他人访问。



在 6.0 之前，如果开启了密码认证，我们需要使用 `redis-cli -h host -p port `这样的命令登录，然后再执行 `auth password` 命令来交互式提供密码来认证。

**但是没有用户这个概念的，这就导致所有的客户端相当于是使用同一个账户来操作同一个 redis 实例的**，redis 6.0 扩展了 AUTH 的语法:

```shell
AUTH <username> <password>
```

同时也兼容了旧版本的 `AUTH`:

```shell
AUTH <password>
```

使用这种方式时，也就是只提供密码，相当于使用了一个默认的用户 “default”，通过这样的方式，实现了对低版本的兼容。



- 通过限制对命令和密钥的访问来提高安全性，以使不受信任的客户端无法访问，而受信任的客户端仅具有对数据库的最低访问级别才能执行所需的工作。例如，某些客户端可能仅能够执行只读命令，
- 提高操作安全性，以防止由于软件错误或人为错误而导致进程或人员访问 Redis，从而损坏数据或配置。例如，没有必要让工作人员从 Redis 调用 `FLUSHALL` 命令。



ACL 的另一种典型用法与托管Redis实例有关。

Redis通常由公司内部管理 redis 基础结构的内部团队为其所拥有的其他内部客户提供的一项托管服务，或者由云提供商在软件即服务设置中提供。

在这两种设置中，我们都希望确保为客户排除配置命令。

过去，通过命令重命名来完成此操作的方法是一种技巧，它使我们可以长时间不用 ACL 生存，但使用体验并不理想。



## 配置ACL

配置ACL的方式有两种，一种是在 config 文件中直接配置，另一种是在外部 aclfile 中配置。

配置的命令是一样的，但是两种方式只能选择其中一种，我们之前使用 requirepass 给 default 用户设置密码 默认就是使用 config 的方式。

```shell
# 比如常见的单机redis配置，就是在redis.conf中配置default用户的密码
requirepass 123456


# 当您要使用外部ACL文件时，需要在redis.conf中使用配置指令aclfile来指定外部acl文件路径
aclfile /etc/redis/users.acl


# 当仅在redis.conf文件内部直接指定几个用户时，可以使用CONFIG REWRITE以便通过重写将新的用户配置存储在文件中。


```



## ACL规则

我们可以使用 ACL LIST 命令来检查当前有效的 ACL 规则。使用 ACL LIST 确认刚启动的，使用默认配置的 Redis 实例 ACL 规则如下：









# Redis开发规范





# redis安全







## 安全模型



redis 是设计成在一个安全的内网环境中，被可信任的内网客户端访问的。这意味着通常不会把









# redis 三节点-cluster部署





### 集群规划



三台服务器各部署一个主节点、一个从节点，同一台服务器上不是直接主从关系。

| 服务器 | 操作系统                      | 角色           | ip:端口                               |
| ------ | ----------------------------- | -------------- | ------------------------------------- |
| node1  | CentOS Linux release 7.6.1810 | master1/slave2 | 192.168.1.199:6379/192.168.1.199:6380 |
| node2  | CentOS Linux release 7.6.1810 | master2/slave3 | 192.168.1.200:6379/192.168.1.200:6380 |
| node3  | CentOS Linux release 7.6.1810 | master3/slave1 | 192.168.1.201:6379/192.168.1.201:6380 |



### 准备工作

以下都要在三个节点上准备：

```shell

# vi /etc/hosts，给三台主机都设置hosts
192.168.1.199 node1 
192.168.1.200 node2
192.168.1.201 node3

# 防火墙
sudo firewall-cmd --zone=public --add-port=6379/tcp --permanent
sudo firewall-cmd --zone=public --add-port=6380/tcp --permanent
sudo firewall-cmd --zone=public --add-port=16379/tcp --permanent
sudo firewall-cmd --zone=public --add-port=16380/tcp --permanent
sudo firewall-cmd --permanent --zone=public --list-ports
sudo firewall-cmd --reload


## 准备gcc环境
# 查看，如果是gcc version 4.8.5，则看下面
gcc -v

# centos7 默认的 gcc 版本为：4.8.5 < 5.3 无法编译，需要准备新的gcc，并设置默认gcc
sudo yum -y install centos-release-scl tcl tclx tcl-devel  
sudo yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils 
# 临时有效，退出 shell 或重启会恢复原 gcc 版本
sudo scl enable devtoolset-9 bash
# 长期有效
sudo echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile

# 查看gcc版本：
gcc -v


# 下载当前最新的源代码包
wget http://download.redis.io/releases/redis-6.2.4.tar.gz -O  /usr/local/src/redis-6.2.4.tar.gz
cd /usr/local/src/
# 编译安装，编译安装后，二进制文件会被复制到/usr/local/bin目录下
tar xf redis-6.0.5.tar.gz
cd redis-6.0.5
# 编译参数 USE_SYSTEMD=yes BUILD_TLS=yes # 在ubuntu使用这个参数 MALLOC=libc
make  
# 默认会把二进制文件安装到 /usr/local/bin 。也可以 make PREFIX=/some/other/directory install 指定不同目录
sudo make install




# 创建日志目录和工作目录
mkdir -p /var/log/redis/
mkdir -p /var/lib/redis/6379
mkdir -p /var/lib/redis/6380


# 创建配置目录
sudo mkdir /etc/redis/
# 把默认配置文件去掉空格
grep -v '^#' redis.conf | grep -v '^$' >  /etc/redis/6379.conf



cp utils/redis_init_script  

```



# redis 三节点-sentinel部署







**一主二从三哨兵**

redis 哨兵集群最少要三个节点。



- 哨兵进程的可执行文件，编译安装后的 redis-sentinel 。一般位于 /usr/local/bin/redis-sentinel
- 哨兵配置文件，位于redis解压根目录下 redis.conf 。/usr/local/src/redis-6.0.5/sentinel.conf



**每一个哨兵**都可以去**监控多个master-slaves的主从架构。**

因为生产环境一般会 **部署多个master-slaves的redis主从集群。相同的一套哨兵集群，可以去** 监控不同的多个redis主从集群**。**

哨兵默认是用26279端口，默认不能跟其他集群在指定端口联通，只能在本地访问。