

# redis 过期时间



- Redis的数据是存储于内存之中，所以对内存的清理是非常重要的
- Redis提出了定期数据存储的设计，也就是数据在Redis上存储是有时间限制的



### 



Redis中使用`EXPIRE`进行键时间的设置，使用`TTL`查询键剩余生存时间



```shell
127.0.0.1:6379> SET cache_page "www.google.com"
OK 
127.0.0.1:6379>  EXPIRE cache_page 30     # 设置过期时间为 30 秒
(integer) 1
127.0.0.1:6379> TTL cache_page            # 查看剩余生存时间
(integer) 23
127.0.0.1:6379> EXPIRE cache_page 30000   # 更新过期时间
(integer) 1
127.0.0.1:6379> TTL cache_page
(integer) 29996
```







