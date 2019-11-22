## 简介

> Redis is an open source (BSD licensed), in-memory data structure store, used as database, cache and message broker.

这是 redis 的官方的定义，它是一个数据库，且是把数据存到内存中，能用作 cache (缓存) 和消息队列。说到数据库，可能大家用得最多的是关系型数据库，比如MySQL，PostgreSQL 等。这种数据库是把数据存到磁盘中的，这种能存大量的数据，然而我们的应用是经常需要访问数据库来查找数据，每次访问，无论怎样，都是需要消耗CPU和IO等待。当应用的数据积累到很庞大时，这种性能的问题更严重，所以有一种解决方法是这样的，把经常被访问的数据放到内存中，因为内存的访问速度比磁盘快太多了，而这部分数据可能不会是全部的数据，因为内存的价格比磁盘贵多了。所以有了 memcached ，这种就是把数据放到内存中，但它支持一种最简单的数据结构，就是键值对，这种数据库又不同于传统结构型的关系型数据库，所以又被称为 nosql。

而redis也是nosql的一种，但它相比memcached不仅支持键值对，还支持列表，集合，排序集合等多种结构，而且它还是可持久化的。持久化就是说在内存中的数据会以文件的形式同步到磁盘中，当下次重启时还能恢复，这点相比memcached，就能存相对重要的数据，毕竟，如果数据不能持久化，丢失了也是件麻烦的事，谁也保证不了不会出问题。

还有一个很重要的特征就是redis支持分布式集群，用它可以轻易地部署到多台机器中，成为一个集群。特别是3.0开始，redis对集群的支持比较健全了。

redis比较常见的作用，第一个是cache，这是由于它的数据存在内存中，访问速度比较快，它能让数据在一定时间后过期，且又有丰富的数据结构的支持，所以它能作为一个高性能的cache。第二个是作为消息队列，用的是它的sub/pub的功能，能具有消息费生产者的模式，且是数据存在内存中，访问速度高。





## 安装

```shell
# Install Redis on Ubuntu 18.04

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install redis-server
# 开机自启
sudo systemctl enable redis-server.service



# 在配置文件中修改使用systemd来做为redis的守护进程管理工具
supervised systemd


```



### 相关文件



| 可执行文件               | 作用              |
| ------------------------ | ----------------- |
| /usr/bin/redis-cli       | redis客户端工具， |
| /usr/bin/redis-check-rdb |                   |
| /usr/bin/redis-server    |                   |
| /usr/bin/redis-check-aof |                   |
| /usr/bin/redis-benchmark |                   |



## 数据类型 

redis 并不是简单的键值对存储服务器，它实际上是一个  *数据结构服务器* ，它支持多种类型的 value  , 在传统的键值存储中通常都是在 string 类型的 key 中存放 string 类型的 value 。

在 redis 中，value 并不限为 string 等简单数据类型，可以是 List , Set ，Hashs 等多种数据结构：

- Binary-safe strings  
  - 
- Lists：按照插入顺序进行排序的多个 string 元素集合，最基本的 ***linked lists***。
- Sets：无序且不重复的 string 元素集合
- Sorted sets：有序的 sets ，每个元素都有一个权重(score)，元素按照 score 排序。
- Hashes：



### Redis Keys

Redis 中的 Keys 是二进制安全的，这就意味着使用任何 **二进制序列** 都可以做为 key , 无论是像 “foo” 这样的字符串还是一个 JPEG 文件的内容，都可以做为 key 。

**甚至空 string 被认为是有效的 key 。**

关于使用 key 的一些建议：

- 使用非常大的 key 不是很好的选择，不仅仅是因为内存浪费，更是因为在数据集中搜索对比的时候需要耗费更多的成本。当要处理的是匹配一个非常大的值，从内存和带宽的角度来看，使用这个值的`hash`值是更好的办法（比如使用`SHA1`）。
- 特别短的key通常也是不推荐的。在写像 u100flw 这样的键的时候，有一个小小的要点，我们可以用`user:1000:followers`代替。可读性更好，对于key对象和value对象增加的空间占用与此相比来说倒是次要的。当短的key可以很明显减少空间占用的时候。**这个例子就描述了使用 redis 一个场景：计数器。如：如知乎每个问题的被浏览次数，新浪微博的用户关注数，userid 为1000 这个用户的粉丝数这个 key 就可以用 "user:1000:followers" 这样的 key 名来表示 **。
- 使用 schema 去限定域，例如使用  "object-type:id" 这种方式来表示，冒号和横线都可以用来分割域，例如  "comment​:123:​reply.to" or "comment​:123:​reply-to" 这样的格式。
- **key 的最大限制是 512 MB。**  
- 

### 字符串类型

通过 key-value 中这样的方式时，string 是 value 中最简单的数据类型，它也是 Memcached 中唯一的数据类型，这个很简单理解，值跟健一样，都是字符串。

```shell
# 使用客户端 redis-cli 登陆到本机，ping检查，使用 set 命令设置键值对，使用 get 命令取值
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
# 使用 set 对已存在的 key 重新赋值，它会覆盖掉以前的值。
127.0.0.1:6379>
127.0.0.1:6379> set mykey anothervalue
OK
127.0.0.1:6379> get mykey
"anothervalue"
127.0.0.1:6379>
127.0.0.1:6379>
# set 命令后加上 NX 参数，则先判断 key 是否存在，如果不存在则创建，如果已存在，则返回 nil 
127.0.0.1:6379> set mykey value NX
(nil)
127.0.0.1:6379>
127.0.0.1:6379> get mykey
"anothervalue"
127.0.0.1:6379>
127.0.0.1:6379>

```









