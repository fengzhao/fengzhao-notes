## 简介

> Redis is an open source (BSD licensed), in-memory data structure store, used as database, cache and message broker.

这是 redis 的官方的定义，它是一个数据库，且是把数据存到内存中，能用作 cache (缓存) 和消息队列。

Redis 是完全开源免费的，遵守 BSD 协议，是一个高性能的 key-value 数据库，与其它 key/value 缓存产品有以下三个特点：

- Redis 支持数据的持久化，可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用。
- Redis 不仅支持 key-value 类型的数据，还提供list，set，zset，hash等数据结构的存储，对程序员透明，无需进行额外的抽象
- Redis 支持数据的备份，即 master-slave 模式的数据备份

说到数据库，可能大家用得最多的是关系型数据库，比如 MySQL，PostgreSQL 等。

这种数据库是把数据存到磁盘中的，这种能存大量的数据，然而我们的应用是经常需要访问数据库来查找数据，每次访问，无论怎样，都是需要消耗CPU和IO等待。

当应用的数据积累到很庞大时，这种性能的问题更严重，所以有一种解决方法是这样的，把经常被访问的数据放到内存中，因为内存的访问速度比磁盘快太多了，而这部分数据可能不会是全部的数据，因为内存的价格比磁盘贵多了。

所以有了 memcached ，这种就是把数据放到内存中，但它仅支持一种最简单的数据结构，就是键值对，这种数据库又不同于传统结构型的关系型数据库，所以又被称为 nosql。

而 redis 也是 nosql 的一种，但它相比 memcached 不仅支持键值对，还支持列表，集合，排序集合等多种结构，而且它还是可持久化的。

持久化就是说在内存中的数据会以文件的形式同步到磁盘中，当下次重启时还能恢复，这点相比memcached，就能存相对重要的数据。

毕竟如果数据不能持久化，丢失了也是件麻烦的事，谁也保证不了不会出问题。

还有一个很重要的特征就是 redis 支持分布式集群，用它可以轻易地部署到多台机器中，成为一个集群。特别是3.0开始，redis对集群的支持比较健全了。

redis 比较常见的作用和应用场景：

- 第一个是 cache，这是由于它的数据存在内存中，访问速度比较快，它能让数据在一定时间后过期，且又有丰富的数据结构的支持，所以它能作为一个高性能的cache。
- 第二个是作为消息队列，用的是它的 sub/pub的功能，能具有消息费生产者的模式，且是数据存在内存中，访问速度高。









## 安装

```shell

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



### redis-conf 配置选项

| daemonize |      |      |
| --------- | ---- | ---- |
| pidfile   |      |      |
| port      |      |      |
| loglevel  |      |      |
| logfile   |      |      |



## 数据类型 

redis 并不是简单的键值对存储服务器，它实际上是一个  ***数据结构服务器*** ，它支持多种类型的 value  , 在传统的键值存储中通常都是在 string 类型的 key 中存放 string 类型的 value 。

在 redis 中，value 并不限为 string 这样的简单数据类型，value 可以是 List , Set ，Hashes 这样更加复杂的数据结构：

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

### 字符串类型

通过 key-value 中这样的方式时，string 是 value 中最简单的数据类型，它也是 Memcached 中唯一的数据类型，这个很简单理解，值跟键一样，都是字符串。

string 数据类型在很多场景都很有用，比如缓存一些 HTML fragments 或者 pages。

```shell
# 使用客户端 redis-cli 登陆到本机，ping检查，使用 set 命令存入键值对，使用 get 命令取值
root@hwsrv-512783:~#
root@hwsrv-512783:~# redis-cli 
127.0.0.1:6379>
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
  - json、xml等字符串
- 使用场景
  - 缓存
  - 计数器
  - 分布式锁
  - ...
- 命令

- get

  语法：get KEY

  功能：获取字符串类型的 key 对应的 value

- incr

  语法：incr KEY

  功能：key 自增 1 ，如果 key 不存在，自增后 key=1

  ```shell
  # 原子自增
  incr 命令将 key 从 string 转换为 value 类型，每执行一次则递增加1后用 set 赋值回去，还有 incrby,decr,decrby 等这些命令都是一样的。
  原子自增意味着递增操作都是串行化的，无法同时有两个客户端对一个 key 进行原子操作。在进行递增加1返回新值后，下一个原子递增才能开始。
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

在接受更复杂的数据结构之前，需要先讨论另外一个数据类型无关的特性，那就是 **Redis expires**。通常可以给 key 设置一个  timeout 时间，这就限定了这个 key 的生存时间。

当时间到了，key 直接被销毁，就好像用户主动调 del 命令删除它一样。

- 可以使用毫秒（millisecond）和秒（seconds）做为生命周期
- 最短的生命周期是1毫秒（millisecond）
- **期限信息的设置是保存在磁盘中持久存在的**，这意味着（当 redis 服务停止的时候，时间也是在走的）

```shell
> set key some-value
OK
# expire key time 设置过期时间
> expire key 5
(integer) 1
# 立即取值，key还存在
> get key 
"some-value"
 # 5秒以后执行get，key已被删除
> get key
(nil)
```



```shell
# 给一个已存在的 key 设置一个过期时间，更新也是这个命令
expire key time 
# 查看剩余生存时间
TTL key
# 


```









https://liangshuang.name/2017/06/29/redis/





## Redis集群







### redis高可用方案

- 持久化

- 主从复制
- 哨兵
- 集群





### 主从复制原理 

主从复制，是指将一台Redis服务器的数据，复制到其他的Redis服务器。

前者称为主节点(master)，后者称为从节点(slave)；数据的复制是单向的，只能由主节点到从节点。

默认情况下，每台Redis服务器都是主节点；且一个主节点可以有多个从节点(或没有从节点)，但一个从节点只能有一个主节点。



主从复制的主要作用：

- 数据冗余：主从复制实现了数据的热备份，是持久化之外的一种数据冗余方式。
- 故障恢复：当主节点出现问题时，可以由从节点提供服务，实现快速的故障恢复；实际上是一种服务的冗余。
- 负载均衡：通过主从复制和读写分离，可以由主节点提供写服务，由从节点提供读服务。尤其是在写少读多的场景下，通过多个从节点分担读负载，可以大大提高Redis服务器的并发。（如电商网站的商品）
- 高可用基石：除了上述作用以外，主从复制还是哨兵和集群能够实施的基础，因此说主从复制是Redis高可用的基础。





#### 建立复制

**主从复制的开启，完全是在从节点发起的；不需要我们在主节点做任何事情。**

从节点开启主从复制，有3种方式：

（1）配置文件

在从服务器的配置文件中加入：slaveof <masterip> <masterport>

（2）启动命令

redis-server启动命令后加入 --slaveof <masterip> <masterport>

（3）客户端命令

Redis服务器启动后，直接通过客户端执行命令：slaveof <masterip> <masterport>，则该Redis实例成为从节点。

上述3种方式是等效的，下面以客户端命令的方式为例，看一下当执行了slaveof后，Redis主节点和从节点的变化。





#### 实例

方便起见，实验所使用的主从节点是在一台机器上的不同Redis实例，其中主节点监听6379端口，从节点监听6380端口；

从节点监听的端口号可以在配置文件中修改：









#### 复制过程

主从复制过程大体可以分为3个阶段：连接建立阶段（即准备阶段）、数据同步阶段、命令传播阶段；下面分别进行介绍。

##### 连接建立阶段

该阶段的主要作用是在主从节点之间建立连接，为数据同步做好准备。

**步骤一、保存主节点信息**

从节点服务器内部维护了两个字段，即masterhost和masterport字段，用于存储主节点的ip和port信息。

需要注意的是，**slaveof** 是异步命令，从节点完成主节点ip和port的保存后，向发送slaveof命令的客户端直接返回OK。然后才开始进行复制。



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

如果从节点中设置了masterauth选项，则从节点需要向主节点进行身份验证；没有设置该选项，则不需要验证。从节点进行身份验证是通过向主节点发送auth命令进行的，auth命令的参数即为配置文件中的masterauth的值。

如果主节点设置密码的状态，与从节点masterauth的状态一致（一致是指都存在，且密码相同，或者都不存在），则身份验证通过，复制过程继续；如果不一致，则从节点断开socket连接，并重连。







### Redis-cluster教程



这是一份 redis-cluster 的教程，不会讲解一些复杂的分布式系统知识，提供了安装搭建配置 redis-cluster 的教程。这份教程仅仅是从用户视角来描述cluster 





redis-cluster 提供了一种可以让数据自动分片在多节点的安装方式。（**automatically sharded across multiple Redis nodes**.）



实际上，在 redis-cluster 中。

- 在多个节点中自动分片数据集的能力。
- 当集群中有节点失联或者故障时，继续提供支持的能力。





#### TCP端口

每个 redis 节点都需要开放两个 tcp 端口，默认的 6379 是给客户端连接使用。



第二个高端口用于集群总线，这是使用二进制协议进行点对点的通讯信道。

集群总线用于节点间的故障检测，配置更新，故障转移授权(failover authorization)等。

客户端永远不会与集群总线端口通讯。而是应该使用普通的命令端口。（但是要注意在防火墙中打开集群间的总线端口）

集群总线端口和命令端口的偏移量始终是固定的。值为 10000 （也就是说客户端端口是 6379，那么总线端口就是 16379）





#### Redis集群数据分片



redis 集群没有使用**一致性哈希**。它用一种不同的分片形式，在这种形式中，每个key都是一个概念性（**hash slot**）的一部分。



Redis集群中有16384个hash slots，为了计算给定的key应该在哪个hash slot上，我们简单地用这个key的CRC16值来对16384取模。

（即：key的CRC16  %  16384）

Redis集群中的每个节点负责一部分hash slots，假设你的集群有3个节点，那么：

- Node A contains hash slots from 0 to 5500
- Node B contains hash slots from 5501 to 11000
- Node C contains hash slots from 11001 to 16383



允许添加和删除集群节点。比如，如果你想增加一个新的节点D，那么久需要从A、B、C节点上删除一些hash slot给到D。

同样地，如果你想从集群中删除节点A，那么会将A上面的 hash slots 移动到B和C，当节点A上是空的时候就可以将其从集群中完全删除。

因为将 hash slots 从一个节点移动到另一个节点并不需要停止其它的操作。

添加、删除节点、更改节点所维护的 hash slots 的百分比 都不需要任何停机时间。也就是说，移动hash slots是并行的，移动hash slots不会影响其它操作。



Redis支持多个key操作，只要这些key在一个单个命令中执行（或者一个事务，或者Lua脚本执行），那么它们就属于相同的hash slot。

你也可以用hash tags俩强制多个key都在相同的hash slot中。



#### redis 主从模型



当部分master节点失败了，或者不能够和大多数节点通信的时候，为了保持可用，Redis集群用一个master-slave模式。

这样的话每个hash slot就有1到N个副本。

在我们的例子中，集群有A、B、C三个节点，如果节点B挂了，那么 5501-11000 之间的 hash slot 将无法提供服务。

然而，当我们给每个 master 节点添加一个 slave 节点以后，我们的集群最终会变成由A、B、C三个 master 节点和 A1、B1、C1 三个 slave 节点组成。

节点 B1 是 B 的副本，如果 B 失败了，集群会将 B1 提升为新的 master，从而继续提供服务。然而，如果 B 和 B1 同时挂了，那么整个集群将不可用。



#### redis集群一致性保证



Redis集群不能保证强一致性。换句话说，Redis集群可能会丢失一些写操作。

Redis集群可能丢失写的第一个原因是因为它用异步复制。



写可能是这样发生的：

- 客户端写到 master B
- master B 返回客户端OK
- master B 将这个写操作广播给它的slaves B1、B2、B3



正如你看到的那样，B 没有等到 B1、B2、B3 确认就回复客户端了，也就是说，B 在回复客户端之前没有等待 B1、B2、B3 的确认，

这对应Redis来说是一个潜在的风险。所以，如果客户端写了一些东西，B 也确认了这个写操作，但是在它将这个写操作发给它的 slaves 之前它宕机了，

随后其中一个slave（没有收到这个写命令）可能被提升为新的master，于是这个写操作就永远丢失了。



这和大多数配置为每秒刷新一次数据到磁盘的情况是一样的。你可以通过强制数据库在返回客户端之前先刷新数据。

但是这样做的结果会导致性能很低，这就相当于同步复制了。

基本上，需要在性能和一致性之间做一个权衡。



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

redis5 可以使用 redis-cli 工具来管理集群

redis3 或 redis4 可以使用 redis-trib.rb 这个工具。在 redis 源代码中的 src 目录中。

```shell
#  redis-trib.rb是一个 ruby 语言的工具，所以需要安装ruby
yum install ruby
yum install rubygems
gem install redis

# 如果提示ruby版本过低，可以使用这个
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm list known
rvm install 2.4.1
```



```shell
# 在 redis5 中使用redis-cli创建集群
redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 \
127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 \
--cluster-replicas 1
```