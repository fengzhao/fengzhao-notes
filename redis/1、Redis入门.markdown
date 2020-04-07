## 简介

> Redis is an open source (BSD licensed), in-memory data structure store, used as database, cache and message broker.

这是 redis 的官方的定义，它是一个数据库，且是把数据存到内存中，能用作 cache (缓存) 和消息队列。说到数据库，可能大家用得最多的是关系型数据库，比如 MySQL，PostgreSQL 等。这种数据库是把数据存到磁盘中的，这种能存大量的数据，然而我们的应用是经常需要访问数据库来查找数据，每次访问，无论怎样，都是需要消耗CPU和IO等待。当应用的数据积累到很庞大时，这种性能的问题更严重，所以有一种解决方法是这样的，把经常被访问的数据放到内存中，因为内存的访问速度比磁盘快太多了，而这部分数据可能不会是全部的数据，因为内存的价格比磁盘贵多了。所以有了 memcached ，这种就是把数据放到内存中，但它支持一种最简单的数据结构，就是键值对，这种数据库又不同于传统结构型的关系型数据库，所以又被称为 nosql。

而 redis 也是 nosql 的一种，但它相比 memcached 不仅支持键值对，还支持列表，集合，排序集合等多种结构，而且它还是可持久化的。持久化就是说在内存中的数据会以文件的形式同步到磁盘中，当下次重启时还能恢复，这点相比memcached，就能存相对重要的数据，毕竟，如果数据不能持久化，丢失了也是件麻烦的事，谁也保证不了不会出问题。

还有一个很重要的特征就是 redis 支持分布式集群，用它可以轻易地部署到多台机器中，成为一个集群。特别是3.0开始，redis对集群的支持比较健全了。

redis 比较常见的作用，第一个是 cache，这是由于它的数据存在内存中，访问速度比较快，它能让数据在一定时间后过期，且又有丰富的数据结构的支持，所以它能作为一个高性能的cache。第二个是作为消息队列，用的是它的 sub/pub的功能，能具有消息费生产者的模式，且是数据存在内存中，访问速度高。









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







