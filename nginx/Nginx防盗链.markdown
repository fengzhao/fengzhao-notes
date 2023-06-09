# nginx防止盗链



## 盗链

盗链是指服务提供商自己不提供服务的内容，通过技术手段绕过其它有利益的最终用户界面（如广告）。

直接在自己的网站上向最终用户提供其它服务提供商的服务内容，骗取最终用户的浏览和点击率。

受益者不提供资源或提供很少的资源，而真正的服务提供商却得不到任何的收益。



### referer 头部

现实生活中，购买服务或加入会员的时候，往往要求提供信息："你从哪里知道了我们？"

这叫做引荐人（referrer），谁引荐了你？对于公司来说，这是很有用的信息。

互联网也是一样，你不会无缘无故访问一个网页，总是有人告诉你，可以去那里看看。服务器也想知道，你的"引荐人"是谁？

HTTP 协议在请求（request）的头信息里面，设计了一个`Referer`字段，给出"引荐网页"的 URL。

这个字段是可选的。客户端发送请求的时候，自主决定是否加上该字段。



举个例子，我们在浏览器中，用谷歌或者百度等搜索引擎去搜索，然后在搜索结果中点击一个超链接，打开一个网站时。



当其他人，通过 URL 引用了你的页面，用户在浏览器中点击 URL ， HTTP 请求的头部会通过 referer 头部将该网站当前页面的 URL 带上，告诉服务器本次请求是由谁发起的。



盗链，就是别人在自己的页面嵌入了你的资源，比如视频资源，图片资源等。访问别人的网站，引用的是你网站的资源。





### Nginx referer  模块



referer 模块默认被编译进 nginx 中，可以通过 `--without-http_referer_module` 禁用



referer 模块有三个指令，下面看一下。



```shell
Syntax: valid_referers none | blocked | server_names | string ...;
Default: —
Context: server, location

Syntax: referer_hash_bucket_size size;
Default: referer_hash_bucket_size 64; 
Context: server, location

Syntax: referer_hash_max_size size;
Default: referer_hash_max_size 2048; 
Context: server, location


# valid_referers 指令，配置是否允许referer头部,以及允许哪些 referer 访问。
# referer_hash_bucket_size 表示这些配置的值是放在哈希表中的，指定哈希表的大小。
# referer_hash_max_size 则表示哈希表的最大大小是多大。
```





**nginx 防盗链配置**



```nginx
server {
    server_name demo.fengzhao.me;
    listen 80;

    error_log logs/myerror.log debug;
    
    root /var/www/html;                                                                                                         	charset utf-8;   
    index  index.html index.htm index.nginx-debian.html;
    
    
    location / {
        # none                允许没有referer头部的请求访问，即允许直接输入URL进行访问
        # blocked             允许referer头部为空的请求访问
        # server_names        允许本机自己可以访问
        # *.ziyang.com        允许匹配上了正则的可以访问
        # www.ziyang.org.cn/nginx/  该页面发起的请求可以访问
        # ~\.google\.  google 前后都是正则匹配
        valid_referers none blocked server_names
                       *.ziyang.com www.ziyang.org.cn/nginx/
                       ~\.google\.;
       
        # 如果没有被上述规则匹配到，则返回403禁止访问
        if ($invalid_referer) {
                return 403;
        }
        return 200 'valid\n';
    }
}
```





在 CDN 场景中，也是通过 referer 白名单和黑名单的方式，来设置防盗链的。



比如，腾讯云 CDN 防盗链相关配置

https://cloud.tencent.com/document/product/228/41454

七牛云 CDN 防盗链相关配置

https://developer.qiniu.com/fusion/manual/3839/domain-name-hotlinking-prevention





## 防盗链第二种



referer 模块是一种简单的防盗链手段，必须依赖浏览器发起请求才会有效，如果攻击者伪造 referer 头部的话，这种方式就失效了。

比如常见的爬虫，可以很容易的构造 referer 头部。



secure_link 模块是另外一种解决的方案。主要用于一些资源站点，或者下载站点。

用户点击下载按钮，服务端生成下载地址，客户端再去下载资源。



用户在客户端点击下载按钮，服务器收到请求后生成一个`下载地址`返回给客户端。

客户端在用这个生成的下载地址去请求资源，此时nginx去做校验，校验链接地址真伪和链接地址是否过期。

如果链接地址是真的并且链接地址没有过期，就给客户端返回下载资源



它的主要原理是，通过验证 URL 中哈希值的方式防盗链：

- 由服务器（可以是 Nginx，也可以是其他 Web 服务器）生成加密的安全链接 URL，返回给客户端
- 客户端使用安全 URL 访问 Nginx，由 Nginx 的 secure_link 变量验证是否通过



原理如下：

- 哈希算法是不可逆的
- **客户端只能拿到执行过哈希算法加密后的 URL**
- 仅生成 URL 的服务器，验证 URL 是否安全的 Nginx，这两者才保存原始的字符串
- 原始字符串通常由以下部分有序组成：
  - 资源位置。如 HTTP 中指定资源的 URI，防止攻击者拿到一个安全 URI 后可以访问任意资源
  - 用户信息。如用户的 IP 地址，限制其他用户盗用 URL
  - 时间戳。使安全 URL 及时过期
  - 密钥。仅服务器端拥有，增加攻击者猜测出原始字符串的难度



**模块**



ngx_http_secure_link_module

- 未编译进 Nginx，需要通过 --with-http_secure_link_module 添加



**变量**

- secure_link
- secure_link_expires



```shell
Syntax: secure_link expression;
Default: —
Context: http, server, location

Syntax: secure_link_md5 expression;
Default: —
Context: http, server, location

Syntax: secure_link_secret word;
Default: —
Context: location
```





```nginx
server {
        listen       80;
        server_name  www.test.com;
        charset utf-8;
        root /usr/local/nginx/html/;
 
       location /download {
       secure_link $arg_md5,$arg_expires; 
       # secure_link：取参数md5,expires的值
       
       secure_link_md5 "$secure_link_expires$uri$remote_addr test"; #test为自定义的加密串
       #s ecure_link_md5验证参数md5, expires是否和服务端生成验证的一致
 
       if ($secure_link = "") {   # 资源不存在或哈希比对失败
            return 403;
       }
 
       if ($secure_link = "0") {  # 时间戳过期 
            return 410;
       }
 
    }
 

```





