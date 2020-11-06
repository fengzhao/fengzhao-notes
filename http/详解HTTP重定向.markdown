

# HTTP 的重定向



URL 重定向，也称为 URL 转发，是一种当实际资源，如单个页面、表单或者整个 Web 应用被迁移到新的 URL 下的时候，保持（原有）链接可用的技术。

HTTP 协议提供了一种特殊形式的响应—— HTTP 重定向（HTTP redirects）来执行此类操作。



重定向可实现许多目标：

- 保留原始域名，网站更换域名后，还是保留以前的域名访问。（比如京东的 www.360buy.com ）

- 站点维护或停机期间的临时重定向。（比如服务维护的时候，重定向到其他页面）
- 永久重定向将在更改站点的URL，上传文件时的进度页等之后保留现有的链接/书签。



在 HTTP 协议中，重定向操作由服务器通过发送特殊的响应（即 redirects）而触发。HTTP 协议的重定向响应的状态码为 3xx 。



## 永久重定向

这种重定向操作是永久性的。它表示原 URL 不应再被使用，而应该优先选用新的 URL。

搜索引擎机器人会在遇到该状态码时触发更新操作，在其索引库中修改与该资源相关的 URL 。

比如访问京东的  http://www.360buy.com 会返回 301 永久重定向到 http://www.jd.com 

这个表示京东已经启用新域名，搜索引擎在遇到这种状态码的时候，也会修改其索引库中的URL。

| 编码  | 含义               | 处理方法                                                     | 典型应用场景                                             |
| :---- | :----------------- | :----------------------------------------------------------- | :------------------------------------------------------- |
| `301` | Moved Permanently  | [`GET`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/GET) 方法不会发生变更，其他方法有可能会变更为 [`GET`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/GET) 方法。[[1\]](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Redirections#attr1) | 网站重构。                                               |
| `308` | Permanent Redirect | 方法和消息主体都不发生变化。                                 | 网站重构，用于非GET方法。(with non-GET links/operations) |



## 临时重定向



有时候请求的资源无法从其标准地址访问，但是却可以从另外的地方访问。在这种情况下可以使用临时重定向。





## 301 Moved Permanently

301 响应状态码的原因短语是 Moved Permanently。表示永久移动。

被请求的资源已永久移动到新位置，并且将来任何对此资源的引用都应该使用本响应返回的若干个`URI`之一。

如果可能，拥有链接编辑功能的客户端应当自动把请求的地址修改为从服务器反馈回来的地址。除非额外指定，否则这个响应也是可缓存的。

新的永久性的URI应当在响应的 `Location` 域中返回。除非这是一个`HEAD`请求，否则响应的实体中应当包含指向新的 `URI` 的超链接及简短说明

如果这不是一个 `GET` 或者 `HEAD`请求，因此浏览器禁止自动进行重定向，除非得到用户的确认，因为请求的条件可能因此发生变化。

注意：对于某些使用 `HTTP/1.0` 协议的浏览器，当它们发送的 `POST` 请求得到了一个301响应的话，接下来的重定向请求将会变成 `GET` 方式。



以京东为例，2007年6月，京东商城当时域名 www.360buy.com 。2013年3月京东主站域名更换为 www.jd.com 

目前，访问 www.360buy.com 就会通过重定向，跳转到 www.jd.com 。我们来看一下访问 http://www.360buy.com 的全过程：





![image-20201106162019820](assets/image-20201106162019820.png)





第一次请求报文和响应报文：

**请求头**：

```HTTP
GET / HTTP/1.1
Host: www.360buy.com
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate, br
DNT: 1
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Pragma: no-cache
Cache-Control: no-cache
```

**响应头**：

```http
HTTP/1.1 301 Moved Permanently
Server: nginx
Date: Fri, 06 Nov 2020 07:53:59 GMT
Content-Type: text/html
Content-Length: 178
Connection: keep-alive
Location: http://www.jd.com/
```

然后客户端根据 `location 头部` 再去请求 http://www.jd.com 

**请求头：**

```http
GET / HTTP/1.1
Host: www.jd.com
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
DNT: 1
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Pragma: no-cache
Cache-Control: no-cache
```



**响应头：**

```http
HTTP/1.1 302 Moved Temporarily
Server: nginx
Date: Fri, 06 Nov 2020 07:53:59 GMT
Content-Type: text/html
Content-Length: 138
Connection: keep-alive
Location: https://www.jd.com/
Access-Control-Allow-Origin: *
Timing-Allow-Origin: *
X-Trace: 302-1604649239250-0-0-0-0-0
Strict-Transport-Security: max-age=360
```



这一次 302 跳转，完成了 http://www.jd.com 到 https://www.jd.com 





## 302 Moved Temporarily

302 响应状态码的原因短语是 Found 。

要求客户端执行临时重定向（原始描述短语为“Moved  Temporarily”）。

由于这样的重定向是临时的，客户端应当继续向原有地址发送以后的请求。只有在Cache-Control或Expires中进行了指定的情况下，这个响应才是可缓存的。

新的临时性的URI应当在响应的Location域中返回。除非这是一个HEAD请求，否则响应的实体中应当包含指向新的URI的超链接及简短说明。

如果这不是一个GET或者HEAD请求，那么浏览器禁止自动进行重定向，除非得到用户的确认，因为请求的条件可能因此发生变化。

注意：虽然RFC 1945和RFC   2068规范不允许客户端在重定向时改变请求的方法，但是很多现存的浏览器将302响应视作为303响应。

并且使用GET方式访问在Location中规定的URI，而无视原先请求的方法。

因此状态码303和307被添加了进来，用以明确服务器期待客户端进行何种反应。











## 301 和 302 的区别



301表示搜索引擎在抓取新内容的同时也将旧的网址交换为重定向之后的网址；

301 比较适用的场景是域名跳转，



302表示旧地址A的资源还在（仍然可以访问），这个重定向只是临时地从旧地址A跳转到地址B，搜索引擎会抓取新的内容而保存旧的网址。