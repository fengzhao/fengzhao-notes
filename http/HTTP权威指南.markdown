



# HTTP简介

HTTP概述

https://www.cnblogs.com/huansky/p/13124807.html



HTTP（HyperText Transfer Protocol）即超文本传输协议，是一种详细规定了浏览器和万维网服务器之间互相通信的规则，它是万维网交换信息的基础。

它允许将HTML（超文本标记语言）文档从Web服务器传送到Web浏览器。



## HTTP工作原理

HTTP协议工作于客户端-服务端架构上。浏览器作为 HTTP 客户端通过 URL 向 HTTP 服务端即 WEB 服务器发送 HTTP 请求。

Web服务器有：Apache httpd 服务器，IIS服务器（Internet Information Services），Nginx , apache tomcat  等。

Web服务器根据接收到的请求后，向客户端发送响应信息。

HTTP默认端口号为80，但是你也可以改为8080或者其他端口。

HTTPS 的默认端口是443 







# [HTTP规范](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Resources_and_specifications)



https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Resources_and_specifications



# HTTP头部



request header 部分（以下简称 RH）是从浏览器端发送到服务器端的，既然是携带给别人看的，那很自然的，我们可以想到，这些字段很可能就是浏览器的“个人信息”和对于服务器来说的有用信息。比如浏览器内核版本（whoami），支持的传输方式，能解析的文件类型等。





在 HTTP/1 中，请求的第一行包含请求方法和路径。 HTTP/2 用一系列伪头部（pseudo-header）替换了请求行。



在 HTTP/2.0 协议中，添加了 pseudo header names （伪头部字段）

在HTTP/2.0中，选择以冒号开头的伪头名称，因为这对于HTTP/1.1中的头名称是非法字符。HTTP/1.1不使用伪头名称。

> **HTTP Header 的名称字段是不区分大小写的**
>
> Each header field consists of a case-insensitive field name followed by a colon (":"), optional leading whitespace, the field value, and optional trailing whitespace.  https://datatracker.ietf.org/doc/html/rfc7230#section-3.2
>
> 需要注意的是，HTTP/2 多了额外的限制，因为增加了头部压缩，要求在编码前必须转成小写 https://datatracker.ietf.org/doc/html/rfc7540#section-8.1.2





如今大多数客户端与 HTTP 服务端都默认会把 HTTP Header 的名称字段统一改成小写，避免使用方再重复做大小写转换的处理逻辑。

比如 NodeJS 中的 HTTP 模块就会自动将 Header 字段改成小写。



在 HTTP/1 中，HTTP 请求和响应都是由「状态行、请求 / 响应头部、消息主体」三部分组成。

一般而言，消息主体都会经过 gzip 压缩，或者本身传输的就是压缩过后的二进制文件（例如图片、音频），但状态行和头部却没有经过任何压缩，直接以纯文本传输。



随着 Web 功能越来越复杂，每个页面产生的请求数也越来越多，根据 [HTTP Archive](http://httparchive.org/trends.php) 的统计，当前平均每个页面都会产生上百个请求。

越来越多的请求导致消耗在头部的流量越来越多，尤其是每次都要传输 UserAgent、Cookie 这类不会频繁变动的内容，完全是一种浪费。

HTTP/1 时代，为了减少头部消耗的流量，有很多优化方案可以尝试，例如合并请求、启用 Cookie-Free 域名等等，但是这些方案或多或少会引入一些新的问题。



HTTP/1 是基于文本的协议，因此使用字符串操作解析请求。 例如，服务器需要查找冒号才能知道header名称结束的位置。 

这种方法可能存在歧义，因此这使得异步攻击成为可能。 



HTTP/2 是类似于 TCP 的二进制协议，因此它的解析基于预定义的偏移量，并且不太容易产生歧义。 



本文使用了人类可读的抽象而不是实际字节来表示 HTTP/2 请求。 例如，在线路上，伪头部名称实际上映射到单个字节 – 它们实际上并不包含冒号。



## 通用头部



### 通用信息头部

#### 



### 通用缓存头部



## 请求头部





### User-Agent

用户不能直接去互联网上获取信息，需要一个软件去代表用户的行为，这个软件就是 User-Agent （用户代理）浏览器就是一种典型的 User-Agent 。

用户使用不同的软件去用统一的协议去做相同的事情。这也是定义在 http 请求里的，每一条 http 请求一定会携带 User-Agent 头



网站的服务者可以通过 User-Agent 头来判断用户使用了什么浏览器，当然也可以根据 User-Agent 的内容来提供差异化的服务。

**当然，从原则上来看，是不应该根据 User-Agent 来提供差异化服务的，应该使用另一种方式：[feature detection](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Browser_detection_using_the_user_agent)**

[标准语法](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent)和历史：

```
User-Agent: <product> / <product-version> <comment>
```



因为服务端可以根据客户端在请求体提供的不同的 User-Agent 的内容来提供差异化的服务，所以当年在浏览器大战时期，浏览器的实现各不相同。 

当年 Mozilla （Firefox 的前身）浏览器最强的，很多网站都只对 Mozilla 提供高质量的服务，后来有人把自己伪装成了 Mozilla （没错，就是 IE 先开始的）。

 从此 `Mozilla/5.0` 就变成了 User-Agent 的第一段：

```http
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0

User-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36
```



https://a-wing.top/browser/2021/08/22/user-agent



### Sec-Fetch-*安全请求头

如果你使用76+版本的chrome浏览器，通过开发者面板查看每个网络请求，会发现都有几个Sec-Fetch开头的请求头：

```http
Sec-Fetch-Dest: document
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: none
Sec-Fetch-User: ?1
```

简单来说，就是网络请求的元数据描述，服务端根据这些补充数据进行细粒度的控制响应，换句话说，服务端可以精确判断请求的合法性，杜绝非法请求和攻击，提高web服务的安全性。

Sec-Fetch-Dest是一个用于HTTP请求头的字段 (全名应该是”Security Fetch Destination”，意思是安全获取目标) ，**用于指示浏览器请求的目标资源类型以及请求的目的和处理方式**。**该字段通常由浏览器自动生成**，并在发送请求时包含在HTTP请求中。它有助于服务器和浏览器之间更好地理解请求的目的和处理方式。



这些值可以帮助服务器和浏览器更好地理解请求的目的和处理方式，从而提高网络请求的效率和安全性。

通过了解请求的目标资源类型，服务器可以更好地优化响应，而浏览器可以更好地处理返回的资源。





这个字段是用于指示浏览器请求的目标资源类型以及请求的目的和处理方式。我们在采集一个网站资源这种小型的爬虫项目中通常是采用**一个通用的header**，**如果我们在请求不同资源的时候，你发现各方面都正常但是有一些请求却拿不到数据，很有可能就是这个字段的问题，你可以尝试单独使用一个header去分别设置Sec-Fetch-Dest字段值，或者是在你通用header中删除掉这个字段尝试。**





## 响应头部



## 实体头部

有很多首部可以用来描述 HTTP 报文的负荷。由于请求和响应报文中都可能包含实体部分，所以在这两种类型的报文中都可能出现这些首部。

HTTP 实体首部描述了 HTTP 报文的内容。HTTP/1.1 版定义了以下 10 个基本字体首部字段：

- Content-Type 
- Content-Length 
- Content-Language 
- Content-Encoding 
- Content-Location
- Content-Range 





### content-length

Content-Length 首部指示出报文中实体主体的字节大小，也就是消息长度。

- 用**十进制数字**表示的 `Entity body` 的字节数，是Headers中常见的一个字段。



**注意，这个大小是包含了所有内容编码的，比如，对文本文件进行了 gzip 压缩的话， Content-Length 首部就是压缩后的大小，而不是原始大小。**

`Content-Length` 首部对于**持久连接**是必不可少的。如果响应通过持久连接传送，就可能有另一条 HTTP 响应紧随其后。

客户端通过 `Content-Length` 首部就可以知道报文在何处结束，下一条报文从何处开始。因为连接是持久的，客户端无法依赖连接关闭来判别报文的结束。



**HTTP/1.1 规范中建议对于带有主体但没有 Content-Length 首部的请求，服务器如果无法确定报文的长度，就应当发送 400 Bad Request 响应或 411 Length Required响应。**

后一种情况表明服务器要求收到正确的 Content-Length 首部。























#### 定长包体与不定长包体

定长包体，在构造报文的时候，明确了报文包体的长度。这时需要在头部携带 Content-Length 来指明报文包体的字节数。

不定长包体：

- 边压缩边发送。



```
transfer-encoding: 

```



### 实体摘要

尽管 HTTP 通常都是在像 TCP/IP 这样的可靠传输协议之上实现的，但仍有很多因素会导致报文的一部分在传输过程中被修改，比如有不兼容的转码代理，或者中间代理有误等等。

为检测实体主体的数据是否被不经意（或不希望有）地修改，发送方可以在生成初始的主体时，生成一个数据的校验和，这样接收方就可以通过检查这个校验和来捕获所有意外的实体修改了。



服务器使用 Content-MD5 首部发送对实体主体运行 MD5 算法的结果。只有产生响应的原始服务器可以计算并发送 Content-MD5 首部。

中间代理和缓存不应当修改或添加这个首部，否则就会与验证端到端完整性的这个最终目的相冲突。 Content-MD5首部是在对内容做了所有需要的内容编码之后，还没有做任何传输编码之前，计算出来的。

为了验证报文的完整性，客户端必须先进行传输编码的解码，然后计算所得到的未进行传输编码的实体主体的 MD5。

举个例子吧，如果一份文档使用 gzip 算法进行压缩，然后用分块编码发送，那么就对整个经 gzip 压缩的主体进行 MD5 计算。

```
HTTP/2 200 OK
server: Tengine
content-type: application/javascript
content-length: 1172
date: Fri, 07 Oct 2022 08:16:11 GMT
vary: Accept-Encoding
x-oss-request-id: 633FE04B76A944323882BED3
x-oss-object-type: Normal
x-oss-hash-crc64ecma: 782727689174376310
x-oss-storage-class: Standard
cache-control: max-age=900,s-maxage=900
content-md5: kbTSVioIE5MtPDEKNEpn5g==
x-oss-server-time: 2
access-control-allow-origin: *
x-source-scheme: https
content-encoding: gzip
ali-swift-global-savetime: 1665130571
via: cache41.l2cn1851[70,70,200-0,M], cache41.l2cn1851[71,0], cache41.l2cn1851[71,0], cache13.cn2967[0,0,200-0,H], cache13.cn2967[1,0]
age: 564
x-cache: HIT TCP_MEM_HIT dirn:12:745548673
x-swift-savetime: Fri, 07 Oct 2022 08:16:11 GMT
x-swift-cachetime: 900
timing-allow-origin: *
eagleid: b6f2592116651311359134856e
X-Firefox-Spdy: h2
```



### 媒体类型Content-Type

Content-Type 首部说明的是原始实体主体的媒体类型。例如，如果实体经过内容编码的话， Content-Type 首部说明的仍是编码之前的实体主体的类型。

MIME 类型由一个主媒体类型（比如：text、image 或 audio 等）后面跟一条斜线以及一个子类型组成，子类型用于进一步描述媒体类型。



### 内容编码

HTTP 应用程序有时在发送之前需要对内容进行编码。

例如，在把很大的 HTML 文档发送给通过慢速连接连上来的客户端之前 , 服务器可能会在发送之前对它进行压缩，这样有助于减少传输实体的时间。

这种类型的编码是在发送方应用到内容之上的。当内容经过内容编码之后，编好码的数据就放在实体主体中，像往常一样发送给接收方。



内容编码过程：

- 网站服务器生成原始响应报文，其中有原始的 `Content-Type` 和 `Content-Length` 首部。
- 内容编码服务器（也可能是原始的服务器或缓存代理等）创建编码后的报文。
  - 编码后的报文有同样的 `Content-Type` 和  `Content-Length` ，可能不同（比如主体被压缩了）。
  - 内容编码服务器在编码后的报文中增加 `Content-Encoding` 首部，这样接收的应用程序就可以进行解码了。
- 客户端接收程序得到编码后的报文，进行解码，获得原始报文。

通过 gzip 内容编码函数对 HTML 页面处理之后，得到一个更小的、压缩的主体。经过网络发送的是压缩的主体，并打上了 gzip 压缩的标志。

接收的客户端使用 gzip 解码器对实体进行解压缩。

```http
HTTP/2 200 OK
server: Tengine
content-type: application/javascript
content-length: 1172
date: Fri, 07 Oct 2022 08:16:11 GMT
vary: Accept-Encoding
x-oss-request-id: 633FE04B76A944323882BED3
x-oss-object-type: Normal
x-oss-hash-crc64ecma: 782727689174376310
x-oss-storage-class: Standard
cache-control: max-age=900,s-maxage=900
content-md5: kbTSVioIE5MtPDEKNEpn5g==
x-oss-server-time: 2
access-control-allow-origin: *
x-source-scheme: https
content-encoding: gzip
ali-swift-global-savetime: 1665130571
via: cache41.l2cn1851[70,70,200-0,M], cache41.l2cn1851[71,0], cache41.l2cn1851[71,0], cache13.cn2967[0,0,200-0,H], cache13.cn2967[1,0]
age: 564
x-cache: HIT TCP_MEM_HIT dirn:12:745548673
x-swift-savetime: Fri, 07 Oct 2022 08:16:11 GMT
x-swift-cachetime: 900
timing-allow-origin: *
eagleid: b6f2592116651311359134856e
X-Firefox-Spdy: h2
```



**内容编码类型**

HTTP 定义了一些标准的内容编码类型，并允许用扩展编码的形式增添更多的编码。由互联网号码分配机构（IANA）对各种编码进行标准化，它给每个内容编码算法分配了唯一的代号：

- gzip 表明实体采用 GNU zip 编码

- compress 表明实体采用 Unix 的文件压缩程序，这种内容编码方式已经被大部分浏览器弃用，部分因为专利问题

- deflate 表明实体是用 zlib 的格式压缩的

- br 表示采用 [Brotli](https://zh.wikipedia.org/wiki/Brotli) 算法的编码方式。

- identity 表明没有对实体进行编码。当没有 Content-Encoding 首部时，就默认为这种情况

  

[Content-Encoding](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Encoding)

**`Content-Encoding`** 列出了对当前实体消息（消息荷载）应用的任何编码类型，以及编码的顺序。它让接收者知道需要以何种顺序解码该实体消息才能获得原始荷载格式。

Content-Encoding 主要用于在不丢失原媒体类型内容的情况下压缩消息数据。



[Accept-Encoding](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept-Encoding)

为了避免服务器使用客户端不支持的编码方式，客户端就把自己支持的内容编码方式列表放在请求的 Accept-Encoding 首部里发出去。

如果 HTTP 请求中没有包含 Accept-Encoding 首部，服务器就可以假设客户端能够接受任何编码方式（等价于发送 Accept-Encoding: * ）。



#### 字符编码

HTTP 报文中可以承载以任何语言表示的内容，就像它能承载图像、影片，或任何类型的媒体那样。对 HTTP 来说，实体主体只是二进制信息的容器而已。

服务器需要告知客户端每个文档的字母表和语言，这样客户端才能正确地把文档中的信息解包为字符并把内容呈现给用户。

服务器通过 HTTP 协议的 Content-Type 首部中的 charset 参数和 Content-Language 首部告知客户端文档的字母表和语言。

这些首部描述了实体主体的"Entity Body"里面装的是什么，如何把内容转换成合适的字符以便显示在屏幕上以及里面的词语表示的是哪种语言。



同时，客户端需要告知服务器用户理解何种语言，浏览器上安装了何种字母表编码算法。

客户端发送 Accept-Charset 首部和 Accept-Language 首部，告知服务器它理解哪些字符集编码算法和语言以及其中的优先顺序。

下面的 Content-Type 首部告知接收者，传输的内容是一份 HTML 文件，用 charset 参数告知接收者使用 utf-8 字符集的解码算法把内容中的二进制码转换为字符：

```
Content-Type: text/html; charset=uft-8
```

如果没有显式地列出字符集，接收方可能就要设法从文档内容中推断出字符集。对于 HTML 内容来说，可以在描述 charset 的 <META HTTP-EQUIV="Content-Type"> 标记中找到字符集。



在过去的几十年间，人们开发了成千上万种字符编解码方法。大多数客户端不可能支持所有这些不同的字符编码和映射系统。

HTTP 客户端可以使用 Accept-Charset 请求首部来明确告知服务器它支持哪些字符系统。 Accept-Charset 首部的值列出了客户端支持的字符编码方案。

例如，下面的 HTTP 请求首部表明，客户端接受西欧字符系统 iso-8859-1 和 UTF-8 变长的Unicode 兼容系统。服务器可以随便选择这两种字符编码方案之一来返回内容。



### 传输编码和分块编码

`Transfer-Encoding`字段是HTTP响应头部的一部分，用于指示在传输响应正文（response body）时所使用的传输编码方式

在HTTP通信中，响应正文可以以多种不同的编码方式传输，其中一种方式是chunked传输编码。



`HTTP`分块传输（Chunked Transfer Encoding）是一种`HTTP`协议在数据传输时的编码格式，它允许将数据分成若干个块进行传输。

每个传输的块都包含大小信息和实际的数据内容。让[服务器](https://cloud.tencent.com/product/cvm?from_column=20065&from=20065)发送大型文件或流数据时不必一开始就发送全部内容，而是可以分成一块一块的数据来发送。

这样可以节省带宽和内存，特别是对于需要长时间连接的情况。

分块编码把报文分割为若干个大小已知的块。块之间是紧挨着发送的，这样就不需要在发送之前知道整个报文的大小了。



若客户端和服务器之间不是持久连接，客户端就不需要知道它正在读取的主体的长度，而只需要读到服务器关闭主体连接为止。



当使用持久连接时，在服务器写主体之前，必须知道它的大小并在 Content-Length 首部中发送。如果服务器动态创建内容，就可能在发送之前无法知道主体的长度。



https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Transfer-Encoding

## 扩展头部









### X-Forwarded-For

X-Forwarded-For 是一个 HTTP 扩展头部。

HTTP/1.1（RFC 2616）协议并没有对它的定义，它最开始是由 Squid 这个缓存代理软件引入，用来表示 HTTP 请求端真实 IP。

如今它已经成为事实上的标准，被各大 HTTP 代理、负载均衡等转发服务广泛使用，并被写入 [RFC 7239](http://tools.ietf.org/html/rfc7239)（Forwarded HTTP Extension）标准之中。

```dart
客户端=>（正向代理=>透明代理=>服务器反向代理=>）Web服务器
```



> X-Forwarded-For 请求头格式
>
> X-Forwarded-For: client, proxy1, proxy2

可以看到，XFF 的内容由「英文逗号 + 空格」隔开的多个部分组成，最开始的是离服务端最远的设备 IP，然后是每一级代理设备的 IP。

如果一个 HTTP 请求到达最后端的 HTTP 服务器之前。

经过了三个代理 Proxy1、Proxy2、Proxy3，IP 分别为 IP1、IP2、IP3，用户真实 IP 为 IP0，那么按照 XFF 标准，服务端最终会收到以下信息：



> X-Forwarded-For: IP0, IP1, IP2



Proxy3 直连服务器，它会给 XFF 追加 IP2，表示它是在帮 Proxy2 转发请求。



一般的客户端（例如浏览器）发送HTTP请求是没有X-Forwarded-For头的，当请求到达第一个代理服务器时，代理服务器会加上X-Forwarded-For请求头，并将值设为客户端的IP地址（也就是最左边第一个值），后面如果还有多个代理，会依次将IP追加到X-Forwarded-For头最右边，最终请求到达Web应用服务器，应用通过获取X-Forwarded-For头取左边第一个IP即为客户端真实IP。

但是如果客户端在发起请求时，请求头上带上一个伪造的X-Forwarded-For，由于后续每层代理只会追加而不会覆盖，那么最终到达应用服务器时，获取的左边第一个IP地址将会是客户端伪造的IP。也就是上面的Java代码中getClientIp()方法获取的IP地址很有可能是伪造的IP地址，如果一个投票系统用这种方式做的IP限制，那么很容易会被刷票。





**Remote Address** 

在Java中，获取客户端IP最直接的方式就是使用request.getRemoteAddr()。这种方式能获取到连接服务器的客户端IP，在中间没有代理的情况下，的确是最简单有效的方式。但是目前互联网Web应用很少会将应用服务器直接对外提供服务，一般都会有一层Nginx做反向代理和负载均衡，有的甚至可能有多层代理。在有反向代理的情况下，直接使用request.getRemoteAddr()获取到的IP地址是Nginx所在服务器的IP地址，而不是客户端的IP。



HTTP 连接基于 TCP 连接，Remote Address 来自 TCP 连接，表示与服务端建立 TCP 连接的设备 IP 。

> 铁律：当多层代理或使用CDN时，如果代理服务器不把用户的真实IP传递下去，那么业务服务器将永远不可能获取到用户的真实IP。

在大部分实际业务场景中，网站访问请求并不是简单地从客户端（访问者）的浏览器直接到达网站的源站服务器，而是在客户端和服务器之前经过了根据业务需要部署的Web应用防火墙、DDoS高防、CDN等代理服务器。

这种情况下，访问请求在到达源站服务器之前可能经过了多层安全代理转发或加速代理转发，源站服务器该如何获取发起请求的真实客户端IP？







**X-Real-IP**

这也是一个自定义 HTTP 头部。

`X-Real-IP` 通常被 HTTP 代理用来表示与它产生 TCP 连接的设备 IP 。这个设备可能是其他代理，也可能是真正的请求端。

需要注意的是，`X-Real-IP` 目前并不属于任何标准，代理和 Web 应用之间可以约定用任何自定义头来传递这个信息。



列表中并没有 IP3，在服务端通过 Remote Address 字段获得 IP3。

我们知道 HTTP 连接基于 TCP 连接，HTTP 协议中没有 IP 的概念，Remote Address 来自 TCP 连接，表示与服务端建立 TCP 连接的设备 IP 。

Remote Address 无法伪造，因为建立 TCP 连接需要三次握手，如果伪造了源 IP，无法建立 TCP 连接，更不会有后面的 HTTP 请求。

不同语言获取 Remote Address 的方式不一样，例如 php 是 `$_SERVER["REMOTE_ADDR"]`，Node.js 是 `req.connection.remoteAddress`，但原理都一样 。

很多 web 应用，也要分析判断头部，来取真正的请求的客户端 IP 。



在 nginx 中，通常可以这样配置

```nginx
location /proxy {                                                                                                               	 proxy_http_version 1.1;                                                                                                     	  proxy_set_header Connection "";
     # 协议升级头部
     proxy_set_header Upgrade $http_upgrade; 
     # 协议升级头部 
     proxy_set_header Connection "upgrade";                                                                       					 proxy_set_header Host $host;                                                                                           		 proxy_set_header X-Real-IP $remote_addr;                                                                               		 proxy_set_header REMOTE-HOST $remote_addr; 
     # 
     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;                                                           	
     proxy_pass http://localhost/index.html;  
```





https://imququ.com/post/x-forwarded-for-header-in-http.html

https://dog.xmu.edu.cn/2021/07/02/x-forwarded-for-ip-address-spoofing.html

https://www.cnblogs.com/bonelee/p/14701861.html

#### 动态NAT场景

比如家里电信宽带上网，电信给分配了公网ip，那么一个访问公网网站的请求经过的 ip 路径如下：

- 192.168.0.101(用户电脑ip)

- 192.168.0.1/116.1.2.3(路由器的局域网ip/路由器得到的电信公网ip)

- 119.147.19.234(业务的前端负载均衡服务器)
- 192.168.126.127(业务处理服务器)。



在这种情况下，对于服务器后端业务服务器，应该取到的客户端IP应该是 116.1.2.3 ，可以在代码中通过头部进行判断



#### 端口NAT场景

宽带提供商没有足够的公网ip，分配到用户的接入网的是个私网ip，比如长宽等小的isp。**现在基本上都是这种网络**

- 192.168.0.123(用户电脑ip)
- 192.168.0.1/10.0.1.2(路由器的局域网ip及路由器得到的运营商内网ip)
- 211.162.78.1（网络运营商长城宽带的公网ip）
- 119.147.19.234(业务的前端负载均衡服务器)
- 192.168.126.127(业务处理服务器)。



在这种情况下，对于服务器后端业务服务器，应该取到的客户端应该是 211.162.78.1，可以在代码中通过头部进行判断。









示例  



```javascript
// 启动一个 nodejs 的应用，监听9009端口
var http = require('http');

http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.write('remoteAddress: ' + req.connection.remoteAddress + '\n');
    res.write('x-forwarded-for: ' + req.headers['x-forwarded-for'] + '\n');
    res.write('x-real-ip: ' + req.headers['x-real-ip'] + '\n');
    res.end();
}).listen(9009, '0.0.0.0');
```





```golang
package main
 
import (
 	// Standard library packages
    "fmt"
    "log"
    "net"
    "net/http" 
)
 
// w表示response对象，返回给客户端的内容都在对象里处理
// r表示客户端请求对象，包含了请求头，请求参数等等
func indexHandler(w http.ResponseWriter, r *http.Request) {
    // 往w里写入内容，就会在浏览器里输出
    fmt.Fprintf(w, "Hello golang http!")
    // 
    fmt.Fprintf(w, "")
}


// RemoteIp 返回远程客户端的 IP，如 192.168.1.1
func RemoteIp(req *http.Request) string {
	remoteAddr := req.RemoteAddr
	if ip := req.Header.Get(XRealIP); ip != "" {
		remoteAddr = ip
	} else if ip = req.Header.Get(XForwardedFor); ip != "" {
		remoteAddr = ip
	} else {
		remoteAddr, _, _ = net.SplitHostPort(remoteAddr)
	}

	if remoteAddr == "::1" {
		remoteAddr = "127.0.0.1"
	}

	return remoteAddr
}


func main() {

    // 设置路由，如果访问/，则调用index方法
    http.HandleFunc("/", indexHandler)
    http.HandleFunc("/", indexHandler)
    
    RemoteIp()
 
    // 启动web服务，监听9090端口
    err := http.ListenAndServe(":9090", nil)
    if err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}
```



https://blog.csdn.net/xiao__gui/article/details/83054462



# 内容协商机制



在 [HTTP](https://developer.mozilla.org/zh-CN/docs/Glossary/HTTP) 协议中，**内容协商**是一种机制，用于为同一 URI 提供资源不同的[表示](https://developer.mozilla.org/zh-CN/docs/Glossary/Representation_header)形式，以帮助用户代理指定最适合用户的表示形式（例如，哪种文档语言、哪种图片格式或者哪种内容编码）。

一个 URL 常常需要代表若干不同的资源。例如那种需要以多种语言提供其内容的网站站点。如果某个站点（比如 Joe 的五金商店这样的站点）有说法语的和说英语的两种用户，它可能想用这两种语言提供网站站点信息。



但在这种情况下，当用户请求 http://www.joes-hardware.com 时，服务器应当发送哪种版本呢？法文版还是英文版？

理想情况下，服务器应当向英语用户发送英文版，向法语用户发送法文版——用户只要访问网站主页就可以得到相应语言的内容

HTTP提供了内容协商方法，允许客户端和服务器作这样的决定。通过这些方法，单一的URL就可以代表不同的资源(比如，同一个网站页面的法语版和英语版)





**Google 建议对每种语言版本的网页使用不同的网址，而不是使用 Cookie 或浏览器设置来调整网页上的内容语言。**世界各国谷歌网址是由Google加上不同国家和地区顶级域名（ccTLD）后缀组成的。

为了适应不同国家地区的搜索习惯，提供最精确的搜索结果，谷歌在全世界主要国家地区都有对应的不同网址。



比如，美国谷歌：google.com（美国不使用google.us），德国谷歌：google.de等等。不同国家的谷歌，搜索同一个关键词，结果都是不一样的，这也就是地域化的区别。

用户在访问谷歌时，也会优先跳转到相应国家的Google网址。因此，如果是针对某个国家地区做SEO，那么在验证结果的时候，一定要使用该国家的谷歌进行搜索，这样才能得到最准确的结果。



**固定访问谷歌地址**

使用google.com/ncr来访问Google，ncr是No Country Redirect的缩写，此时Google会重定向请求到主站google.com，而不会定向到访问IP所在的Google域名了。





在服务端驱动型内容协商或者主动内容协商中，浏览器（或者其他任何类型的用户代理）会随同 URL 发送一系列的 HTTP 头。这些头描述了用户倾向的选择。

服务器则以此为线索，通过内部算法来选择最佳方案提供给客户端。如果它不能提供一个合适的资源，它可能使用 [`406`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status/406)（Not Acceptable）、[`415`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status/415)（Unsupported Media Type）进行响应并为其支持的媒体类型设置标头（例如，分别对 POST 和 PATCH 请求使用 [`Accept-Post`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept-Post) 或 [`Accept-Patch`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept-Patch) 标头）。相关算法与具体的服务器相关，并没有在规范中进行规定。



HTTP/1.1 规范指定了一系列的标准标头用于启动服务端驱动型内容协商（[`Accept`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept)、[`Accept-Charset`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept-Charset)、[`Accept-Encoding`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept-Encoding)、[`Accept-Language`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept-Language)）。

尽管严格来说 [`User-Agent`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/User-Agent) 并不在此列，有时候它还是会被用来确定给客户端发送的所请求资源的特定表示形式，不过这种做法不提倡使用。

服务器会使用 [`Vary`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Vary) 标头来说明实际上哪些标头被用作内容协商的参考依据（确切来说是与之相关的响应标头），这样可以使[缓存](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Caching)的运作更有效。

除此之外，有一个向可供选择的列表中增加更多标头的实验性提案，称为*客户端提示*（Client Hint）。客户端示意机制可以告知运行用户代理的设备类型（例如，是桌面计算机还是移动设备）。

即便服务端驱动型内容协商机制是最常用的对资源特定表示形式进行协商的方式，它也存在如下几个缺点：

- 服务器对浏览器并非全知全能。即便是有了客户端示意扩展，也依然无法获取关于浏览器能力的全部信息。与客户端进行选择的代理驱动型内容协商机制不同，服务器端的选择总是显得有点武断。
- 客户端提供的信息相当冗长（HTTP/2 协议的标头压缩机制缓解了这个问题），并且存在隐私风险（HTTP 指纹识别技术）。
- 因为给定的资源需要返回不同的表示形式，共享缓存的效率会降低，而服务器端的实现会越来越复杂。





**内容协商\**是一种机制，用于为同一 URI 提供资源不同的[表示](https://developer.mozilla.org/zh-CN/docs/Glossary/Representation_header)形式，以帮助用户代理指定最适合用户的表示形式（例如，哪种文档语言、哪种图片格式或者哪种内容编码）。

一个URL常常需要代表若干不同的资源。例如那种需要以多种语言提供其内容的网站站点。





内容协商的基本原则：

- **主动式内容协商**

- **响应式内容协商**



**内容协商首部集是由客户端发送给服务器用于交换偏好信息的，以便服务器可以从文档的不同版本中选择出最符合客户端偏好的那个来提供服务。**

HTTP/1.1 规范指定了一系列的标准标头用于启动服务端驱动型内容协商（[`Accept`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept)、[`Accept-Charset`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept-Charset)、[`Accept-Encoding`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept-Encoding)、[`Accept-Language`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept-Language)）

- [`Accept`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept) 头部列举了用户代理希望接收的媒体资源的 MIME 类型。其中不同的 MIME 类型之间用逗号分隔，同时每一种 MIME 类型会配有一个品质因数（quality factor），该参数明确了不同 MIME 类型之间的相对优先级。
- [`Accept-Encoding`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Accept-Encoding) 头部明确说明了（接收端）可以接受的内容编码形式（所支持的压缩算法）。该标头的值是一个 Q 因子清单（例如 `br, gzip;q=0.8`），用来提示不同编码类型值的优先级顺序。默认值 `identity` 的优先级最低（除非声明为其他优先级）。
- 





## Vary头部

Vary出现在响应信息中的作用是什么呢？

**首先这是由服务器端添加，添加到响应头部。大部分情况下是用在客户端缓存机制或者是缓存服务器在做缓存操作的时候，会使用到Vary头，会读取响应头中的Vary的内容，进行一些缓存的判断。**



对于服务器提供的某个接口来说，有时候会出现不同种类的客户端对其进行网络请求获取数据，不同的客户端可能支持的压缩编码方式不同。

可能有的客户端不支持压缩，那么服务器端返回的数据就不能压缩，有的支持gzip编码，那么服务器端就可以进行gzip编码返回给客户端，客户端获取到数据之后，做响应的gzip解码。



假设你的服务器为同一个URL提供了两种版本：

1. **压缩版**（给现代浏览器）：体积小，传输快

2. **原始版**（给老旧设备）：无需解压，直接可读

如果缓存服务器如[CDN]不加区分地将压缩后的内容返回给所有用户，会发生什么？

- 支持解压的客户端：正常加载 ✅
- 不支持解压的客户端：乱码或崩溃 ❌

这就是 `Vary: Accept-Encoding` 要解决的核心问题——**智能缓存分发**。



当浏览器请求资源时，会在请求头中携带支持的压缩格式，例如：

```http
GET /style.css HTTP/1.1
Accept-Encoding: gzip, br
```

这相当于告诉服务器："我可以解压GZIP和Brotli格式的内容"。



服务器根据客户端的声明，返回对应编码的响应，并标注：

```http
HTTP/1.1 200 OK
Content-Encoding: gzip
Vary: Accept-Encoding
```

通过 `Vary: Accept-Encoding` 告知缓存："不同 `Accept-Encoding` 的请求要区别对待"。

也就是说 `Vary` 字段用于列出一个响应字段列表，告诉缓存服务器遇到同一个 URL 对应着不同版本文档的情况时，如何缓存和筛选合适的版本。



在 CORS 的场景下，我们需要使用`Vary: Origin`来保证不同网站发起的请求使用各自的缓存。比如从`foo.taobao.com`发起的请求缓存下的响应头是

```http
Access-Control-Allow-Origin: https://foo.taobao.com
Vary: Origin
```

这样`bar.taobao.com`在发起同 URL 的请求就不会使用这份缓存了，因为`Origin`请求头变了。



Amazon S3，全名为亚马逊简易存储服务，可以上传任意的资源文件，然后提供 HTTP 协议方式访问。

既然是个共用的第三方服务，当然就有配置 CORS 响应头的功能，然而它们就犯了规范中专门强调的这个错误：没有`Origin`请求头就不返回`Access-Control-Allow-Origin`，同时`Vary: Origin`也没有返回。



和 Amazon S3 对标的服务国内也有很多，比如阿里云 OSS。是的，阿里云的 OSS 也有同样的 bug。有人也反馈过，还写了 [demo 页面](https://wscdn.huanleguang.com/assets/oss_img_cors_demo.v3.html)。

这个页面里先用普通的`<img>`对一张图片发起了请求（非 CORS，不带`Origin`），然后又用带`crossorigin`属性的`<img>`对同一张图片发起请求（CORS 请求，带`Origin`），结果后者报错了，但如果禁用浏览器缓存，就不会报错





**`Vary` 头如何影响缓存行为？**

**缓存服务器的逻辑**

当收到后续请求时，缓存会检查两个条件：

1. 请求的URL是否匹配？

2. 请求头中的 `Accept-Encoding` 是否与已缓存版本一致？

例如：

- 用户A的 `Accept-Encoding: gzip` → 缓存压缩版
- 用户B的 `Accept-Encoding: identity`（无压缩）→ 缓存独立存储原始版



**未设置 `Vary` 的风险**

如果服务器省略了 `Vary: Accept-Encoding`：

- CDN可能将压缩版内容返回给不支持解压的客户端 → **页面崩溃**
- 或错误地缓存未压缩版本，导致支持压缩的客户端浪费带宽 → **性能下降**



 **正确做法**

- 对所有可压缩资源（CSS/JS/字体等）启用 `Vary: Accept-Encoding`
- 配合 `Content-Encoding` 明确编码类型
- 定期用WebPageTest或Lighthouse检查配置

❌ **应避免**

- 在非压缩资源上设置 `Vary: Accept-Encoding`

- 忽略老旧客户端的兼容性测试





还有种情况，对于不同的客户端，需要的内容不一样，比如针对特定，浏览器要求输出的内容不一样，比如在IE6浏览器上要输出不一样的内容，这就需要服务器端做不同的数据返回。

所以说，服务器提供的同一个接口，客户端进行同样的网络请求，对于不同种类的客户端可能需要的数据不同，服务器端的返回方式返回数据也会不同。

对于这个问题的解决，我想很多人是清楚的，我们可以在请求信息添加`Accept-Encoding`、`User-Agent`等头部。



`Accept-Encoding`表示客户端支持的编码格式，常见的编码格式有gzip/compress/deflate/identity，服务器端会根据客户端提供的`Accept-Encoding`对返回的内容进行编码，并通过添加响应头`Content-Encoding`表明服务器端使用的编码格式。

`User-Agent`表示客户端代理，使得服务器能够识别客户使用的操作系统及版本、CPU 类型、浏览器及版本、浏览器渲染引擎、浏览器语言、浏览器插件等。这样服务器就能区别不同种类的客户端，做出不同的数据返回操作。



# 内容编码

HTTP 应用程序有时在发送之前需要对内容进行编码。例如，在把很大的 HTML 文档发送给通过慢速连接连上来的客户端之前 , 服务器可能会对它进行压缩，这样有助于减少传输实体的时间。

服务器还可以把内容搅乱或加密，以此来防止未经授权的第三方看到文档的内容。原始媒体/内容的类型通过 [`Content-Type`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Type) 首部给出，而 `Content-Encoding` 应用于数据的表示，或“编码形式”。

-  [`Content-Type`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Type) 用于向接收方说明传输资源的媒体类型。例如，如果传输的是图片，那么它的媒体类型可能会是 `image/png` 、`image/jpg`。在浏览器中，浏览器会根据响应报文 Content-Type 判断响应体的资源类型，然后根据不同文件类型做出不同的展示。
- Content-Encoding 通常用于对实体内容进行压缩编码，目的是优化传输，例如用 gzip 压缩文本文件，能大幅减小体积。通常是 gzip，compress，deflate
- 

如果原始媒体以某种方式编码（例如 zip 文件），则该信息不应该被包含在 `Content-Encoding` 首部内。

## 内容编码类型

HTTP 定义了一些标准的内容编码类型，并允许用扩展编码的形式增添更多的编码。

由互联网号码分配机构（IANA）对各种编码进行标准化，它给每个内容编码算法分配了唯一的代号。

 Content-Encoding 首部就用这些标准化的代号来说明编码时使用的算法。

```
Content-Encoding: gzip,compress,deflate,identity
```

|          |      |      |
| -------- | ---- | ---- |
| gzip     |      |      |
| compress |      |      |
| deflate  |      |      |
| identity |      |      |



## 文件和编码

文件（内容）就是字节序列。 文本文件也是文件， 所以它也是字节序列。



https://blog.csdn.net/shawgolden/category_12281813.html?spm=1001.2014.3001.5482



通常说到文件时， 指的是 **文件内容**，但文件还有 **文件名**， 文件名与文件内容是分开存储的。你可以在硬盘上新建一个文件， 它的大小为 0 

但它是有文件名的， 比如上述的"新建文本文档.txt"， 保存这些名字自然也要占用空间， 只不过它与文件内容是分离的。



文件名也是一段文本，自然也会涉及到字符集编码。**文件内容**则视情况而定：

- 文本文件：常见的比如 txt, html, xml 以及各种源代码文件等等。
- 非文本文件：比如图片文件 jpg, gif , 以及各种各样的二进制文件。



由于对文件名没有一个统一的编码, 不同系统平台间交换文件时, 中文文件名极易发生乱码现象。在从windows上传文件到linux，肯定是会遇到过终端显示乱码的情况。

> 你可能碰到过这样的事, 把一个文本文件从 Windows 平台上传到 Linux 平台, 并在 Linux 平台下打开时发现乱码了, 但这不意味着文件内容有了什么变化, 通常的原因是你的文件是用 GBK 编码的, 但 Linux 平台下打开时它缺省可能用的是 UTF-8 编码去读取, 因此, 你只要调整成正确的编码去读取即可.



比如，Word 用什么编码? Word 生成的 doc 或者 docx 虽然不是文本文件, 但我们可以想像，它里面可能有图像，又有文字。 其中的文字自然也会用到某种编码，只不过这些都不需要我们去操心。

又比如， Java 中的 class 文件， 它也不是文本文件， 通常称为字节码文件。 但它里面也会保存 String 的常量, 这自然又要牵涉到编码。实际用的是所谓的 `modified UTF-8` 编码。



如何确定文本文件的字符集编码？

设想一下， 如果在保存文本文件时，也同时把所使用的编码的信息也保存在文件内容里，那么， 在再次读取时， 确定所使用的编码就容易多了。

很多的非文本文件比如图片文件通常会在文件的头部加上所谓的 “magic number（魔法数字）” 来作为一种标识。所谓的"magic number", 其实它就是一个或几个固定的字节构成的固定值，用于标识文件的种类（类似于签名）







# 传输编码

在 HTTP 中传输数据有一个 chunked 的方式, 又称“分块传输”。在响应报文里用头字段Transfer-Encoding: chunked 来表示。

意思是报文里的 body 部分不是一次性发过来的，而是分成了许多的块（chunk）逐个发送。



# HTTP报文





HTTP 报文是服务器和客户端之间交换数据的方式，有两种类型的消息︰

- 请求（requests）--由客户端发送用来触发一个服务器上的动作；
- 响应（responses）--来自服务器的应答。





HTTP消息由采用 ASCII 编码的多行文本构成。在HTTP/1.1及早期版本中，这些消息通过连接公开地发送。

在HTTP/2中，为了优化和性能方面的改进，HTTP报文被分到多个HTTP帧中。



Web 开发人员或网站管理员，很少自己手工创建这些原始的 HTTP 消息：

由软件、浏览器、代理或服务器完成。他们通过配置文件（用于代理服务器或服务器），API（用于浏览器）或其他接口提供 HTTP 消息。

HTTP 请求和响应具有相似的结构，由以下部分组成：

1. 起始行：一行起始行用于描述要执行的请求，或者是对应的状态，成功或失败。这个起始行总是单行的。
2. 头部：一个可选的 HTTP 标头集合指明请求或描述消息主体（body）。
3. 一个空行指示所有关于请求的元数据已经发送完毕。
4. 主体：一个可选的包含请求相关数据的*主体*（比如 HTML 表单内容），或者响应相关的文档。主体的大小有起始行的 HTTP 头来指定。





HTTP/1.1 请求的第一行包含请求方法和路径。

HTTP/2 用一系列伪头部（pseudo-header）替换了请求行，这五个伪头部很容易识别，因为它们在名称的开头用了一个冒号来表示。

比如请求方法和路径伪头字段如下：

- ":method" 伪头字段包含了 HTTP 方法；
- ":path" 伪头字段包含目标 URL 的路径和查询部分；
- 

```http
GET /zh-CN/docs/Glossary/Simple_header HTTP/1.1
Host: developer.mozilla.org
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:50.0) Gecko/20100101 Firefox/50.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: https://developer.mozilla.org/zh-CN/docs/Glossary/Simple_header

(content)
```

```http
HTTP1.1  200 OK
Connection: Keep-Alive
Content-Encoding: gzip
Content-Type: text/html; charset=utf-8
Date: Wed, 20 Jul 2016 10:55:30 GMT
Etag: "547fa7e369ef56031dd3bff2ace9fc0832eb251a"
Keep-Alive: timeout=5, max=1000
Last-Modified: Tue, 19 Jul 2016 00:59:33 GMT
Server: Apache
Transfer-Encoding: chunked

(content)
```





# [HTTTP请求方法](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods)



HTTP 定义了一组**请求方法**，以表明要对给定资源执行的操作。指示针对给定资源要执行的期望动作。虽然他们也可以是名词，但这些请求方法有时被称为 HTTP 动词。





| 方法    | 描述                 |      |
| ------- | -------------------- | ---- |
| GET     | 主要的资源获取方法， |      |
| HEAD    | 类似GET方法，        |      |
| POST    |                      |      |
| PUT     |                      |      |
| DELETE  |                      |      |
| CONNECT |                      |      |
| OPTIONS |                      |      |
| TRACE   |                      |      |





# URL的构成

https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/Web_mechanics/What_is_a_URL



```
schema://<user>:<password>@host:port/path;<params>?<query_string>#frag
```



- 方案：URL 的第一部分是方案（scheme），它表示浏览器必须使用的协议来请求资源（协议是计算机网络中交换或传输数据的一组方法）。

  - 访问服务器以获取资源时要使用哪种协议：http、https、ftp

  - `scheme`是协议名不区分大小写，以冒号结尾，表示需要使用的协议来检索资源。
  - 在RFC1738中定义`scheme`中只能包含`字母、数字、+、-` ，现实中浏览器没有严格的遵守。
  - 为了符合RFC1738中的语法规范，每个URL中需要在认证信息前面加入“//”。在省略“//”字符串的情况下，会造成解析错误。

- 用户名：可选，某些方案访问资源时需要的用户名。一般在ftp比较多。

- 密码：可选，用户名后面可能要包含的密码，中间由冒号（:）分隔

- 主机：资源宿主服务器的主机名或点分 IP 地址（现在一般是域名或IP）

  - 服务器地址，正常的URL是DNS指向的域名例如baidu.com，或者IPv4地址如127.0.0.1，或IPv6的地址如[0:0:0:0:0:0:0:1]。

  - 虽然RFC中的IP地址只允许规范的符号，但是大多数应用程序调用的是标准的C库，导致会宽松很多。

    - http://127.0.0.1/ 这是一个典型的IPv4地址。

    - http://0x7f.1/ 这是用十六进制表示的127.0.0.1

    - http://017700000001/ 用八进制表示的127.0.0.1

- 端口：服务器端口（http默认是80，https默认是443）

- 路径：请求路径

- 参数：请求参数

- 查询字符串

- 片段fragment

  页面的某个位置，其功能是让用户打开某个网页时，自动定位到指定位置上。

  在RFC 3986的文档中定义了一个URI的基本结构，定义了没有特殊意义的字符



浏览器本身支持的协议：`http: https: ftp: file:`(之前是local:，用来获取本地文件或者NFS与SMB共享)

在现实中，一些非正式的协议也会被支持，如`javascript`等。伪协议：一些保留协议用来调用浏览器脚本引擎或者函数，没有真正取回任何远程内容，也没有建立一个独立的文件。

如：`javascript: data:`

data协议例子：`data:text/html;base64,PGlmcmFtZS9vbmxvYWQ9YWxlcnQoMSk+`

封装的伪协议：`view-source:http://www.example.com/`

`view-source:`是由Chrome与Firefox提出的用来查看当前页面源代码的协议。





```

# 地址符号（&）是目前最广泛使用的查询字符串参数分隔符，尤其是在现代Web开发中。它是默认的分隔符，适用于大多数浏览器和服务器。
https://example.com/products?category=shoes&color=red&size=9



# 分号（;）曾经被推荐作为查询字符串参数的另一种分隔符，主要用于避免在某些特殊情况下对&字符进行转义。它通常用于路径参数（Path Parameters）或少数老旧的系统中作为参数分隔符。
# 在URL中，查询参数用于向服务器传递额外的信息，以便服务器能够根据这些参数来处理请求。通常，查询参数由键值对组成，键和值之间使用等号（=）连接，不同的键值对之间使用与号（&）分隔。
https://www.example.com/path/to/page;param1=value1;param2=value2
https://example.com/products;category=shoes;color=red;size=9
```







"http://www.xxx.com/page"一般是指向一个页面的地址，而URL参数则是给这个页面添加了访问参数，例如我们可以在页面地址后面加上"?id=aaa&group=bbb"来记录当前需要访问的记录id为aaa，分组id为bbb。

```
http://www.xxx.com/page?id=aaa&group=bbb
```

由'?'和'&'表示的URL参数从最初提出一直到现在，其作用和用法始终没有变过，而'#'则在web发展的漫长的岁月中前前后后改变过了多次。下面我们来详细讲讲'#'







**'#'**的名字为hash，最初被提出时被用于锚点定位功能。所谓锚点定位，意思是让浏览器定位到页面上的某个元素位置处。

例如，某页面上有很多很多的元素，其中有一个元素的id为"div1"，那么，我们只要在URL地址里加上"#div1"就可以让浏览器滚动到这个元素的位置处。







2008年，W3C提出了XHR的概念，通过使用XHR的api，人们发明出了ajax技术，使前端能够实现页面无刷新技术，即在页面不刷新的情况下，更新页面上的部分数据。

例如，某个列表页面带有分页，首次打开页面时，js通过ajax加载并展示了第一页的数据，当用户点击第二页时，js再次发起请求加载得到第二页的数据，然后把table中原来的数据清空，重新展示第二页的数据，这样实现了整个页面不需要重新加载即可翻页动态加载浏览数据。

 

前端页面无刷新技术的出现，是前端发展的一个历史性的进步，在后来的几年时间里，页面无刷新技术开始疯狂盛行，时至今日，该技术毫无疑问已经成为了前端技术的基石之一。

https://www.cnblogs.com/wjbin/p/15272551.html



## **URL是否区分大小写？**

[参考](https://www.zhihu.com/question/19572705)

URL的基本结构是：[协议]://[域名]/[路径]



域名：域名不论是大写输入还是大小写混合输入都是可以访问的，例如 [http://ZHIhu.com](https://link.zhihu.com/?target=http%3A//ZHIhu.com)

不管几级域名，都不分。Zhihu.com, zhIHu.com, WWW.ZhiHu.com，都一样



路径：路径部分是否区分大小写则不一定，要看具体网站后台是如何实现的。**特别在短网址中，一般就是区分的。**



有的网站，不区分，**有的网站，有意将目录和文件名强制小写，比如新浪微博斜杠后面的用户名。** 



只有路径部分才是会区分大小写。每个网站都有后台的服务器，如果服务器只是单纯的采用路径映射到机器的文件系统中，那不同的操作系统平台是会有不同的区别的：

- Linux：常见的是采用第三/四代扩展文件系统(ext3/4)，在该文件系统下是需要区分大小写的
- Mac OS X: 使用的HFS / HFS + / APFS(2016年发布的macOS Sierra开始)文件系统是不区分大小写
- Windows：微软公司开发的NTFS也是不区分大小写的



对于我们最经常接触到应用服务器来说，访问一个路径并不是指向文件系统中的某一个文件，而是作为一个字符串传输给应用服务器进行解析处理。

如果服务器是直接将路径映射到文件系统中去找，则不同平台上有不同实现：

- Mac OS X 默认的文件系统（HFS case-insensitive) 是不分大小写的、Windows 上的 NTFS 也是。

- 而 Linux  系统常用的 ext3/4 则是需要区分大小写的。

所以如果服务器不做额外的操作，则会根据文件系统不同有不同效果。



而像知乎这种应用服务器则又有不同。此时路径并不指向文件系统的某个文件，而是作为字符串交有应用来处理。比如，知乎使用的 Tornado 服务器是使用正则表达式来进行匹配路径。正则表达式可以通过不同写法或者标志符来控制是否区分大小写。







## URL与URI区别





# URL编码

**问题: 从浏览器地址栏输入url到请求返回发生了什么？**浏览器进行URL解析，url为啥要解析？



对于get方法来说，都是把数据串联在请求的url后面作为参数。若请求`query string`中包含中文，中文会被编码为 `%+16进制+16进制`形式。

但你真的深入了解过，为什么要进行这种转义编码吗？编码的原理又是什么？



**为什么要进行URL编码？**

URL参数字符串中使用`key=value`键值对这样的形式来传参，键值对之间以 `&` 符号分隔，如 /s?q=abc& ie=utf-8。

如果你的value字符串中包含了`=` 或者 `&`，那么势必会造成接收URL的服务器解析错误，因此必须将引起歧义的 `&` 和 `=` 符号进行转义，也就是对其进行编码。



例如，浏览器中进行百度搜索 "你好" 时，链接地址会被自动编码：

```
（编码前） https://www.baidu.com/s?wd=你好
（编码后）https://www.baidu.com/s?wd=%E4%BD%A0%E5%A5%BD
```


出现以上情况是网络请求发送前，**浏览器对请求URL进行了`URL编码（URL Encoding）`。**



- RFC3986文档规定，URL中只允许包含英文字母（a-zA-Z）、数字（0-9）、-_.~4个特殊字符以及所有保留字符。  

  

RFC3986文档对URL的编解码问题做出了详细的建议，指出了哪些字符需要被编码才不会引起Url语义的转变，以及对为什么这些字符需要编码做出了相 应的解释。



**需要URL encode的字符一般都是非ASCII的字符（笼统的讲），再通俗的讲就是除了英文字母以外的文字（如：中文，日文等）都要进行URL encod**



**URL encode到底按照那种编码方式对字符编码？**

浏览器在传输URl时得对URL进行编码，IE默认是以UTF-8来传输 的，Firefox肯定不是以UTF-8来编码，有可能是以ISO-8859-1来编码的，而Chrome好像是采用的GBK来编码。



如：最常使用的空格用%20来表示

```shell
# 比如在百度搜索"nginx http"
# 可以看到URL中的querystring就可以看到空格被编码为%20
https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=nginx%20http
https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=nginx%20http&fenlei=256&rsv_pq=0x9e752ae30002a7c3&rsv_t=b1d7VO8NNHhfki3WreWqLnUUfFwBN1D%2FoTGfja80r%2B%2FtaP%2BfllEKkA8rZtUq&rqlang=en&rsv_dl=tb&rsv_enter=1&rsv_sug3=22&rsv_sug1=15&rsv_sug7=100&rsv_sug2=0&rsv_btype=i&prefixsug=nginx%2520http&rsp=3&inputT=4996&rsv_sug4=4996
```



[参考](https://www.cnblogs.com/liuhongfeng/p/5006341.html)







### 图片base64编码

图片的 base64 编码就是可以将一副图片数据编码成一串字符串，使用该字符串代替图像地址。

这样做有什么意义呢？我们知道，我们所看到的网页上的每一个图片，都是需要消耗一个 http 请求下载而来的。

不管如何，图片的下载始终都要向服务器发出请求，要是图片的下载不用向服务器发出请求，而可以随着 HTML 的下载同时下载到本地那就太好了，而 base64 正好能解决这个问题。



举个栗子。[www.google.com](https://links.jianshu.com/go?to=http%3A%2F%2Fwww.google.com) 的首页搜索框右侧的搜索小图标使用的就是base64编码:

```
"data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPCEtLSBHZW5lcmF0b3I6IEFkb2JlIElsbHVzdHJhdG9yIDI0LjAuMCwgU1ZHIEV4cG9ydCBQbHVnLUluIC4gU1ZHIFZlcnNpb246IDYuMDAgQnVpbGQgMCkgIC0tPgo8c3ZnIHZlcnNpb249IjEuMSIgaWQ9IlN0YW5kYXJkX3Byb2R1Y3RfaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIKCSB4PSIwcHgiIHk9IjBweCIgd2lkdGg9IjE5MnB4IiBoZWlnaHQ9IjE5MnB4IiB2aWV3Qm94PSIwIDAgMTkyIDE5MiIgZW5hYmxlLWJhY2tncm91bmQ9Im5ldyAwIDAgMTkyIDE5MiIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSI+CjxyZWN0IGlkPSJib3VuZGluZ19ib3hfMV8iIGZpbGw9Im5vbmUiIHdpZHRoPSIxOTIiIGhlaWdodD0iMTkyIi8+CjxnIGlkPSJhcnRfbGF5ZXIiPgoJPGNpcmNsZSBpZD0iRG90IiBmaWxsPSIjNDI4NUY0IiBjeD0iOTYiIGN5PSIxMDQuMTUiIHI9IjI4Ii8+Cgk8cGF0aCBpZD0iUmVkIiBmaWxsPSIjRUE0MzM1IiBkPSJNMTYwLDcydjQwLjE1VjEzNmMwLDEuNjktMC4zNCwzLjI5LTAuODIsNC44MnYwdjBjLTEuNTcsNC45Mi01LjQzLDguNzgtMTAuMzUsMTAuMzVoMHYwCgkJYy0xLjUzLDAuNDktMy4xMywwLjgyLTQuODIsMC44Mkg2NmwxNiwxNmg1MGgxMmM0LjQyLDAsOC42My0wLjksMTIuNDYtMi41MWMzLjgzLTEuNjIsNy4yOC0zLjk2LDEwLjE3LTYuODYKCQljMS40NS0xLjQ1LDIuNzYtMy4wMywzLjkxLTQuNzRjMi4zLTMuNCwzLjk2LTcuMjgsNC44MS0xMS40NGMwLjQzLTIuMDgsMC42NS00LjI0LDAuNjUtNi40NXYtMTJWOTYuMTVWODRsLTYtMTlsLTEwLjgyLDIuMTgKCQlDMTU5LjY2LDY4LjcxLDE2MCw3MC4zMSwxNjAsNzJ6Ii8+Cgk8cGF0aCBpZD0iQmx1ZSIgZmlsbD0iIzQyODVGNCIgZD0iTTMyLDcyYzAtMS42OSwwLjM0LTMuMjksMC44Mi00LjgyYzEuNTctNC45Miw1LjQzLTguNzgsMTAuMzUtMTAuMzVDNDQuNzEsNTYuMzQsNDYuMzEsNTYsNDgsNTYKCQloOTZjMS42OSwwLDMuMjksMC4zNCw0LjgyLDAuODJjMCwwLDAsMCwwLDBMMTQ5LDQ1bC0xNy01bC0xNi0xNmgtMTMuNDRIOTZoLTYuNTZINzZMNjAsNDBINDhjLTE3LjY3LDAtMzIsMTQuMzMtMzIsMzJ2MTJ2MjBsMTYsMTYKCQlWNzJ6Ii8+Cgk8cGF0aCBpZD0iR3JlZW4iIGZpbGw9IiMzNEE4NTMiIGQ9Ik0xNDQsNDBoLTEybDE2LjgzLDE2LjgzYzEuMjMsMC4zOSwyLjM5LDAuOTMsMy40NywxLjU5YzIuMTYsMS4zMiwzLjk3LDMuMTMsNS4yOSw1LjI5CgkJYzAuNjYsMS4wOCwxLjIsMi4yNCwxLjU5LDMuNDd2MEwxNzYsODRWNzJDMTc2LDU0LjMzLDE2MS42Nyw0MCwxNDQsNDB6Ii8+Cgk8cGF0aCBpZD0iWWVsbG93IiBmaWxsPSIjRkJCQzA0IiBkPSJNNDgsMTY4aDM5Ljg5bC0xNi0xNkg0OGMtOC44MiwwLTE2LTcuMTgtMTYtMTZ2LTIzLjg5bC0xNi0xNlYxMzZDMTYsMTUzLjY3LDMwLjMzLDE2OCw0OCwxNjh6CgkJIi8+CjwvZz4KPC9zdmc+Cg=="
```



```
<img src="data:image/gif;base64,R0lGODlhHAAmAKIHAKqqqsvLy0hISObm5vf394uLiwAAAP///yH5B…EoqQqJKAIBaQOVKHAXr3t7txgBjboSvB8EpLoFZywOAo3LFE5lYs/QW9LT1TRk1V7S2xYJADs=">

```





# HTTP请求方法



一个 HTTP 事务由一条（从客户端发往服务器的）请求命令和一个（从服务器发回客户端的）响应结果组成。这种通信是通过名为 HTTP 报文（HTTP message）的格式化数据块进行的。

HTTP 支持几种不同的请求命令，这些命令被称为 HTTP 方法（HTTP method）。每条 HTTP 请求报文都包含一个方法。

HTTP 定义了一组**请求方法**, 以表明要对给定资源执行的操作。指示针对给定资源要执行的期望动作。虽然他们也可以是名词，但这些请求方法有时被称为HTTP动词。每一个请求方法都实现了不同的语义。

GET 方法和 HEAD 方法都被认为是安全的，这就意味着使用 GET 或 HEAD 方法的 HTTP 请求都不会产生什么动作。



- GET：GET方法请求一个指定资源的表示形式. 使用GET的请求应该只被用于获取数据。
- HEAD：HEAD方法请求一个与GET请求的响应相同的响应，但没有响应体。
- POST方法用于将实体提交到指定的资源，通常导致在服务器上的状态变化或副作用。
- PUT方法用请求有效载荷替换目标资源的所有当前表示。
- DELETE方法删除指定的资源。
- CONNECT方法建立一个到由目标资源标识的服务器的隧道。



# HTTP范围请求

HTTP 本身是一种无状态的“松散”协议，而在经历了很多版本的迭代之后，只在 HTTP/1.1（RFC2616） 之上，才支持范围请求。所以如果客户端或者服务端两端的某一端低于 HTTP/1.1，我们就不应该使用范围请求的功能。

而在 HTTP/1.1 中，很明确的声明了一个响应头部 `Access-Ranges` 来标记是否支持范围请求，它只有一个可选参数 `bytes`。



断点续传主要就是靠范围请求来实现的。



使客户端能够要求服务器仅向其回传 HTTP 消息的一部分。

范围请求对于支持随机访问的媒体播放器、明确只需大型文件某部分的数据处理工具，以及允许用户暂停及恢复下载的下载管理器等客户端尤其有用。



比如，你在看当下正热播的某穿越剧，想跳过片头，直接看正片，或者有段剧情很无聊，想拖动进度条快进几分钟，这实际上是想获取一个大文件其中的片段数据，而分块传输并没有这个能力。

HTTP 协议为了满足这样的需求，提出了 **范围请求** （range requests）的概念，允许客户端在请求头里使用专用字段来表示只获取文件的一部分，相当于是**客户端的 化整为零 **。

范围请求不是 Web 服务器必备的功能，可以实现也可以不实现，所以服务器必须在响应头里使用字段 **Accept-Ranges: bytes** 明确告知客户端： 我是支持范围请求的 。

如果不支持的话该怎么办呢？服务器可以发送 `Accept-Ranges: none`，或者干脆不发送 `Accept-Ranges` 字段，这样客户端就认为服务器没有实现范围请求功能，只能老老实实地收发整块文件了。





**range** ： 用于请求头中，指定第一个字节的位置和最后一个字节的位置

```
Range:(unit=first byte pos)-[last byte pos] 
```

**Content-Range**： 用于响应头，指定整个实体中的一部分的插入位置，他也指示了整个实体的长度。

在服务器向客户端返回一个部分响应，它必须描述响应覆盖的范围和整个实体长度。



https://www.cnblogs.com/plokmju/p/http_range.html





# SSE流式传输

大模型应用出现前，互联网在线应用以 Web 类应用为主，基于浏览器运行，通常通过 HTTP/HTTPS 协议与服务器通信。

例如电商应用、新零售/新金融/出行等交易类应用，教育、传媒、医疗等行业应用，以及公共网站、CRM 等企业内部应用，适用范围非常广泛。

其中，HTTPS 是 HTTP 的安全版本，通过 SSL/TLS 协议，对传输数据进行加密保护，加解密过程中会带来一些性能损耗。



不同类型的大模型应用，对网络通信的需求不尽相同，但几乎都离不开以下需求：

- **实时对话：** 用户与模型进行连续交互，模型需要即时响应。例如通义千问，HIgress 官网的答疑机器人，都是需要依据客户问题，即时做出响应。
- **流式输出：** 大模型生成内容时，逐字或逐句返回结果，而不是一次性返回。但是钉钉、微信等应用，两个人相互对话时，采用的就不是流式输出了，文字等内容都是一次性返回的。
- **长时任务处理：** 大模型可能需要较长时间处理复杂任务，同时需要向客户端反馈进度，尤其是处理长文本、以及图片、视频等多模态内容；这是因为依赖大模型计算的响应，要比依赖人为写入的业务逻辑的响应，消耗的资源多的多，这也是为什么大模型的计算要依靠 GPU，而非 CPU，CPU 在并行计算和大规模矩阵计算上远不如 GPU。
- **多轮交互：** 用户与模型之间需要多次往返交互，保持上下文。这是大模型应用保障用户体验的必备能力。



这些场景对实时性和双向通信有较高要求，沿用 Web 类应用的主流通信协议 - HTTPS，将出现以下问题：

- 仅支持单向通信，即请求-响应模型，必须是客户端发起时，服务端才能做出响应，无法进行双向通信，导致无法支持流式输出，无法处理长时任务。
- 客户端每次发出请求都需要重新建立连接，延迟增加，导致无法支持实时对话。
- HTTPS 是一种无状态的通信协议，每次请求都是独立的，服务端不会保存客户端的状态，即便客户端可以在每次请求时重复发送上下文信息，但会带来额外的网络开销，导致无法高效的支持多轮交互场景。



虽然 HTTPS 已经发展到 HTTPS/2 和 HTTPS/3，在性能上了有了提升，但是面对大模型应用这类对实时性要求较高的场景，依旧不够原生，并未成为这类场景下的主流通信协议。

**服务器发送事件（SSE，server-send events）是一种基于 HTTP 协议的单向通信协议，它允许服务器以事件流（Event Stream）的形式实时向客户端推送数据，而无需客户端明确请求。**

它建立在标准的 HTTP 协议之上，通过单向的持久连接，服务器可以主动向客户端发送事件和数据。



流式模式，顾名思义，即通过流的方式持续发送数据而不是一次性全部返回。与传统的 HTTP 请求模式不同，流式模式的特点在于服务器可以在连接打开后持续地向客户端发送数据。

这种实时传输方式不仅可以加快数据的响应速度，还可以减少带宽占用，使得应用的运行更加流畅。





以打字机输出为例，假设我们在 Web 页面上输入一个查询请求，传统模式下，页面会等待服务器返回完整的结果才会显示。

而在流式模式下，服务器会逐步发送数据，客户端可以立即将接收到的数据呈现在用户面前，产生一种“打字机”式的输出效果。这种方式显著提升了用户的等待体验，并让应用表现更加动态化和富有生命力。



本质上，它是以流信息的方式来实现的，由客户端向服务端发起建立连接请求，并保持连接打开，然后服务端主动推送消息给客户端，服务器给客户端发送的 SSE 数据，必须是 UTF-8 编码，且返回的内容类型是 text/event-stream。

比如当你在使用 ChatGPT 时，当你询问它问题时，你会看到它会逐字地将回答显示出来，实际上这是 ChatGPT 将先计算出的数据主动的“推送”给你，采用 SSE 技术边计算边返回，避免接口等待时间过长而直接关闭页面。





## SSE 的优势

1. **实时性**：SSE 提供了一种实时通信机制，允许服务器主动向客户端推送数据。这种实时性使得 SSE 特别适用于需要即时更新的应用场景，如实时聊天、在线协作工具、实时数据展示、通知推送等。
2. **减少网络负担**：与传统的轮询方式相比，SSE 采用长连接，通过单一的 HTTP 连接，服务器可以向客户端推送多个事件，避免了频繁的 HTTP 请求，从而减少了网络负担。
3. **轻量级**：SSE 是基于 HTTP 协议，现有的服务器软件都支持，相较于 WebSocket，SSE 的使用更加简单。
4. **自动重连**：SSE 在连接中断后能够自动尝试重新建立连接，而无需额外的代码。这种自动重连机制增加了系统的稳定性，确保即使在网络不稳定的情况下，通信仍能够持续进行。



`header('Content-Type: text/event-stream') `是用于设置HTTP响应头。它指定了服务器响应的内容类型为 `text/event-stream`，这是用于Server-Sent Events（SSE）的规定内容类型。

**底层原理是，当浏览器收到带有 `Content-Type: text/event-stream` 响应头的HTTP响应时，它会将响应解析为SSE流。SSE允许服务器通过单个HTTP连接将实时事件（event）流式传输到客户端。**

SSE的工作原理如下：

- 客户端通过浏览器向服务器发送一个带有SSE特定的请求，通常是使用 `EventSource 对象或 `<source>` 元素。
- 服务器收到请求后，将建立一个持久的HTTP连接，保持连接打开，并将 `Content-Type` 设置为 `text/event-stream`。
- 服务器通过该连接发送一个或多个事件（event）到客户端。每个事件由一个或多个字段组成，如 event、data、id 等。
- 客户端收到事件后，可以根据需要对事件进行处理，例如更新页面内容、执行操作等。
- 连接保持打开，服务器可以随时推送新的事件到客户端，实现实时通信的效果。
- `Content-Type: text/event-stream` 响应头告诉浏览器使用SSE的协议来解析响应，并按照SSE规范处理收到的事件数据。浏览器会将每个事件分解为适当的事件对象，从而能够对其进行处理和展示。



需要注意的是，SSE是一种单向通信协议，只允许服务器向客户端推送数据，而不支持客户端向服务器发送请求。因此，SSE适用于需要服务器主动向客户端推送实时数据的场景，如实时通知、实时数据更新等。

# HTTP连接管理



## TCP连接

**TCP 负责在不可靠的传输信道之上提供可靠的抽象层，向应用层隐藏了大多数网络通信的复杂细节，比如丢包重发、按序发送、拥塞控制及避免、数据完整等等。**

**TCP 为 HTTP 提供了一条可靠的比特传输管道。从 TCP 连接一端填入的字节会从另一端以原有的顺序、正确地传送出来。**

**TCP 会按序、无差错地承载 HTTP 数据。**



HTTP 标准并未规定 TCP 就是唯一的传输协议。如果你愿意，还可以通过 UDP（用户数据报协议）或者其他可用协议来发送 HTTP 消息。

但在现实当中，由于 TCP 提供了很多有用的功能，几乎所有 HTTP 流量都是通过 TCP 传送的。



HTTP 要传送一条报文时，会以流的形式将报文数据的内容通过一条打开的 TCP 连接按序传输。

TCP 收到数据流之后，会将数据流砍成被称作段的小数据块，并将段封装在 IP 分组中，通过因特网进行传输。

所有这些工作都是由 TCP/IP 软件来处理的，HTTP 程序员什么都看不到。





每个 TCP 报文段都是由 IP 分组承载，从一个 IP 地址发送到另一个 IP 地址的。每个 IP分组中都包括：

- 一个 IP 分组首部（通常为 20 字节）：IP 首部包含了源和目的 IP 地址、长度和其他一些标记
- 一个 TCP 段首部（通常为 20 字节）：TCP 段的首部包含了 TCP端口号、TCP 控制标记，以及用于数据排序和完整性检查的一些数字值
- 一个 TCP 数据块（0 个或多个字节）





在任意时刻计算机都可以有几条 TCP 连接处于打开状态。TCP 是通过端口号来保持所有这些连接持续不断地运行。

**一个 TCP 连接是通过四元组来唯一标识的：(源 IP 地址):(源端口号)<——>(目的 IP 地址):(目的端口号)**

**唯一标识：两条不同的 TCP 连接不能拥有 4 个完全相同的值（但不同连接的部分组件可以拥有相同的值）**

牢记这个概念，面试中可以避免踩很多坑。





TCP 的包是不包含 IP 地址信息的，那是 IP 层上的事，但是有源端口和目的端口。就是说，端口这一东西，是属于 TCP 知识范畴的。

我们知道两个进程，在计算机内部进行通信，可以有管道、内存共享、信号量、消息队列等方法。

而两个进程如果需要进行通讯最基本的一个前提是能够唯一的标识一个进程，在本地进程通讯中我们可以使用 **「PID(进程标识符)」** 来唯一标识一个进程。

但 PID 只在本地唯一，如果把两个进程放到了不同的两台计算机，然后他们要通信的话，PID 就不够用了，这样就需要另外一种手段了。

解决这个问题的方法就是在运输层使用 **「协议端口号 (protocol port number)」**，简称 **「端口 (port)」**.

我们知道 IP 层的 ip 地址可以唯一标识主机，而 TCP 层协议和端口号可以唯一标识主机的一个进程，这样我们可以利用：**「ip地址＋协议＋端口号」**唯一标示网络中的一个进程。

在一些场合，也把这种唯一标识的模式称为**「套接字 (Socket)」**。

这就是说，虽然通信的重点是应用进程，但我们只要把要传送的报文交到目的主机的某一个合适的端口，剩下的工作就由 TCP/UDP 传输层协议来完成了。



在TCP/UDP 传输层协议中，需要通过端口进行寻址，来识别同一计算机中同时通信的不同应用程序。

所以，传输层的「端口号」的作用，是为了区分同一个主机上不同应用程序的数据包。传输层有两个传输协议分别是 TCP 和 UDP，在内核中是两个完全独立的软件模块。

当主机收到数据包后，可以在 IP 包头的「协议号」字段知道该数据包是 TCP/UDP。

所以可以根据这个信息确定送给哪个模块（TCP/UDP）处理，送给 TCP/UDP 模块的报文根据「端口号」确定送给哪个应用程序处理。

因此， TCP/UDP 各自的端口号也相互独立，如 TCP 有一个 80 号端口，UDP 也可以有一个 80 号端口，二者并不冲突。







默认情况下，针对「多个 TCP 服务进程可以绑定同一个端口吗？」

这个问题的答案是：**如果两个 TCP 服务进程同时绑定的 IP 地址和端口都相同，那么执行 bind() 时候就会出错，错误是“Address already in use”**。

注意，如果 TCP 服务进程 A 绑定的地址是  0.0.0.0 和端口 8888，而如果 TCP 服务进程 B 绑定的地址是 192.168.1.100 地址（或者其他地址）和端口 8888，那么执行 bind() 时候也会出错。

这是因为 0.0.0.0  地址比较特殊，代表任意地址，意味着绑定了 0.0.0.0  地址，相当于把主机上的所有 IP 地址都绑定了。



### TCP 三次握手

为了实现可靠传输，发送方和接收方始终需要同步( SYNchronize )序号。 

需要注意的是， 序号并不是从 0 开始的， 而是由发送方随机选择的初始序列号 ( Initial Sequence Number, ISN )开始 。 

由于 TCP 是一个双向通信协议， 通信双方都有能力发送信息， 并接收响应。 因此， 通信双方都需要随机产生一个初始的序列号， 并且把这个起始值告诉对方。



所有 TCP 连接建立之前一开始都要经过三次握手，客户端与服务器在交换应用数据之前，必须就**起始分组序列号，以及其他一些连接相关的细节**达成一致。

**出于安全考虑，序列号由两端随机生成。**



- SYN 
  客户端选择一个随机序列号 x，并向服务端发送一个 SYN 分组，其中可能还包括其他 TCP标志和选项。

  client进入`SYN_SENT`状态，等待服务端确认。

  
  
- SYN ACK 
  服务器给 x 加 1，并选择自己的一个随机序列号 y，追加自己的标志和选项，然后返回响应。

  server进入`SYN_RCVD`状态。

  

- ACK 
  客户端给 x 和 y 加 1 并发送握手期间的最后一个 ACK 分组。





![1602948494101](assets/1602948494101.png)





三次握手带来的延迟使得每创建一个新 TCP 连接都要付出很大代价。而这也决定了提高 TCP 应用性能的关键，在于想办法重用连接。



##### 为什么tcp要用三次握手？

TCP 需要 seq 序列号来做可靠重传或接收，而避免连接复用时无法分辨出 seq 是延迟或者是旧链接的 seq，因此需要三次握手来约定确定双方的 ISN（初始 seq 序列号）。



**TCP 设计中一个基本设定就是，通过 TCP 连接发送的每一个包，都有一个 sequence number。而因为每个包都是有序列号的，所以都能被确认收到这些包。**

确认机制是累计的，所以一个对 sequence number X 的确认，意味着 X 序列号之前(不包括 X) 包都是被确认接收到的。

这条连接突然断开重连后，TCP 怎么样识别之前旧链接重发的包？——这就需要独一无二的 ISN（[初始序列号](https://www.zhihu.com/search?q=初始序列号&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A573627478})）机制。

- 当一个新连接建立时，`初始序列号（ initial sequence number ISN）生成器`会生成一个新的32位的 ISN。

https://www.zhihu.com/question/24853633/answer/573627478





#### TCP三次握手时延

------

1、请求新的 TCP 连接时，客户端要向服务器发送一个小的 TCP 分组（通常是 40 ～60 个字节）。这个分组中设置了一个特殊的 SYN 标记，说明这是一个连接请求。

2、如果服务器接受了连接，就会对一些连接参数进行计算，并向客户端回送一个TCP 分组，这个分组中的 SYN 和 ACK 标记都被置位，说明连接请求已被接受。

3、最后，客户端向服务器回送一条确认信息，通知它连接已成功建立。**现代的 TCP 栈都允许客户端在这个确认分组中发送数据。**



由于 HTTP 是在 TCP 连接上传输数据的。所以 TCP 的三次握手的时延，也是很大开销。所以性能优化要围绕以下几点展开：

- **客户端与服务器尽可能少的建立tcp连接。（要时刻牢记tcp的唯一标识）**
- **tcp连接建立之后，尽量做到复用**



### TCP流量控制

------

**什么是流量控制**

流量控制是一种预防发送端过多向接收端发送数据的机制。

一条 TCP 连接的每一侧主机都会为该连接设置了**接收缓存**。当该 TCP 连接收到正确、按序的字节后，它就将数据放入**接收缓存**。

相关应用进程会从该缓存中读取数据。事实上，接收方应用可能由于繁忙等原因，并没有马上读取。如果发送方的数据发的太快，很容易使得**接收缓存溢出**。



**为什么要流量控制**

**如果缓存区满了发送方还在疯狂着发送数据，接收方只能把收到的数据包丢掉，大量的丢包会极大着浪费网络资源，因此，我们需要控制发送方的发送速率，让接收方与发送方处于一种动态平衡才好。**

**对发送方发送速率的控制，我们称之为流量控制。**



**流量控制的实现**



TCP 是一个可靠的连接，对应具体的现象就是所有的 TCP 包正常通信过程中都是有一问一答的过程，如果异常情况，一定时间内没有收到这个回复的包，那么发送端就会重新发送，直到有回复。

**滑动窗口**

通信分别都维护了**发送缓冲区和接收冲区。称之为滑动窗口。**

由于TCP/IP支持全双工传输，因此通信的双方都拥有两个滑动窗口，一个用于接收数据，称之为接收窗口；一个用于发送数据，称之为拥塞窗口(即发送窗口)。指出接收窗口大小的通知我们称之为窗口通告。





为实现流量控制，TCP 连接中的数据的发送方要向对方通告自己的 **接收窗口**（rwnd）变量，用于表示接收能力，其中包含能够保存数据的缓冲区空间大小信息。



由于 TCP 是全双工通信，所以 TCP 连接的两端都要 向对方提供这个变量。接收端将此窗口值放在 TCP 报文的首部中的窗口字段，传送给发送端。



第一次建立连接时，两端都会使用自身系统的默认设置来发送 rwnd 。

浏览网页通常主要是从服务器向客户端下载数据，因此客户端窗口更可能成为瓶颈。

如果是在上传图片或视频，即客户端向服务器传送大量数据时，服务器的接收窗口又可能成为制约因素。



由于 TCP 是全双工通信，所以 TCP 连接的两端都要 向对方提供这个变量。

对于 CDN 服务器，initcwnd 的设置尤其重要。CDN服务器充当您的内容和用户之间的代理，具有两个角色：

- 服务器-响应用户的请求。

- 客户端-向原始服务器发出请求（在MISS缓存上）

  

![浏览器，CDN和原始服务器的交互以及TCP性能设置](https://www.cdnplanet.com/static/img/tcp-performance-tuning_2.png)



现在，当CDN充当*服务器*时，CDN上的 initcwnd 设置是确定新连接的第一段大小的重要因素。但是，当CDN充当*客户端*角色时，如果原始服务器的initcwnd高于CDN服务器的initrwnd，则CDN的广告接收窗口将成为瓶颈。

由于大多数 CDN 都无法保持与原始站点的长连接，因此高速缓存MISS两次启动缓慢！

   

### TCP慢启动

------



在网络实际的传输数据过程中，会出现拥塞的现象，网络上充斥着非常多的数据包，但是却不能按时被传送，形成网络拥塞，其实就是和平时的堵车一个性质了。

TCP 设计中也考虑到这一点，使用了一些算法来检测网络拥塞现象，如果拥塞产生，变会调整发送策略，减少数据包的发送来缓解网络的压力。

拥塞控制主要有四个算法：

- 慢启动
- 拥塞避免
- 拥塞发生时，快速重传
- 快速恢复

慢启动实现：

慢启动为发送方的 TCP 增加了一个窗口变量：拥塞窗口，记为 cwnd，初始化之后慢慢增加这个 cwnd 的值来提升速度。同时也引入了 ssthresh 门限值，如果 cwnd 达到这个值会让 cwnd 的增长变得平滑，算法如下：

1. 连接建好的开始先初始化cwnd = 1，表明可以传一个MSS大小的数据
2. 每当收到一个ACK，cwnd++; 呈线性上升
3. 每当过了一个RTT，cwnd = cwnd*2; 呈指数让升
4. 当cwnd >= ssthresh时，就会进入“拥塞避免算法”

简单来说，每成功接收一个分组，发送端就有了发送另外两个分组的权限。

如果某个 HTTP 事务有大量数据要发送，是不能一次将所有分组都发送出去的。必须发送一个分组，等待确认；然后可以发送两个分组，每个分组都必须被确认，这样就可以发送四个分组了，

以此类推。这种方式被称为“打开拥塞窗口”。

由于存在这种拥塞控制特性，所以新连接的传输速度会比已经交换过一定量数据的、“已调谐”的连接慢一些.



### 串行事务处理时延

假设有一个包含了 3 个嵌入图片的 Web 页面。浏览器需要发起 4 个 HTTP 事务来显示此页面：
1 个用于顶层的 HTML 页面，3 个用于嵌入的图片

如果每个事务都需要（串行地建立）一条新的连接，那么连接时延和慢启动时延就会叠加起来：



### 并行连接（多个TCP连接）

在 HTTP 1.x 中，如果客户端想发送多个并行的请求以及改进性能，那么必须使用多个 TCP 连接

并行连接，意思就是打开多个TCP连接，HTTP 允许客户端打开多条 TCP 连接，并行地执行多个 HTTP 事务。

包含嵌入对象的组合页面如果能（通过并行连接）克服单条连接的空载时间和带宽限制，加载速度也会有所提高。



在 HTTP 1.x 中，如果客户端想发送多个并行的请求以及改进性能，那么必须使用多个 TCP 连接。如果单条连接没有充分利用客户端的因特网带宽，可以将未用带宽分配来装载其他对象。

**即使并行连接的速度可能会更快，但并不一定总是更快。**客户端的网络带宽不足时，大部分的时间可能都是用来传送数据的。

在这种情况下，一个连接到速度较快服务器上的HTTP 事务就会很容易地耗尽所有可用的 Modem 带宽。

如果并行加载多个对象，每个对象都会去竞争这有限的带宽，每个对象都会以较慢的速度按比例加载，这样带来的性能提升就很小，甚至没什么提升。



**并行连接的问题**

- 每个事务都会打开 / 关闭一条新的连接，会耗费时间和带宽。 
- 由于 TCP 慢启动特性的存在，每条新连接的性能都会有所降低。 
- 可打开的并行连接数量实际上是有限的。 （浏览器并发请求限制）



### HTTP Pipelining 

HTTP/1.1 存在一个问题，单个 TCP 连接在同一时刻只能处理一个请求。典型的半双工通信。

意思是说：两个请求的生命周期不能重叠，任意两个 HTTP 请求从开始到结束的时间在同一个 TCP 连接里不能重叠。

例如：http1.1，对讲机，只能让一个人说一个人听

实现原理：

半双工传输模式采用载波侦听多路访问 /冲突检测。传统的共享型LAN以半双工模式运行 ，线路上容易发生传输冲突。

与集线器相连的节点（即多个节点连接到集线器，共享一条到交换机端口的连接）必须以半双工模式运行。因为这种节点必须能够冲突检测，类似于单车道桥梁。





正常的http一般实现都是连接完成后（tcp握手）发生request流向服务器，然后及进入等待，收到response后才算结束



 一个支持持久连接的客户端可以在一个TCP连接中发送多个请求（不需要等待任意请求的响应）。收到请求的服务器必须按照请求收到的顺序发送响应。

当然http1.1 即支持keep alive，完成一次收发后完全可以不关闭连接使用同一个链接发生下一个请求



一定要等到response到达后，客户端才能发起下一个request的，如果应用服务器需要时间处理，所有后面的请求都需要等待，即使不需要任何处理直接回复给客户端，请求，回复在网络上的时间也是必须完整的等下去，而且由于tcp传输本身的特性，速率是逐步上升的，这样断断续续的发送接收十分影响tcp迅速达到线路性能最大值。



### 持久连接（TCP长连接）

https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Connection_management_in_HTTP_1.x

持久连接就是 TCP 连接的重用，一个 Web 页面上的大部分内嵌图片通常都来自同一个 Web 站点，而且相当一部分指向其他对象的超链通常都指向同一个站点。

> 初始化了对某服务器 HTTP 请求的应用程序很可能会在不久的将来对那台服务器发起更多的请求，这种特性称为站点局部性（site locality）



在`HTTP/1.0`中，一个 http 请求收到服务器响应后，默认会断开对应的 TCP 连接。这样每次请求，都需要重新建立 TCP 连接，这样一直重复建立和断开的过程。简直就是灾难。

所以为了复用 TCP 连接。在 http/1.0 中规定了两个头部 Connection 和 keep-alive，可以设置头字段`Connection: keep-alive`。这是一个协商头部。

- 客户端可以通过包含 `Connection: Keep-Alive`请求头将一条 TCP 连接保持在打开状态。（客户端说，我想保持 TCP 长连接）

- 如果服务器愿意为了下一条 HTTP 请求，将 TCP 连接保持在打开状态，就在响应中包含相同的响应头部  `Connection: Keep-Alive` 。（服务器说，我支持 TCP 长连接）

- 这样 HTTP 请求完成后，就不会断开当前的 TCP 连接，后续的 HTTP 请求可以使用当前 TCP 连接进行通信。（这样，就维持了长连接）



在 chrome F12 中，点击一个 HTTP 事务，查看 timing 时，如果看到初始化连接和SSL开销消失了，说明使用的是同一个TCP连接。

如果响应头中没有 `Connection: Keep-Alive`，客户端就认为服务器不支持 keep-alive，会在发回响应报文之后主动关闭 TCP 连接。

`HTTP/1.1`将`Connection`写入了标准，默认值为`keep-alive`。除非强制设置为`Connection: close`，才会在请求后断开TCP连接。



> 
>
> 域名哈希技术
>
> 头条面试题一：
>
> 网页中的图片资源为什么分放在不同的域名下 ?  
>
> 比如知乎中的图片资源的URL通常是 https://pic1.zhimg.com/013926975_im.jpg ，与主站的域名不同。
>
> 一、
>
> 其实就是域名哈希技术（或者说域名分区）
>
> 由于浏览器针对同一个域名的并发请求是有限制的，Chrome是 6 个。
>
> 即在Chrome 中访问 zhihu.com 时，本地与 zhihu.com 同时最多只能有 6 个 TCP 连接。
>
> 浏览器对并发请求的数目限制是针对域名的，即针对同一域名（包括二级域名）在同一时间支持的并发请求数量的限制。
>
> 如果请求数目超出限制，则会阻塞。因此，网站中对一些静态资源，使用不同的一级域名，可以提升浏览器并行请求的数目，加速界面资源的获取速度。
>
> 但是，每个新主机也会有一次额外的 DNS 查询，也有更多的开销。
>
> 在实践中，可以用一个服务器托管资源，然后 cname 解析多个域名到同一台服务器。
>
> 由于浏览器的限制是对域名的限制，并没有对 IP 的限制，这样就可以突破限制。
>
> 但是这种域名分区并不是越多越好，很明显，如果一个客户端对服务器建立太多 TCP 连接，自然会过多消耗服务器资源。
>
> 
>
> 浏览针对同一个域名的并发请求限制到底是什么意思？







```shell

# Connection响应首部和Keep-Alive响应首部
# Keep-Alive 首部完全是可选的，但只有在提供 Connection: Keep-Alive 时才能使用它
# timeout  估计了服务器希望将连接保持在活跃状态的时间，这并不是一个承诺值。
# max      这并不是一个承诺值。
Connection: Keep-Alive
Keep-Alive: max=5, timeout=120
# 这个例子说明服务器最多还会为另外 5 个事务保持连接的打开状态，或者将打开状态保持到连接空闲了 2 分钟之后
```



**Keep-Alive 连接的限制和规则**

- 在 HTTP/1.0 中，keep-alive 并不是默认使用的。 客户端必须发送一个 Connection: Keep-Alive 请求首部来激活 keep-alive 连接。
- 发送了 Connection: close 请求首部之后，客户端就无法在那条连接上发送更多的请求了。
- HTTP/1.1 的代理必须能够分别管理与客户端和服务器的持久连接——每个持久连接都只适用于一跳传输。
- 哑代理，Keep-Alive首部是针对单条TCP链路的，逐跳首部只与一条特定的连接有关，不能被转发。
- 所以现代的代理在转发报文时，要去掉 Connection 和 Keep-Alived 首部
- 



在`HTTP/1.1`中，将`Connection`写入了标准，默认值为`keep-alive`。除非强制设置为`Connection: close`，才会在请求后断开TCP连接。



**事务执行结束之后保存打开状态的连接，叫持久连接。（实际上就是TCP的长连接）**

**长连接可能的问题**：

> **不小心就会累积出大量的空闲连接，耗费本地以及远程客户端和服务器上的资源。**
>
> **存活功能的探测周期太长**，还有就是它只是探测TCP连接的存活，属于比较斯文的做法，遇到恶意的连接时，保活功能就不够使了。
>
> 如果条件再允许就可以以客户端机器为颗粒度，限制每个客户端的最大长连接数，这样可以完全避免某个蛋疼的客户端连累后端服务。



**短连接**

> **短连接**对于服务器来说管理较为简单，存在的连接都是有用的连接，不需要额外的控制手段。
>
> 但如果客户**请求频繁**，将在**TCP的建立和关闭操作上浪费时间和带宽**。
>
> 长连接和短连接的产生在于client和server采取的关闭策略，具体的应用场景采用具体的策略，没有十全十美的选择，只有合适的选择。



在 HTTP/2 中，由于





### 管道化连接

在持久连接的基础上，管道化连接更进一步，客户端可以将大量请求放入队列中排队。



副作用是很重要的问题。如果在发送出一些请求数据之后，收到返回结果之前，连接关闭了，客户端就无法百分之百地确定服务器端实际激活了多少事务。

有些事务，比如 GET 一个静态的 HTML 页面，可以反复执行多次，也不会有什么变化。

而其他一些事务，比如向一个在线书店 POST 一张订单，就不能重复执行，不然会有下多张订单的危险。

#### **幂等事务**

如果一个事务，不管是执行一次还是很多次，得到的结果都相同，这个事务就是幂等的。



客户端不应该以管道化方式传送非幂等请求，否则，传输连接的过早终止就会造成一些不确定的后果。要发送一条非幂等请求，就需要等待来自前一条请求的响应状态。

大多数浏览器都会在重载一个缓存的 POST 响应时提供一个对话框，询问用户是否希望再次发起事务处理。





### 正常关闭连接

TCP 连接是双向的。TCP 连接的每一端都有一个输入队列和一个输出队列，用于数据的读或写。

放入一端输出队列中的数据最终会出现在另一端的输入队列中。

#### 完全关闭和半关闭

应用程序可以关闭 TCP 输入和输出信道中的任意一个，或者将两者都关闭了。套接字调用 close() 会将 TCP 连接的输入和输出信道都关闭了，这被称作“完全关闭”

还可以用套接字调用 shutdown() 单独关闭输入或输出信道。这被称为“半关闭”

关闭连接的输出信道总是很安全的。连接另一端的对等实体会在从其缓冲区中读出所有数据之后收到一条通知，说明流结束了，这样它就知道你将连接关闭了。

关闭连接的输入信道比较危险，除非你知道另一端不打算再发送其他数据了。

如果另一端向你已关闭的输入信道发送数据，操作系统就会向另一端的机器回送一条TCP “连接被对端重置” 的报文

**HTTP 规范建议，当客户端或服务器突然要关闭一条连接时，应该“正常地关闭传输连接”，**



> **
>
> 
>
> 
>
> 
>
> 
>
> 
>
> 
>
> 
>
> 
>
> 















## HTTP时延

与建立 TCP 连接，以及传输请求和响应报文的时间相比，事务处理时间可能是很短的。

**除非服务端或客户端超载有性能问题，否则 HTTP 时延就是由 TCP 网络时延构成的。**



1、域名解析。

2、建立TCP连接，TCP三次握手，四次断开。

3、客户端通过TCP管道发送HTTP请求报文。

4、服务器收到报文后，进行处理，生成响应报文。

5、通过TCP管道向客户端发送响应报文。

6、客户端浏览器收到报文，并解析渲染页面。



### TCP三次握手时延

------

1、请求新的 TCP 连接时，客户端要向服务器发送一个小的 TCP 分组（通常是 40 ～60 个字节）。这个分组中设置了一个特殊的 SYN 标记，说明这是一个连接请求。

2、如果服务器接受了连接，就会对一些连接参数进行计算，并向客户端回送一个TCP 分组，这个分组中的 SYN 和 ACK 标记都被置位，说明连接请求已被接受。

3、最后，客户端向服务器回送一条确认信息，通知它连接已成功建立。现代的 TCP 栈都允许客户端在这个确认分组中发送数据。



### 延时确认

------

由于因特网自身无法确保可靠的分组传输（因特网路由器超负荷的话，可以随意丢弃分组，IP协议是不可靠的），所以 TCP 实现了自己的确认机制来确保数据的成功传输。

> 每个 TCP 段都有一个序列号和数据完整性校验和。每个段的接收者收到完好的段时，都会向发送者回送小的确认分组。
>
> 如果发送者没有在指定的窗口时间内收到确认信息，发送者就认为分组已被破坏或损毁，并重发数据。



由于确认报文很小，所以 TCP 允许在发往相同方向的输出数据分组中对其进行“捎带”。TCP 将返回的确认信息与输出的数据分组结合在一起，可以更有效地利用网络。

为了增加确认报文找到同向传输数据分组的可能性，很多 TCP 栈都实现了一种“延迟确认”算法。即返回的确认分组先不发出去，在主机的TCP缓冲区中等待。

延迟确认算法会在一个特定的窗口时间（通常是 100 ～ 200 毫秒）内将输出确认存放在缓冲区中，以寻找能够捎带它的输出数据分组。

如果在那个时间段内没有输出数据分组，就将确认信息放在单独的分组中传送。



但是，HTTP 具有双峰特征的请求 - 应答行为降低了捎带信息的可能。当希望有相反方向回传分组的时候，偏偏没有那么多。通常，延迟确认算法会引入相当大的时延。根据所使用操作系统的不同，可以调整或禁止延迟确认算法。

在对 TCP 栈的任何参数进行修改之前，一定要对自己在做什么有清醒的认识。TCP中引入这些算法的目的是防止设计欠佳的应用程序对因特网造成破坏。

对 TCP 配置进行的任意修改，都要绝对确保应用程序不会引发这些算法所要避免的问题。





### TCP慢启动

------



在网络实际的传输过程中，会出现拥塞的现象，网络上充斥着非常多的数据包，但是却不能按时被传送，形成网络拥塞，其实就是和平时的堵车一个性质了。

TCP设计中也考虑到这一点，使用了一些算法来检测网络拥塞现象，如果拥塞产生，变会调整发送策略，减少数据包的发送来缓解网络的压力。

拥塞控制主要有四个算法：

- 慢启动
- 拥塞避免
- 拥塞发生时，快速重传
- 快速恢复

慢启动为发送方的TCP增加了一个窗口：拥塞窗口，记为 cwnd，，初始化之后慢慢增加这个 cwnd 的值来提升速度。同时也引入了 ssthresh 门限值，如果 cwnd 达到这个值会让 cwnd 的增长变得平滑，算法如下：

1. 连接建好的开始先初始化cwnd = 1，表明可以传一个MSS大小的数据

2. 每当收到一个ACK，cwnd++; 呈线性上升

3. 每当过了一个RTT，cwnd = cwnd*2; 呈指数让升

4. 当cwnd >= ssthresh时，就会进入“拥塞避免算法”

简单来说，每成功接收一个分组，发送端就有了发送另外两个分组的权限。

如果某个 HTTP 事务有大量数据要发送，是不能一次将所有分组都发送出去的。必须发送一个分组，等待确认；然后可以发送两个分组，每个分组都必须被确认，这样就可以发送四个分组了，

以此类推。这种方式被称为“打开拥塞窗口”。

由于存在这种拥塞控制特性，所以新连接的传输速度会比已经交换过一定量数据的、“已调谐”的连接慢一些.





### Nagle算法

TCP 有一个数据流接口，应用程序可以通过它将任意尺寸的数据放入 TCP 栈中——即使一次只放一个字节也可以！



每个 TCP 段中都至少装载了 40 个字节的标记和首部，所以如果 TCP 发送了大量包含少量数据的分组，网络的性能就会严重下降。

> 发送大量单字节分组的行为称为“发送端傻窗口综合症”。这种行为效率很低、违反社会道德，而且可能会影响其他的因特网流量。





## HTTP连接的处理



### connection首部



HTTP 允许在客户端和最终的源端服务器之间存在一串 HTTP 中间实体（代理，缓存等）

可以从客户端开始，逐跳地将 HTTP 报文经过这些中间设备，转发到源端服务器上去（或者进行反向传输）。



HTTP 应用程序收到一条带有 Connection 首部的报文时，接收端会解析发送端请求的所有选项，并将其应用。

然后会在将此报文转发给下一跳地址之前，删除Connection 首部以及 Connection 中列出的所有首部。





## 代理

代理就是帮助你（client）处理与服务器（server）连接请求的中间应用，我们称之为 proxy server。



根据不同网络协议层次，可以分为各种代理：



### 正向代理

对于 client，想要连上 server，如果这个中间过程你知道代理服务器的存在，那这就是正向代理（即这个过程是 client 主动的过程）。

在很多网络请求场景中，都可以使用正向代理：



- 比如我们在 Chrome 上配置 SwitchOmega 工具来使用代理，设置一系列代理规则，可以先将请求发到代理服务器，由代理服务器再去发送请求。 

- 比如我们在一些开发工具（比如 jetbrains idea）中，配置 proxy 来设置代理服务器。

- 比如我们在 ssh 或者一些网络应用的命令行工具时，也可以使用代理选项来使用代理服务器。 
- 本地设备和服务器之间的通信有可能因为某些不可控因素被切断。我们可以采用“曲线”的方式，让一个第三方的服务器来做接力，从而连接目标服务器。 代理服务器可以绕过许多基于 IP 地址的限制。例如某视频网站只允许日本的 IP 访问，那么可以借助一台在日本的代理服务器，来让视频网站误以为访问者是一台身在日本的电脑。





### 反向代理

对于 client，直接访问当目标服务器 server（proxy）。但目标服务器 server 可能会将请求转发到其它应用服务器 server（app）（即这个过程是 server 主动的过程）。

代理过程其对用户是透明的，如用户去访问 example.com，他并不知道该网站背后发生了什么事，一个 API 请求被转发到哪台服务器。

比如我们常用的 nginx，openresty 等软件。用于实现负载均衡和高可用。



### HTTP代理

HTTP 代理其实分两种，一种是反向代理，比如 nico 和 nginx 就是这种，这里不展这种代理。

另一种是隧道代理，咱们主要展开下这种代理，它能代理任何基于 TCP 的内容，这里注意有个误区，很多人以为 HTTP 代理只能代理 http:// 内容，其实也可以代理 https:// 以及任何基于  TCP 的内容，但是不能代理 UDP 内容，等会展开下就知道为什么不能代理 UDP 内容了。

Web 隧道允许用户通过 HTTP 连接发送非 HTTP 流量，这样就可以在 HTTP 上捎带其他协议数据了。

使用 Web 隧道最常见的原因就是要在 HTTP 连接中嵌入非 HTTP 流量，这样，这类流量就可以穿过只允许 Web 流量通过的防火墙了。

HTTP 隧道的一种常见用途是通过 HTTP 连接承载加密的安全套接字层（SSL，Secure Sockets Layer）流量，这样 SSL 流量就可以穿过只允许 Web 流量通过的防火墙了。

Web 隧道是用 HTTP 的 CONNECT 方法建立起来的。CONNECT 方法并不是 HTTP/1.1 核心规范的一部分，但却是一种得到广泛应用的扩展。

CONNECT 方法请求隧道网关创建一条到达任意目的服务器和端口的 TCP 连接，并对客户端和服务器之间的后继数据进行盲转发。



假设有一个 HTTP Proxy Server

```
1.2.3.4:8010
```

某客户端想代理的地址

```
google.com:443
```

咱们分配一下角色，这里某客户端可能是 Chrome 浏览器，也可能是 curl 命令。而 HTTP Proxy Server 就是服务端。

客户端和服务端的交互如下:

第一步：客户端 -> 服务端，发送要代理的地址

```
CONNECT google.com:443 HTTP/1.1
```

第二步：服务端 -> 客户端，响应结果

```
HTTP/1.1 200 Connection established
```

然后隧道就建立了，客户端和服务端就可以通过这个隧道互相传输内容了。

**问题一：域名在哪儿里解析** 被代理的地址是由客户端传递给服务端的，客户端如果传递的是域名地址，那么域名将在服务端解析，当然也有可能客户端在本地预先解析出来域名的 IP，然后传递给服务端 IP 地址。所以域名在哪里解析，完全取决于最起初发起请求的客户端这个角色。

**问题二：不能代理 UDP 内容** 如 前面看到的交互步骤，整个交互内容并没有区分 TCP 或 UDP 的字段，对吧？所以其只能代理 TCP 内容。当然有同学会说，在服务端强制当做 UDP 内容来处理不就行了，那其实就变成另外一种代理协议了。

**问题三：传输内容没有加密** 这个其实是相对于 HTTP Proxy Server 来说的，它收到内容后并没有二次加工。当然客户端如果要求的代理的内容是 HTTPS  内容，内容已经在客户端进行 TLS 加密了，所以再次强调，这个其实是相对于 HTTP Proxy Server 来讲，即 HTTP  代理是一个非加密代理协议。



### Socks 5 代理

Socks 5 代理。它能代理任何基于 TCP 的内容，也能代理 UDP 内容。但其实很多 Socks 5 代理服务端并没有实现 UDP 的支持。

> Socks 是一种互联网协议，它通过一个代理服务器在客户端和服务端之间交换数据。简单来说，它就是一种代理协议，扮演一个中间人的角色，在客户端和目标主机之间转发数据。 https://luyuhuang.tech/2020/08/27/rfc1928.html

尽管市场上还有其他类型的代理，但是SOCKS和HTTPS代理是市场上的主要代理，顶级代理提供商也对此提供了支持。

HTTPS是HTTP的安全和改进版本，而SOCKS5是SOCK协议的安全性增强版本。

当你不使用代理时，你发送给网站的请求会直接进入网站。但是当你使用代理时，情况就不同了。

当你发送一个请求时，它首先会转到代理服务器，由代理服务器修改它(如果需要用另一个IP地址替换你的真实IP地址)，然后发送请求到你的请求网站。之后，响应又被发送到代理，再由代理将响应返回给你。

代理允许你你从以前没有访问过的位置访问Internet，并访问它们的本地数据。

虽然它有很多好处，但毫无疑问，它也有自己的缺点。由于代理服务器可以访问通过它们发送的信息，它们反过来也可以改变数据，在某些情况下，成为实现互联网审查的模式。

有时出于个人隐私的原因（或者其他原因），我们希望隐藏自己的IP，让http服务器无法记录我们访问过它，这时我们可以使用代理服务器。

代理服务器(Proxy Server)是工作在浏览器与http服务器之间的一个服务应用，所有经过代理服务器的http请求，都会被转发到对应的http服务器上。

当然，除了http可以使用代理外，https、ftp、RTSP、pop3等协议同样可以使用代理访问，不过本文介绍的是支持http、https协议访问的代理。

linux curl命令可以使用下面参数设置http(s)代理、socks代理，已经设置它们的用户名、密码以及认证方式：







### HTTP 代理和 Socks 5 代理的应用场景

在很久以前，互联网对加密还不太重视，那个时候，大家在远端搭建一个 HTTP 代理或 Socks5 代理，然后在本地应用上配置上远端的代理地址，就这么很快乐的用着。 然而某天人们觉醒了，我本地通过这两个代理协议向远端发送的数据没有加密，这样岂不是路上的人们都可以看到我传输的数据。这有点不快乐。

所以比如强加密无特征协议的 brook 协议诞生了。 因为经过远古时代的发展，很多应用比如 Chrome 浏览器，都支持配置 Socks 5 Server，所以像 Brook 客户端的 Proxy  模式，会在本地建立一个 Socks 5 Server，这也意味着 HTTP 代理和 Socks 5  代理的应用场景基本上从以前的远端运行模式过渡到本地运行模式。



### 代理软件的部署

**常用代理软件**

<https://github.com/elazarl/goproxy>

https://www.cnblogs.com/bluestorm/p/9032086.html



#### 出口代理

可以将代理固定在本地网络或者本地计算机的出口点，以便控制本地网络与大型因特网之间的流量。

比如在电脑的浏览器上配置代理规则。

**客户端代理**

- 手工配置浏览器

  只能为所有内容指定唯一的一个代理服务器

- 配置PAC代理

  提供一个 URI，指向一个用 JavaScript 语言编写的代理自动配置文件；客户端会取回这个 JavaScript 文件，并运行它以决定是否应该使用代理

  PAC 文件的后缀通常是 .pac，MIME 类型通常是 application/x-ns-proxy-autoconfig

  每个 PAC 文件都必须定义一个名为 FindProxyForURL(url,host) 的函数，用来计算访问 URI 时使用的适当的代理服务器

  ```javascript
  // 根据url的scheme不同使用不同的代理
  function FindProxyForURL(url, host) {
      if (url.substring(0, 5) == "http:") {
          return "PROXY http-proxy.mydomain.com:8080";
      } else if (url.substring(0, 4) == "ftp:") {
          return "PROXY ftp-proxy.mydomain.com:8080";
      } else {
          return "DIRECT";
      }
  }
  ```








#### 透明代理

网络基础设施可以通过若干种技术手段，在客户端不知道，或没有参与的情况下，拦截网络流量并将其导入代理。

这种拦截通常都依赖于监视 HTTP 流量的交换设备及路由设备，在客户端毫不知情的情况下，对其进行拦截，并将流量导入一个代理。

比如常用的软路由，在网关处设置代理等等。





### 代理相关的首部

#### VIA首部

Via 首部字段列出了与报文途经的每个中间节点（代理或网关）有关的信息。

报文每经过一个节点，都必须将这个中间节点添加到 Via 列表的末尾。

代理也可以用 Via 首部来检测网络中的路由循环。代理应该在发送一条请求之前，在 Via 首部插入一个与其自身有关的独特字符串，并在输入的请求中查找这个字符串，以检测网络中是否存在路由循环。

请求和响应报文都会经过代理进行传输，因此，请求和响应报文中都要有 Via首部

请求和响应通常都是通过同一条 TCP 连接传送的，所以响应报文会沿着与请求报文相同的路径回传

如果一条请求报文经过了代理 A、B 和 C，相应的响应报文就会通过代理 C、B、A 进行传输。因此，响应的 Via 首部基本上总是与请求的 Via 首部相反

```
# 报文流经了两个代理,第一个代理名为 proxy-62.irenes-isp.net ，它实现了 HTTP/1.1 协议.第二个代理名为 cache.joes-hardware.com
Via: 1.1 proxy-62.irenes-isp.net, 1.0 cache.joes-hardware.com
```



### 追踪报文



代理服务器可以在转发报文时对其进行修改。可以添加、修改或删除首部，也可以将主体部分转换成不同的格式。

代理变得越来越复杂，开发代理产品的厂商也越来越多，互操作性问题也开始逐渐显现。

通过 HTTP/1.1 的 TRACE 方法，用户可以跟踪经代理链传输的请求报文，观察报文经过了哪些代理，以及每个代理是如何对请求报文进行修改的。

当 TRACE 请求到达目的服务器时，整条请求报文都会被封装在一条 HTTP 响应的主体中回送给发送端。

```
# 请求报文
TRACE /index.html HTTP/1.1
Host: www.joes-hardware.com
Accept: text/html


# 响应头部
HTTP/1.1 200 OK
Content-Type: message/http
Content-Length: 269
Via: 1.1 cache.joes-hardware.com, 1.1 p1127.att.net, 1.1 proxy.irenes-isp.net

# 响应主体
TRACE /index.html HTTP/1.1
Host: www.joes-hardware.com
Accept: text/html
Via: 1.1 proxy.irenes-isp.net, 1.1 p1127.att.net, 1.1 cache.joes-hardware.com
X-Magic-CDN-Thingy: 134-AF-0003
Cookie: access-isp="Irene's ISP, California"
Client-ip: 209.134.49.32
```







### 代理认证



### 代理的互操作性

客户端、服务器和代理是由不同厂商构建的，实现的是不同版本的 HTTP 规范

它们支持的特性各不相同，也存在着不同的问题。



#### Allow首部

通过 HTTP OPTIONS 方法，客户端（或代理）可以发现 Web 服务器或者其上某个特定资源所支持的功能





## TLS代理



代理分为转发代理（Forwarding proxies）和TLS终止代理（TLS terminating proxies）

 

- 转发代理只转发数据包，却看不到加密的有效内容。
- TLS终止代理，代理程序会解开TLS数据包来查看有效载荷，burp采用的就是这种代理







## 缓存



当 Web 请求抵达缓存时，如果 "本地" 有 "已缓存" 的副本，就可以从本地存储设备而不是原始服务器中提取这个文档。（并不一定是本地计算机）

缓存是 Web 性能优化的一个很重要的优化手段。



缓存是一种保存资源副本并在下次请求时直接使用该副本的技术。当 web 缓存发现请求的资源已经被存储，它会拦截请求，返回该资源的拷贝，而不会去源服务器重新下载。

这样带来的好处有：**缓解服务器端压力，提升性能(获取资源的耗时更短了)。对于网站来说，缓存是达到高性能的重要组成部分。**

缓存需要合理配置，因为并不是所有资源都是永久不变的：重要的是对一个资源的缓存应截止到其下一次发生改变（即不能缓存过期的资源）。





### 缓存操作的目标



虽然 HTTP 缓存不是必须的，但重用缓存的资源通常是必要的。然而常见的 HTTP 缓存只能存储 [`GET`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/GET) 响应，对于其他类型的响应则无能为力。

缓存的关键主要包括 request method 和目标 URI（一般只有GET请求才会被缓存）。



 

Web 缓存的分类：服务器缓存(代理服务器缓存、CDN 缓存)，第三方缓存，浏览器缓存等。

缓存的种类有很多,其大致可归为两类：私有与共享缓存。共享缓存存储的响应能够被多个用户使用。私有缓存只能用于单独用户。

- 私有缓存（浏览器缓存）
- 共享缓存（CDN缓存，反向代理缓存，负载均衡器缓存，网关缓存）





### 缓存的新鲜度检测

理论上来讲，当一个资源被缓存存储后，该资源应该可以被永久存储在缓存中。

由于缓存只有有限的空间用于存储资源副本，所以缓存会定期地将一些副本删除（不可能无限缓存），这个过程叫做**缓存驱逐**。



另一方面，当服务器上面的资源进行了更新，那么缓存中的对应资源也应该被更新，由于HTTP是C/S模式的协议，服务器更新一个资源时，不可能直接通知客户端（CDN或者其他缓存）更新缓存内容。





缓存对缓存的副本进行再验证时，会向原始服务器发送一个小的再验证请求。如果内容没有变化，服务器会以一个小的 304 Not Modified 进行响应。

只要缓存知道副本仍然有效，就会再次将副本标识为暂时新鲜的，并将副本提供给客户端，这称为 **再验证命中** 。



**缓存命中和未命中**

当请求到达缓存时，会在缓存中检查资源是否存在，如果存在，则直接返回，称为**缓存命中**，如果不存在，则继续向下游服务器请求资源，称为**缓存未命中**。



HTML5 中引入了应用程序缓存，这意味着 web 应用可进行缓存，并可在没有因特网连接时进行访问。

- 离线浏览 - 用户可在应用离线时使用它们
- 速度 - 已缓存资源加载得更快
- 减少服务器负载 - 浏览器将只从服务器下载更新过或更改过的资源。

目前基本上所有的浏览器都支持 HTML5 缓存技术。不过这项技术已经从 WEB 标准中废除，基本上可以不用了解。




大部分缓存只有在客户端发起请求，并且副本旧得足以需要检测的时候，才会对副本进行再验证。





#### Cache-Control 首部（强缓存）

cache-control 首部是 HTTP1.1 引入的首部，请求头和响应头都支持这个属性。通过它提供的不同的值来定义缓存策略。

**请求时的缓存指令**包括: no-cache、no-store、max-age、 max-stale、min-fresh、only-if-cached等。
**响应消息中的指令**包括: public、private、no-cache、no- store、no-transform、must-revalidate、proxy-revalidate、max-age。



**没有缓存**

```html
Cache-Control: no-store
```

缓存中不得存储任何关于客户端请求和服务端响应的内容。每次由客户端发起的请求都会下载完整的响应内容。

（）





**缓存但重新验证**

```html
Cache-Control: no-cache
```

每次有请求发出时，缓存会将此请求发到服务器。（这个请求应该要带有与本地缓存验证的字段）

服务器端会验证请求中所描述的缓存是否过期，若未过期（注：实际就是返回304），则缓存才使用本地缓存副本。





**缓存过期**

```html
Cache-Control: max-age=31536000
```

Cache-Control:max-age  其中 max-age 指定了文档的最大使用期限。最大的合法生存时间为 484200 秒 。

针对应用中那些不会改变的文件，通常可以手动设置一定的时长以保证缓存有效，例如图片、css、js等静态资源。

Cache-Control: max-age=0 服务器可以请求缓存不缓存文档，让每次访问都请求到服务器上。

相对[Expires](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Expires)而言，max-age是距离请求发起的时间的秒数。即这个缓存有效时间是相对上一次访问的时间。







**私有和公共缓存**

```html
Cache-Control: private
Cache-Control: public
```

"public" 指令表示该响应可以被任何中间人（注：比如中间代理、CDN等）缓存。

若指定了"public"，则一些通常不被中间人缓存的页面（译者注：因为默认是private）（比如 带有HTTP验证信息（帐号密码）的页面 或 某些特定状态码的页面），将会被其缓存。

 "private" 则表示该响应是专用于某单个用户的，中间人不能缓存此响应，该响应只能应用于浏览器私有缓存中。









#### Expires 首部（强缓存机制）

- **值**：是一个GMT时间格式的绝对时间，`Expires` 的日期时间必须是格林威治时间（GMT），而不是本地时间。举例：`Expires: Fri, 30 Oct 1998 14:19:41`

- **作用**：告诉缓存器相关副本在多长时间内是新鲜的。过了这个时间，缓存器就会向源服务器发送请求，检查文档是否被修改。

- **兼容性**：几乎所有的缓存服务器都支持 `Expires`（过期时间）属性

  **规则**：基于客户最后查看副本的时间（最后访问时间）或者根据服务器上文档最后被修改的时间

  应用

  - 对于设置静态图片文件（例如导航栏和图片按钮）缓存特别有用；因为这些图片修改很少，你可以给它们设置一个特别长的过期时间，这会使你的网站对用户变得相应非常快。
  - 对于控制有规律改变的网页也很有用，例如：你每天早上6点更新新闻页，你可以设置副本的过期时间也是这个时间，这样缓存服务器就知道什么时候去取一个更新版本，而不必让用户去按浏览器的"刷新"按钮。
  - 过期时间头信息属性值只能是HTTP格式的日期时间，其他的都会被解析成当前时间"之前"，副本会过期

  局限性

  虽然过期时间属性非常有用，但是它还是有些局限， 

  - 首先：是牵扯到了日期，这样Web服务器的时间和缓存服务器的时间必须是同步的，如果有些不同步，要么是应该缓存的内容提前过期了，要么是过期结果没及时更新。
  - 如果你设置的过期时间是一个固定的时间，如果你返回内容的时候又没有连带更新下次过期的时间，那么之后所有访问请求都会被发送给源Web服务器，反而增加了负载和响应时间

  

#### If-Modified-Since 首部

If-Modified-Since 是一个请求头部，他用于指定内容修改时间。

将这个首部添加到 GET 请求中去，If-Modified-Since:Date 

- 如果自指定日期后，文档被修改了，通常 GET 就会成功执行，携带新首部的新文档会被返回给缓存，新首部中包含了新的过期时间。
- 如果自指定日期后，文档没被修改过，条件就为假，



#### If-None-Match 首部

If-None-Match 是一个请求头部，用于指定请求文档的版本号。

```
If-None-Match: W/"43cd67b71ec96ce713c66db2315e23cf"
```

当缓存向原始服务器请求时，就会检查这个版本号，响应报文中的 etag 就是资源的版本号。



#### Last-Modified 首部

If-Modified-Since 首部可以与 Last-Modified 服务器响应首部配合工作。

原始服务器会将最后的修改日期附加到所提供的文档上去。







### Memory Cache 

https://help.aliyun.com/knowledge_detail/40077.html

我们用 chrome 访问很多页面时，如果刷新页面，F12 后可以看到，有些 HTTP 资源状态码是 200 。size 是 memory cache 。

Memory Cache 也就是内存中的缓存，主要包含的是当前中页面中已经抓取到的资源，例如页面上已经下载的样式、脚本、图片，字体等。

读取内存中的数据肯定比磁盘快，内存缓存虽然读取高效，可是缓存持续性很短，会随着进程的释放而释放。 **一旦我们关闭 Tab 页面，内存中的缓存也就被释放了**。



**那么既然内存缓存这么高效，我们是不是能让数据都存放在内存中呢？**

这是不可能的。计算机中的内存一定比硬盘容量小得多，操作系统需要精打细算内存的使用，所以能让我们使用的内存必然不多。

当我们访问过页面以后，再次刷新页面，可以发现很多数据都来自于内存缓存（memory cache）。

内存缓存中有一块重要的缓存资源是 preloader 相关指令（例如`<link rel="prefetch">`）下载的资源。

众所周知 preloader 的相关指令已经是页面优化的常见手段之一，它可以一边解析 js/css 文件，一边网络请求下一个资源。

需要注意的事情是，**内存缓存在缓存资源时并不关心返回资源的HTTP缓存头Cache-Control是什么值，同时资源的匹配也并非仅仅是对 URL 做匹配，还可能会对 Content-Type，CORS 等其他特征做校验**。



![1607884065215](assets/1607884065215.png)





![1607884224020](assets/1607884224020.png)





![1607884512892](assets/1607884512892.png)



Like their names said:

"Memory Cache" stores and loads resources to and from Memory (RAM). So this is much faster but it is non-persistent. Content is available until you close the Browser.

"Disk Cache" is persistent. Cached resources are stored and loaded to and from disk.

Simple Test: Open Chrome Developper Tools / Network. Reload a page multiple times. The table column "Size" will tell you that some files are loaded "from memory cache". Now close the browser, open Developper Tools / Network again and load that page again. All cached files are loaded "from disk cache" now, because your memory cache is empty.





https://www.jianshu.com/p/54cc04190252

前端性能优化之资源预加载

https://blog.csdn.net/deaidai/article/details/86486496

Nginx 下关于缓存控制字段cache-control的配置说明

https://www.cnblogs.com/kevingrace/p/10459429.html



# HTTP演进历史



## HTTP/0.9 1991年

最初的 HTTP 协议并没有版本号，0.9 实际上是为了跟后续的 1.0 版本作区分。总的来说 0.9 版本十分简陋，功能单一。

它只有一个方法（GET），没有首部，其设计目标也无非是获取 HTML （也就是说没有图片，只有文本）。

特点：

- 只支持 GET 请求，在其后面跟上目标资源的路径

- 没有 HTTP 头部

**不足：**

- **因为没有 HTTP 头部，所以除了文本类型无法区分和传输其他类型**

- **没有状态码和错误码，一旦出现问题，只能返回一个固定的错误页面**





## HTTP/1.0 1996年

 RFC 1945

在 0.9 基础上做了扩展，支持传输更多类型的内容。

特点：

- 在请求中明确了版本号

- 增加响应状态码

- 增加 HTTP 头，使传输资源更加灵活，如：

- - Content-type：通过指定不同的 MIME type，表明资源的格式，如 text/html、text/css、image/png、application/javascript、application/octet-stream 等
  - Accept-Encoding / Content-Encoding：表明客户端支持的压缩类型和响应中使用的压缩类型

**不足：**

- **每个 TCP 连接只能发送一个请求，造成了连接效率低下。后续在请求和响应头中增加了一个非标准的 Connection: keep-alive，告知双方请求可以复用同一条 TCP 连接而不是每次请求响应后都关闭连接。**

  **不过由于不是标准字段，不同实现的行为可能不一致，因此没有从根本上解决。**



## HTTP/1.1 1997年

 [RFC 2068](https://datatracker.ietf.org/doc/html/rfc2068)

在 1997 年初，HTTP1.1 标准发布。HTTP/1.1 消除了大量歧义内容并引入了多项改进

特点：

- 持久连接复用成为默认，不需要声明 Connection: keep-alive，想要关闭可以在响应中增加 Connection: close 声明

- pipelining 管道，可以一次性发送多个请求，避免了此前一次只能发送一个请求的情况，不过响应需要按照发送的顺序来回复。

- 增加几种 HTTP 方法

- 增加分块传输的流模式，响应头携带 Transfer-Encoding:chunked 并在每一个分块增加 Content-Length 表明当前块长度，并在所有内容传输完成的最后追加一个 Content-Length:0 表明传输完成。

- 增加 range 、Content-Range 相关头，用来支持续传和分段请求。



**不足：**

- **存在 `Head of line blocking` 队头阻塞问题，即同一个连接中有一个请求阻塞了，后续所有请求都将被阻塞。**



| HTTP/1.0问题                          | HTTP/1.1改进                                                 |      |
| ------------------------------------- | ------------------------------------------------------------ | ---- |
| 不能让多个请求共用一个连接            | 默认支持持久连接(keep-alive)，管道化(pipelining)特性允许客户端在一次TCP连接中发送所有的请求，这对于提升性能和效率而言意义重大 |      |
| 缺少强制的 Host 首部                  | 强制要求客户端提供 Host 首部，让虚拟主机托管（在一个 IP 上提供多个 Web 服务主机域名）成为可能 |      |
| 缓存控制相当简陋                      | 扩展缓存相关首部以增强缓存控制，增加Range请求以支持断点续传，增加Upgrade 首部以支持升级到其它协议比如WebSocket |      |
| 仅支持基本的GET、POST 和 HEAD请求方法 | 增加了OPTIONS、PUT、PATCH、DELETE、TRACE 和 CONNECT 等六种请求方法，扩展了功能 |      |





| HTTP/1.1问题                          | HTTP/2改进                                                   |      |
| ------------------------------------- | ------------------------------------------------------------ | ---- |
| HTTP/1.1 的队头阻塞                   | 默认支持持久连接(keep-alive)，管道化(pipelining)特性允许客户端在一次TCP连接中发送所有的请求，这对于提升性能和效率而言意义重大 |      |
| 缺少强制的 Host 首部                  | 强制要求客户端提供 Host 首部，让虚拟主机托管（在一个 IP 上提供多个 Web 服务主机域名）成为可能 |      |
| 缓存控制相当简陋                      | 扩展缓存相关首部以增强缓存控制，增加Range请求以支持断点续传，增加Upgrade 首部以支持升级到其它协议比如WebSocket |      |
| 仅支持基本的GET、POST 和 HEAD请求方法 | 增加了OPTIONS、PUT、PATCH、DELETE、TRACE 和 CONNECT 等六种请求方法，扩展了功能 |      |





**HTTP/1.1 的队头阻塞**

HTTP是基于“请求—应答”模型的，在这个模型的基础上，HTTP规定报文必须是一发一收的，这就形成了一个先进先出的串行队列，如果你不知道什么是队列的话。

既然是队列，就存在一个这样的问题，队列里的请求没有优先级，谁先进来谁就先出去。但是假如某一个排在前面的请求卡住了，没有返回，那后面的所有队列中的请求都要等着那个卡住的请求结束，结果就是我分担了本来不应该由我来承担的时间损耗。

那要怎么解决这个问题呢？诶？你不是说这个问题是解决不了的么？

嗯……从规范上，从设计上来说确实无法解决，既然是队列就必然是这样的，但是上有政策下有对策，我大不了多开几个域名呗，多开几个队列，让它堵的可能性小点，你是不是想到了啥？嗯，就是我们上面说到的“**域名分片**”技术。

在HTTP/1.1中，也曾试图通过“**管线化**” 的技术来解决队头阻塞的问题，管线化就是指将多个HTTP请求整批发送给服务器的技术，虽然可以整批发送，但是服务器还是要按照队列的顺序返回结果



其实很好理解，就好像我们在一个汽车在单车道上跑，堵车的可能性就很大，堵车了我也没办法，只能等前面解决了继续走，但是假设我是6车道，18车道，是不是就能在一定程度上解决这个问题了

（其实用车道比喻HTTP的队头阻塞并不是十分恰当，比喻TCP的队头阻塞更恰当一点，但是这样好理解）。





基于这样的思路，HTTP/2针对队头阻塞的问题提出了**多路复用**的解决方案。什么意思呢，HTTP/2实现了资源的并行请求，也就是你在任何时候都可以发送请求，不用管前一个请求是否堵塞，服务器会在处理好数据后就返回给你。



TCP 是面向连接的、可靠的流协议，其为上层应用提供了可靠的传输，保证将数据有序并且准确地发送至接收端。为了做到这一点，TCP采用了“顺序控制”和“重发控制”机制，另外还使用“流量控制”和“拥塞控制”来提高网络利用率。

应用层（如HTTP）发送的数据会先传递给传输层（TCP），TCP 收到数据后并不会直接发送，而是先把数据切割成 MSS 大小的包，再按窗口大小将多个包丢给网络层（IP 协议）处理。

​		IP 层的作用是“实现终端节点之间的通信”，并不保证数据的可靠性和有序性，所以接收端可能会先收到窗口末端的数据，这个时候 TCP 是不会向上层应用交付数据的，它得等到前面的数据都接收到了才向上交付，所以这就出现了队头阻塞，即队头的包如果发生延迟或者丢失，队尾必须等待发送端重新发送并接收到数据后才会一起向上交付。 

即：如果一个 TCP 包丢失，所有后续的包都需要等待它的重传，即使它们包含来自不同流的无关联数据。

当然 TCP 有快重传和快恢复机制，一旦收到失序的报文段就立即发出重复确认，并且接收端在连续收到三个重复确认时，就会把慢开始门限减半，然后执行拥塞避免算法，以快速重发丢失的报文。





## HTTP/2 2015年

2012 年初，HTTP 工作组（IETF 工作组中负责 HTTP 规范的小组）启动了开发下一个 HTTP 版本的工作。

其纲领的关键部分阐述了工作组对新协议的一些期望：

- 相比于使用 TCP 的 HTTP/1.1，最终用户可感知的多数延迟都有能够量化的显著改善；
- 解决 HTTP 中的队头阻塞问题；
- 并行的实现机制不依赖与服务器建立多个连接，从而提升 TCP 连接的利用率，特别是在拥塞控制方面；



最终，RFC 7540 在 2015 年 5 月 14 日发布了，HTTP/2 成为正式协议。

# HTTP2 

HTTP/2 ， 简称 h2 ，是 WWW 所使用的 HTTP 协议的一个重大修订版本。其目的是提升加载 WEB 内容时的感知性能。

自 1999 年 HTTP/1.1 通过以来，Web 发生了天翻地覆的变化。最早大小只有几千字节、包含资源只有个位数，主要基于文本的网页。如今已经发展成平均大小超过2MB，包含资源数平均数为140的富媒体网站。

现代Web应用，[HTTP Archive](http://httparchive.org/) 这个网站项目一直在抓取世界上是热门的网站（Alexa 前 100 万名中的 30 多万名），记录、聚合并分析每个网站使用的资源、内容类型、首部及其他元数据的数量。

Web 应用每次访问都需要走一遍“安装过程”——下载资源、构建 DOM 和 CSSOM、运行 JavaScript。上百个资源、成兆字节的数据、数十个不同的主机，所有这些都必须在短短几百 ms 内亲密接触一次，才能带来即刻呈现的 Web 体验。



> 速度是一种功能，而非简单的为了速度而速度。谷歌、微软和亚马逊的研究都表明，性能可以直接转换成收入。比如，Bing 搜索网页时延迟 2000 ms 会导致每用户收入减少 4.3%。
>
> 网络越快，PV 越多，黏性越强，转化率越高







HTTP/2 可以让我们的应用更快、更简单、更稳定 - 这几词凑到一块是很罕见的！

HTTP/2 将很多以前我们在应用中针对 HTTP/1.1 想出来的“歪招儿”一笔勾销，把解决那些问题的方案内置在了传输层中。 不仅如此，它还为我们进一步优化应用和提升性能提供了全新的机会！

HTTP/2 的主要目标是通过支持完整的请求与响应复用来减少延迟，通过有效压缩 HTTP 标头字段将协议开销降至最低，同时增加对请求优先级和服务器推送的支持。 

为达成这些目标，HTTP/2 还给我们带来了大量其他协议层面的辅助实现，例如新的流控制、错误处理和升级机制。

上述几种机制虽然不是全部，但却是最重要的，每一位网络开发者都应该理解并在自己的应用中加以利用。



**HTTP/2 没有改动 HTTP 的应用语义。 HTTP 方法、状态代码、URI 和标头字段等核心概念一如往常，这一点是非常重要的，可以理解为是向下兼容的。** 

不过，HTTP/2 修改了数据格式化（分帧）以及在客户端与服务器间传输的方式。这两点统帅全局，通过新的分帧层向我们的应用隐藏了所有复杂性。 因此，所有现有的应用都可以不必修改而在新协议下运行。

**HTTP 2.0 性能增强的核心，全在于新增的二进制分帧层，它定义了如何封装 HTTP 消息并在客户端与服务器之间传输。**





HTTP 2.0 的主要目标是改进传输性能，实现低延迟和高吞吐量。主版本号的增加听起来像是要做大的改进，从性能角度说的确如此。

但从另一方面看，HTTP 的高层协议语义并不会因为这次版本升级而受影响。所有 HTTP 首部、值，以及它们的使用场景都不会变。

HTTP/2主要基于SPDY协议，通过对HTTP头字段进行数据压缩、对数据传输采用多路复用和增加服务端推送等举措，来减少网络延迟，提高客户端的页面加载速度。

**HTTP/2没有改动HTTP的应用语义，仍然使用HTTP的请求方法、状态码和头字段等规则，它主要修改了HTTP的报文传输格式，通过引入二进制分帧实现性能的提升。**





[HTTP/2: the Future of the Internet](https://http2.akamai.com/demo) 这是 Akamai 公司建立的一个官方的演示，用以说明 HTTP/2 相比于之前的 HTTP/1.1 在性能上的大幅度提升。

 同时请求 379 张图片，从Load time 的对比可以看出 HTTP/2 在速度上的优势。





## HTTP中的关键性能指标



Web 应用的执行主要涉及三个任务：取得资源、页面布局和渲染、JavaScript 执行。其中，渲染和脚本执行在一个线程上交错进行，不可能并发修改生成的 DOM。

优化运行时的渲染和脚本执行是至关重要的



DNS查找 





## HTTTP/1.1的问题









## 二进制分帧和流

HTTP 2.0 性能增强的核心，全在于新增的二进制分帧层



![http2_binary_framing_layer](assets/http2_1.png.webp)



- 

- **帧（Frame）**：HTTP/2 数据通信的最小单位。帧用来承载特定类型的数据，如 HTTP 首部、负荷；或者用来实现特定功能，例如打开、关闭流。

  每个帧都包含帧首部，其中会标识出当前帧所属的流；

- **消息（Message）**：指 HTTP/2 中逻辑上的 HTTP 消息。例如请求和响应等，消息由一个或多个帧组成；

- **流（Stream）**：存在于连接中的一个虚拟通道。流可以承载双向消息，每个流都有一个唯一的整数 ID；

- **连接（Connection）**：与 HTTP/1 相同，都是指对应的 TCP 连接；





HTTP/2 允许在单个连接上同时发送多个请求，每个 HTTP 请求或响应使用不同的流。

连接上的数据流被称为数据帧，每个数据帧都包含一个固定的头部，用来描述该数据帧的类型、所属的流 ID 等。



### 二进制

**HTTP/2** 是一个二进制的、基于数据包的协议，而 HTTP/1 是完全基于文本的。

`HTTP/1` 的请求和响应报文，都是由起始行，首部和实体正文（可选）组成，各部分之间以文本换行符分隔。

**HTTP/2 将请求和响应数据分割为更小的帧，并且它们采用二进制编码**。

- **在 HTTP/2 中，同域名下所有通信都在单个 TCP 连接上完成，这个连接可以承载任意数量的双向数据流。**

- **每个数据流都以消息的形式发送，而消息又由一个或多个帧组成。多个帧之间可以乱序发送，因为根据帧首部的流标识可以重新组装。**

**简言之，HTTP2.0把HTTP协议通信的基本单位缩小为一个一个的帧，这些帧对应着逻辑流中的消息。相应地，很多流可以并行的在同一个TCP连接上交换消息。**









| 名称         | 作用                                                         |
| ------------ | ------------------------------------------------------------ |
| SETTINGS帧   | 用于传递关于HTTP2连接的配置参数。                            |
| HEADERS帧    | 包含 HTTP headers。                                          |
| DATA帧       | 包含 HTTP body。                                             |
| RST_STREAM帧 | 直接取消一个流。客户端可以通过发送RST_STREAM帧直接取消一个流，当服务端收到一个RST_STREAM帧时，会直接关闭该流，该流也不再属于活跃流。 |



## 多路复用

在 `HTTP/1.x` 中，每一个请求和响应都要占用一个 TCP 连接。

尽管有 `Keep-Alive` 机制可以复用，但在每个 TCP  连接上同时只能有一个请求 / 响应，这意味着完成响应之前，这个连接不能用于其他请求。



如果客户端要想发起多个并行请求以提升性能，则必须使用多个 TCP 连接。这是 `HTTP/1.x` 交付模型的直接结果，该模型可以保证每个连接每次只交付一个响应（响应排队）。 

更糟糕的是，这种模型也会导致队首阻塞，从而造成底层 TCP 连接的效率低下。



大多数 HTTP 传输都是短暂且急促的，而 TCP 则针对长时间的批量数据传输进行了优化。 通过重用相同的连接，HTTP/2 既可以更有效地利用每个 TCP 连接，也可以显著降低整体协议开销。 



HTTP/2 中新的二进制分帧层突破了这些限制，实现了完整的请求和响应复用：

1、客户端和服务器可以将 HTTP 消息分解为互不依赖的帧，然后交错发送，最后再在另一端把它们重新组装起来。

2、HTTP/2 拥有了「多路复用」功能，意思是: **在一条连接上，可以同时发起无数个请求，并且响应可以同时返回**。

**简单来说， 就是在同一个TCP连接，同一时刻可以传输多个HTTP请求。**



- 同域名下所有通信都在单个连接上完成，消除了因多个 TCP 连接而带来的延时和内存消耗。
- 单个连接上可以并行交错的请求和响应，之间互不干扰。



> **HTTP/2 最大限度的兼容 HTTP/1.1 原有行为：**
>
> 1. **在应用层上修改，基于并充分挖掘 TCP 协议性能。**
> 2. **客户端向服务端发送 request 请求的模型没有变化。**
> 3. **scheme 没有发生变化，没有 http2://**
> 4. **使用 HTTP/1.X 的客户端和服务器可以无缝的通过代理方式转接到 HTTP/2 上。**
> 5. **不识别 HTTP/2 的代理服务器可以将请求降级到 HTTP/1.X。**



https://imququ.com/post/http2-and-wpo-2.html



我们使用`http2`时，应该要注意到，在`http1.1`时代的一些优化方案如合并请求、雪碧图、域名分区等可能不再那么必要。

虽然`http2`解决了很多之前旧版本的问题，但是它也没有彻底解决队头阻塞问题。因为 tcp 协议的“超时重传”机制，丢失的包必须等待重新传输确认，才能传输下一个包。因此当`http2`出现丢包时，会阻塞掉复用该连接的所有请求。

为此，`http3`使用了基于 UDP 传输协议的 QUIC 协议，QUIC 原生实现了多路复用，其传输的单个数据流可以保证有序交付且不会影响其他的数据流，这就解决了 `http2`中 tcp 重传导致的阻塞问题。

不过 `http3` 目前离生产使用还有很长的路要走，服务端方面，2020年6月10日，Nginx 刚宣布实现了初始版本，而 Apache httpd 暂时还没有任何支持 `http3` 的消息。客户端方面，Firefox 75，Chrome 83 以上版本开始支持`http3` 协议。

#### 在 nodejs 中使用 HTTP2 

```javascript
// 示例代码app.js
const http2 = require('http2');
const fs = require('fs');

const server = http2.createSecureServer({
  key: fs.readFileSync('localhost-privkey.pem'),
  cert: fs.readFileSync('localhost-cert.pem')
});
server.on('error', (err) => console.error(err));

server.on('stream', (stream, headers) => {
  // stream is a Duplex
  stream.respond({
    'content-type': 'text/html; charset=utf-8',
    ':status': 200
  });
  stream.end('<h1>Hello World</h1>');
});

server.listen(8443,'0.0.0.0');
```





```shell
# 自签SSL证书



openssl req  -newkey  rsa:4096 \
	-x509 
	-sha256   \
    -nodes  \
    -sha256 \ 
    -subj  '/CN=localhost' \
  	-keyout localhost-privkey.pem  \
    -out localhost-cert.pem \ 

-newkey rsa:4096-创建新的证书请求和4096位RSA密钥。默认值为2048位。
-x509 -创建X.509证书。
-sha256 -使用265位SHA（安全哈希算法）。
-days 3650 -认证证书的天数。 3650是10年。您可以使用任何正整数。
-nodes -创建没有密码的密钥。
-out example.crt -指定将新创建的证书写入的文件名。您可以指定任何文件名。
-keyout example.key -指定要写入新创建的私钥的文件名。您可以指定任何文件名。

-subj 指定基本信息
CN=-国家/地区名称。 ISO的两个字母缩写。
ST= -州或省名。
L= -地区名称。您所在的城市的名称。
O= -您组织的全名。
OU= -组织单位。
CN= -完全限定的域名。


# 运行项目
node app.js


# 客户端访问，验证 HTTP2 协议
```



#### 服务器推送



HTTP 2.0 新增的一个强大的新功能，就是服务器可以对一个客户端请求发送多个响应。



https://iziyang.github.io/2020/08/29/20-nginx/





## HTTP2 TLS 握手协商

HTTP 协议从诞生一直到 HTTP/2，都是依赖 TCP 传输数据。TCP 协议提供面向连接的可靠数据传输能力。

当我们在浏览器输入网址按回车的时候，浏览器怎么确定要用 HTTP 协议的哪个版本来通信呢？

HTTP/2 也强制使用 TLS 加密（理论上也支持明文通信，但浏览器都没有实现）。TLS 协议本身支持所谓的 ALPN  功能，全称叫应用层协议协商。

也就是说，如果浏览器支持 HTTP/2 协议，它会在创建 TLS 连接的时候给服务器发送 h2  标识，如果服务也支持，则双方就会继续使用 HTTP/2 通信；如果不支持，则降级回 HTTP/1 协议。



基于 HTTPS 的协议协商非常简单，多了 TLS 之后，双方必须等到成功建立 TLS 连接之后才能发送应用数据。而要建立 TLS 连接，本来就要进行 CipherSuite 等参数的协商。

引入 HTTP/2 之后，需要做的只是在原本的协商机制中把对 HTTP 协议的协商加进去。

HTTP/2 需要基于 HTTPS 部署是当前主流浏览器的要求。如果你的 HTTP/2 服务要支持浏览器访问，那就必须基于 HTTPS 部署；如果只给自己客户端用，可以不部署 HTTPS



支持 HTTP/2 的 Web Server 基本都支持 HTTP/1.1。这样，即使浏览器不支持 HTTP/2，双方也可以协商出可用的 HTTP 版本，没有兼容性问题。



因为都是用 TCP +  TLS，这种降级不会带来性能问题上。



参考

https://imququ.com/post/protocol-negotiation-in-http2.html

https://taoshu.in/http3-port.html





## HTTP2特性之Server Push



访问网站始终遵循着**请求——响应**模式。用户将请求发送到远程服务器，在一些延迟后，服务器会响应被请求的内容。

对网络服务器的初始请求通常是一个 HTML 文档。在这种情况下，服务器会用所请求的 HTML 资源进行响应。接着浏览器开始对 HTML 进行解析，过程中识别其他资源的引用，例如样式表、脚本和图片。

紧接着，浏览器对这些资源分别发起独立的请求，等待服务器返回。

这一机制的问题在于，它迫使用户等待这样一个过程：直到一个 HTML 文档下载完毕后，浏览器才能发现和获取页面的关键资源。从而延缓了页面渲染，拉长了页面加载时间。



有了 Server Push，就有了解决上述问题的方案。Server Push 能让服务器在用户没有明确询问下，抢先地 “推送” 一些网站资源给客户端。只要正确地使用，我们可以根据用户正在访问的页面，给用户发送一些即将被使用的资源。

比如说你有一个网站，所有的页面都会在一个名为 styles.css 的外部样式表中，定义各种样式。当用户向务器请求 index.html 时，我们可以向用户推送 styles.css，同时我们发送 index.html。



目前很多公司网站请求资源的顺序是：

1. 请求html文件
2. 服务端返回html文件
3. 解析html文件
4. 请求css、js等文件
5. 服务端或cdn返回文件





优化资源加载最有效的方式是：尽可能加载少的资源；如果这个资源之后才用得到，那么就不要一开始就加载它。

关键资源、关键渲染路径、关键请求链的概念诞生已久，异步加载资源的概念可谓是老生常谈：懒加载图片、视频、iframe，乃至懒加载 CSS、JS、DOM，懒执行函数。但是，关键资源递送的思路却依然没有多少改变。

 过去常见关键样式或关键媒体资源内联在 HTML 中，虽然客户端只请求了 HTML，但是这些资源随 HTML 文件一起到达用户手中、避免了浏览器在解析 DOM 后再开始加载资源。但是这部分关键资源却不能够被有效的缓存起来。

于是，HTTP/2 提出了 Server Push，相比内联的方法有额外的性能收益： 

相比内联在 HTML 中、跟随 HTML 的缓存 TTL，这部分响应可被浏览器缓存起来 成功缓存以后，其他页面可以不再请求这一文件 客户端可以选择拒绝接收服务端对这一资源的 Push 需要注意的是，启用 Server Push 以后一定会存在流量浪费，因为服务端在接收到请求后一定会将额外的资源一并响应给客户端。

如果客户端本地已有 HTTP 缓存，可以在接收到 Push 的帧后发送 RST_STREAM 帧阻止服务端发送后续的帧，但是头部的几个帧已经发送了，这是无可避免的。 

但是，如果没有 Server Push，浏览器加载关键资源就会受到许多条件的限制（TCP 头部阻塞、浏览器解析 DOM 找出外链资源的耗时、浏览器等待服务端返回请求的外链资源的耗时），因此 Server Push 的核心就是用带宽和流量换取延时。

以我的博客为例，我为 blog.skk.moe 的 CSS 启用了 Server Push 以后，DOMContentLoaded 触发计时平均减少了 180ms，这是一个很惊人的数字了。







# HTTP3 

自nginx的1.25.0版本开始，nginx首次对http3进行了正式支持，这也为我们在WEB服务器上部署http3提供了极大的便利。

http3必须依赖于TLS协议，所以需要要证书。







# HTTP代理

在网络通信中，`HTTP` 代理是一个常见的工具，用于在客户端和服务器之间中转HTTP请求和响应。它可以用于多种目的，包括提升安全性、管理网络流量、提高访问速度等。

代理服务器的定义：代理服务器（Proxy Server）是一种位于客户端和目标服务器之间的中间服务器，用于转发客户端的请求并将服务器的响应返回给客户端。



**请求流程**：

- 客户端发送 `HTTP` 请求到代理服务器。
- 代理服务器接收请求并将其转发给目标服务器。
- 目标服务器处理请求并返回响应给代理服务器。
- 代理服务器将响应返回给客户端



**响应流程**：与请求流程类似，代理服务器在请求和响应过程中充当中间人角色。

**数据传输和处理**：代理服务器可以对传输的数据进行缓存、过滤和修改。



```
+--------+     HTTP Request     +-----------+    HTTP Request     +-----------+
| Client |--------------------->| Proxy     |-------------------->| Target    |
|        |                      | Server    |                     | Server    |
+--------+                      +-----------+                     +-----------+
          <---------------------                  <----------------
           HTTP Response                          HTTP Response
```





`HTTP` 客户端向代理发送请求报文，代理服务器需要正确地处理请求和连接（例如正确处理 `Connection: keep-alive`），同时向服务器发送请求，并将收到的响应转发给客户端。 

这种代理扮演的是「`中间人`」角色，对于连接到它的客户端来说，它是服务端；对于要连接的服务端来说，它是客户端。它就负责在两端之间来回传送 `HTTP` 报文。



```
➜  ~ curl -vvv http://baidu.com
*   Trying 39.156.66.10:80...
* Connected to baidu.com (39.156.66.10) port 80
GET / HTTP/1.1
Host: baidu.com
User-Agent: curl/8.4.0
Accept: */*
➜  ~ curl -vvv -x http://127.0.0.1:8080 http://www.baidu.com
*   Trying 127.0.0.1:8080...
* Connected to 127.0.0.1 (127.0.0.1) port 8080
GET http://www.baidu.com/ HTTP/1.1
Host: www.baidu.com
User-Agent: curl/8.4.0
Accept: */*
Proxy-Connection: Keep-Alive
```







# cookie和session



HTTP是一种无状态的协议，不会保存客户端和服务端之间的通信状态。这样可以处理大量的事物，保证了HTTP协议的伸缩性。

HTTP协议的无状态，意味着服务器无法知道两个请求是否来自同一个浏览器，即服务器不知道用户上一次做了什么，每次请求都是完全相互独立的。

早期互联网只是用于简单的浏览文档信息、查看黄页、门户网站等等，并没有**交互**这个说法。

但是随着互联网慢慢发展，宽带、服务器等硬件设施已经得到很大的提升，互联网允许人们可以做更多的事情，所以**交互式Web**慢慢兴起，而HTTP无状态的特点却严重阻碍其发展！



HTTP 最初是一个匿名、无状态的请求/响应协议（无状态协议）。服务器处理来自客户端的请求， 然后向客户端回送一条响应。

Web 服务器几乎没有什么信息可以用来判定是哪个用 户发送的请求，也无法记录来访用户的请求序列。

现代的 Web 站点希望能够提供个性化的接触。它们希望对连接另一端的用户有更多 的了解，并且能在用户浏览页面时对其进行跟踪。

Amazon.com 这样流行的在线商 店网站可以通过以下几种方式实现站点的个性化

典型的场景比如购物车，当你点击下单按钮时，由于HTTP协议无状态，所以并不知道是哪个用户操作的，所以服务端要为特定的用户创建了特定的Session，用用于标识这个用户，并且跟踪用户，这样才知道购物车里面有几本书。

这个Session是保存在服务端的，有一个唯一标识。在服务端保存Session的方法很多，内存、数据库、文件都有。

集群的时候也要考虑Session的转移，在大型的网站，一般会有专门的Session服务器集群，用来保存用户会话，这个时候 Session 信息都是放在内存的，使用一些缓存服务比如Memcached之类的来放 Session。





HTTP Cookie（也叫 Web Cookie 或浏览器 Cookie）是**服务器发送到用户浏览器并保存在客户端本地**的一小块数据。

它会在浏览器下次向同一服务器再发起请求时被携带并发送到服务器上。

（试想，如果没有 cookie，如果你进入一个购物网站并且尚未登陆，添加商品到购物车后，然后刷新页面，购物车就被清空。那会是多么麻烦）



通常，它用于告知服务端两个请求是否来自同一浏览器，如保持用户的登录状态。Cookie 使基于[无状态](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview#HTTP_is_stateless_but_not_sessionless)的HTTP协议记录稳定的状态信息成为了可能。



Cookie 曾一度用于客户端数据的存储，因当时并没有其它合适的存储办法而作为唯一的存储手段，但现在随着现代浏览器开始支持各种各样的存储方式，Cookie 渐渐被淘汰。

由于服务器指定 Cookie 后，浏览器的每次请求都会携带 Cookie 数据，会带来额外的性能开销（尤其是在移动环境下）。

新的浏览器API已经允许开发者直接将数据存储到本地，如使用 [Web storage API](https://developer.mozilla.org/zh-CN/docs/Web/API/Web_Storage_API) （本地存储和会话存储）或 [IndexedDB](https://developer.mozilla.org/zh-CN/docs/Web/API/IndexedDB_API) 。



### cookie的用途



- 会话管理
- 个性化
- 用户跟踪（广告）





用户首次访问购物网站，网站server为用户生成了一个 `sessionId`，并在响应中携带 `Set-Cookie: sessionId=123; Expires=Tue, 15 Jan 2021 21:47:38 GMT`;



浏览器收到服务端的响应，从响应中获取到Set-Cookie，将sessionId=123存储浏览器cookie中。

由于Set-Cookie中携带了Expires属性，浏览器同时为该cookie设置过期时间（如果没有Expires属性，浏览器会把该cookie作为session cookie处理，当用户关闭浏览器时，该cookie会被删除）



用户将一个iphone商品加入购物车，浏览器会将此购物车操作发送给server，并且在该请求中的cookie中自动携带上sessionId=123。server会记住sessionId=123的用户在购物车中添加了一个iphone

用户然后关闭了该购物网站

数小时后，用户再此打开此购物网站并访问购物车，网站从后端请求购物车数据。浏览器查找本地cookie，发现保存了此网站sessionId=123的有效cookie，浏览器在网站请求头中附带自动附带sessionId=123的cookie。

服务端收到购物车查询请求，并获从请求头中获取到sessionId=123，服务器查找内存中的id=123的session，发现有此用户的购物车商品数据（一台iphone）。服务器将此数据返回给前端。

用户在购物车中看到了自己上次访问网站是添加的iphone，选中此商品完成结算。







### cookie的过程

当服务器收到 HTTP 请求时，服务器可以在响应头里面添加一个或多个 [`Set-Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Set-Cookie) 头部。

浏览器收到响应后通常会保存 Cookie，之后对该服务器每一次请求中都通过 [`Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Cookie) 请求头部将 Cookie 信息发送给服务器。

另外，Cookie 的过期时间、域、路径、有效期、适用站点都可以根据需要来指定。

```shell
# 服务器返回的浏览器的响应头中添加这个头部，设置cookie
Set-Cookie: yummy_cookie=choco; 
Set-Cookie: tasty_cookie=strawberry



# 接下来浏览器对服务器的请求报文中都会携带这些cookie
GET /sample_page.html HTTP/1.1
Host: www.example.org
Cookie: yummy_cookie=choco; tasty_cookie=strawberry
```



### cookie的生命周期

Cookie 的生命周期可以通过两种方式定义：

- 会话期 Cookie 是最简单的 Cookie：浏览器关闭之后它会被自动删除，也就是说它仅在会话期内有效。会话期Cookie不需要指定过期时间（`Expires`）或者有效期（`Max-Age`）。需要注意的是，有些浏览器提供了会话恢复功能，这种情况下即使关闭了浏览器，会话期Cookie 也会被保留下来，就好像浏览器从来没有关闭一样，这会导致 Cookie 的生命周期无限期延长。

- 持久性 Cookie 的生命周期取决于过期时间（`Expires`）或有效期（`Max-Age`）指定的一段时间。

  ```shell
  Set-Cookie: id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT;
  ```

> **提示：**当Cookie的过期时间被设定时，设定的日期和时间只与客户端相关，而不是服务端。



如果您的站点对用户进行身份验证，则每当用户进行身份验证时，它都应重新生成并重新发送会话 Cookie，甚至是已经存在的会话 Cookie。

此技术有助于防止[会话固定攻击（session fixation attacks）](https://wiki.developer.mozilla.org/en-US/docs/Web/Security/Types_of_attacks#Session_fixation)，在该攻击中第三方可以重用用户的会话。



### cookie的作用域

`Domain` 和 `Path` 标识定义了Cookie的作用域：即允许 Cookie 应该发送给哪些 URL。

```javascript
//nodejs的demo项目设置cookie
var http = require('http');
var server = http.createServer(function(request, response)
{
    
    response.setHeader('X-Foo', 'bar');
    response.setHeader('Set-Cookie', ['type=ninja', 'language=javascript']); 
    
    response.end("Hello fengzhao\n");
});

server.listen(3000);

```



禁用Cookie会怎样?如果客户在浏览器禁用了Cookie，该怎么办呢?

方案一：拼接SessionId参数。在GET或POST请求中拼接SessionID，GET请求通常通过URL后面拼接参数来实现，POST请求可以放在Body中。无论哪种形式都需要与服务器获取保持一致。

这种方案比较常见，比如老外的网站，经常会提示是否开启Cookie。如果未点同意或授权，会发现浏览器的URL路径中往往有"?sessionId=123abc"这样的参数。



方案二：基于Token(令牌)。在APP应用中经常会用到Token来与服务器进行交互。Token本质上就是一个唯一的字符串，登录成功后由服务器返回，标识客户的临时授权，客户端对其进行存储，在后续请求时，通常会将其放在HTTP的Header中传递给服务器，用于服务器验证请求用户的身份。



### cookie安全

- 中间人攻击/网络窃听
- 





众所周知，Chrome有浏览器记住和保存密码的功能，可以在Chrome浏览器 "密码管理器" 查看已保存的明文密码。



```bash
# Chrome浏览器cookie文件

C:\Users\<UserName>\AppData\Local\Google\Chrome\User Data\Default\Cookies
C:\Users\<UserName>\AppData\Local\Google\Chrome\User Data\Default\Network\Cookies


# Chrome浏览器保存的各种网站的账号密码文件

# 加密的sqlite文件路径: C:\Users\<UserName>\AppData\Local\Google\Chrome\User Data\Default\Login Data
# 解密密钥文件路径   C:\Users\<UserName>\AppData\Local\Google\Chrome\User Data\Local State
```



https://juejin.cn/post/6959830432519520292#heading-15

https://cloud.tencent.com/developer/article/1910076



在任何情况下，cookie都是由您访问的网站的网络服务器提供给您的。如果您访问的网站没有选择不提供cookie，则通常会为您提供两种主要“风味”之一。

- **第一方cookie：**直接从您访问的网站提供的cookie。这些通常用于维护会话，因此您下次访问时将保持登录状态。在大多数情况下，只要您访问的网站没有受到威胁，第一方数据就是安全的。它们为用户存储有用的数据。例如，首选语言，成功登录。在电子商务中，cookie 还存储有关购物车中剩余商品的数据等。
- **第三方cookie：**由不在您访问的网站上的第三方提供的cookie。这些cookie通常通过广告或其他功能链接到第三方。因此，即使是最善意的网站所有者也可能成为第三方cookie的渠道，例如，如果他们列出来自第三方的广告，其做法不那么有名气。网站传递给第三方广告商以实现更准确定位的 cookie。广告系统通过第三方 cookie 知道，既然你在一个网站上买了橡胶靴，你应该在另一个网站上展示一把雨伞。



现在三阶饼干将消失。这样做的原因是越来越多的隐私保护趋势。



> 人们希望更好地控制他们的数字足迹。他们想控制自己的数据。



在这种趋势的背景下，例如，欧盟通过了著名的 GDPR 法律——现在每个欧洲网站上的用户都会看到一个带有几个按钮的丑陋栏：继续，选择要在此存储的有关您的数据地点。



## Session

实际上打开浏览器是可以看到保存了哪些Cookie的，也就是说如果把用户名和密码放在Cookie上是很不安全的，只要电脑被黑，在Cookie里面的重要信息就会被泄露。



- **session 是基于 cookie 实现的，session 存储在服务器端，sessionId 会被存储到客户端的cookie 中**

session的中文翻译是“会话”，当用户打开某个web应用时，便与web服务器产生一次session。服务器使用session把用户的信息临时保存在了服务器上，用户离开网站后session会被销毁。

这种用户信息存储方式相对cookie来说更安全，可是session有一个缺陷：如果web服务器做了负载均衡，那么下一个操作请求到了另一台服务器的时候session会丢失。



HTTP代理



# Chrome浏览器密码存储机制

**如何查看chrome中已保存的网站密码**

Chrome 密码管理器的进入方式：右侧扳手图标→设置→显示高级设置→密码和表单→管理已保存的密码。或者直接在地址栏中复制粘贴：chrome://chrome/settings/passwords，然后回车进入。

如果你允许Chrome保存密码，点击密码区域，显示一个“显示”按钮，再点击“显示”按钮，可看到密码。



当我们登录成功时，并且使用的是一套新的证书（也就是xx次登录该网站），Chrome就会询问我们是否需要记住密码。

那么登录成功后，密码是如何被Chrome存储的呢？



密码存储的位置是 `"C:\Users\xxx\AppData\Local\Google\Chrome\User Data\Default\Login Data"`，实际上它是一个数据库文件。

Chrome已保存的密码数据存储在一个 SQLite 数据库中，路径如上。你可以用  SQLite Database Browser 等数据库IDE工具打开这个文件（文件名就是“Login Data”），查看“logins”表格，该表就包含了被保存的密码。

但你会看到“password_value” 域的值是不可读，因为值已加密。

**以密文的方式存储，加密方式是 AES-256 in GCM mode，但是密钥也存储在本地，也就是说可以手动完成解密**



为了执行加密（在Windows操作系统上），Chrome使用了Windows提供的API，该API**只**允许用于加密密码的Windows用户账户去解密已加密的数据。

所以基本上来说，你的主密码就是你的Windows账户密码。所以，只要你登录了用自己的账号Windows，Chrome就可以解密加密数据。



CryptProtectData





不过，因为你的Windows账户密码是一个常量，并不是只有Chrome才能读取“主密码”，其他外部工具也能获取加密数据，同样也可以解密加密数据。

比如使用NirSoft的免费工具ChromePass*（*[*NirSoft官方下载*](http://www.nirsoft.net/utils/chromepass.html)*）*，就可以看得你已保存的密码数据，并可以轻松导出为文本文件。



既然 ChromePass 可以读取加密的密码数据，那恶意软件也能读取的。

当ChromePass.exe被上传至VirusTotal时，超过半数的反病毒（AV）引擎会标记这一行为是危险级别。



不过在这个例子中，这个工具是安全的。不过有点囧，微软的Security Essentials并没有把这一行为标记为危险。

在后渗透中，获取用户凭证是很重要的一步，其中就包括浏览器的各种敏感信息。包括浏览记录、下载历史、cookie、书签等等。

Chrome的数据文件存储路径可以通过在搜索框中输入chrome://version 看到，其中Profile Path就是存储路径。



① 如果黑客要使用脚本进行破解，必然要有权限（因为文件放在`APPData`文件夹下），但如果有权限，那说明电脑本身是不安全的，那也就没必要只关注谷歌浏览器的密码了，因为整个电脑都已经被黑客操控了

② GitHub 代码库的私钥，包括很多隐私数据同样是存储在电脑中

③ 如果需要二次保护，可以用 1Password 等软件包含密码



# 认证

有数百万的人在用 Web 进行私人事务处理，访问私有的数据。通过 Web 可以很方便地访问这些信息，但仅仅是方便访问还是不够的。

我们要保证只有特定的人能看到我们的敏感信息并且能够执行我们的特权事务。**并不是所有的信息都能够公开发布的。**服务器需要通过某种方式来了解用户身份。一旦服务器知道了用户身份，就可以判定用户可以访问的事务和资源了。



认证就意味着要证明你是谁。通常是通过提供用户名和密码来进行认证的。HTTP 为认证提供了一种原生工具。尽管我们可以在HTTP 的认证形式和 cookie 基础之上 "运行自己的" 认证工具，但在很多情况下，HTTP 的原生认证功能就可以很好地满足要求。

**认证就是要给出一些身份证明。**当出示像护照或驾照那样有照片的身份证件时，就给出了一些证据，说明你就是你所声称的那个人。在自动取款机上输入 PIN 码，或在计算机系统的对话框中输入了密码时，也是在证明你就是你所声称的那个人。

现在，这些策略都不是绝对有效的。密码可以被猜出来或被人偶然听到，身份证件可能被偷去或被伪造。但每种证据都有助于构建合理的信任，说明你就是你所声称的那个人。



认证、授权和凭证是安全系统最基础的三个基石。

- 认证：即你是谁？告诉系统你是什么什么？通常这个谁我们是指的用户，在一些系统中，也泛指代码的安全认证。如Java Applets，这个不做介绍，这里只介绍用户的认证。
- 授权：即你可以干什么？系统告诉你你的权限
- 凭证：即如何证明你是你？系统是系统？ 通过凭证来证明彼此的身份。





### HTTP 基本认证

`HTTP Basic` 认证原生提供了一种 质询 / 响应（challenge/response）框架，简化了对用户的认证过程。它的具体过程如下：

- 客户端请求资源（客户端发起请求报文，通常是 get 或 post 请求）
- 服务端返回 401 ，响应头中包含 www-Authorization 首部，质询用户认证。要求用户提供身份信息。
- 客户端提供账号密码，账号密码拼接后经过 base64 编码然后包含在 Authorization 头部提交给服务端。
- 服务端解码并验证，然后返回资源。

#### 相关头部

```
WWW-Authenticate: <type> realm=<realm>
```

#### base64编码

我们发现字符串 “Man” 的Base64编码是 “TWFu” ，那么这是怎么转换过来的呢？

不急，我们一个一个字符来分析：

字符"M"对应的ASCII编码是77，二进制形式即 01001101；

字符“a”对应的ASCII编码是97，二进制表现形式为 01100001；

字符“n”对应的ASCII编码为110，二进制形式为：01101110。

这三个字符的二进制位组合在一起就变成了一个24位的字符串“010011010110000101101110”。



接下来，我们从左至右，每次抽取6位作为1组（因为6位一共有2^6=64种不同的组合），因此每一组的6位又代表一个数字（0~63），接下来，我们查看索引表，找到这个数字对应的字符，就是我们最后的结果，是不是很简单呢？

https://blog.csdn.net/doujinlong1/article/details/86579369

https://www.cnblogs.com/ranyonsue/p/8615824.html



#### 基本认证的安全缺陷



### 摘要认证





# Oauth2.0 认证



**令牌与密码的区别**

令牌（token）与密码（password）的作用是一样的，都可以进入系统，但是有三点差异。

- 令牌是短期的，到期会自动失效，用户自己无法修改。密码一般长期有效，用户不修改，就不会发生变化。
- 令牌可以被数据所有者撤销，会立即失效。以上例而言，屋主可以随时取消快递员的令牌。密码一般不允许被他人撤销。
- 令牌有权限范围（scope），比如只能进小区的二号门。对于网络服务来说，只读令牌就比读写令牌更安全。密码一般是完整权限。



上面这些设计，保证了令牌既可以让第三方应用获得权限，同时又随时可控，不会危及系统安全。

注意，只要知道了令牌，就能进入系统。系统一般不会再次确认身份，所以令牌必须保密，泄漏令牌与泄漏密码的后果是一样的。 

这也是为什么令牌的有效期一般都设置得很短的原因。



https://websec.readthedocs.io/zh/latest/auth/oauth.html

# HTTP安全





中间人攻击

- 服务器认证（客户端知道它们是在与真正的而不是伪造的服务器通话）。 

- 客户端认证（服务器知道它们是在与真正的而不是伪造的客户端通话）。 
- 完整性（客户端和服务器的数据不会被修改）。
- 加密（客户端和服务器的对话是私密的，无需担心被窃听）。 
- 效率（一个运行的足够快的算法，以便低端的客户端和服务器使用）。 
- 





### 对称加密



### 非对称加密





### 数字签名



除了加 / 解密报文之外，还可以用加密系统对报文进行签名（sign），以说明是谁编写的报文，同时证明报文未被篡改过。

**这种技术被称为数字签名（digital signing）**



数字签名是附加在报文上的特殊加密校验码。使用数字签名有以下两个好处。

- 签名可以证明是作者编写了这条报文。只有作者才会有最机密的私有密钥， 因此，只有作者才能计算出这些校验和。校验和就像来自作者的个人“签名”一样。



数字签名通常是用非对称公开密钥技术产生的。因为只有所有者才知道其私有密钥，所以可以将作者的私有密钥当作一种“指纹”使用。



# 深入浅出HTTPS



- 为什么用了 HTTPS 就是安全的？
- HTTPS 的底层原理如何实现？
- 用了 HTTPS 就一定安全吗？
- 什么是TLS双向认证？
- 客户端是如何确保服务端身份？
- 服务端如何确保客户端身份？HTTPS报文在传输过程被篡改了怎么办？
- 如何保证安全呢？你说安全就安全吗，究竟是怎么实现的呢？绝对安全吗？





## 一、为什么需要HTTPS？



**安全问题的本质**

安全问题的本质是**“信任”**问题。一切的安全方案设计的基础都是建立在信任的关系上的。

我们必须相信一些东西，必须有一些最基本的假设，安全方案才能得以建立，如果我们否定一切，安全方案就会如无源之水，无根之木，无法设计，也无法完成。

把握住信任条件的度， 使其恰到好处，正是设计安全方案的难点所在，也是安全这门学问的艺术魅力所在。



**信息安全三要素**

安全三要素是安全的基本组成元素，分别是机密性（Confidentiality）、完整性（Integrit）、可用性（Availability）

- **机密性：**要求保护数据内容不被泄漏，**加密是实现机密性要求的常用技术手段**。

- **完整性：**要求保护的数据内容是完整的、没有被篡改的。常见的保证一致性的技术手段是**数字签名**。
- **可用性：**要求保护的资源是“随需而得”。资源的范围很广，很多时候，资源的可用性主要是指数据的可用性。

在安全领域中，最基本的要素就是这三个，后来还有人想扩充这些要素，增加了 诸如可审计性、不可抵赖性等，但最重要的还是以上三个要素。



**在设计安全方案时，也要以这三个要素为基本的出发点，去全面地思考所要面对的问题。**

- 空间身份防假冒（冒充服务提供者，去诈骗用户。冒充信息发送方，去诈骗接收方，比如假传圣旨，伪造圣旨等）

- 信息防泄密（盗取用户信息，用户数据，防止信息在传输过程中被第三方读取到，比如战争时期的无线电监听，电文破译等）

- 内容防篡改（信息传输过程防止被第三方篡改）

- 行为抗抵赖（防止抵赖，比如看过不承认等）



通信，信息从**发送方**出产生，通过各种媒介传输到**接收方**，中间的传输信道/传输链路一般被认为是不可信的。

从以前的信件，无线电报，现在的互联网通信等，信息都有可能被截取或被篡改。所以通讯加密这个需求自然而然就诞生了。



HTTP1.1 做为应用层超文本传输协议。存在以下安全性问题：

1. 使用明文(不加密)进行通信，内容可能会被窃听；（即信息传输可能会在传输链路中被窃听）
2. 不验证通信方的身份，通信方的身份有可能遭遇伪装；（中间人攻击）
3. 无法证明报文的完整性，报文有可能遭篡改。

由于 HTTP 设计之初没有考虑到这几点，所以基于 HTTP 的这些应用都会存在安全问题。当初设计 HTTPS 是为了满足哪些需求？

**兼容性**

因为是先有 HTTP 再有 HTTPS。所以，HTTPS 的设计者肯定要考虑到对原有 HTTP 的兼容性。

这里所说的兼容性包括很多方面。比如已有的 Web 应用要尽可能无缝地迁移到 HTTPS

1. HTTPS 还是要基于 TCP 来传输
2. 单独使用一个新的协议，把 HTTP 协议包裹起来。
3. 所谓的“HTTP over SSL”，实际上是在原有的 HTTP 数据外面加了一层 SSL 的封装。HTTP 协议原有的 GET、POST 之类的机制，基本上原封不动。



**保密性/防泄密**

HTTPS 需要做到足够好的保密性。

首先要能够对抗“嗅探”（圈内行话叫 Sniffer）。所谓的“嗅探”，通俗而言就是监视你的网络传输流量。

如果你使用【明文】的 HTTP 上网，那么监视者通过嗅探，就知道你在访问哪些网站的哪些页面，传输了哪些内容。

嗅探是最低级的攻击手法。除了嗅探，HTTPS 还需要能对抗其它一些稍微高级的攻击手法——比如“重放攻击”。



**完整性/防篡改**

在发明 HTTPS 之前，由于 HTTP 是明文的，不但容易被嗅探，还容易被篡改。

比如以前国内网络运营商（ISP）都比较流氓，经常有网友抱怨说访问某网站（本来是没有广告的），竟然会跳出很多中国电信的广告。

因为你的网络流量需要经过 ISP 的线路才能到达公网。如果你使用的是明文的 HTTP，ISP 很容易就可以在你访问的页面中植入广告。

所以，当初设计 HTTPS 的时候，还有一个需求是“确保 HTTP 协议的内容【不】被篡改”。



**真实性/防假冒**

在谈到 HTTPS 的需求时，“真实性”经常被忽略。其实“真实性”的重要程度【不亚于】前面的“保密性”和“完整性”。

你因为使用网银，需要访问该网银的 Web 站点。那么，你如何确保你访问的网站确实是你想访问的网站？

仅靠DNS和域名是远远不够，由于 DNS 的不可靠（存在“域名欺骗”和“域名劫持”），你看到的网址里面的域名未必是真的。

所以，HTTPS 协议必须有某种机制来确保“真实性”的需求。





## 二、数据没有加密

基于 TCP/IP 的网络，在整个网络通讯链路中，各处都会存在被监听的风险。

而且如果用 HTTP 协议进行通信，HTTP 本身没有加密功能，所以也无法做到对**通信整体**(**使用 HTTP 协议通信的请求和响应的内容**)进行加密。**即：HTTP 报文使用明文(指未经过加密的报文)方式发送。**



在互联网整个信息传输链路中各个环节都可能被监听。就算是加密通信，也能被监听到通信内容，只不过监听者看到的是密文。

要解决 HTTP 上面 3 个大的安全问题，第一步就是要先进行加密通信。

于是在传输层增加了一层 SSL（Secure Sockets Layer 安全套接层）/ TLS (Transport Layer Security 安全层传输协议) 来加密 HTTP 的通信内容。



能让 HTTPS 带来安全性的是其背后的 TLS 协议。它源于九十年代中期在 Netscape 上开发的称为安全套接字层(SSL)的协议。

到 20 世纪 90 年代末，Netscape 将 SSL 移交给了 IETF，IETF 将其重命名为 TLS，并从此成为该协议的管理者。许多人仍将 Web 加密称作 SSL，即使绝大多数服务已切换到仅支持 TLS。



HTTPS (HTTP Secure) 并不是新协议，而是 HTTP 先和 SSL（Secure Sockets Layer 安全套接层）/ TLS (Transport Layer Security 安全层传输协议) 通信，再由 SSL/TLS 和 TCP 通信。也就是说 HTTPS 使用了隧道进行通信。



为什么不直接对 HTTP 报文进行加密，这样就不需要 SSL/TLS 这一层了。

如果直接对 HTTP 报文进行加密也可以做到加密通信，但是虽然解决了第一条，但是后面 2 条就不好解决了。



### 加密算法



#### 摘要算法/哈希函数

**消息摘要算法**是密码学算法中非常重要的一个分支，它通过对所有数据提取指纹信息以实现数据签名、数据完整性校验等功能，由于其不可逆性，有时候会被用做敏感信息的加密。消息摘要算法也被称为哈希（Hash）算法或散列算法。

**任何消息经过散列函数处理后，都会获得唯一的散列值，这一过程称为 “消息摘要”，其散列值称为 “数字指纹”，其算法自然就是 “消息摘要算法”了。**

**哈希函数**，或者叫**散列函数**，是一种从任何一种数据中创建一个**数字指纹**（也叫数字摘要）的方法，散列函数把数据压缩（或者放大）成一个长度固定的字符串。



> 注意：用于保护密码的哈希函数和你在数据结构中学到的哈希函数是不同的。比如用于实现哈希表这之类数据结构的哈希函数，它们的目标是快速查找，而不是高安全性。
>
> 只有**加密哈希函数**才能用于保护密码，例如SHA256，SHA512，RipeMD和WHIRLPOOL。

> 严格来说，摘要算法**不是加密算法**，不能用于数据加密（因为无法通过摘要反推明文）
>
> **哈希（Hash）是将目标文本转换成具有相同长度的、不可逆的杂凑字符串（或叫做消息摘要）**
>
> **加密（Encrypt）是将目标文本转换成具有不同长度的、可逆的密文。**
>
> 哈希算法往往被设计成生成具有相同长度的文本，而加密算法生成的文本长度与明文本身的长度有关。
>
> 哈希算法是不可逆的，而加密算法是可逆的。

摘要算法只能用于对数据的单项运算，无法还原被摘要源数据，其特点为：

- 不可逆：**本质上就是只能将原始数据生成摘要，而不能将摘要还原数据，即理论上无法通过反向运算得到原始数据内容。**
- 雪崩效应：少量消息位的变化会引起信息摘要的许多位变化
- **加密过程不需要密钥，并且经过加密的数据几乎无法被解密**

- 定长输出（无论消息长度，计算出的长度永远不变）

  - 例如 MD5 算法摘要的消息有 128 个比特位，用 SHA-1 算法摘要的消息最终有 160 个比特位的输出，SHA-1 的变体可以产生 192 个比特位和 256 个比特位的消息摘要。一般认为，摘要的最终输出越长，该摘要算法就越安全。

- **只有输入是相同的明文数据并且采用相同的消息摘要算法，得出来的密文才是一样的。换句话说，如果其数字指纹一致，就说明其消息是一致的。**

  

```

hash("hello") = 2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824
hash("hbllo") = 58756879c05c68dfac9866712fad6a93f8146f337a69afe7dd238f3364946366
hash("waltz") = c0e81794384491161f1777c232bc6bd9ec38f616560b120fda8e90f383853542
```





单向散列技术是为了保证信息的完整性，防止信息被篡改的一项技术。**只有输入是相同的明文数据并且采用相同的消息摘要算法，得出来的密文才是一样的。**

其加密过程的计算量是比较大的，所以在以前计算设备的性能不是那么高的情况下，它只适合于少量数据的加密，比如计算机的口令。

现在计算机的性能发展的越来越快，它的应用领域也越来越广。

使用场景：

- 用户密码存储：将用户密码计算摘要后存入数据库中。谁都不知道明文。用户输入明文后，单向计算出摘要后再匹配检查是否输入正确。

- 数据签名：一般地，把对一个信息的摘要称为该消息的指纹或数字签名。数字签名是保证信息的完整性和不可否认性的方法。**数据的完整性是指信宿接收到的消息一定是信源发送的信息，而中间绝无任何更改；信息的不可否认性是指信源不能否认曾经发送过的信息。**其实，通过数字签名还能实现对信源的身份识别（认证），即确定 “信源” 是否是信宿意定的通信伙伴。 数字签名应该具有唯一性，即不同的消息的签名是不一样的；同时还应具有不可伪造性，即不可能找到另一个消息，使其签名与已有的消息的签名一样；还应具有不可逆性，即无法根据签名还原被签名的消息的任何信息。这些特征恰恰都是消息摘要算法的特征，所以消息摘要算法适合作为数字签名算法。

  

- 文件防篡改：很多网站提供文件下载，网站中同时提供了消息摘要值，比如md5或sha256，用户下载文件到本地后，可以检查本地文件的摘要值与网上对比。GNU/Linux中有各种命令可以快速查看文件的摘要：md5sum , sha512sum，sha256sum 等。

无论是文本文件，二进制文件，还是其他的什么可以读入内存的二进制序列。都可以计算摘要。



##### 常见摘要算法

**消息摘要算法主要分为三大类：**

- **MD（Message Digest，消息摘要算法）**
- **SHA-1（Secure Hash Algorithm，安全散列算法）**
- **MAC（Message Authentication Code，消息认证码算法）**

| 算法簇                               | 具体算法                                        | 输入长度（比特位） | 摘要长度（比特位） |
| ------------------------------------ | ----------------------------------------------- | ------------------ | ------------------ |
| **MD5**                              | MD5                                             |                    |                    |
| **SHA-2**                            | SHA-224<br>SHA-256<br>SHA-384<br>SHA-512        |                    |                    |
| **SHA-3**（Secure Hash Algorithm 3） | SHA3-224<br/>SHA3-256<br/>SHA3-384<br/>SHA3-512 |                    |                    |
|                                      |                                                 |                    |                    |
|                                      |                                                 |                    |                    |
|                                      |                                                 |                    |                    |



MD5算法（Message Digest 5）是一种密码散列函数，产生出一个128位的散列值，可以用一个长度为32的十六进制字符串表示。

MD5算法是由美国密码学家Ronald Linn Rivest（这位大佬就是发明RSA算法的R）设计的，于1992年公开，用来取代之前的MD4算法。

SHA 算法主要包括其代表算法 SHA-1 和 SHA-1 算法的变种 SHA-2 系列算法（包含 SHA-224、SHA-256、SHA-384 和 SHA-512）；



##### 如何破解哈希

这里更多的是在讨论哈希后的密码的破解

> 在不考虑`UNICODE`编码中电脑键盘未标明的特殊字符，我们构建密码时，我们通常选择字符范围是：
>
> - 数字：0~9 共10位 
>
> - 大小写英文字母：a~z A~Z 共52位
>
> - 特殊字符：“ !"#$%&&#039;()*+,-./:;<=>?@[\]^_`{|}~” 不包含两边引号共33位（其中包含空格）



如果要评判一则口令是强是弱，就必须先考虑影响口令强度的因素：**复杂性和长度**，因为我们在输入口令时只有这两种维度的选择：

- 要么多输入一些特殊字符增强复杂性。

- 要么多输入一些混合字符/字母增加口令长。


在不考虑拖库、社工等口令获取方式的前提条件下，通常情况下，破解口令仅有**暴力破解**的方式可以选择，其中亦包括**字典攻击**和**彩虹表**破解。



在纯粹的暴力破解中，攻击者需要逐一长度地尝试口令可能组合的方式，是ATM机般的纯数字组合，还是12306般的纯数字字母组合，亦或是正常电商那般可以混合输入数字、字母和特殊字符。

假设一则口令P的字符长度是L，可选择的字符组合形式范围的长度是S，那么即便是在“暴力破解”这种残暴字眼的手段中，运气不好的情况下仍然需要最多尝试S的L次方。

> 口令是否安全的原则取决于攻击者能否在可容忍的时间内破解出真实口令，而是否有耐心进行暴力破解往往决定于攻击者的目的及成效：
>
> 一名仅为破解电子书小说压缩包的宅男不大可能会浪费一天以上时间等待口令的“出现”。



如果我们将SL当作口令强度的评测标准，显而易见，在口令长度相同的情况下，我们可选择的组合方式和范围内越大则口令强度越强，即S越大，SL的值越大。

另一方面，在可选择的组合方式和范围有限的情况下，口令长度越长则口令强度越强，即L越大，SL的值越大。

由于SL是指数级的增长，所以口令的高复杂度并不意味着口令的高强度，比如：

> 16位纯数字的口令的组合方式有10的16次方，而8位数字/字母/特殊字符混合口令的组合方式仅约为95的8次方。

从暴力破解的难度上看，前者比后者要高出一个数量级。



穷举出16位纯数字的密码，一共有 1,0000,0000,0000,0000 种情况。每种情况



**查表法**



在很多年前，国外的黑客们就发现单纯地通过导入字典，采用和目标同等算法破解，其速度其实是非常缓慢的，就效率而言根本不能满足实战需要。

之后通过大量的尝试和总结，黑客们发现如果能够实现直接建立出一个数据文件，里面事先记录了采用和目标采用同样算法计算后生成的Hash散列数值，在需要破解的时候直接调用这样的文件进行比对，破解效率就可以大幅度地，甚至成百近千近万倍地提高，这样事先构造的Hash散列数据文件在安全界被称之为Table表(文件)。

通过这种表直接破解就叫查表法。





查表法对于破解一系列算法相同的哈希值有着无与伦比的效率。主要的思想就是预计算密码字典中的每个密码，然后把哈希值和对应的密码储存到一个用于快速查询的数据结构中。

一个良好的查表实现可以每秒进行数百次哈希查询，即使表中储存了几十亿个哈希值。



**彩虹表**

最出名的Tables是Rainbow Tables，即安全界中常提及的彩虹表



它是以Windows的用户帐户LM/NTLM散列为破解对象的。简单说明一下，在 Windows2000/XP/2003系统下，账户密码并不是明文保存的，而是通过微软所定义的算法，保存为一种无法直接识别的文件，即通常所说的SAM文件。

这个文件在系统工作时因为被调用所以不能够被直接破解。但我们可以将其以Hash即散列的方式提取，以方便导入到专业工具破解：







**彩虹表不是 “密码 ⇨ 明文” 的简单存储**。要从 c = hash(m) 逆向得到原始明文 m，有三种办法：

 



**密码加盐**

查表法和彩虹表只有在所有密码都以相同方式进行哈希加密时才有效。如果两个用户密码相同，那么他们密码的哈希值也是相同的。

哈希加盐

https://www.tomczhen.com/2016/10/10/hashing-security/

https://cloud.tencent.com/developer/article/1805350



#### 加密算法



- 可逆加密：数据的加密和解密都需要使用秘钥操作。
  对称加密：常见的对称加密算法有DES、3DES、AES128、AES192、AES256
  非对称加密 ：常见的非对称加密有RSA、SM2，RS256 (采用SHA-256 的 RSA 签名)

Base64转码：把字符串转换成以“==”结尾的字符串。如：Z38cPD5XbiPZ41LKQmhZAw==！







#### **对称加密算法**

1976年以前，所有的加密方法都是同一种模式：

1.信息的发送方，选择某一种加密规则（比如说密码本，汉字与字符的映射表等），对信息进行加密，然后进行发送；

2.接收方使用同一种规则，对信息进行解密。



**这种方式被称为对称加密，加密规则被称为密钥。**

这种加密模式有一个最大弱点：甲方必须把加密规则告诉乙方，否则无法解密。保存和传递密钥，就成了最头疼的问题。



对称加密是使用同一个密钥对信息进行加解密。

这就类似于，我们对一个压缩包进行加密时输入一个密码，那么我们在解密时输入同一个密码进行解密，一个道理。

加密过程：明文+密钥a，进行加密，输出密文。

解密过程：密文+密钥a，进行解密，输出明文。



另外在多方通信中，密钥的管理也会非常的麻烦。

在数据传送前，发送方和接收方必须商定好密钥，然后使双方都能保存好密钥。其次如果一方的密钥被泄露，那么加密信息也就不安全了。

另外，每对用户每次使用对称加密算法时，都需要使用其他人不知道的唯一秘密钥，也就是说每一组收发方所使用的密钥都是唯一的，例如：A电脑与B、C、D都有通信，那么A就得存储与B、C、D三台电脑通信所用的密钥。这会使得收、发双方所拥有的钥匙数量巨大，密钥管理成为双方的负担。





#### 非对称加密算法



可以在不直接传递密钥的情况下，完成解密。这能够确保信息的安全性，避免了直接传递密钥所造成的被破解的风险。

与对称加密算法不同，是由一对密钥来进行加解密的过程，分别称为公钥和私钥。

两者之间有数学相关，该加密算法的原理就是对一极大整数做因数分解的困难性来保证安全性。

一般有如下2种用法：

- 公钥加密，私钥解密。

- 私钥加密，公钥解密。

即如果用公开密钥对数据进行加密，只有用对应的私有密钥才能解密；

如果用私有密钥对数据进行加密，那么只有用对应的公开密钥才能解密。

从理论上讲，生成的公钥和私钥是对等的，只是两个数而已。把它们哪个公开出去用于加密，哪个保留起来用于解密，都是一样的。

但是严格地讲，“私钥加密，公钥解密”这种说法是错误的。实际上，公钥和私钥在安全等方面，有完全不同的要求。

故，我们常用的用法是：公钥加密，私钥解密。

通常个人保存私钥，公钥是公开的（可能同时多人持有）。





在 CTF 中通常也会有密码类的题目，掌握一些常见密文特征也是 CTFer 们必备的技能！



- 编码：Base 系列、Unicode、Escape、URL、Hex；
- 算法：MD5、SHA 系列、HMAC 系列、RSA、AES、DES、3DES、RC4、Rabbit、SM 系列；
- 混淆：Obfuscator、JJEncode、AAEncode、JSFuck、Jother、Brainfuck、Ook!、Trivial brainfuck substitution；
- 其他：恺撒密码、栅栏密码、猪圈密码、摩斯密码、培根密码、维吉尼亚密码、与佛论禅、当铺密码。



Base64 是我们最常见的编码，除此之外，其实还有 Base16、Base32、Base58、Base85、Base100 等，他们之间最明显的区别就是使用了不同数量的可打印字符对任意字节数据进行编码，比如 Base64 使用了64个可打印字符（A-Z、a-z、0-9、+、/），Base16 使用了16个可打印字符（A-F、0-9）



- Base16：结尾没有等号，数字要多于字母；
- Base32：字母要多于数字，明文数量超过10个，结尾可能会有很多等号；
- Base58：结尾没有等号，字母要多于数字；
- Base64：一般情况下结尾都会有1个或者2个等号，明文很少的时候可能没有；
- Base85：等号一般出现在字符串中间，含有一些奇怪的字符；
- Base100：密文由 Emoji 表情组成。





### 密钥交换算法

“密钥协商机制”是：（在身份认证的前提下）如何规避【偷窥】的风险。
通俗地说，即使有攻击者在偷窥你与服务器的网络传输，客户端（client）依然可以利用“密钥协商机制”与服务器端（server）协商出一个用来加密应用层数据的密钥（也称“会话密钥”）。



目前最常用的密钥交换算法有 RSA 和 ECDHE：RSA 历史悠久，支持度好，但不支持 PFS（Perfect Forward Secrecy）；

而 ECDHE 是使用了 ECC（椭圆曲线）的 DH（Diffie-Hellman）算法，计算速度快，支持 PFS。

要了解更多 RSA 和 ECDHE 密钥交换的细节，可以阅读 Cloudflare 的这篇文章：https://blog.cloudflare.com/keyless-ssl-the-nitty-gritty-technical-details/。



内置 ECDSA 公钥的证书一般被称之为 ECC 证书，内置 RSA 公钥的证书就是 RSA 证书。

由于 256 位 ECC Key 在安全性上等同于 3072 位 RSA Key，加上 ECC 运算速度更快，ECDHE 密钥交换 + ECDSA 数字签名无疑是最好的选择。

由于同等安全条件下，ECC 算法所需的 Key 更短，所以 ECC 证书文件体积比 RSA 证书要小一些。



RSA 证书可以用于 RSA 密钥交换（RSA 非对称加密）或 ECDHE 密钥交换（RSA 非对称签名）；而 ECC 证书只能用于 ECDHE 密钥交换（ECDSA 非对称签名）。

并不是所有浏览器都支持 ECDHE 密钥交换，也就是说 ECC 证书的兼容性要差一些。

例如在 Windows XP 中，使用 ECC 证书的网站只有 Firefox 能访问（Firefox 的 TLS 自己实现，不依赖操作系统）；Android 平台中，也需要 Android 4+ 才支持 ECC 证书。



好消息是，Nginx 1.11.0 开始提供了对 RSA/ECC 双证书的支持。

它的实现原理是：分析在 TLS 握手中双方协商得到的 Cipher Suite，如果支持 ECDSA 就返回 ECC 证书，否则返回 RSA 证书。

也就是说，配合最新的 Nginx，我们可以使用 ECC 证书为现代浏览器提供更好的体验，同时老旧浏览器依然会得到 RSA 证书，从而保证了兼容性。这一次，鱼与熊掌可以兼得。



**国密证书**

国密算法是由国家密码管理局制定的自主可控的国产算法，其能够提高加密强度和加解密性能，满足政府、事业单位、大型国企、金融等行业的国产化改造和国密算法合规需求，建立起以国产密码为主要支撑的信息安全保障体系。

然而，由于国密算法在操作系统和浏览器等环境中并未得到全面兼容，传统浏览器可能存在国密算法适配问题，同时还可能存在操作系统与根证书信任的问题，导致使用国密证书的网站可能无法正常使用。



Web应用服务器仅部署了国密SSL证书，则只能在支持国密算法的浏览器中访问，如密信浏览器和红莲花浏览器。

因此，为了确保与各类浏览器的兼容性，通常会采取SM2/RSA双证书部署方案。



## 三、身份认证/加签验签/

**基于某些“私密的共享信息”**

为了解释“私密的共享信息”这个概念，咱们先抛开“信息安全”，谈谈日常生活中的某个场景。

假设你有一个久未联系的老朋友。因为时间久远，你已经没有此人的联系方式了。某天，此人突然给你发了一封电子邮件。
那么，你如何确保——发邮件的人确实是你的老朋友？

有一个办法就是：你用邮件向对方询问某个私密的事情（这个事情只有你和你的这个朋友知道，其他人不知道）。如果对方能够回答出来，那么对方【很有可能】确实是你的老朋友。

从这个例子可以看出，如果通讯双方具有某些“私密的共享信息”（只有双方知道，第三方不知道），就能以此为基础，进行身份认证，从而建立信任。



**基于双方都信任的“公证人”**

“私密的共享信息”，通常需要双方互相比较熟悉，才行得通。如果双方本来就互不相识，如何进行身份认证以建立信任关系？

这时候还有另一个办法——依靠双方都信任的某个“公证人”来建立信任关系。

如今 C2C 模式的电子商务，其实用的就是这种方式——由电商平台充当公证人，让买家与卖家建立某种程度的信任关系。



对于 SSL/TLS 的应用场景，由于双方（“浏览器”和“网站服务器”）通常都是素不相识，显然【不可能】采用第一种方式（私密的共享信息）。而只能采用第二种方式（依赖双方都信任的“公证人”）。

那么，谁来充当这个公证人？这时候，CA 就华丽地登场啦。所谓的 CA，就是“数字证书认证机构”的缩写，英文全称叫做“Certificate Authority”。



### 数字签名

通常误解出现在对签名的理解上，有很多人把签名也理解成加密（虽然本质上仍然是加密，但签名的目的不同，技术实现也有所不同），认为只要签名了，数据就不出被泄漏了，这是很大的一个误解。

**签名的作用不是防泄密，而是防篡改**



对信息内容追加签名

每次写完信，除了对信件内容进行加密外，还会用一套算法，针对信件明文生成一个签名（一般不会对明文直接签名，先会用哈希算法对明文进行摘要，然后对摘要进行加密，这个密文就叫签名）

这套算法会保证：只要信件明文有任何改动，生成的签名都是不一样的。

这样就做到了防篡改吗？是的，回到故事中，你的女友收到信件其实包含两个密文，一个是明文加密后的内容，我们称之为密文，一个是明文摘要加密后的内容，我们称之为签名。她收到你的信后，先要进行验签操作。即先用私钥解密密文，得到解密后的明文。那这个明文与原来的明文一致吗？他用同样的算法对收到明文做摘要，我为记为摘要2，然后再用公钥解密签名，得到摘要1，如果摘要2与摘要1相同，那么就说明信件明文或密文没有被篡改。如果两个摘要不同，那么她马上明白，密文不可信，被篡改过。即验签不通过。



**数字签名**的过程通常如下：

1. 发送者使用一个散列函数（如SHA-256）对原始数据生成一个固定长度的**消息摘要**（或哈希值）。
2. 发送者使用自己的**私钥**对这个消息摘要进行加密，从而生成**数字签名**。
3. 发送者将原始数据和数字签名一起发送给接收者。

接收者收到数据后，会进行以下验证：

1. 接收者用相同的散列函数对收到的数据重新计算一次消息摘要。
2. 接收者使用发送者的**公钥**来解密数字签名，得到发送者计算的原始消息摘要。
3. 接收者比对两个消息摘要。如果它们完全一致，则证明数据未被篡改，且确实是由拥有相应私钥的发送者发送的。



在这个过程，生成摘要的目的是为了加密数据，利用私钥加密摘要数据即为签名。



### 代码签名

**众所周知，软件流氓推广几乎无处不在，让人防不胜防，您要没有火眼金睛或者稍有疏忽，各种全家桶绝对会让你抓狂。**

[代码签名](https://www.digicert.com/cn/signing/code-signing-certificates)是将数字签名应用于软件二进制文件或文件的流程。

此数字签名验证软件作者或发布者的身份，并验证文件自签名以来是否未被更改或篡改。

代码签名向软件接收者表明代码可以受到信任，而且代码签名在打击入侵系统或数据的恶意企图方面发挥着重要作用。

代码签名是开发者对软件进行的数字签名，用户可根据签名确认开发者的身份，确保自己下载的版本来源可信且没有经过第三方篡改。



- **确保软件来自软件发布者**
- **保护软件在发行后不被更改**

代码签名的用例包括内部或外部使用的软件、补丁或修复程序、测试、IoT设备产品开发、计算环境和移动应用程序。

除了代码和软件之外，代码签名还适用于应用程序、固件、文件、消息、XML、脚本、容器和图像。







[代码签名证书](https://www.digicert.com/cn/signing/code-signing-certificates)通常被软件工程师或开发人员用于对应用程序、驱动程序、软件和其他可执行文件进行数字签名。

代码签名证书为最终用户提供了一种验证已发布代码是否未被第三方更改或入侵的方法。

代码签名证书包含您的签名、公司名称以及时间戳（如需要）。[代码签名证书](https://www.digicert.com/cn/solutions/security-solutions-for-code)的优势在于：

- 保护您的知识产权
- 防止程序上出现安全警告标签
- 高效监测代码更改
- 履行合同义务



https://oldj.net/article/2022/07/15/code-signing-with-electron-on-windows/



**jar包的签名和认证？**

我们相关的class文件打包成了jar包之后，在传递这个jar的时候，如何防止jar不被他人暗中的修改呢？

- 方案一，可能你会想到对整个jar文件进行加密，这个思路是可行的，但是却显得比较笨拙，对每个jar文件都执行加密，需要的时候又要执行解密，不仅浪费时间，效率上也是不可取的。
- 方案二。对jar包的部分内容进行加密，这个思路好像效率高点，但是对哪一部分进行加密？如果没有加密的那一部分被修改了怎么确认？这又一个问题。

​     以上两种简单地解决方案虽然看起来简单但是实施起来都是有困难的，那么有没有好的方法？

​     有，在jar文件上hash摘要，简单的说hash摘要就是有一个叫hash(String content)的哈希函数，当你传入内容的时候它都将返回一个独一无二个的128的hash数值，这样无论传入的内容多大，hash摘要的长度是固定的。

当然附加到jar文件的最后面时总体上并不会影响jar的结构和传输。

​         只要接收方也拥有这个hash函数，那么将jar的内容进行hash后的值再和附加在jar中的hash值做对比就可以知道jar的内容是否被修改过了，看起来好像完美了，

　　但是如果有意破坏的人把jar和hash都替换成具有破坏性ar文件以及由这个具有破坏性的jar文件进行hash运算的hash值，那么前面做的事情也就都没有意义了，于是聪明的人类想到了

　　对hash摘要运用私钥进行加密，这样只有加密方才能对hash值加密，而解密的那方运用公钥进行解密，而且它总是知道怎么解密的，我们把对hash摘要进行加密的过程称之为签名。

​    这就是jar包签名的大致过程好吧，上面引述了那么多，无非是想描述下面图3-3的过程，如果你看到这个图完全明白，那前面那段废话就直接跳过吧！



### 接口加签验签

HTTPS 已经为数据提供了传输过程中的加密和防篡改保护，那为什么还需要加签验签？因为 HTTPS 无法解决**业务请求的合法性**问题。

在不同的或系统之间通过API接口进行交互时，两个系统之间必须进行身份的验证，以满足安全上的防抵赖和防篡改。



**接口加签**，是指客户端在发送请求调用接口之前，需要通过**密钥**或**证书**对消息内容进行签名的过程，是业务自身对通讯数据的签名，保证业务数据和合法性。

**工作原理：**

1. **准备数据：** 客户端会把请求中的关键数据（如 `timestamp`、`nonce`、请求参数等）按特定规则组合成一个字符串。
2. **生成签名：** 客户端使用一个双方共享的**密钥**（或私钥）和一种加密算法（如 HMAC-SHA256、RSA 等），对上一步生成的字符串进行加密或哈希运算，得到一个唯一的**签名（Signature）**。
3. **发送请求：** 客户端将这个签名作为请求的一部分（通常放在 HTTP Header 或 URL 参数中），连同原始数据一起发送给服务器。



**接口验签**：接口验签是**服务器**在接收到请求后，对签名进行验证的过程。这就像验证印章的真伪。

**工作原理：**

1. **提取数据：** 服务器从接收到的请求中提取出原始数据和客户端发送过来的签名。
2. **重新生成签名：** 服务器使用同样的**密钥**（或公钥）和加密算法，对提取出的原始数据重新计算一次签名。
3. **比对签名：** 服务器将自己计算出的签名与客户端发来的签名进行比对。



接口加签和验签是一种在应用层实现的、针对 API 请求的**身份验证和数据完整性保护机制**。接口加签验的过程，不是为了证明自己的身份



重放攻击是指攻击者截获合法请求后，再次发送该请求。为了防止这种情况，我们可以结合时间戳或随机数来增强安全性。



接口加签是**客户端**在发送请求前，对请求数据进行签名的过程。这就像给请求盖一个私密的“印章”。

### CA证书数字签名过程

申请证书的过程，也可存在着信任链问题：

第一个问题：我是 google.com 的域名持有者，我要向CA机构申请一个 https://www.google.com 的 https 证书。我如何证明我持有这个域名？

>  即，域名持有者向CA申请时，如何自证自己是真正持有域名？				

第二个问题：域名持有者，向CA机构申请HTTPS证书，如何确认通讯过程是真正的CA。

>  即，CA签发证书给网站持有者，如何自证是真正的CA？

X.509标准就是一套这样的：签发流程， 证书格式等的规范。



CA 签发证书的过程：

1）申请者准备CSR文件：

我自己的网站，需要使用 https 通信，那么我向"证书CA机构"申请数字证书的时候，就需要向他们提供相应的信息，这些信息要以特定文件格式(.csr)提供的。

CSR是以-----BEGIN CERTIFICATE REQUEST-----开头，-----END CERTIFICATE REQUEST-----为结尾的base64格式的编码。

将其保存为文本文件，就是所谓的CSR文件。这个文件就是"证书签名请求文件"；

申请者首先在本地生成一个非对称的密钥对，利用这个私钥对"我们需要提供的信息（域名等）"进行加密，从而生成证书请求文件(.csr)，这个证书请求文件其实就是私钥对应的公钥证书的原始文件，里面含有对应的公钥信息；

同时根据 pub_svr 生成请求文件 csr，提交给 CA 机构，csr 中含有申请者的公钥、组织信息、个人信息（域名）等信息。（注意：只提交公钥。不提交私钥）

[什么是CSR文件](https://cloud.tencent.com/document/product/400/5367)

[如何制作CSR文件](https://support.huaweicloud.com/scm_faq/scm_01_0059.html)

[在线制作CSR](https://myssl.com/csr_create.html)

> 备注：
>
> 手动CSR：上述过程用户自己生成。
>
> 自动CSR：在很多公有云中申请SSL证书，它们都自动在线帮你生成CSR文件了。大大简化操作。
>
> 大部分公有云会帮你生成这个密钥对，并用公钥



注意：通过网络发出去给CA机构的CSR文件，除了包含域名基本信息外，还有用户自己的公钥。





2)  [身份验证](https://support.huaweicloud.com/ccm_faq/ccm_01_0135.html)：按照CA中心的规范，申请数字证书，必须配合完成域名授权验证来证明您对所申请绑定的域名的所有权。

所以对于所有的申请者，CA都要确保申请者确实是有这个域名的控制权，才能给他签发证书。即要验证申请人的身份。

行业的标准叫做 [ACME Challenge](https://letsencrypt.org/zh-cn/docs/challenge-types/)，大致的原理是：申请者向（CA）证明自己是 super-bank.com, 你让 `super-bank.com/.well-known/acme-challenge/foo` 这个 URL 返回 `bar` 这个 text，来证明你有控制权，我就给你发证书。（其实还支持 DNS TXT 等其他的方式）



- DNS验证：CA指定一条DNS记录，你去你的域名商处添加一条DNS解析，CA来验证。

- 文件验证：将CA指定的txt文件部署到你的域名下，CA来验证。

- 邮箱验证：邮箱验证指通过回复邮件的方式来验证域名所有权。

  [域名验证方式](https://cloud.tencent.com/document/product/400/4142)



2）审核信息：CA 机构通过线上、线下等多种手段验证申请者提供信息的真实性，如组织是否存在、企业是否合法，是否拥有域名的所有权等。



3）签发证书：如信息审核通过，CA 机构会向申请者签发认证文件：HTTPS证书

CA会对提交的证书请求中的所有信息生成一个摘要，然后使用CA根证书对应的私钥进行加密，这就是所谓的“签名”操作，完成签名后就会得到真正的签发证书(.cer或.crt)



在CA签发的证书中，包含申请者的公钥在内，几乎所有的数据都是明文的，也都是申请者自己提供的（当然CA需要审核），签发的证书唯一多出来的信息就是基于申请者提供的所有信息生成了一份摘要，然后用CA自己的私钥对摘要进行了加密，这段加密后的密文被称之为“签名”，这部分数据是返还的签发证书(.cer或.crt)中多出来的关键数据。



- HTTPS证书包含以下信息：

  - 申请者公钥、申请者的组织信息和个人信息、签发机构 CA 的信息、有效时间、证书序列号等信息的明文。
  - 同时包含一个签名（CA自证这个证书是这个CA签发的）

- 这个签名算法：

  - 首先，使用散列函数计算公开的明文信息的信息摘要，得到HASH值，然后用 **CA 的私钥** 对信息摘要进行加密，密文即签名。

  - （注意CA的公钥是）

    

> 我们可以拿到证书之后，可以在线查看证书的信息。
>
> [证书信息查看](https://myssl.com/cert_decode.html)



### HTTPS证书格式

本质上 SSL 证书是一个 X.509 证书，是定义证书数据结构的标准。

在 X.509 标准下，包含 Base64 ASCII 文本与二进制两种文件储存方式，根据使用的格式和编码，证书文件具有不同的扩展名。



大多数 CA (证书颁发机构) 提供 PEM 格式的证书，保存在 Base64 ASCII 编码的文件中。证书文件类型可以是 `.pem`、`.crt`、`.cer` 或 `.key`。

因为是文本类型，所以对文件后缀名不敏感。PEM 文件可以在单个文件中包含服务器证书、中间证书和私钥。

服务器证书和中间证书也可以放在单独的 `.crt` 或 `.cer` 文件中，私钥可以放在 `.key` 文件中。

PEM 文件使用 ASCII 编码，可以使用文本编辑器打开，文本内容中公钥、私钥都有两种形式。

X.509 规定，取 `----` 开头的下一行首开始，到下一个 `----` 开头的上一行尾结束。



**PKCS12 格式**

PKCS#12证书采用二进制格式，文件扩展名为 `.pfx` 或 `.p12`，支持将 `服务器证书`、`中间证书` 和 `私钥` 存储在一个具有密码保护的文件中，主要用于Windows平台。



## 四、TLS通讯流程



TCP/IP 传输协议的 TCP 协议是面向连接的，也就是传输数据之前，必须建立可靠的连接。

建立连接的过程中，需交换信息（如选取哪种协议、协议版本等），这个过程称为*握手 handshaking*。



握手过程中会协商后续通信使用的参数，如传输速率、编码方式、校验，以及其他协议选取、硬件支持的功能等。

握手是两个实体之间的通信，但在 TCP/IP 中握手常指 TCP 的三次握手。



### TCP握手

建立 TCP 连接需要三次握手：

1. 客户端想要连接服务端时，向服务端发送 SYN message。Message 还包含 sequence number（32位的随机数），ACK 为0，window size、最大 segment 大小。并进入**SYN_SENT**状态，等待服务器确认。

   例如，如果 window size 是 2000 bits，最大 segment 大小是 200 bits，则最大可传输 segments 是 10 data。

   （其中，SYN=1，ACK=0，表示这是一个TCP连接请求数据报文；序号seq=x，表明传输数据时的第一个数据字节的序号是x）。

   

2. 服务端收到客户端 synchronization request 后，回复客户端 SYN 和 ACK。ACK 数值是收到的 SYN 加一。例如客户端发送的 SYN 是 1000，则服务端回复的 ACK 是 1001。

   如果服务端也想建立连接，回复中还会包括一个 SYN，这里的 SYN 是另一随机数，与客服端的 SYN 不相同。这一阶段完成时，客户端与服务端的连接已经建立。

   

3. 客户端收到服务器的SYN+ACK包，向服务器发送一个序列号(seq=x+1)，确认号为ack(客户端)=y+1。收到服务端的 SYN 后，客户端回复 ACK，ACK 值是 SYN 值加一。这一过程完成后，服务端与客户端的连接也建立了起来。



建立连接时，客户端发送SYN包到服务器，其中包含客户端的初始序号seq=x，

（其中，SYN=1，ACK=0，表示这是一个TCP连接请求数据报文；序号seq=x，表明传输数据时的第一个数据字节的序号是x）。



TCP 连接的双方通过三次握手确定 TCP 连接的初始序列号、窗口大小以及最大数据段，这样通信双方就能利用连接中的初始序列号保证双方数据段的不重不漏，通过窗口大小控制流量，并使用最大数据段避免 IP 协议对数据包分片。

换个角度看为什么需要三次握手？客户端和服务端通信前要进行连接，三次握手就是为了确保自己和对方的收发能力是正常的。

1. 第一次握手：客户端发送、服务端接收网络包，服务端可以得出：客户端发送能力、服务端接收能力是正常的。
2. 第二次握手：服务端发送、客户端接收网络包。从客户端的视角来看，我接收到了服务端发送的响应数据包，说明服务端收到了第一次握手时我发出的网络包，且收到请求后进行了响应，这说明服务端的接收、发送能力正常，我的发送、接收能力正常。
3. 第三次握手：客户端发送、服务端接收网络包，这样服务端就能得出结论：客户端的接收、发送能力正常，服务端的发送、接收能力正常。第一次、二次握手后，服务端并不知道客户端的接收能力，以及自己的发送能力是否正常。第三次握手后，这些能力才得以确认。



三次握手后，客户端、服务端才确认了自己的接收、发送能力均是正常的。



TCP 中的连接是什么，我们简单总结一下：用于保证可靠性和流控制机制的信息，包括 Socket、序列号以及窗口大小叫做连接。

建立 TCP 连接就是通信的双方需要对上述的三种信息达成共识，连接中的一对 Socket 是由互联网地址标志符和端口组成的，窗口大小主要用来做流控制，最后的序列号是用来追踪通信发起方发送的数据包序号，接收方可以通过序列号向发送方确认某个数据包的成功接收。

到这里，我们将原有的问题转换成了『为什么需要通过三次握手才可以初始化 Sockets、窗口大小和初始序列号？』，那么接下来我们就开始对这个细化的问题进行分析并寻找解释。





### TLS握手

**一般情况下，不管 TLS 握手次数如何，都得先经过 TCP 三次握手后才能进行**。因为 HTTPS 都是基于 TCP 传输协议实现的，得先建立完可靠的 TCP 连接才能做 TLS 握手的事情。



「HTTPS 中的 TLS 握手过程可以同时进行三次握手」

- **客户端和服务端都开启了 TCP Fast Open 功能，且 TLS 版本是 1.3；**
- **客户端和服务端已经完成过一次通信。**



https://aandds.com/blog/network-tls.html#2fa47076



#### TCP Fast Open

TCP Fast Open（TFO）是对传输控制协议（TCP）的一种扩展，用于加快两个端点之间连续 TCP 连接的打开速度。TFO由2014年12月发布的RFC 7413定义。



在传统的 TCP 三次握手过程中，建立连接需要一个完整的往返时间（Round Trip Time，RTT），这对于一些对延迟敏感的应用，如网页浏览等，会造成一定的性能损失。特别是在网络延迟较高的情况下，这种延迟影响更为明显。

Google研究发现TCP三次握手是页面延迟时间的重要组成部分，所以他们提出了TFO：在TCP握手期间交换数据，这样可以减少一次RTT。根据测试数据，TFO可以减少15%的HTTP传输延迟，全页面的下载时间平均节省10%，最高可达40%。

TCP Fast Open 的目的就是为了减少这种连接建立的延迟，提高 TCP 连接的效率。



工作原理：

- 首次连接请求
  - 客户端发送 SYN 报文，报文中包含 `Fast Open` 选项，且该选项的 `Cookie` 为空，表示客户端请求 `Fast Open Cookie`。
  - 服务器如果支持 `Fast Open` 功能，会生成一个 Cookie，并将 Cookie 放置在 `SYN+ACK` 报文中的 `Fast Open` 选项中返回给客户端。
  - 客户端收到 `SYN+ACK` 报文以后，本地缓存 Fast Open 选项中的 Cookie。
- 后续连接建立
  - 客户端再次向服务器建立连接时，发送的 SYN 报文会包含数据以及本地缓存的 `Fast Open Cookie`。
  - 服务器在收到 Cookie 后会对其进行校验，如果 Cookie 有效，服务器将在 SYN+ACK 报文中对 SYN 和数据进行确认，并且随后会将数据返回给客户端。如果 Cookie 无效，服务器会丢弃 SYN 报文中的数据，随后的确认报文只会确认 SYN 对应的序列号。
  - 客户端会发送 ACK 确认服务器发回的 SYN 以及数据，如果第一次握手时数据没有被确认，客户端会重新发送数据。



作用：

- **降低连接延迟**：通过在首次连接时获取 Cookie，后续连接可以在第一次握手时就发送数据，跳过了一个 RTT 的延迟，能够显著提高连接建立的速度，对于频繁建立连接的应用场景，如网页浏览、在线游戏等，性能提升效果明显。
- **减轻服务器负担**：在某些情况下，例如突发的大量连接请求，TFO 可以减少服务器在连接建立阶段的处理负担，因为部分数据可以在早期就开始传输，而不需要等待三次握手完全完成。





TLS 和 HTTP/1.x 一样，目前受到主流支持的 TLS 协议版本是 1.1 和 1.2，分别发布于 2006年和2008年，也都已经落后于时代的需求了。在2018年8月份，IETF终于宣布TLS 1.3规范正式发布了。

TLS 握手中的确切步骤将根据所使用的密钥交换算法的种类和双方支持的密码套件而有所不同。RSA 密钥交换算法虽然现在被认为不安全，但曾在 1.3 之前的 TLS 版本中使用。





- 客户端问候：握手开始，Client 先发送 ClientHello ，在这条消息中，Client 会上报它支持的所有“能力”。
  - client_version 中标识了 Client 能支持的最高 TLS 版本号；
  - random 中标识了 Client 生成的随机数，用于预备主密钥和主密钥以及密钥块的生成，总长度是 32 字节，其中前 4 个字节是时间戳，后 28 个字节是随机数；
  - cipher_suites 标识了 Client 能够支持的密码套件。
  - extensions 中标识了 Client 能够支持的所有扩展。



- Server 在收到 ClientHello 之后，如果能够继续协商，就会发送 ServerHello，否则发送 Hello Request 重新协商。在 ServerHello 中，Server 会结合 Client 的能力，选择出双方都支持的协议版本以及密码套件进行下一步的握手流程。    
  - server_version 中标识了经过协商以后，Server 选出了双方都支持的协议版本。
  - random 中标识了 Server 生成的随机数，用于预备主密钥和主密钥以及密钥块的生成，总长度是 32 字节，其中前 4 个字节是时间戳，后 28 个字节是随机数；
  - cipher_suites 标识了经过协商以后，Server 选出了双方都支持的密码套件。
  - extensions 中标识了 Server 处理 Client 的 extensions 之后的结果。


| 序号 | 方向   | 协议                | 描述                                                         |
| ---- | ------ | ------------------- | ------------------------------------------------------------ |
| 1    | C —> S | Client Hello        | 客户端向服务端发送 Client Hello 消息。消息携带客户端支持的TLS协议版本、加密算法、压缩算法，以及客户端生成的随机数（client random）。 |
| 2    | S —> C | Server Hello        | 服务端发送它选择的 TLS 版本，加密套件，`服务端随机数` 给客户端。 |
| 3    | S —> C | Certificate         | 服务端发送 CA 证书（公钥 + 证书持有者等信息）给客户端。即服务端的证书链，其中包含证书支持的域名、发行方和有效期等信息。 |
|      |        | Server Key Exchange | 服务端生成 `椭圆曲线私钥` ==> 生成 `椭圆曲线公钥` ==> 服务端的 RSA 私钥实现 `椭圆曲线公钥签名`。 2. 服务端发送：椭圆曲线算法信息，`（服务端的）椭圆曲线公钥`，`（服务端的）椭圆曲线公钥签名` 给客户端。 |
|      |        | Server Hello Done   | 服务端发送确认给客户端，已完成 Hello 阶段流程。              |



| 序号 |  方向  |  握手  |                             协议                             | 描述                                                         | 抓包 |
| :--: | :----: | :----: | :----------------------------------------------------------: | :----------------------------------------------------------- | :--: |
|  1   | C —> S | 第一次 |                         Client Hello                         | 客户端发送它支持的 TLS 版本，加密套件列表，`客户端随机数` 给服务端。 |      |
|  2   | S —> C | 第二次 |                         Server Hello                         | 服务端发送它选择的 TLS 版本，加密套件，`服务端随机数` 给客户端。 |      |
|  3   | S —> C | 第二次 |                         Certificate                          | 服务端发送 CA 证书（公钥 + 证书持有者等信息）给客户端。      |      |
|  4   | S —> C | 第二次 |                     Server Key Exchange                      | 1. 服务端生成 `椭圆曲线私钥` ==> 生成 `椭圆曲线公钥` ==> 服务端的 RSA 私钥实现 `椭圆曲线公钥签名`。 2. 服务端发送：椭圆曲线算法信息，`（服务端的）椭圆曲线公钥`，`（服务端的）椭圆曲线公钥签名` 给客户端。 |      |
|  5   | S —> C | 第二次 |                      Server Hello Done                       | 服务端发送确认给客户端，已完成 Hello 阶段流程。              |      |
|  6   | C —> S | 第三次 |                     Client Key Exchange                      | 客户端生成 `椭圆曲线公钥`，并将其发送给服务端。 1. 客户端接收到证书后，通过本地系统的 证书链 验证该证书是否合法。 2. 客户端通过证书公钥解签 `（服务端的）椭圆曲线公钥`，确认该数据的完整性和安全性。 3. 客户端生成 `椭圆曲线私钥` ==> 生成 `椭圆曲线公钥`。 4. 客户端使用服务端的 RSA 公钥加密客户端的 `椭圆曲线公钥`，并将其发送给服务端。 |      |
|  7   | C —> S | 第三次 |                      Change Cipher Spec                      | 客户端通知服务端，确认握手过程中的加密算法和密钥已经生效，表示之后的消息都将使用新的密钥。 1.`（客户端的）椭圆曲线私钥` 和 `（服务端的）椭圆曲线公钥` 通过点运算计算出新的点 (x，y)，取 x 作为 `预主密钥`。 2. 客户端随机数 + 服务端随机数 + 预主密钥 = [主密钥](https://www.laoqingcai.com/tls1.2-premasterkey/) ==> `会话密钥`。 3. 客户端的会话密钥已协商出来，客户端发送确认给服务端。 |      |
|  8   | C —> S | 第三次 | [Encrypted Handshake Message](https://blog.csdn.net/mrpre/article/details/77868570) | 客户端将之前的握手数据（发送和接收）做一个摘要，再用会话密钥（对称密钥）加密摘要数据，将密文发送给服务端。作用： 1. 服务端解密密文以此验证双方协商出来的密钥是否一致。 2. 服务端还可以验证确认握手数据的安全性和完整性，保证不被中间人篡改。 |      |
|  9   | S —> C | 第四次 |                      New Session Ticket                      | 服务器发送该消息给客户端，包含一个新的会话票据，用于快速恢复会话，避免重复握手。 |      |
|  10  | S —> C | 第四次 |                      Change Cipher Spec                      | 服务端接收到客户端生成的 `椭圆曲线公钥`，也协商出共享的 `会话秘钥`，并通知客户端表示之后的消息都将使用新的密钥。 1.`（服务端的）椭圆曲线私钥` 和 `（客户端的）椭圆曲线公钥` 通过点运算计算出新的点 (x，y)，取 x 作为 `预主密钥`。 2. 客户端随机数 + 服务端随机数 + 预主密钥 = 主密钥 ==> `会话密钥`。 3. 服务端的会话密钥已协商出来，服务端发送确认给客户端。 |      |
|  11  | S —> C | 第四次 |                 Encrypted Handshake Message                  | 服务端将之前的握手数据（发送和接收）做一个摘要，再用会话密钥（对称密钥）加密摘要数据，将密文发送给客户端，确认握手过程的完成。 |      |



**TLS1.2握手**

使用 HTTPS 发送 HTTP 请求时，首先使用三次握手建立可靠的 TCP 连接，之后就通过 TLS 四次握手交换双方的密钥。



1. 客户端向服务端发送 Client Hello 消息。消息携带客户端支持的TLS协议版本、加密算法、压缩算法，以及客户端生成的随机数（client random）。
2. 服务端收到客户端消息后：
   1. 向客户端发送 Server Hello 消息，并携带选取的协议版本、加密方法、session id，以及服务端生成的随机数。
   2. 向客户端发送 Certificate 消息，即服务端的证书链，其中包含证书支持的域名、发行方和有效期等信息。
   3. 向客户端发送 Server Key Exchange 消息，传递公钥、签名等信息。
   4. 向客户端发送可选的 CertificateRequest 消息，验证客户端证书。
   5. 向客户端发送 Server Hello Done 消息，通知已经发送了全部的信息。
3. 客户端收到服务端的协议版本、加密方法、session id 和证书等信息后，验证服务端证书。
   1. 向服务端发送 Client Key Exchange 消息，包含使用服务端公钥加密的随机字符串，即预主密钥（Pre Master Secret）。
   2. 向服务端发送 Change Cipher Spec 消息，通知服务端后续数据会加密传输。
   3. 向服务端发送 Finished 消息，其中包含加密后的握手信息。
4. 服务端收到 Change Cipher Spec 和 Finished 消息后：
   1. 向客户端发送 Change Cipher Spec 消息，通知客户端后续数据会加密传输。
   2. 向客户端发送 Finished 消息，验证客户端的 Finished 消息并完成 TLS 握手。

TLS 握手的关键在于利用通信双方生成的随机字符串和服务端的公钥生成一个双方经过协商后的密钥，通信双方后续使用这个对称密钥加密数据，防止中间人监听和攻击，保障通信安全。

在 TLS 1.2 中，需要 2-RTT（Round-Trip Time，往返延迟）才能建立 TLS 连接。在 TLS 1.3 中，客户端不仅发送 ClientHello、支持的协议、加密算法，还尝试猜测服务器将选择哪种密钥协商算法，并为此发送共享密钥。这样服务端选取加密算法后，因为已经有了 client key，可以立即生成 key，进而减少一次 RTT。



客户端发送一个 `ClientHello` 消息到服务器端，消息中同时包含了它的 Transport Layer Security (TLS) 版本，可用的加密算法和压缩算法。





![](./assets/TLS.png)







## 五、TLS版本

2008 年 8 月 TLS v1.2 发布。

时隔 10 年，TLS v1.3 于 2018 年 8 月发布，在**性能优化**和**安全性**上做了很大改变，同时为了避免新协议带来的升级冲突，TLS v1.3 也做了兼容性处理，通过增加扩展协议来支持旧版本的客户端和服务器。



**安全性**

TLS v1.2 支持的加密套件很多，在兼容老版本上做的很全，里面有些加密强度很弱和一些存在安全漏洞的算法很可能会被攻击者利用，为业务带来潜在的安全隐患。

TLS v1.3 移除了这些不安全的加密算法，简化了加密套件，对于服务端握手过程中也减少了一些选择。

- 移除 MD5、SHA1 密码散列函数的支持，推荐使用 SHA2（例如，SHA-256）。
- 移除 RSA 及所有静态密钥（密钥协商不具有前向安全特性）。
- 溢出 RC4 流密码、DES 对称加密算法。
- 密钥协商时的椭圆曲线算法增加 https://www.wanweibaike.net/wiki-X25519 支持。
- 支持带 [Poly1305](https://www.wanweibaike.net/wiki-Poly1305)[消息验证码](https://www.wanweibaike.net/wiki-訊息驗證碼) 的 [ChaCha20](https://www.wanweibaike.net/wiki-ChaCha20) 流加密算法，流加密也是一种对称加密算法。
- 移除了 CBC 分组模式，TLS v1.3 对称加密仅支持 AES GCM、AES CCM、ChaCha20**-**Poly1305 三种模式。
- 服务端 “Server Hello” 之后的消息都会加密传输，因此常规抓包分析就会有疑问为什么看不到证书信息。



**性能优化**



https://github.com/qufei1993/blog/issues/30



TLS1.3 

TLS 1.3 是最新推荐的加密协议，适用于保护各种网络通信，包括网页浏览、电子邮件、在线交易、即时通讯、移动支付和其他许多应用。

通过使用 TLS 1.3，可以建立更安全、更可靠的通信连接，确保数据的私密性和完整性。它于2018年8月由互联网工程任务组（IETF）标准化，发布于文档 [RFC 8446](https://datatracker.ietf.org/doc/html/rfc8446)。

为了解决tls1.2存在的问题，`tls1.3`协议应运而生，tls1.3`废弃`了一些存在安全隐患的加密套件，并新增了一些`安全级别较高`的加密套件。

同时在**性能**上，TLS1.3能够实现`1-RTT`密钥协商，以及`0-RTT`连接恢复（tls1.2连接恢复需要`1-RTT`），握手效率提升了1倍左右。



TLS1.3支持的加密套件如下：

- TLS_AES_128_GCM_SHA256
- TLS_AES_256_GCM_SHA384
- TLS_CHACHA20_POLY1305_SHA256



从**加密套件**上看，与tls1.2相比（如：`tls_ecdhe_ecdsa_with_aes_128_gcm_sha256`）, tls1.3协议支持的加密套件不再包含`密钥协商算法`和`签名算法`，仅包含加密和摘要算法，这是因为在TLS 1.3中：

- 所有密钥协商默认使用`ECDHE算法`，这意味着在握手过程中，客户端和服务器都使用`椭圆曲线密钥协商`来生成共享的对称密钥。

  椭圆曲线Diffie-Hellman密钥交换提供了`强大的安全性`和`前向保密性`，可以抵抗主动攻击和被动监听。

- TLS1.3`允许`客户端和服务器`选择适当的签名算法`，以实现身份验证和握手完整性的保护。

  这种`灵活性`和`可扩展性`是TLS 1.3设计的一部分，以提供更安全和可靠的通信。

- TLS1.3仅支持AEAD带认证的加密算法，不再支持CBC模式的加密算法，提高了加密数据的安全性

> 注：*需要注意的是，尽管TLS1.3`默认使用ECDHE`作为密钥协商算法，但仍然`可以通过配置选择`其他密钥交换算法，如基于RSA的密钥交换（RSA Key Exchange）。然而，在TLS 1.3中，推荐使用ECDHE来获得更高的安全性和性能。*











## 六、HTTPS 加密了哪些内容？



**HTTPS 会加密 URL 吗？HTTPS 会加密头部吗？**

```http
<method> <request-URL> <version>\r\n
<headers1>\r\n
<headers2>\r\n
\r\n
<entity-body>
```

```http
<version>  <status> <reason-phrase>\r\n
<headers1>\r\n
<headers2>\r\n
\r\n
<entity-body>
```



因为 URL 的信息都是保存在 `HTTP ` 中的，而 HTTPS 是会对 `HTTP Header` 和  `HTTP Body` 整个加密的，所以 URL 自然是会被加密的。

浏览器显示信息是已经解密后的信息，所以不要误以为 URL 没有加密。如果你用抓包工具，抓包 HTTPS 的数据的话，你是什么都看不到的，如下图，只会显示“Application Data”，表示这是一个已经加密的 HTTP 应用数据。



```http
GET / HTTP/1.1
Host: google.com
Sec-Ch-Ua: "Not/A)Brand";v="8", "Chromium";v="126"
Sec-Ch-Ua-Mobile: ?0
Sec-Ch-Ua-Platform: "Windows"
Accept-Language: zh-CN
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.57 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
X-Client-Data: CPvqygE=
Sec-Fetch-Site: none
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Sec-Fetch-Dest: document
Accept-Encoding: gzip, deflate, br
Priority: u=0, i
Connection: keep-alive
```



但请注意 hostname 一般是会被明文传送的，因为 SNI是透明的。HTTPS 没有完全加密访问请求，因为 `Server Name` 依然是明文传输的。它发生在 HTTPS 传输过程中的 `Client Hello` 握手阶段



HTTPS 可以看到请求的域名吗？

从上面我们知道，HTTPS 是已经把  HTTP Header + HTTP Body 整个加密的，所以我们是无法从加密的 HTTP 数据中获取请求的域名的。

但是我们可以在 **TLS 握手过程中看到域名信息**。TLS 第一次握手的 “Client Hello” 消息中，有个 server name 字段，它就是请求的域名地址。



### SNI信息

SNI（Server Name Indication）是对SSL/TLS协议的扩展，允许服务器在单个IP地址上承载多个SSL证书，**可解决一个HTTPS服务器拥有多个域名但是无法预知客户端到底请求的是哪一个域名的服务问题。**

客户端建立HTTPS连接TLS握手第一步就是请求服务器的证书。而服务器在发送证书时，是不知道浏览器访问的是哪个域名的，所以不能根据不同域名发送不同的证书。

因此就引入一个扩展叫SNI，SNI是为了解决一个服务器使用多个域名和证书的SSL/TLS扩展，做法就是在 Client Hello 中补上请求的域名信息

（SNI，即服务器名称指示，允许在握手过程开始时通过客户端告诉服务器正在连接的主机名称，从而解决一个服务器拥有多个域名的情况。）



使用SNI时，服务器的主机名包含在TLS握手中，这使得HTTPS网站具有唯一的TLS证书，即使它们位于共享IP地址上也是如此。





## 七、TLS基本概念



### CA 机构

CA 即 **证书授权中心** (certificate authority)

类似于国家出入境管理处一样，给别人颁发护照；也类似于国家工商管理局一样，给公司/企业颁发营业执照。

我们可以把证书机构看作真实世界中的权威机构，例如政府部门。我们使用的身份证具有可信度，这是因为有政府部门担保其中信息的正确性。

在数字证书体系中也有类似的权威机构，我们称之为**CA （Certificate Authority，证书认证机构）**。



为了让服务端的公钥被大家信任，互联网上各种HTTPS网站的HTTPS服务端的证书都是由 CA 签发的。

CA 就是网络世界里的公安局、公证中心，具有极高的可信度，所以由它来给各个公钥签名，信任的一方签发的证书，那必然证书也是被信任的。

CA（Certificate Authority）即数字证书颁发机构，主要负责发放和管理数字证书，SSL证书就是CA机构颁发的。



**证书**颁发**机构（CA）**或**认证机构**是一个受信任的实体，负责颁发数字证书，以确认域名所有权和申请人的身份。 

CA 在浏览器和服务器之间建立信任和安全通信方面发挥着根本性的作用，它可以验证有关客户或组织确实是他们声称的那个人。

任何人都可以成为 CA 并签发自签证书，但只有少数几家公司最终会为公众签发 SSL/TLS 证书。



- 认证CA，只有通过WebTrust国际安全审计认证，根证书才能预装到主流的操作系统和浏览器中，成为全球可信的ssl证书颁发机构。
- 自建CA，在一些内部或测试场景中，比如kubernetes或者一个大的组织内部，也可以自建CA，自签证书



WebTrust 是由全球两大著名注册会计师协会 AICPA（美国注册会计师协会）和 CICA（加拿大注册会计师协会）共同制定的安全审计标准，也是电子认证服务行业中唯一的国际性认证标准，主要对互联网服务商的系统及业务运作逻辑安全性、保密性等共计七项内容进行近乎严苛的审查和鉴证。

**WebTrust 认证**是各大主流的浏览器、微软等大厂商支持的标准，是规范 CA 机构运营服务的国际标准。在浏览器厂商根证书植入项目中，只有通过 WebTrust 国际安全审计认证，根证书才能预装到主流的浏览器而成为一个全球可信的CA认证机构，从而实现浏览器与数字证书的无缝嵌入。

https://www.racent.com/blog/what-is-WebTrust-which-CAs-passed-the-WebTrust-audit

只有通过 WebTrust 国际安全审计认证，根证书才能预装到主流的浏览器而成为一个全球可信的认证机构。

Webtrust 认证是各大主流的浏览器、微软等大厂商支持的标准，是规范 CA 机构运营服务的国际标准。

在操作系统和浏览器厂商根证书植入项目中，必要的条件就是要通过 Webtrust 认证，才能实现浏览器与数字证书的无缝嵌入。



目前全球主流的CA机构有Comodo、Symantec、GeoTrust、DigiCert、Thawte、GlobalSign、RapidSSL等，其中Symantec、GeoTrust都是DigiCert机构的子公司。



目前市场上大部分用户使用的SSL证书都是国外品牌。常见CA机构：

- 沃通CA 
- DigiCert
- GlobalSign
- letsencrypt





CA 对公钥的签名认证也是有格式的，不是简单地把公钥绑定在持有者身份上就完事了，还要包含序列号、用途、颁发者、有效时间等等，把这些打成一个包再签名，完整地证明公钥关联的各种信息，形成“数字证书”。

证书里的证明对象是一个“实体”（Common Name），可以证明任何东西，但是在互联网的环境下，这个“实体”就通常是域名了。



#### 证书颁发机构有哪些类型？

在讨论不同的证书颁发机构类型时，我们必须根据它们的层次结构、产品和信任级别进行分类。 我们先来看看由根 CA、中间 CA 和签发 CA 组成的分级顺序。



##### 什么是根证书颁发机构？

根证书颁发机构是对浏览器和操作系统默认信任的根证书进行自我签名的 CA。 

由于这些证书无需进一步验证即可生效，因此它们被存储在物理设备上，并被保存在戒备森严的保险库中。

**所有公共 CA 都是可信 CA，因为它们的根证书已包含在浏览器的预安装包或根存储中。**

------

##### 什么是中级证书颁发机构？

中间认证机构是不受浏览器和操作系统信任的 CA，但其证书由根 CA 签发。 如果应用程序可以验证由中间 CA 签发的证书可以追溯到根 CA，那么这些证书就被认为是有效的。

中间 CA 的作用是在根 CA 和签发 CA 之间充当额外的安全层。 如果出现安全漏洞，中间 CA 将减轻潜在的安全影响。

------

##### 什么是颁发证书机构？

签发证书机构是向最终用户提供 SSL 证书的 CA。 它从属于中间 CA，中间 CA 使用其公开密钥签署签发 CA。 

由签发 CA 签发的证书有效期为一年，只有在证书与各自的中间机构和根链接时，浏览器才会信任这些证书。

说到信任，CA 主要分为两个分支：公共 CA 和私有证书颁发机构。

------

##### 公用证书颁发机构和私有 CA 有什么区别？

**公共证书**颁发**机构**是由第三方组织控制的可信 CA，通常用于向公众颁发 SSL 证书。

 浏览器和操作系统信任其 SSL 证书的所有商业和开源 CA 都是公共证书颁发机构。 而公共 CA 又可进一步分为商业 CA 和开源 CA。

**商业 CA**提供具有最高信任度和安全性的付费数字证书。 它们是唯一提供商业验证、扩展验证和多域 SSL 证书的 CA。

**开源 CA**可签发浏览器和操作系统信任的免费 SSL 证书。 这些 CA 只能验证域名所有权，适用于不涉及在线交易的个人网站、博客或在线投资组合。

**私人证书**颁发**机构**是由单个组织运营的 CA，一般用于向其设备和员工颁发数字证书。 专用 SSL 证书仅用于内部服务器和机器。



### 证书链体系

CA 中心为每个使用公开密钥的用户发放一个数字证书，数字证书的作用是证明证书中列出的用户合法拥有证书中列出的公开密钥。

CA 机构的数字签名使得攻击者不能伪造和篡改证书。



**数字证书的实质是证书权威机构（CA）用自己的私钥，对普通用户提交的公钥和名称的绑定关系的数字签名。**



不过 CA 如何证明自己呢？这本质还是信任链的问题。“小一点”的 CA 可以让“大 CA” 签名认证，但链条的最后，也就是 Root  CA，就只能自己证明自己了，这个就叫“自签名证书”（Self-Signed Certificate）或者“根证书”（Root  Certificate）。对于根证书我们必须无条件相信，否则整个证书信任链就走不下去了。

有了这个证书体系，**各大操作系统和浏览器都内置了各大 CA 机构的根证书**，上网的时候只要服务器发过来它的证书，就可以验证证书里的签名，顺着证书链（Certificate Chain）一层层地验证，直到找到根证书，就能够确定证书是可信的，从而里面的公钥也是可信的。

**根证书是自签名证书，也就是自己证明自己，是信任的起点，所以作为用户，也就是“你”，就必须信任它，否则就没有从它开始的整个证书链。**

**所谓自签名，就是用证书里的公钥来证明证书里的公钥，自己证明自己。**



假设现在有一个三级的证书体系（Root CA=> 一级 CA=> 二级 CA），它是如何完成证书信任链验证过程的呢？

前面我们说过，由于操作系统和浏览器都内置了各大 CA 的根证书，上网的时候只需要服务器发送来它的证书，就可以验证证书里的签名，顺着证书链（Certficate Chain）一层层地验证，直到找到根证书。

如果服务器返回的是一个二级证书，操作系统和浏览器内置的根证书（根公钥）只能解密根证书签名的证书，无法解密二级证书，只有使用一级证书的（公钥）才能解密二级证书，那么操作系统和浏览器是如何自上而下地层层解析得到根证书的呢？其实**服务器返回的是一个证书链，然后操作系统或浏览器就可以使用信任的根证书（根公钥）解析根证书得到一级证书的公钥+摘要验签，然后拿一级证书的公钥解密一级证书得到二级证书的公钥+摘要验签，再然后拿二级证书的公钥解密二级证书得到服务器的公钥和摘要验签名，验证过程就此结束！**

服务器在握手的时候会返回整个证书链，但通常为了节约数据量，不会包含最终的根证书，因为根证书通常已经在浏览器或者操作系统里内置了。

在这样一条信任链中，CA  的诚实可信是公钥信任体系的信任根。一旦计算机的“受信任根证书颁发机构”列表中，混入了不可信任的根证书，就可以随时签发任何名称的数字证书。由于计算机对所有受信任更证书所签发的数字证书基于不区分的平等信任，混入信任列表的恶意根证书签发的伪造证书将会危害计算机的所有安全通信，机密的信息会被解析窃听，显示为有效的数字签名和安全的 HTTPS 的连接其实际是不可信的。











默认地，这些

在 HTTP 里面，各种网站的**HTTPS证书**都是要向**CA**来申请，验证之后签发的。







### 数字证书

- 证书文件（server.crt）：CA机构返回的证书文件，包含很多种格式和形式。包括 nginx , tomcat , apache 等等。

  

- 证书私钥文件（server.crt）
  - 自动CSR：自动CSR，直接从签发方处下载证书私钥文件。
  - 手动CSR：自己要保留好自己的证书私钥文件。



对应的nginx配置：

```nginx
ssl_certificate      cert/server.crt; # 替换成您的证书文件的路径。
ssl_certificate_key  cert/server.key; # 替换成您的私钥文件的路径。
```



https://blog.csdn.net/zyhse/article/details/108026800



### SSL证书类型

**根据证书的安全性不同**

- DV类型证书：中文全称是域名验证型证书，证书审核方式为通过验证域名所有权即可签发证书。

此类型证书适合个人和小微企业申请，价格较低，申请快捷，但是证书中无法显示企业信息，安全性较差。在浏览器中显示锁型标志。

DV SSL证书是只验证网站域名所有权的简易型（Class 1级）SSL证书，可10分钟快速颁发，能起到加密传输的作用。

证书信息里面只有域名一项（Common Name 字段）

- OV类型证书：中文全称是企业验证型证书(Organization validated)，证书审核方式为通过验证域名所有权和申请企业的真实身份信息才能签发证书。

目前OV类型证书是全球运用最广，兼容性最好的证书类型。此证书类型适合中型企业和互联网业务申请。

在浏览器中显示锁型标志，并能通过点击查看到企业相关信息。支持ECC高安全强度加密算法，加密数据更加安全，加密性能更高。

常见的企业网站都是这种，比如 www.zhihu.com  , www.huawei.com  ，证书里除了注明了域名之外还添加了公司名（Organization）等信息。

- EV类型证书，全称 Extended validation，也就是扩展认证。CA 会对证书持有人进行更加全面的认证。~~如果浏览器会在网址左边显示组织机构信息~~。用户看到这些信息会更加放心。

从认证效力上看，DV 小于 OV 小于 EV。价格显然是 EV 大于 OV 大于 DV 了。随着 [Let's Encrypt](https://letsencrypt.org/) 的上线，DV 证书几乎可以免费获取，大大加快了 https 的普及速度。

浏览器厂商也在不断调整 https 的展示策略。其趋势就是**不断推动 https 的普级，不断弱化用户对 https 的感知，最终让 https 完全取代 http 而用户完全无法感知的效果**。为了达到这个效果，浏览器会将 http 网站标记为不安全站点，比如我国的政府网站。

反过来，对于使用 https 的安全网站，则不再提示。Chrome 最新开发版甚至连 EV 认证信息都不再展示。

**在最新版本的 Firefox 和 Chrome 中，访问使用 EV 证书的 https 站点时，地址栏不显示绿色的锁头图标和公司信息，取而代之的是和 DV 证书站点相同的灰色锁头图标。**



多数网站都已经支持 HTTPS 加密连接，浏览器地址栏特别标记的锁头图标算完成历史任务，也到该退场的时候。

Google 宣布，2023 年 9 月 Chrome 117 版开始，会全面取消锁头图标，并全面更新 Chrome UI界面。

HTTPS 加密连接已成常态，用户随意访问任何网络，大都能看到网址栏前面有个代表加密通讯的绿锁图标，让使用者即使在公共或不安全的网络浏览网站时，可确保自己的凭证和数据不会被恶意拦截。

既然大部分网站都支持 HTTPS 加密连接，那么特别加上锁头图标就没必要。且 Google 研究发现，大多数使用者根本不知道锁头图标表示的意思。

Google 决定全面取消 Chrome 浏览器锁头图标，改成中性标志以避免使用者误解，并强调安全是预设的，且使用者可更方便对网站权限进行设置。

Google 会在 9 月初释出 Chrome 117 桌面版浏览器，推出全新 Tune 图标。由两个圆圈和两条线组成，代表着使用者可对访问的网站进行设置，包括权限与隐私。

点击Tune 图示和点击锁头图示后选项大同小异，Google 认为新的图标更有助于使用者方便设置权限与数据安全。



具体参考

[ why-firefox-chrome-kill-ev](https://dallas.lu/why-firefox-chrome-kill-ev)

https://blog.skk.moe/post/chrome-omnibox-www/

https://taoshu.in/ssl-ev-is-dead.html





根据 Let’s Encrypt CA 的统计，截至 2017 年 11 月，Firefox 加载的网页中启用 HTTPS 的比例占 67%，比去年底的 45% 有巨大提升。

浏览器开发商如 Mozilla， Google 准备采取下一步措施：将所有 HTTP 网站标记为不安全。

随着 HTTPS 的普及，给网站加个 SSL 证书已经是大势所趋而且很有必要了。目前已经存在不少免费好用的 SSL 证书



毫无疑问，Letsencrypt.org 是目前使用范围最为广泛的免费 SSL 证书，而且[官方博客宣布](https://letsencrypt.org/2017/12/07/looking-forward-to-2018.html)，自 2018 年开始提供通配符 SSL 证书，也就是 wildcard certificates

这对于广大个人站长来说，无疑是个不错的利好消息。唯一的缺憾就是，Letsencrypt.org 发行的证书有效期只有 3 个月，虽然可以通过定时任务来自动续期。



Cloudflare 很早就开始提供免费 SSL 证书，前提是你的域名要放在 Cloudflare 解析，注册为 Free Plan 就可以。

备注：只要域名加入 Cloudflare Free Plan，解析 A 记录的时候，点击 Traffic to this hostname will go through Cloudflare，就可以了。

一般情况下，这个免费的 Universal SSL 里会包含一大堆别人的域名（该证书也是 Comodo 发行的）。

当然，如果你比较介意这个的话，可以付费购买其 Dedicated SSL Certificate ($5/month) 或 Dedicated SSL Certificate with Custom Hostnames ($10/month)。



ECC证书

https://blog.xinac.cn/archives/letsencrypt%E7%94%B3%E8%AF%B7rsaecc%E5%8F%8C%E8%AF%81%E4%B9%A6%E6%B5%81%E7%A8%8B%E6%94%AF%E6%8C%81%E9%80%9A%E9%85%8D%E7%AC%A6%E8%AF%81%E4%B9%A6.html

https://blog.mf8.biz/nginx-install-tls1-3/



### 国密证书

国密证书，是指采用国密算法加密签名的证书。

各大国外浏览器和国外操作系统，预置的都是国际知名各大 CA 的根证书，而国密 CA 作为后来者，还没有大范围使用，所以国际上主流的浏览器（firefox、chrome、safari等）连国密都不支持，更别提预置国密相关根证书。

国产密码算法（国密算法）是指国家密码局认定的国产商用密码算法，在金融领域目前主要使用公开的SM2、SM3、SM4三类算法，分别是非对称算法、哈希算法和对称算法。

SM2算法：SM2椭圆曲线公钥密码算法是我国自主设计的公钥密码算法，包括SM2-1椭圆曲线数字签名算法，SM2-2椭圆曲线密钥交换协议，SM2-3椭圆曲线公钥加密算法，分别用于实现数字签名密钥协商和数据加密等功能。SM2算法与RSA算法不同的是，SM2算法是基于椭圆曲线上点群离散对数难题，相对于RSA算法，256位的SM2密码强度已经比2048位的RSA密码强度要高。

SM3算法：SM3杂凑算法是我国自主设计的密码杂凑算法，适用于商用密码应用中的数字签名和验证消息认证码的生成与验证以及随机数的生成，可满足多种密码应用的安全需求。为了保证杂凑算法的安全性，其产生的杂凑值的长度不应太短，例如MD5输出128比特杂凑值，输出长度太短，影响其安全性SHA-1算法的输出长度为160比特，SM3算法的输出长度为256比特，因此SM3算法的安全性要高于MD5算法和SHA-1算法。

SM4算法：SM4分组密码算法是我国自主设计的分组对称密码算法，用于实现数据的加密/解密运算，以保证数据和信息的机密性。要保证一个对称密码算法的安全性的基本条件是其具备足够的密钥长度，SM4算法与AES算法具有相同的密钥长度分组长度128比特，因此在安全性上高于3DES算法。







### 信任和责任

我们在互联网上的每一动作都需要一个基本的信任体系。当你通过浏览器去访问你的银行账户或你喜爱的社交媒体时，你肯定希望你访问的那个网站就是你在浏览器输入的那个网站。这种期望就基于一个基本的信任体系，这就是我们常听见的web PKI(Public Key Infrastructure)系统。



从一个较高的层次来看，PKI系统就像一个公证人，它通过签发数字证书来赋予服务器为网站提供服务的能力。这个数字证书就是我们常说的证书了，它包括了网站的域名，组织名称，有效期和一个公钥。对于每一个公钥来说，都有一个对应的私钥。如果服务器需要使用指定证书去为网站提供HTTPS服务，那么这个服务器就需要证明对该私钥的所有权。



网站获取数字证书的第三方机构就是CA机构(Certificate Authorities) CA机构在颁发证书前会验证操作者的域名所有权。如果一个数字证书是由一个浏览器信任的CA颁发的，那么该证书就可以用于HTTPS站点了。所有的这些验证都是浏览器内部实现的，给用户的唯一感知的只是浏览器上一个小绿锁🔐，或是出错时的一个错误。



PKI系统本身是很好的，但是作为一个信任系统，依然存在很多风险。一个最基本的风险就是，CA机构可以为任何网站颁发证书。

这就意味着，[Hong Kong Post Office](https://bugzilla.mozilla.org/show_bug.cgi?id=408949)可以为gmail.com或facebook.com签发证书，而且被大部分浏览器信任。更糟糕的是，如果CA被黑客攻击了，那么黑客可以在CA毫无知觉的情况下颁发任何证书，从而导致用户处于一个高风险的处境中。



谁来监管证书颁发机构？

如果认证机构负责 SSL 验证和撤销，那么谁来监管它们？ 要回答这个问题，让我们来考察一下参与这一复杂过程的各方。

浏览器和应用程序

浏览器和应用程序定义了管理 CA 的规则。 所有浏览器的安装包（也称为根存储）中都包含受信任 CA 的信息。 只有当公共 CA 的根已经在根存储中标记为可信时，浏览器才会接受公共 CA 签发的 SSL 证书。

并非所有浏览器都有自己的可信根存储。 它们还依赖于客户操作系统的根存储。 如果 CA 的根签发的数字证书不在浏览器或操作系统的根存储中，浏览器会警告用户不要信任 SSL 证书。

但浏览器如何确定要信任哪些 CA 根呢？ 嗯，他们一直都有关于 CA 应如何运作的预定规则。 此外，他们还在不断改进，以建立高端安全标准。

随着时间的推移，他们已经成功淘汰了 MD5 和 SHA-1 等较弱的算法。 他们还删除了过时的密钥大小，如 512 位和 1024 位。 如果 CA 不符合浏览器的详尽要求，就会从浏览器的受信根存储中删除。



HTTPS 有个重要的一环就是证明”张三是张三“，并且是通过权威的 CA 机构颁发的证书来证明所持公钥的合法性，在那节我们提到， CA 就是神，而顶级 CA 就是众神之神，这些神是绝对公平客观，不造假不作恶，对吧？那现实中这些神的表现又怎么样呢？绝大部分的 CA，尤其是顶级 CA 肯定是严格遵守规则的，否则一旦出问题，另外一个大神浏览器和操作系统就会把他们的 CA 证书从信任列表移除，然后它们就得跌下神坛，离破产也不远了。但除了顶级 CA，还有相当多的中间 CA 机构，另外神也有打盹的时候啊，让我们一起回顾下面这些触目惊心的旧闻：

- 2011 年 3 月，证书市场份额前列的科摩多（Comodo）公司遭黑客入侵，共 9 个数字证书被窃，包括：mail.google.com、addons.mozilla.org 和 login.yahoo.com 等。当时有人称那次事件为“CA 版的 911 攻击”；
- 同年荷兰 CA 提供商 DigiNotar 服务器被伊朗黑客攻破，黑客签发了包括 Goolge，Facebook，美国中情局和军情六处等在内的 531 个网站证书，并用于窃听伊朗用户的 Gmail 等信息，该事件直接导致该公司在一年后破产，有兴趣可以查看这个新闻链接；
- 除了被黑客入侵，还有自己作死的，比如有 360 背景的沃通，有兴趣可以查看这个新闻;
- 2013 年，Google 发现法国政府控制下的 CA 机构 ANSSI 伪造证书并用于窃听用户信息，这个事件在业界造成了极其恶劣的影响，斯诺登也披露美国中情局长期利用伪造的证书窃听用户的数据，法国和美国政府并不孤单，有兴趣的同学可以 Goolge 下 CNNIC 干过哪些事，以及它的背景，我就不多说了:)



如果某人控制了一个不属于他自己站点的证书，那么他可以模拟这个站点，从而窃取用户的信息。就目前来说，像火狐，苹果，谷歌都有他们自己的信任CA库。

如果这些CA出现些问题，用户将承担很大的风险。

从中可看出，PKI少的就是责任追究机制。如果一个误颁发的证书只影响到个人，这中间没有任何反馈机制让其他人知道CA的失误行为。

这不是一个假想的状态。就在2011年，DigiNotar，一个荷兰的CA机构，被黑客攻陷。

黑客利用该CA签发了一张`*.google.com`的证书，他们试图模拟Gmail，窃取伊朗用户的个人信息。

但这次攻击被Google探测到了，通过公钥固定技术(public key pinning)。公钥固定是一个有风险的技术，只有一些技术过硬的公司在使用。

公钥固定所带来的风险往往超过其价值，它通常被认为是蹩脚机制的典型例子，被浏览器弃用。



**证书透明度（certificate-transparency）**

如果公钥固定机制也不起作用了，那么我们怎么去探测CA的一些错误？这时CT就应运而生。

CT的目标就是让所有的证书透明，这样误颁发的证书也能被发现，从而可以采取相应的应对措施。



**证书透明度**是一个公共日志，旨在通过允许任何人实时审核证书来提高[SSL/TLS 证书生态系统](https://www.ssldragon.com/zh/blog/ssl-vs-tls-certificates/)的安全性。 

CT 可防止签发恶意证书，并检测任何错误签发的证书。 它提供了一个对证书框架进行持续、外部监控的机制，从而大大降低了证书误签发而不被察觉的风险。



通过一系列的事件，人们发现整个安全体系理论上看似乎无懈可击，实际上脆弱不堪，给人一种无力感，不少大牛包括一些互联网巨头开始关注并思考这个问题。Ben Laurie 和 Adam Langley 首先构思了“证书透明度”，并将一个框架实现开发为开源项目，2013 年 3 月，Google 推出其首个证书透明度日志。证书透明度是针对 CA 机构颁发证书的过程不透明而提出来的，俗话说，没有监督的权力是腐败的根源，要让权力在阳光下运行，这也是证书透明度的主要理念，它不是为了推翻 CA，而是让证书的签发过程透明化，一旦有人造假或人为失误，将立即暴露在阳光下，无所遁形。

证书透明度主要有三个部分：

- 证书透明度日志(Certificate logs)
- 证书监控(Certificate monitors)
- 证书审计(Certificate auditors)



### 证书交叉认证

在 PKI 证书体系中，**信任是通过逐级签名以及对这些签名的验证来实现的**。 

对大部分客户端系统来说，这些系统中会存在一个或多个受信的根证书发证机构的证书， 其公钥是通过这些系统本身的更新机制派发的。

根证书发证机构的证书通常是自签名的，更新相对来说比较麻烦（它通常依赖于操作系统的在线或离线更新机制）， 因此这些证书的私钥事关重大，因此人们通常不希望经常更新它们，因而证书发证机构在绝大多数时候并不会使用这些私钥来签署证书。取而代之的是，他们会创建一些称为中级发证机构的证书用来签署日常的证书，这样根证书的私钥可以采用更为严密的方法来保护， 例如可以把它们从网络上彻底断开，而中级发证机构的证书则可以以较高的频率进行密钥轮换，借此来避免其私钥暴露导致的风险。





一个新的发证机构进入市场时，其自签名的根证书往往不会被已经在市场上的客户端系统认可， 因此这样一来新的发证机构想要获得用户就必须想办法解决能被用户承认这个问题。

一旦获得了一定的知名度并证明了自己的可靠性， 这些发证机构便可以遵循一定的流程获得主流浏览器或操作系统的认可， 并将自己的根证书也加入到它们的受信根证书列表中了。 



所以，在起步阶段，新的发证机构往往会要求一些已经存在的根证书去对其根证书进行交叉签署， 在客户端验证证书有效性时，由于这些根证书在他们看来是一个经过了受信根证书签名的中级证书而不是一个普通的不受信自签名根证书， 因此也就不会给出无法验证证书是否有效的提示，而是能够正确地对其有效性进行验证了。







Let’s Encrypt 在起步阶段正是采用了这种做法。通俗地说，它的中级发证机构的证书被两家根证书机构同时签名， 其一是它自己的 ISRG Root，另一个是另一家根证书机构 IdenTrust 的 DST Root X3。

初期，由于 DST Root X3 已经被许多操作系统和浏览器认证过，因此为其普及起到了非常重要的作用。



UTC 时间 2021年9月29日 19:21:40，DST Root X3 的根证书过期了。这样一来，这一边的信任链便不再成立。

DST Root X3 的过期时间是早已公布了的，过去几年， Let’s Encrypt 也大力推广了自己的 ISRG Root， 因此对比较新的操作系统来说，DST Root X3 的根证书过期这件事并不是什么太大的问题，毕竟另外一条信任链仍然可以用来验证证书的有效性。

然而我们都知道凡事都是有代价的。早先版本的 OpenSSL 中存在一个 bug，简而言之，在验证证书时， 它会捋出一条潜在的信任链，然后再逐个确认链条上的每一个环节的过期时间。

这样一来，如果本地的根证书存储中包含了已经过期的 DST Root X3 证书，OpenSSL 就有可能找到这条信任链， 并在稍后发现该根证书已经过期并不再信任之。这会导致证书无法验证，并导致对应的服务无法访问。

https://blog.delphij.net/posts/2021/09/ssl/



在Let’s Encrypt颁发的证书中，证书包内包含文件如下：

- cert.pem：所申请的服务器证书，可以直接上传至“上传证书”对话框的“证书内容”参数中。
- privkey.pem：服务器证书所对应的私钥文件。该私钥文件为通用PEM格式，需参考 [当上传证书时提示私钥格式校验失败，如何排查解决](https://www.easystack.cn/doc/CertificateService/1.1.1/zh-cn/FAQ/CommenCert.html) 转换为对应算法格式后，再上传至“上传证书”对话框的“证书私钥”参数中。
- chain.pem：签发服务器证书的CA证书链。该证书链中根CA的证书可能不正确，需获取正确根CA的证书，再上传至“上传证书”对话框的“证书链”参数中。
- fullchain.pem：包含签发服务器证书的CA证书链和服务器证书。



https://www.easystack.cn/doc/CertificateService/1.1.1/zh-cn/FAQ/Encrypt.html



## 八、中间人攻击原理

HTTPS 劫持其实是一个老生常谈的话题，从上古时代的 HTTPS 降级（maybe sslstrip），到现在很稳定的安全工具 burpsuite，xray 等，以及一些常见的网络调试工具 fiddler、charles、surge，很多都直接或者间接利用了 HTTPS 的 MITM 攻击。



MITM" 是 "Man-in-the-Middle" 的缩写，意思是中间人攻击。

MITM攻击是一种网络攻击技术，攻击者通过欺骗的手段，让自己成为通信双方之间的中间人，从而可以窃取双方之间的通信内容、修改通信内容、甚至篡改通信流量，从而实现窃取信息、伪造信息等攻击目的。

"未知攻，焉知防"，在渗透测试中，MITM劫持可以被用来模拟真实的黑客攻击，以测试系统和应用程序的安全性。

渗透测试中使用MITM攻击的一个典型场景是在测试Web应用程序时。攻击者可以使用MITM技术拦截应用程序和服务器之间的通信，以获取用户名和密码等敏感信息，或者篡改应用程序返回的数据。攻击者可以使用代理工具，来捕获应用程序发送和接收的数据，对数据进行修改或篡改，然后重新发送到应用程序或服务器。这样就可以测试应用程序是否可以有效地防范MITM攻击，并且是否能够正确地处理应用程序和服务器之间的通信。

MITM攻击还可以用来测试网络的弱点，并检测是否存在潜在的漏洞。通过MITM攻击，渗透测试人员可以捕获网络中传输的数据，并进行分析和审查，以发现可能存在的安全问题。

例如，攻击者可以利用MITM攻击来欺骗局域网内的设备，并拦截设备之间的通信流量，从而窃取敏感信息，或者篡改数据包，对网络进行进一步的攻击。

总的来说，MITM劫持是渗透测试中常用的一种技术，它可以帮助测试人员发现网络中可能存在的安全漏洞，提供相应的建议和解决方案，从而保护系统和应用程序的安全。





BurpSuite的基本思路是伪装成目标https服务器，让浏览器（client）相信BurpSuite就是目标站点。为了达成目标，BurpSuite必须：

（1）生成一对公私钥，并将公钥和目标域名绑定并封装为证书；

（2）让操作系统或浏览器相信此证书，即通过证书验证。



所以， BurpSuite需要在操作系统添加一个根证书，这个根证书可以让浏览器信任所有BurpSuite颁发的证书。

之后，BurpSuite拥有了两套对称密钥，一套用于与client交互，另外一套与server交互，而在BurpSuite处可以获得https明文。





使用 Charles，Fiddler，Burpsuite，xray ，surge 等各种工具，都是直接或者间接利用了 HTTPS 的 MITM 攻击。

启动代理服务器，浏览器配置一个代理就可以抓包进行调试、漏洞测试了。Fiddler、Charles都是收费软件



**不安全的 CA 导致信任链崩坏**

**不安全的 CA 可以给任何网站进行签名，TLS 服务端解密需要服务端私钥和服务段证书，然而这个不安全的 CA 可以提供用户暂时信任的服务端私钥和证书**，这就好比你信任了一个信用极差的人进入你的家，这个信用极差的人可以在你的家里乱翻乱拿无恶不作。



HTTP 抓包神器 Fiddler 的工作原理是在本地开启 HTTP 代理服务，通过让浏览器流量走这个代理，从而实现显示和修改 HTTP 包的功能。

如果要让 Fiddler 解密 HTTPS 包的内容，需要先将它自带的根证书导入到系统受信任的根证书列表中。

一旦完成这一步，浏览器就会信任 Fiddler 后续的「伪造证书」，从而在浏览器和 Fiddler、Fiddler 和服务端之间都能成功建立 TLS 连接。



而对于 Fiddler 这个节点来说，两端的 TLS 流量都是可以解密的。



Charles is an HTTP and SOCKS proxy server. Proxying requests and responses enables Charles to inspect and change requests as they pass from the client to the server, and the response as it passes from the server to the client. This section outlines some of the proxying functions that Charles provides. Also see the [Tools](https://www.charlesproxy.com/documentation/tools/) section.

Charles 是一个HTTP和**Socks 5 代理**服务器



**系统代理**

这个概念大家想必大家都比较熟悉， 比如 macOS, 在 系统偏好->网络->高级->代理 里就可以修改系统代理。Windows中同样有这样的设置。

但是在这里设置代理后, 【**应用软件会不会走这个代理完全取决于应用软件自己**】。

比如 Chrome 浏览器会走这儿设置的代理， 而 Terminal 等很多应用就选择无视这个代理。

URL输入chrome://flags/，搜索：Allow invalid certificates for resources loaded from localhost 设置为Enable

这里其实工作在应用层，在这里拦截的话，抓包工具只需要处理应用层的协议包即可。这也是目前大部分抓包工具实现的方式。

许多抓包软件从系统代理捕获数据包，应用程序很容易跳过系统代理。



浏览器—>Charles 

- Windows / Internet Explorer proxy settings – used automatically by most Windows applications
- macOS proxy settings – used automatically by most macOS applications
- Mozilla Firefox proxy settings (all platforms)



在很多朋友尝试 HTTPS 中间人的时候，其实都有过这样的想法：“我挂在路由器上，让我所有的的 HTTPS 流量全都变成明文！”。

但是往往受限于性能问题以及部署问题，导致了很多人“只是想想”。



不管是 HTTP 还是 HTTPS 的劫持，除了解决安全工程问题，其实还有更多别的用途：比如你连入了一个 WIFI，需要 Web 端认证，这个时候你的路由器本质就是在“劫持”你到认证页面，当你认证成功，路由器防火墙策略把你的流量放行，并停止劫持。

毕竟劫持不仅可以劫持用户端，服务端返回的数据也可以被劫持：操纵用户手脚还是蒙住用户的眼睛都可以



BurpSuite





## 九、重放攻击





> 重放攻击（英语：replay attack，或称为回放攻击）是一种恶意或欺诈的重复或延迟有效数据的网络攻击形式。
>
> 这可以由发起者或由拦截数据并重新传输数据的对手来执行，这可能是通过IP数据包替换进行的欺骗攻击的一部分。 这是“中间人攻击”的一个较低级别版本。
> 这种攻击的另一种描述是： “从不同上下文将消息重播到安全协议的预期（或原始和预期）上下文，从而欺骗其他参与者，致使他们误以为已经成功完成了协议运行。”



把之前的、正常的请求再次发送，这就是重放攻击。





有的朋友就会说了：我的接口是加签的，应该没问题吧？你加签咋了？

我没有动你的报文，所以你也可以正常验签呀。

我不仅抄你报文里面的正常字段，报文里面的签名我也抄全乎了。所以，接收方接到报文之后能正常验签。没有任何毛病。



有的朋友还会说了：我的接口是有加密的，应该没问题吧？看来还是不懂重放攻击的基本原理。你加密咋了？

反正我截取到了你的报文，虽然你报文加密了，我看起来是一段乱码，但是我也不需要知道你报文的具体内容呀，直接重发就完事了。



**加密的目的：为了保证传输信息的隐私性，不被别人看到传输的具体内容，只能让接收方看到正确的信息。**

**加签的目的：消息接收方验证信息是否是合法的发送方发送的，确认信息是否被其他人篡改过。**

不管是加密还是加签，都涉及到公私钥。**记住了：公钥加密、私钥加签。**

所以，别人根本就不需要知道你报文的具体含义。只要我再次发给你，你进行解密操作，发现能解密。能解密说明暗号对上了。

所以，虽然报文是加密、加签传输的，对于防止请求重放，并没有什么卵用。

当面试官问你：HTTPS数据加密是否可以防止重放攻击？

答：否，加密可以有效防止明文数据被监听，但是却防止不了重放攻击。







### 可信时钟

甲虽将合同文件发给乙，但甲拒不承认在签名所显示的那一刻签署过此文件（数字签名就相当于书面合同的文字签名），并将此过错归咎于电脑，进而不履行合同，怎么办？

解决办法是采用可信的时钟服务（由权威机构提供），即由可信的时间源和文件的签名者对文件进行联合签名。

在书面合同中，文件签署的日期和签名一样均是十分重要的防止文件被伪造和篡改的关键性内容（例如合同中一般规定在文件签署之日起生效）。

在电子文件中，由于用户桌面时间很容易改变（不准确或可人为改变），由该时间产生的时间戳不可信赖，因此需要一个第三方来提供时间戳服务（数字时间戳服务（DTS）是网上安全服务项目，由专门的机构提供）。此服务能提供电子文件发表时间的安全保护。

时间戳产生的过程为：用户首先将需要加时间戳的文件用哈希编码加密形成摘要。然后将该摘要发送到DTS，DTS在加入了收到文件摘要的日期和时间信息后再对该文件加密（数字签名），然后送回用户。

因此时间戳（time-stamp）是一个经加密后形成的凭证文档，它包含三个部分：需加时间戳的文件的摘要，DTS收到文件的日期和时间，DTS的数字签名。

由于可信的时间源和文件的签名者对文件进行了联合签名，进而阻止了文档签名的那一方（即甲方）在时间上欺诈的可能，因此具有不可否认性。





## 十、前端加密

用户名和密码通常是作为 `form` 表单中的 `input` 控件进行输入，然后明文传输到服务端进行校验登录的。此时，可能会出现密码明文传输问题。

前端加密主要是指在浏览器端执行的加密过程，用于增强数据的隐私和安全性。这样的加密操作一般用于在数据从客户端发送到服务器之前保护数据。

需要注意的是，依赖纯前端加密可能会有安全隐患，因为经验丰富的攻击者可以直接修改或绕过前端代码。



**CryptoJS是一个JavaScript的加解密的工具包**

它支持多种的算法：`MD5、SHA1、SHA2、SHA3、RIPEMD-160` 哈希散列，进行 `AES、DES、Rabbit、RC4、Triple DES` 加解密。



当然，前端加密，也有其价值存在，比较可以让抓包者不会轻易抓到明文密码。



当数据（比如密码）经过 AES 加密（或其他加密算法）处理后，会得到一串二进制数据。

因为这些二进制数据不方便直接在文本环境中传输或存储（例如在 JSON、URL 参数或 HTML 属性中），所以通常会将其**再进行 Base64 编码**，将其转换为可打印的 ASCII 字符。







最好的加密是 `https`。 毕竟你无论如何加密 用 `js` 都相当于裸奔，前端加密的作用只是让人一眼看不出实际值，想要找出来还是有办法的 `RSA` 加密自然可以，我个人理解 `https` 就是 `RSA` 的一种

- 用户在前端输入密码，通过js代码对输入的密码进行不可逆加密，然后在后端将密文直接存进数据库。这样的话，就算别人拦截到你的数据包，看到的也只是加密后的密文。**这也是为什么一些平台找回密码仅仅是输入新密码，因为他们也没办法获取旧密码**
- 用户在前端输入密码，通过js代码对输入的密码进行可逆加密（需要前后端协调好秘钥），传到后端后，再对加密的密文进行解密，然后跟数据库的明文密码进行比较。这样，别人如果不知道秘钥的话，也基本上拦截不到密码。

信息安全的保护确实分成两个部分，**端的安全**（可以具体到客户端和服务器端）和**链路的安全**，也就是传输过程中的安全。





单就**传输信道(链路)**而言，https 能解决中间人问题，明文在这个用户前端到厂商之间的 https 信道范围内没问题。 单就 github 而言，因为有二次验证，所以即使拿到密码了换个设备也登陆不上，所以有一定合理性。



前端加密的意义是什么？

在 HTTP 环境下，无论如何都可能会被劫持流量，不管前端做不做加密都会被轻易成功登录。这个时候保护密码明文是否有意义？

有人站队前端加密无意义，考虑的是这个加密对本站的安全性没有任何提升；

但如果你是从保护用户的角度出发，用户多站点共享密码是现状，你在没法改变这一点的情况下，如果能够保护密码明文，至少降低了一点该用户其他网站（即使是 HTTPS 的网站）被一锅端的风险。这怎么能说完全没有意义？





前端做过了md5，后台就不用做了，这个做法会有什么后果？如果某一天，这个系统的数据库泄露了，黑客就直接拿到了每个用户的密码md5值，但此时，由于黑客知道密码是在前端进行哈希的，所以他不需要爆破出[md5对应的原文是什么，而是直接修改客户端向服务器发出的请求，把密码字段换成数据库中MD5就可以了，由于与数据库中记录一致，直接就会登录成功。这跟**直接存储明文密码没有任何区别！！！**所以不管前端是不是加密了密码，后台使用安全的哈希算法]对内容再次转换是非常有必要的。（MD5可不行，要用bcrypt








一般我们可以认为，端都是可信的。

- 对于服务器端，你愿意使用这个公司提供的服务，一个隐含的条件就是相信这个提供服务的公司，所以服务器端可以认为是比较安全的。

- 对于客户端，你愿意使用这台电脑，也表明你认为这台电脑是比较安全的。只有对于一些安全级别更高的业务，比如在线交易，才需要额外的再对客户端的安全性做一次校验。

保护的焦点，应该集中在通信的链路上，而不是端上，而且，在链路上进行窃听，比在大部分时候在端上进行攻击都来得有效和难以发现。



安全有一个原则叫纵深防御，就是当一个防护被突破后， 有另一层防护， 会更安全。

就好比说数据库已经有密码保护了， 为啥不能往数据库里存用户口令明文呢？

密码(口令)明文是隐私，不应该让服务端知道的隐私。你"知道我的密码明文, 也知道我的用户名。我可以认为"你"有能力去其他网站尝试登录我的账号。

网站最好永远，永远不要有可能知道用户的**明文密码**。因为HTTPS只保证通信过程的安全，不保证服务器上数据的隐秘性

对于服务侧，经手数据的很多环节都是能看到 HTTPS 内明文的。最典型的就是内容分发，通常 CDN 的本质就是**可信中间人**。如果数据流转的环节需要再加强防御，那 HTTPS 内再加密还有点意义，据要结合具体场景分析。

就拿 CDN 举例，如果 CDN 是坏人，只加密密码，用户隐私、Token 等信息都是明文，那一样可以窃取信息、拿下账户、伪造信息，那加密的意义也就不是很明显。



## 十一、HTTPS性能优化



- **协议优化**
  - 从TLS1.2 升级成 TLS1.3，减少rtt往返时延
  - 密钥交换算法：ECDHE 算法是在 DHE 算法的基础上利用了 ECC 椭圆曲线特性，可以用更少的计算量计算出公钥，以及最终的会话密钥。
  - 

- **证书优化**
  - 服务器证书：从RSA换成ECDSA，性能更好
  - 





ECC 被认为是 RSA 的继任者，新一代的非对称加密算法，加密速度快，效率更高，对服务器资源消耗低。





## 十二、证书有效期

2025 年 4 月 13 日。CA/Browser Forum 组织投票，正式通过 [SC-081 提案](https://github.com/cabforum/servercert/pull/553)。此后，SSL证书的有效期会逐步从现在的 398 天缩短到 47 天（2029 年 3 月 15 日起生效）。

这个提案最早由苹果公司在 2023 年秋季提出，尽管这个提案受到了广大站长的强烈反对，但浏览器厂商和行业组织仍然坚定的给予了支持（29 赞成，5 弃权，0 反对）。



SC-081 主要在证书有效期、域名验证数据重用有效期两个方向做了进一步缩短：

| 时间节点                    | 非 SAN 验证数据重用 | SAN 验证数据重用 | 证书最长有效期 |
| --------------------------- | ------------------- | ---------------- | -------------- |
| 2026年3月15日之前           | 825 天              | 398 天           | 398 天         |
| 2026年3月15日–2027年3月15日 | 398 天              | 200 天           | 200 天         |
| 2027年3月15日–2029年3月15日 | 398 天              | 100 天           | 100 天         |
| 2029年3月15日之后           | 398 天              | 10 天            | 47 天          |



- 降低私钥泄露带来的风险

  根据 CA/B 论坛的要求，CA 在发现证书泄漏后应在 24 小时内吊销。然而，部分 CA 并未严格执行该规定，导致泄漏证书仍可能被滥用。通过缩短证书有效期，可以限制泄漏证书的可用时间，从而降低潜在风险。

  

- 弥补现有吊销机制的不足

  当前的吊销手段（如 CRL 和 OCSP）存在效率低、响应慢等问题，尤其在紧急情况下难以及时生效。缩短证书有效期，即便吊销机制未能及时生效，证书也能在短时间内自然失效，提升整体安全性。

  OCSP 存在单点故障的风险，当 OCSP 服务器出现故障时，客户端往往会忽略证书的吊销状态，仍然认为证书有效值得信任。

  

- 推动新加密算法的使用

  随着计算能力提升，部分传统加密算法已不再安全。长期有效的证书会延缓新算法的推广。从实践上看用户往往都是在更新证书时候更新新的加密算法，通过减少证书有效期，促进证书更新，从而更快地采用更安全的加密技术。

  

- 强化证书所有权与域名控制权的一致性

  数字证书签发需通过域名控制验证（DCV），而现行规则允许 DCV 结果最长复用 398 天，与证书最长有效期一致。这意味着在较长周期内，无需重新验证域名控制权，存在一定安全隐患。

  通过缩短证书和 DCV 的有效期，能更频繁地验证控制权，确保证书、域名及其所有者的一致性。



一年期，多年期证书破灭，CA 无法签发超过 47 天有效期的证书，虽然我们还可能订购到一年期和多年期证书，但他们往往都是几张证书凑出来的，仍然需要重新安装新证书。在新的证书政策下，以 47 天有效期计算，同一域名每年需要申请约 8 次证书。这种高频率的更新，显著增加了运维团队的工作负担，也带来了证书管理的碎片化问题。

在实际环境中，企业往往采用分布式架构，不同的服务器、环境、服务节点可能各自使用不同版本的证书。如果缺乏统一的证书生命周期管理机制，极易出现个别节点的证书被遗忘更换，最终导致业务中断。

世界是一个巨大的草台班子，推动缩短证书有效期的“始作俑者”苹果公司自己也曾“中招”。

在 2024 年，苹果就因未及时续期数字证书，导致 Apple Music 出现短暂中断。这一事件再次说明，即便是全球最具自动化能力的科技巨头，也难以在高频证书更新中做到绝对可靠。



尽管短周期证书在提升安全性方面具备明确优势，但如果缺乏相应的自动化工具和集中化管理能力，它很容易让“保障安全”的初衷适得其反，反而成为新的风险源头。

面对高频更新和生命周期碎片化等现实挑战，引入自动化工具来实现证书的全生命周期管理，已经不再是“可选项”，而是确保稳定运维的必然选择。从证书的申请、签发、验证，到部署、续期、替换，每一步都需要被纳入标准化、可控、可审计的流程之中。





从 SC-081 的通过可以看出，SSL 证书行业正在迈向“更短生命周期、更强自动化、更高安全性”的新阶段。这既是技术发展的必然趋势，也是行业对现实挑战的主动应对。

未来，证书将不再是“买一次管一年”的低频运维事项，而是一个需要纳入日常 DevOps 流程、持续监控与自动化处理的关键资产。

面对愈发严苛的证书政策和愈加复杂的系统架构，我们要做的不是回避变化，而是用工具与流程将不确定性变为确定性，让安全真正“跑在业务前面”，而不是在事故发生后才追悔莫及。





## 十三、域前置伪装



> 核心原理：
>
> 域前置的核心技术是 CDN。因为 CDN 大多都是复用的，1 台 CDN 会同时负责对多个网站进行加速，如 `a.com` 和 `b.com` 都是由 `22.33.22.33` 这个 CDN 进行加速的。
>
> 当我浏览器访问 `a.com` 和 `b.com` 其实都是访问的 `22.33.22.33` 这个 IP，那么问题来了，CDN 如何分辨访问是哪个域名的呢？通过 HTTP 请求包中的 Host 头，而 Host 头又是极其容易伪造的，所以这就有了可乘之机。





渗透测试过程中，我们会遇到这种情形，即网络中部署了很多防御方案，比如防火墙开启IDP，IPS，IDS等，这些方案可用于限制网络出站规则。

例如，仅仅允许TCP 80及443通过代理离开网络，并且还会有许多设备在应用层来检查这个流量，如果检测到恶意的Payload，则进行拦截并报警。

绕过这些解决方案一直是入侵者与防御者之间的博弈，防御者努力的想怎么拦，而入侵者在努力的想怎么绕。因此也有了很多很多的攻击技术，比如DNS隧道，ICMP隧道等等。

最近有一篇文章[《Doodles, stickers, and censorship circumvention for Signal Android》](https://whispersystems.org/blog/doodles-stickers-censorship/)介绍了通过`Domain Fronting`来绕过信号限制的方式，在此文中指出“许多流行的服务和CDN（如Google，Amazon Cloudfront，Amazon S3，Azure，CloudFlare，Fastly和Akamai）可以以一种方式获取信号，这种方式看起来与其他未经审查的流量不可辨别。因此，我们也可以通过此技术来绕过一些过滤规则。



假设我们执行以下一种命令：

```bash
curl https://www.allow.com -H "Host: www.forbidden.com" -v

curl https://1.1.1.1 -H "Host: www.forbidden.com" -v  ##1.1.1.1为CDN的IP

```



结果是，***客户端实际通信的对象是www.forbidden.com，但在流量监控设备看来，客户端是在与www.allow.com通信，即客户端将流量成功伪装成了与www.allow.com通信的流量***



- 用户用合法的域名`allow.com`向DNS请求CDN的IP，然后向CDN发起请求，这一步自然是没有任何问题的



## 十四、TLS双向认证

在标准 HTTPS 中，主要是服务器向客户端证明自己的身份（通过服务器证书），从而建立起一个安全的、加密的通信通道。

**双向认证则是在此基础上更进一步，要求客户端也提供证书，由服务端验证客户端的身份。这种方式常用于需要高度安全的系统，以确保通信双方都是可信任的。**



最典型的场景就是kubernetes：**Kubernetes集群的访问权限控制由API Server负责，API Server的访问权限控制由身份验证(Authentication)、授权(Authorization)和准入控制（Admission control）三个步骤组成**





客户端需要携带由该客户端 CA 证书签发的客户端证书进行访问



https://blog.kenxu.top/post/bypass-gfw-p1/

# PKI体系

https://arthurchiao.art/blog/everything-about-pki-zh/







# 解决方案 



### HTTPS证书吊销机制梳理



- HTTPS的证书过期是谁来判断？
- 证书的合法性又是谁检查的呢？
- 什么时候触发?
- 影响性能吗?
- 如何吊销证书?
- HTTPS的请求是客户端（浏览器）发起的，他是如何知道证书被吊销的？
- 验证HTTPS证书的过程是什么样的？



在 TLS 握手中，有一个证书校验阶段，服务端把域名证书的公钥下发给浏览器（客户端），浏览器（客户端）校验证书合法性：



**证书完整性验证**

使用RSA公钥解密来验证证书上的私钥签名是否合法，如果签名无效，则可认定证书被修改，直接报错。

**证书有效性验证**

CA在颁发证书时，都为每个证书设定了有效期，包括开始时间与结束时间。系统当前时间不在证书起止时间的话，都认为证书是无效的。

**证书吊销状态检测**

如果，证书在有效期之内需要丢了怎么办？需要吊销证书了，那么这里就多了一个证书吊销状态的检测。用户将需要吊销的证书通知到CA服务商，CA服务商通知浏览器该证书的撤销状态。





## mTLS



相互 TLS 简称 mTLS，是一种[相互身份验证](https://www.cloudflare.com/learning/access-management/what-is-mutual-authentication/)的方法。mTLS 通过验证他们都拥有正确的私人[密钥](https://www.cloudflare.com/learning/ssl/what-is-a-cryptographic-key/)来确保网络连接两端的各方都是他们声称的身份。



mTLS 通常被用于[零信任](https://www.cloudflare.com/learning/security/glossary/what-is-zero-trust)安全框架*，以验证组织内的用户、设备和服务器。它也可以帮助保持 API 的安全。

**零信任意味着默认情况下不信任任何用户、设备或网络流量，这种方法有助于消除许多安全漏洞。**







通常在 TLS 中，服务器有一个 TLS 证书和一个公钥/私钥对，而客户端没有。典型的 TLS 流程是这样运作的：



1. 客户端连接到服务器
2. 服务器出示其 TLS 证书
3. 客户端验证服务器的证书
4. 客户端和服务器通过加密的 TLS 连接交换信息





在 mTLS 中，客户端和服务器都有一个证书，并且双方都使用它们的公钥/私钥对进行身份验证。与常规 TLS 相比，mTLS 中有一些额外步骤来验证双方（额外的步骤**加粗**显示）。

1. 客户端连接到服务器
2. 服务器出示其 TLS 证书
3. 客户端验证服务器的证书
4. **客户端出示其 TLS 证书**
5. **服务器验证客户端的证书**
6. **服务器授予访问权限**
7. 客户端和服务器通过加密的 TLS 连接交换信息



实施 mTLS 的组织充当其自己的证书颁发机构。这与标准 TLS 相反，标准 TLS 的证书颁发机构是一个外部组织，负责检查证书所有者是否合法拥有关联[域](https://www.cloudflare.com/learning/dns/glossary/what-is-a-domain-name/)（了解 [TLS 证书验证](https://www.cloudflare.com/learning/ssl/types-of-ssl-certificates)）。

mTLS 需要“根”TLS 证书；这使组织能够成为他们自己的证书颁发机构。授权客户端和服务器使用的证书必须与此根证书相对应。根证书是自签名的，这意味着组织自己创建它。（这种方法不适用于公共互联网上的单向 TLS，因为必须由外部证书颁发机构颁发这些证书。）







参考： 

https://info.support.huawei.com/info-finder/encyclopedia/zh/SSL.htm



# websocket

HTTP 协议有一个缺陷：通信只能由客户端发起。

举例来说，我们想了解今天的天气，只能是客户端向服务器发出请求，服务器返回查询结果。HTTP 协议做不到服务器主动向客户端推送信息。



WebSocket 是一种网络传输协议，可在单个 TCP 连接上进行全双工通信，位于 OSI 模型的应用层。

在HTML5中，为了加强web的功能，提供了websocket技术，它不仅是一种web通信方式，也是一种应用层协议。

WebSocket 协议在 2011 年由 IETF 标准化为 [RFC 6455](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Ftools.ietf.org%2Fhtml%2Frfc6455)，后由 [RFC 7936](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Ftools.ietf.org%2Fhtml%2Frfc7936) 补充规范。

它提供了浏览器和服务器之间原生的双全工跨域通信，通过浏览器和服务器之间建立websocket连接（实际上是TCP连接）。

在 [RFC 6455](https://datatracker.ietf.org/doc/html/rfc6455) 规范中描述的 `WebSocket` 协议，提供了一种在浏览器和服务器之间建立持久连接来交换数据的方法。

数据可以作为“数据包”在两个方向上传递，而无需中断连接也无需额外的 HTTP 请求。



它借鉴了socket这种思想，为web应用程序客户端和服务端之间（注意是客户端服务端）提供了一种全双工通信机制。同时，它又是一种新的应用层协议

WebSocket 使得客户端和服务器之间的数据交换变得更加简单，允许服务端主动向客户端推送数据。

在 WebSocket API 中，浏览器和服务器只需要完成一次握手，两者之间就可以创建持久性的连接，并进行双向数据传输。



首先是客户端new 一个websocket对象，该对象会发送一个http请求到服务端，服务端发现这是个webscoket请求，会同意协议转换，发送回客户端一个101状态码的response，以上过程称之为一次握手，经过这次握手之后，客户端就和服务端建立了一条TCP连接，在该连接上，服务端和客户端就可以进行双向通信了。这时的双向通信在应用层走的就是ws或者wss协议了，和http就没有关系了。所谓的ws协议，就是要求客户端和服务端遵循某种格式发送数据报文（帧），然后对方才能够理解。







# WEB性能优化最佳实践

近几年来，WPO（Web Performance Optimization，Web 性能优化）产业从无到有，快速增长，充分说明用户越来越重视速度方面的用户体验。

而且，在我们这个节奏越来越快、联系越来越紧密的世界，追求速度不仅仅是一种心理上的需要，更是一种由现实事例驱动的用户需求。



- 网站越快，用户的黏性越高；
- 网站越快，用户忠诚度更高； 
- 网站越快，用户转化率越高。



在软件交互中，哪怕 100~200 ms 左右的延迟，我们中的大多数人就会感觉到“拖拉”；

如果超过了 300 ms 的门槛，那就会说“反应迟钝”；而要是延迟达到 1000 ms（1s）这个界限，很多用户就会在等待响应的时候分神，有人会想入非非，有人恨不得忙点别的什么事儿。





简言之，速度是关键。要提高速度，必须先了解与之相关的各种因素，以及根本性的限制。

本章主要介绍对所有网络通信都有决定性影响的两个方面：延迟和带宽



- 延迟：分组从信息源发送到目的地所需的时间
- 带宽：逻辑或物理通信路径最大的吞吐量





> tracert 路由跟踪
>
> http://einverne.github.io/post/2017/06/traceroute.html



> 为减少跨大西洋的延迟而铺设 Hibernia Express 专线
>
>
> 在金融市场上，很多常用交易算法首要的考虑因素就是延迟，因为几 ms 的差距可能导致数百万美元的收益或损失。
> 2011 年初，华为与 Hibernia Atlantic 开始合作铺设一条横跨大西洋，连接伦敦和纽约的近 5000 km 的海底光缆（Hibernia Express）。
>
> 铺设这条海底光缆的唯一目的，就是减少城市间的路由，（相对于使用其他横跨大西洋的线路）为交易商节省 5 ms 的延迟。
>
> 开通运营后，这条光缆将只由金融机构使用，耗资预计达 4 亿美元。
> 简单计算一下，不难得出节省 1 ms 的成本是 8000 万美元。延迟的代价由此可见一斑。







**大名鼎鼎的雅虎前端优化规则**



### 减少HTTP请求数

Make Fewer HTTP Requests

Web 前端 80% 的响应时间花在图片、样式、脚本等资源下载上。最直接的方式是减少页面所需资源，但并不现实。所以，减少HTTP请求数主要的途径是：

- Combined files 合并JS/CSS文件。服务器端（CDN）自动合并，基于Node.js的文件合并工具，通过把所有脚本放在一个文件中的方式来减少请求数。
- CSS Sprites 雪碧图可以合并多个背景图片，通过`background-image` 和 `background-position` 来显示不同部分。
- Inline images 行内图片使用Data URI scheme将图片嵌入HTML或者CSS中；或者将CSS、JS、图片直接嵌入HTML中，会增加文件大小，也可能产生浏览器兼容及其他性能问题。

减少页面的HTTP请求数是个起点，这是提升站点首次访问速度的重要指导原则。



减少DNS查询



减少DNS查询。

就像电话簿，你在浏览器地址栏输入网址，通过DNS查询得到网站真实IP。

DNS查询被缓存来提高性能。这种缓存可能发生在特定的缓存服务器（ISP/local area network维护），或者用户的计算机。DNS信息留存在操作系统DNS缓存中（在windows中就是 *DNS Client Serve* ）。大多浏览器有自己的缓存，独立于操作系统缓存。只要浏览器在自己的缓存里有某条DNS记录，它就不会向操作系统发DNS解析请求。

IE默认缓存DNS记录30分钟，FireFox默认缓存1分钟。

当客户端的DNS缓存是空的，DNS查找次数等于页面中的唯一域名数。

减少DNS请求数可能会减少并行下载数。避免DNS查找减少响应时间，但减少并行下载数可能会增加响应时间。指导原则是组件可以分散在至少2个但不多于4个的不同域名。这是两者的妥协。





雪碧图的主要作用是**减少 HTTP 请求数量**。

假如你有 100 张小图片，你要发起 100 个请求。如果你合并成一个大图片，那你只需要发一个请求。

这在 HTTP/1 上是有不错的优化效果的，因为 HTTP/1 下不能充分利用 TCP 带宽，一个 TCP 同时只能有一个请求，请求太多就要排队，导致严重的阻塞。

到了 HTTP/2 因为多路复用特性的缘故，则没有太大必要了，所有的请求都是通过流的方式打散发送的，充分利用 TCP 的带宽。



另一个作用是 **提前加载好需要用到的图片**。

假设我们的一个按钮是用图片做的，hover 时会替换图片。如果分成独立的两个图片，hover 就会出现闪烁的效果。

这是因为图片还没有下载好，在图片完成下载前，显示的是空白，直到图片下载完成才替换上图片。

如果我们将按钮的所有状态都放到雪碧图了，就不会有这个问题了。当然还有一种方式就是通过 JS 手动做其他状态小图片的缓存。





### 域名发散和域名收敛

在大型网站中，我们发现页面资源经常使用不同的域名进行引用。

例如126邮箱的部分js、css、图片存放于http://mimg.127.net/域名下，京东的部分静态图片存放在http://img11.360buyimg.com域名下。

知乎中的图片资源的URL通常是 https://pic1.zhimg.com/013926975_im.jpg ，与主站的域名不同。



引申到了一个网上说的头条面试题：网页中的图片资源为什么分放在不同的域名下 ?  

那这样做究竟有什么好处呢，和性能又有什么关系呢，下面进行具体分析。

首先，浏览器对域名的请求限制。一般都是查看浏览器的network。通过查看network发现，chrome浏览器在同一时间内向同域至多发起6个请求。之后的请求，需要等待前6个返回后才能技术发送。

- **浏览器针对同一个域名的并发请求是有限制的，Chrome 和 edge 都是 6 个。即在Chrome中访问 www.zhihu.com 时，同时最多只能有 6 个TCP连接。**

- **浏览器对并发请求的数目限制是针对域名的，即针对同一域名在同一时间支持的并发请求数量的限制。**

如果请求数目超出限制，则会阻塞。因此，网站中对一些静态资源，使用不同的一级域名，可以提升浏览器并行请求的数目，加速界面资源的获取速度。







**追根究底一下，浏览器为什么要针对同一域名的tcp并发连接数要设限制？**

网络连接的本质为 http 连接，而 http 是封装过的 tcp 连接，那么问题就转化为了：为什么要对 tcp 连接进行并发限制？

基于端口数量和线程切换开销的考虑，浏览器不可能无限量的并发请求，因此衍生出来了并发限制和HTTP/1.1的Keep alive。 所以，IE6/7在HTTP/1.1下的并发才2，但HTTP/1.0却是4。 

而随着技术的发展，负载均衡和各类NoSQL的大量应用，基本已经足以应对C10K的问题。 但却并不是每个网站都懂得利用domain hash也就是多域名来加速访问。因此，新的浏览器加大了并发数的限制，但却仍控制在8以内



- **保护客户端**：由于 TCP 协议的限制，PC 端只有65536个端口可用以向外部发出连接，而操作系统对半开连接数也有限制以保护操作系统的 TCP\IP 协议栈资源不被迅速耗尽，因此浏览器不好发出太多的 TCP 连接，而是采取用完了之后再重复利用 TCP 连接或者干脆重新建立 TCP 连接的方法。

  

- 如果采用阻塞的套接字模型来建立连接，同时发出多个连接会导致浏览器不得不多开几个线程，而线程有时候算不得是轻量级资源，毕竟做一次上下文切换开销不小。

- 这是浏览器作为一个有良知的客户端在保护服务器。就像以太网的冲突检测机制，客户端在使用公共资源的时候必须要自行决定一个等待期。

  - 当超过2个客户端要使用公共资源时，强势的那个邪恶的客户端可能会导致弱势的客户端完全无法访问公共资源。
  - 从前迅雷被喷就是因为它不是一个有良知的客户端，它作为 HTTP 协议客户端没有考虑到服务器的压力，作为 BT 客户端没有考虑到自己回馈上传量的义务。

  

- 

  

  

**修改并发请求数量**

浏览器这样做出发点是好的，但有时候我们想要个性化定制（比如做个插件开个挂之类的😈）就没那么方便了，那能不能修改限制上限呢？

- Chrome 的并发请求数量是不能修改的，因为已经固定写到源码中了，具体可以查看这个[链接](https://chromium.googlesource.com/chromium/src/+/65.0.3325.162/net/socket/client_socket_pool_manager.cc#44)

- Firefox 是可以修改的，想要修改首先在地址栏输入 `about:config`，搜索 `http.max` 关键字。下面这两个列都可以修改。
  - `network.http.max-connections` 为全局 HTTP 同时最大的连接数量，默认为 900；
  - `network.http.max-persistent-connections-per-server` 为单个域名最大链接数量，默认为 6；





**域名发散/分区**

针对浏览器这种并发限制，在前端性能优化手段上，很自然就会诞生**域名发散**的技术：

> 将资源跟主站放在不同的域名之下。以提供最大并行度，让客户端加载静态资源更为迅速。
>
> 每个新主机名都要求有一次额外的 DNS 查询，每多一个套接字都会多消耗两端的一些资源，而更糟糕的是，站点作者必须手工分离这些资源，并分别把它们托管到多个主机上。
>
> 实践中，把多个域名（如 shard1.example.com、shard2.example.com）解析到同一个 IP 地址是很常见的做法。所有分区都通过 CNAME DNS 记录指向同一个服务器，而浏览器连接限制针对的是主机名，不是 IP 地址。
>
> 另外，每个分区也可以指向一个 CDN 或其他可以访问到的服务器。
>
> 域名分区是一种合理但又不完美的优化手段。请大家一定先从最小分区数目（不分区）开始，然后逐个增加分区并度量分区后对应用的影响。







**域名收敛**

域名收敛的意思就是建议将静态资源只放在一个域名下面，而非发散情况下的多个域名下。域名发散可以突破浏览器的域名并发限制，那么为要反其道而行之呢？

域名发散是 PC 时代的产物，在 PC 上，我们采用域名发散策略，是因为在 PC 端上，DNS 解析通常而言只需要几十 ms ，可以接受。

在移动互联网时代，通过无线设备访问网站，App的用户已占据了很大一部分比重，而域名发散正是在这种情况下提出的。

移动端，2G 网络/3G网络/4G网络/wifi 强网，而且移动 4G 容易在信号不理想的地段降级成 2G 。

通过大量的数据采集和真实网络抓包分析（存在DNS解析的请求），DNS的消耗相当可观，2G网络大量5-10s，3G网络平均也要3-5s（数据来源于淘宝）。 

下面附上在 2G，3G，4G， WIFI 情况下 DNS 递归解析的时间 （ms）：



**因为在增加域的同时，往往会给浏览器带来 DNS 解析的开销。所以在这种情况下，提出了域名收敛，减少域名数量可以降低 DNS 解析的成本。**







### 请求数优化

 

Web 前端 80% 的响应时间花在图片、样式、脚本等资源下载上。最直接的方式是减少页面所需资源，但并不现实。所以，减少 HTTP 请求数主要的途径是：





### DNS预读和缓存

[MDN参考文档](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/X-DNS-Prefetch-Control)

有dns的地方，就有缓存。浏览器、操作系统、Local DNS、根域名服务器，它们都会对DNS结果做一定程度的缓存。











前面讲到了 DNS 的开销。当浏览器访问一个域名的时候，需要解析一次DNS，获得对应域名的ip地址。在解析过程中：

**按照浏览器缓存、操作系统缓存、路由器缓存、ISP(运营商)DNS缓存、根域名服务器、顶级域名服务器、主域名服务器的顺序，逐步读取缓存，直到拿到IP地址。**



**浏览器DNS缓存**

**注意，浏览器DNS缓存的时间跟DNS服务器返回的TTL值无关。**

> 浏览器在获取网站域名的实际IP地址后会对其IP进行缓存，减少网络请求的损耗。
>
> 每种浏览器都有一个固定的DNS缓存时间，其中Chrome的过期时间是1分钟，在这个期限内不会重新请求DNS。
>
> Chrome浏览器看本身的DNS缓存时间比较方便，在地址栏输入：





**DNS Prefetch**

DNS Prefetch，即DNS预解析。

就是根据浏览器定义的规则，提前解析之后可能会用到的域名，使解析结果缓存到系统缓存中，缩短DNS解析时间，来提高网站的访问速度。



现代浏览器在 DNS Prefetch 上做了两项工作：

- 1、html 源码下载完成后，会解析页面的包含链接的 a 标签，提前查询对应的域名。
- 2、对于访问过的页面，浏览器会记录一份域名列表，当再次打开时，会在 html 下载的同时去解析 DNS。



DNS预解析分为以下两种：

**自动解析**

浏览器使用超链接的href属性来查找要预解析的主机名。

当遇到a标签，浏览器会自动将href中的域名解析为IP地址，这个解析过程是与用户浏览网页并行处理的。但是为了确保安全性，在HTTPS页面中不会自动解析。

**手动解析**

在页面添加如下标记：

```
<link rel="dns-prefetch" href="//g.alicdn.com" />
```

上面的`link`标签会让浏览器预取"g.alicdn.com"的解析

希望在`HTTPS`页面开启自动解析功能时，添加如下标记：

```
<meta http-equiv="x-dns-prefetch-control" content="on">
```

希望在`HTTP`页面关闭自动解析功能时，添加如下标记：

```
<meta http-equiv="x-dns-prefetch-control" content="off">
```

**并非所有页面都要手动解析，一般在整个站点的入口页做这个工作就行了，毕竟一个站点下用到的大多数域名都会在首页体现。**





DNS Prefetch有效缩短了DNS的解析时间

如果浏览器最近将一个域名解析为IP地址，所属的操作系统将会缓存，下一次DNS解析时间可以低至0-1ms。 

如果结果不在系统本地缓存，则需要读取路由器的缓存，则解析时间的最小值大约为15ms。如果路由器缓存也不存在，则需要读取ISP（运营商）DNS缓存，一般像`taobao.com`、`baidu.com`这些常见的域名，读取ISP（运营商）DNS缓存需要的时间在80-120ms，如果是不常见的域名，平均需要200-300ms。一般的网站在运营商这里都能查询的到，所以普遍来说DNS Prefetch可以给一个域名的DNS解析过程带来15-300ms的提升，尤其是一些大量引用很多其他域名资源的网站，提升效果就更加明显了。

浏览器底层缓存进行了建模，当Chrome浏览器启动的时候，就会自动的快速解析浏览器最近一次启动时记录的前10个域名。所以经常访问的网址就没有DNS解析的延迟，打开速度更快。



**`X-DNS-Prefetch-Control`** 头控制着浏览器的 DNS 预读取功能。 



DNS 预读取是一项使浏览器主动去执行域名解析工作的功能，其范围包括文档的所有链接，无论是图片的，CSS 的，还是 javaScript 等其他用户能够点击的 URL。















## TCP优化



# 浏览器渲染原理

当浏览器的网络线程收到 HTML 文档后，会产生一个渲染任务，并将其传递给渲染主线程的消息队列。 在事件循环机制的作用下，渲染主线程取出消息队列中的渲染任务，开启渲染流程。

整个渲染流程分为多个阶段，分别是： HTML 解析、样式计算、布局、分层、绘制、分块、光栅化、绘画 每个阶段都有明确的输入输出，上一个阶段的输出会成为下一个阶段的输入。 这样，整个渲染流程就形成了一套组织严密的生产流水线。





https://wukaipeng.com/technique/browser/rendering



# 浏览器进程模型

传统的浏览器被设计为显示网页，而Chrome的设计目标是支撑"Web App"（当时的js和相关技术已经相当发达了，Gmail等服务也很成功）。

这就要求Chrome提供一个类似于“[操作系统](https://www.zhihu.com/search?q=操作系统&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A999401453})”感觉的架构，支持App的运行。而App会变得相当的复杂，这就难以避免出现bug，然后crash。

同时浏览器也要面临可能运行“[恶意代码](https://www.zhihu.com/search?q=恶意代码&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A999401453})”。



浏览器不能决定上面的js怎么写，会不会以某种形式有意无意的攻击浏览器的渲染引擎。如果将所有这些App和浏览器实现在一个进程里，一旦挂，就全挂。

因此Chrome一开始就设计为把**隔离性**作为基本的设计原则，用进程的隔离性来实现对App的隔离。这样用户就不用担心：

- 一个Web App挂掉造成其他所有的Web App全部挂掉（稳定性）
- 一个Web App可以以某种形式访问其他App的数据（安全性）

以及Web App之间是并发的，可以提供更好的响应，一个App的渲染卡顿不会影响其他App的渲染（性能）（当然这点线程也能做到）



因此，这样看起来用进程实现非常自然。



目前世界上使用率最高的浏览器是 [Chrome](https://www.google.com/chrome/)，它的核心是 [Chromium](https://www.chromium.org/chromium-projects/)（Chrome 的开发实验版），微软的 [Edge](https://www.microsoft.com/en-us/edge) 以及国内的大部分主流浏览器，都是基于 Chromium 二次开发而来，它们都有一个共同的特点：**多进程架构**。

当我们用 Chrome 打开一个页面时，会同时启动多个进程：(Chrome 使用了由 Apple 发展来的号称 “地表最快” 的 [Webkit](https://webkit.org/) 排版引擎，搭载 Google 独家开发的 [V8](https://v8.dev/) Javascript 引擎)

注：Google 加入 WebKit 的开发是在 2008 年 Chrome 浏览器推出前后的事情。Chrome 浏览器使用 WebKit 引擎是 Android 团队的建议，2013年Google将 Chrome 的渲染引擎从WebKit 分叉出来，并将其命名为Blink

https://developer.chrome.com/docs/web-platform/blink



**高性能的 Web 应用的设计和优化都离不开浏览器的多进程架构**，接下来我会以 Chrome 为例，带你了解多进程架构。



`Chromium`里有三种进程——浏览器、渲染器和插件。

浏览器进程只有一个，管理窗口和tab，也处理所有的与磁盘，网络，用户输入和显示的工作。这就是我们看到的“Chrome界面”。

渲染器开多个。每个渲染器负责处理HTML、CSS、js、图片等，将其转换成用户可见的数据。以前的 Chrome使用开源的 webkit 实现这个功能。

> 顺便说一句，webkit是由Apple开发的，当时有很多坑，也被长期吐槽；现在Chrome已经转成使用自家的Blink引擎了。

插件会开很多。每个类型的插件在第一次使用时会启动一个相应的进程。



一般来讲每一个网站的实例都会创建一个渲染进程。

但也有特例，比如一个站点通过js在新tab/window上打开同一个站点的另外的页面。这两个界面内部会共享同一个进程，也能彼此分享数据。

在Chrome角度，这两个页面算是“同一个App”。



但是如果用户用浏览器的地址栏开一个新的tab，而该网址已经有tab了，Chrome会算是“来自同一域名的两个App”，从而创建新的进程。

但是大家都知道进程开多了资源消耗也变大，因此Chrome会限制最大的进程数量（比如20）。

当进程达到这个数量后，Chrome会倾向于去复用已有的进程（所以这时，隔离性就会被影响）。







# Chrome性能分析工具





在chrome浏览器中，打开view - Developer - Developer Tools，选择performance标签，就会出现这Chrome Developer tools的性能标签页。

- 第一部分：

在performance界面的第一部分，最上面的是时间线。

时间线下面依次是FPS、CPU、NET、HEAP。

**FPS**：frame per second，每秒帧数。这部分和页面的动画性能相关，如果出现了**红色的长条，说明这部分有卡帧**的情况，需要进行优化。而绿色的长条说明性能好，绿色的长条越长说明性能越好。



# 动态数据

在现代网站和应用中另一个常见的任务是**从服务端获取个别数据来更新部分网页而不用加载整个页面**。这看起来是小细节却对网站性能和行为产生巨大的影响。

所以我们将在这篇文章介绍概念和技术使它成为可能，例如：XMLHttpRequest 和 Fetch API





这导致了创建允许网页请求小块数据（例如 [HTML](https://developer.mozilla.org/zh-CN/docs/Web/HTML), [XML](https://developer.mozilla.org/zh-CN/docs/Glossary/XML), [JSON](https://developer.mozilla.org/zh-CN/docs/Learn/JavaScript/Objects/JSON), 或纯文本) 和 仅在需要时显示它们的技术，从而帮助解决上述问题。

这是通过使用诸如 [`XMLHttpRequest`](https://developer.mozilla.org/zh-CN/docs/Web/API/XMLHttpRequest) 之类的 API 或者 — 最近以来的 [Fetch API](https://developer.mozilla.org/zh-CN/docs/Web/API/Fetch_API) 来实现。这些技术允许网页直接处理对服务器上可用的特定资源的 [HTTP](https://developer.mozilla.org/zh-CN/docs/Web/HTTP) 请求，并在显示之前根据需要对结果数据进行格式化。

> 在早期，这种通用技术被称为 Asynchronous JavaScript and XML**（Ajax），** 因为它倾向于使用[`XMLHttpRequest`](https://developer.mozilla.org/zh-CN/docs/Web/API/XMLHttpRequest) 来请求 XML 数据。
>
> 但通常不是这种情况 (你更有可能使用 `XMLHttpRequest` 或 Fetch 来请求 JSON), 但结果仍然是一样的，术语“Ajax”仍然常用于描述这种技术。



`XMLHttpRequest`（通常缩写为 XHR）现在是一个相当古老的技术 - 它是在 20 世纪 90 年代后期由微软发明的，并且已经在相当长的时间内跨浏览器进行了标准化。



Ajax，全称“Asynchronous JavaScript and XML”（异步JavaScript和XML），是一种用于创建交互式网页应用的网页开发技术。

在 Web 应用中通过异步发送 HTTP 请求向服务器获取内容，并使用这些新内容更新页面中相关的部分，而无需重新加载整个页面的 Web 开发技术。这可以让网页更具有响应性，因为只请求了需要更新的部分。

它允许浏览器与服务器之间进行异步数据交互，可以在不重新加载整个页面的情况下，更新页面的部分内容。

AJAX的关键技术

- XMLHttpRequest（简称XHR）：这是浏览器内置的对象，允许JavaScript在后台（异步）向服务器发送请求以及接收服务器返回的数据。

- JavaScript：编写客户端脚本，用于调用XHR对象、处理服务器返回的数据以及更新DOM树中的部分内容。



数据格式：尽管名字中含有XML，但AJAX实际上并不局限于XML数据格式，JSON现在已经成为更常用的数据交换格式，因为其可读性强、体积小且容易被JavaScript解析。

异步处理：与传统的同步请求不同，异步请求不会导致浏览器停止响应，用户可以在等待服务器响应的同时继续与页面进行其他交互。

可以实现的一些功能如下

- 动态加载数据：在不刷新页面的情况下，从服务器获取新的数据并更新页面内容(百度搜索)。

- 实时验证：在用户输入时，实时检查输入的有效性并给出反馈。

- 提高用户体验：减少页面的加载时间和刷新次数，提供更加流畅的用户交互。





Fetch API 基本上是 XHR 的一个现代替代品——它是最近在浏览器中引入的，它使异步 HTTP 请求在 JavaScript 中更容易实现，对于开发人员和在 Fetch 之上构建的其他 API 来说都是如此。



这完全取决于你正在干的项目是啥样。XHR 已经面世非常之久，现在已经有了相当棒的跨浏览器支持。然而对于网页平台来说，Fetch 和 Promise 是新近的产物，除了 IE 和 Safari 浏览器不支持，别的浏览器大多提供了支持。（现在 Safari 也即将为 fetch 和 promise 提供支持）。

如果你的项目需要支持年代久远的浏览器，那么使用 XHR 可能会更爽一些。如果你的项目比较激进而且你根本不管老版的浏览器吃不吃这套，那就选择 Fetch 吧老铁。

话说回来，咱倒真应该两者都学学——因为使用 IE 浏览器的人们在变少，Fetch 会变得越来越流行（事实上 IE 已经没人管了，因为微软 Edge 浏览器的受宠），但在所有浏览器彻底支持 Fetch 之前，你可能还得和 XHR 纠缠一阵子。



# restful 架构风格



REST（英文：Representational State Transfer，又称具象状态传输）

是 Roy Thomas Fielding 博士于 2000 年在他的博士论文中提出来的一种万维网软件（可理解为 Web 应用）架构风格。

目的是便于不同软件/程序在网络（例如互联网）中互相传递信息。

**REST 是一种软件架构风格，不是技术框架，REST 有一系列规范，满足这些规范的 API 均可称为 RESTful API。**

**REST 与技术无关，它代表的是一种软件架构风格，REST它是 Representational State Transfer 的简称，中文的含义是: "表征状态转移" 或 "表现层状态转化"。**

它是基于 HTTP、URI、XML、JSON 等标准和协议，支持轻量级、跨平台、跨语言的架构设计。

目前在三种主流的 Web 服务实现方案中，因为 REST 模式与复杂的 SOAP 和 XML-RPC 相比更加简洁，越来越多的 web 服务开始采用 REST 风格设计和实现。

例如，Amazon.com 提供接近 REST 风格的 Web 服务执行图书查询；雅虎提供的 Web 服务也是 REST 风格的。

RESTful API，RESTful 是目前最流行的API设计规范，它是用于Web数据接口的设计。它结构清晰、符合标准、易于理解、扩展方便，所以正得到越来越多网站的采用。

Fielding 是一个非常重要的人，他是 HTTP 协议（1.0 版和 1.1 版）的主要设计者、Apache 服务器软件的作者之一、Apache 基金会的第一任主席。

所以，他的这篇论文一经发表，就引起了关注，并且立即对互联网开发产生了深远的影响。



前后端分离的思想: 即后端负责数据接口, 前端负责数据渲染, 前端只需要请求下api接口拿到数据，然后再将数据显示出来。

因此后端开发人员需要设计api接口，因此为了统一规范: 社区就出现了 RESTful API 规范，其实该规范很早就有的，只是这几年最近慢慢流行起来。

RESTful API 可以通过一套统一的接口为所有web相关提供服务，实现前后端分离。



如果一个架构符合 REST 原则，就称它为 RESTful 架构。

- 资源（Resources）

这个还是比较好理解的，我们平时上网就是在不停的访问资源嘛~~前面也是说过 URI（统一资源定位符）的互联网上的每一种资源都可以对应一个特定的 URL。

所谓"上网"，就是与互联网上一系列的"资源"互动，调用它的 URI。

- 表现层（Representation）

"资源"是一种信息实体，它可以有多种外在表现形式。我们把"资源"具体呈现出来的形式，叫做它的"表现层"（Representation）。

举个栗子就是一段字符可以表现为 txt、HTML、XML、JSON；一幅图片可以是 JPEG、GIF、PNG；

URL 来确定这个实体（资源），它的具体表现形式，应该在 HTTP 请求的头信息中用 Accept 和 Content-Type 字段指定，这两个字段才是对"表现层"的描述。

- 状态转化（State Transfer）

访问一个网站，就代表了客户端和服务器的一个互动过程。在这个过程中，势必涉及到数据和状态的变化。

HTTP 协议是一个无状态协议。这意味着，所有的状态都保存在服务器端。

因此，如果客户端想要操作服务器，必须通过某种手段，让服务器端发生"状态转化"（State Transfer）。而这种转化是建立在表现层之上的，所以就是"表现层状态转化"。

客户端用到的手段，只能是 HTTP 协议，它们分别对应四种基本操作：

- GET用来获取资源
- POST用来新建资源（也可以用于更新资源）
- PUT用来更新资源
- DELETE用来删除资源



**REST API 设计原则**

1. 每一个URI代表一种资源;

2. 同一种资源有多种表现形式(xml/json);

3. 所有的操作都是无状态的。

4. 规范统一接口。

5. 返回一致的数据格式。

6. 可缓存(客户端可以缓存响应的内容)。

符合上述REST原则的架构方式被称作为 RESTful 规范。



在接口命名时应该用名词，不应该用动词，因为通过接口操作到是资源。

在url中加入版本号，利于版本迭代管理更加直观。



```
https://www.rgc.com/v1/
```



# 浏览器地址栏输入后回车会发生什么

一道经典的面试题"浏览器打开url到页面展现，中间发生了什么？"，面试官通常用这道题来考察候选者对网络知识掌握的广度和深度。

「当浏览器输入网页后，发生了什么事？」



*知识的诅咒（英语：Curse of knowledge），又称专家盲点，是一种 认知偏差，指人在与他人交流的时候，下意识地假设对方拥有理解所需要的背景知识。 Robin Hogarth首先提出该名词 [1] 。 专家盲点也是 教育的重大阻碍之一。*



[重新思考浏览器输入了 URL 并按下回车之后到底发生了什么——本地 DNS 部分 | Nova Kwok's Awesome Blog](https://nova.moe/rethink-type-url-dns/)

## 1、浏览器URL自动补全填充

现在的浏览器，地址栏（多功能框）也可以用作搜索框。地址栏会自动使用 Google 进行搜索，但您也可将默认搜索引擎改设为另一搜索引擎。

当我们在浏览器地址栏输入信息时，浏览器就已经开始进行工作了。浏览器根据自己的算法，以及当前是否隐身模式。

首先它会监听我们输入的信息并尝试匹配出你想要访问的网址或关键词，以 `chrome` 为例，它会猜我们想要什么，给出下面的建议项：

- 使用默认搜索引擎搜索关键字
- 书签，历史记录和最近下载中存储的其他链接
- 使用默认搜索引擎的相关关键字搜索选项



这些建议选项来源于输入内容匹配到的书签和历史记录（URL和title都可被匹配），输入关键字的搜索建议，以及其它的一些策略。

Chrome提供了一个工具页`chrome://predictors`来查看历史建议。可以看出，每个建议会被计算命中次数和命中概率。

如果输入的内容匹配到较高预测分值的建议项时，Chrome根据预测分值的高低会有不同的处理策略。

如在输入过程中就提前进行`DNS预解析`，预先建立`TCP连接`，甚至`预先加载页面`等。

这样，当我们输入完URL按回车键之前，Chrome其实已经提前开始工作了，以便为用户节省时间。





## 2、浏览器URL解码

因为网络标准规定了 URL 中只能包含字母和数字，还有一些其它特殊符号（包括百分号和双引号等）

通常如果一样东西需要编码，说明这样东西并不适合传输。原因多种多样，如size过大，包含隐私数据。

对于URL来说，之所以要进行编码，主要是以下几个原因

- `URL中有些字符可能会引起歧义`。

- 有些特殊值（比如中文等），无法直接在URL中体现。

如果不转义就会出现歧义，比如 `https://www.baidu.com/s?wd=nginx`，假如我的`key`本身就包括等于`=`符号，比如`ke=y=value`，就会出现歧义，你不知道`=`到底是连接`key`和`value`的符号，还是说本身`key`里面就有`=`。



具体可参考

https://blog.csdn.net/swadian2008/article/details/104280384

https://yangleiup.github.io/accumulate/url%E7%BC%96%E7%A0%81%E4%B8%8E%E8%A7%A3%E7%A0%81.html

## 3、DNS解析

有DNS的地方，就有缓存。浏览器、操作系统、Local DNS、根域名服务器，它们都会对 DNS 结果做一定程度的缓存。



**简单来说，一条域名的 DNS 记录会在客户端本地有两种缓存：浏览器缓存和操作系统(OS)缓存。注意这两个不是一个概念。**

在浏览器中访问域名的时候，会优先访问浏览器缓存，如果未命中则访问 OS 缓存，最后再进行DNS查找。





https://blog.skk.moe/post/what-happend-to-dns-in-proxy/

https://jaminzhang.github.io/dns/DNS-TTL-Understanding-and-Config/

我们在设置 DNS 解析记录会有一个 ttl 值(time to live)，单位是秒，意思是这个记录最大有效期是多少秒。

**经过实验，OS 缓存DNS解析记录时会参考 ttl 值，但是不完全等于 ttl 值，而浏览器 DNS 缓存的时间跟 ttl 值无关，每种浏览器都使用一个固定值。**



- 在Chrome地址栏中输入chrome://net-internals/#dns 就可以看各域名的DNS 缓存时间。默认，Chrome对每个域名会默认缓存60s。

- 







### 浏览器是怎么发出的 DNS 请求



现代的浏览器本身会缓存 DNS 记录，这个缓存在 Chrome 的官方文档中被称为 built-in resolver 或者 async resolver

浏览器DNS缓存 



浏览器 DNS 缓存（未命中） -> 浏览器调用 `getaddrinfo()` 查询数据，其中，`getaddrinfo()` 的查询背后有多个缓存





## 4、HSTS检查

众所周知，采用HTTPS的网站更安全。

现代浏览器会内置一个列表，记录了一些域名。如果我们访问的域名在这个列表中，浏览器在发送第一个请求之前就会自动将网络协议补全成为`HTTPS`。



比如这个[链接](https://cloud.tencent.com/document/product/400/35244)中，描述了让nginx设置 http 跳转 https

简单来讲就是，浏览器向网站发起一次HTTP请求，服务器会返回301重定向，然后客户端会再发起一次 HTTPS 请求，并得到最终的响应内容。

所有的这一切对用户而言是完全透明的，所以在用户眼里看来，在浏览器里直接输入域名却依然可以用HTTPS协议和网站进行安全的通信，是个不错的用户体验。

**这个过程其实发生了一次 http 请求和响应的。这种情况如果第一次请求被截获同样无法保证安全。这就是所谓的  SSL Stripping Attack（SSL 剥离攻击）**





既然建立HTTPS连接之前的这一次HTTP明文请求和重定向有可能被攻击者劫持，那么解决这一问题的思路自然就变成了如何避免出现这样的HTTP请求。

我们期望的浏览器行为是：当用户让浏览器发起HTTP请求的时候，浏览器内部将其转换为HTTPS请求，直接略过上述的HTTP请求和重定向，从而使得中间人攻击失效，规避风险。

其大致流程如下：

(略过HTTP请求和重定向，直接发送HTTPS请求)

- 第1步：用户在浏览器地址栏里输入网站域名，浏览器得知该域名应该使用HTTPS进行通信
- 第2步：浏览器直接向网站发起HTTPS请求
- 第3步：网站返回相应的内容

那么问题来了，浏览器是如何做到这一点的呢？它怎么知道哪个域名应该发HTTPS请求，那个域名应该用HTTP请求呢？

HSTS技术就这样被引进来了。HSTS的全称是HTTP Strict-Transport-Security，它是一个Web安全策略机制（web security policy mechanism）。

HSTS最早于2015年被纳入到 ThoughtWorks技术雷达，并且在2016年的最新一期技术雷达里，它直接从“评估（Trial）”阶段进入到了“采用（Adopt）“阶段，这意味着ThoughtWorks强烈主张业界积极采用这项安全防御措施，并且ThoughtWorks已经将其应用于自己的项目。

HSTS最为核心的技术其实是一个HTTP响应头（HTTP Response Header）。

正是它可以让浏览器得知，在接下来的一段时间内，当前域名只能通过HTTPS进行访问，并且在浏览器发现当前连接不安全的情况下，强制拒绝用户的后续访问要求。

HSTS Header的语法如下：

Strict-Transport-Security: <max-age=>[; includeSubDomains][; preload]

- max-age是必选参数，是一个以秒为单位的数值，它代表着HSTS Header的过期时间，通常设置为1年，即31536000秒。
- includeSubDomains是可选参数，如果包含它，则意味着当前域名及其子域名均开启HSTS保护。
- preload是可选参数，只有当你申请将自己的域名加入到浏览器内置列表的时候才需要使用到它。关于浏览器内置列表，下文有详细介绍。

**让浏览器直接发起HTTPS请求**

只要在服务器返回给浏览器的响应头中，增加Strict-Transport-Security这个HTTP Header（下文简称HSTS Header），例如：

```http
Strict-Transport-Security: max-age=31536000; includeSubDomains

比如nginx设置，
add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload";

```

就可以告诉浏览器，在接下来的31536000秒内（1年），对于当前域名及其子域名的后续通信应该强制性的只使用HTTPS，直到超过有效期为止。

**Chrome、Firefox 等浏览器里，当您尝试访问该域名下的内容时，会产生一个 307 Internal Redirect（内部跳转），自动跳转到 HTTPS 请求。**

**注意这段话，Chrome 访问该域名时，会产生一个 307 的内部跳转，并自动重定向到该地址的 HTTPS 版本。**

**这个 307 响应是虚假的（dummy），而非服务器生成的——即 Chrome 是先在内部进行了此操作，然后才发出真正到达目标服务器的 HTTPS 请求。**

（注意HTTP规范中的 307 状态码描述是 Internal Redirect，而 307 状态码本身的描述是 Temporary Redirect）

很多地方都可以进行HSTS的配置，例如反向代理服务器、应用服务器、应用程序框架，以及应用程序中自定义Header。你可以根据实际情况进行选择。



另外提一点，假如`baidu.com`不在浏览器的HSTS列表中，那么也会被自动补全成`HTTPS`。

> 备注，我们也可以







## 5、TLS握手





## 6、HTTP







# HTTP请求优先级



性能优化有很多角度，其中一个关键是控制关键请求的优先级，从而达到性能优化的效果。

### 背景

网页由数十个（有时数百个）单独的资源组成，这些资源由浏览器加载和组装到最终显示的内容中。这包括用户与之交互的可见内容（HTML，CSS，图像）以及网站本身的应用程序逻辑（JavaScript），广告，跟踪网站使用情况的分析以及营销跟踪信标。对这些资源的加载方式进行排序会对用户查看内容和与页面交互所需的时间产生重大影响。





现代浏览器用流式解析器来解析 HTML —— 在完全下载之前，就可以在 HTML 标记之中找到资产。

当浏览器找到资产时，就会按照预先确定的优先级把它们加到网络队列中。









# webhook钩子详解



webhooks是一个api概念，是微服务api的使用范式之一，也被成为反向api，即：前端不主动发送请求，完全由后端推送。 举个常用例子，比如你的好友发了一条朋友圈，后端将这条消息推送给所有其他好友的客户端，就是 Webhooks 的典型场景。

简单来说，WebHook就是一个接收HTTP POST（或GET，PUT，DELETE）的URL。一个实现了WebHook的API提供商就是在当事件发生的时候会向这个配置好的URL发送一条信息。

与请求-响应式不同，使用WebHooks，你可以实时接受到变化。

这又是一种对客户机-服务器模式的逆转，在传统方法中，客户端从服务器请求数据，然后服务器提供给客户端数据（客户端是在拉数据）。

在Webhook范式下，服务器更新所需提供的资源，然后自动将其作为更新发送到客户端（服务器是在推数据），客户端不是请求者，而是被动接收方。

这种控制关系的反转可以用来促进许多原本需要在远程服务器上进行更复杂的请求和不断的轮询的通信请求。

通过简单地接收资源而不是直接发送请求，我们可以更新远程代码库，轻松地分配资源，甚至将其集成到现有系统中来根据API的需要来更新端点和相关数据，唯一的缺点是初始建立困难。





webhook是在特定情况下触发的一种api（回调），用于在项目发生相关事件时通知外部服务器。

这些回调由第三方的用户、开发人员自己定义、维护、管理，就好像允许别人挂载一条网线到你的Web网站或者应用程序的钩子上，来实时地收到你的推送信息。

比如 github  gitlab  jenkins dingding 机器人等，都支持自定义webhook





# HTTP内容协商



# 跨域

“前端如何解决跨域问题?” 

这个是前段在知乎看到的一个提问，这几乎是做前端都会遇到的一个问题，产生的情况可能会很多，解决一个问题还是要先了解下为什么会产生这样问题。



CORS 是浏览器端还是服务器端的限制?

https://www.caofanqi.cn/archives/%E5%89%8D%E5%90%8E%E7%AB%AF%E5%BC%80%E5%8F%91%E8%B7%A8%E5%9F%9F%E9%97%AE%E9%A2%98%E8%AF%A6%E8%A7%A3



## 浏览器同源策略

同源策略是在客户端网络应用（比如网络浏览器）上实施的安全政策，用于防止来自不同来源的资源之间发生交互。

虽然这种安全措施可用于防止恶意行为，但也可能会阻止已知来源之间开展的合法交互。



同源策略是一种约定，它是浏览器最核心也最基本的安全功能，如果缺少了同源策略，浏览器很容易受到XSS、CSRF等攻击。

所谓同源是指"协议+域名+端口"三者相同，即便两个不同的域名指向同一个ip地址，也非同源。



资源`URL`的以下**三项中均相同**时才认为两个资源是`同源的`。

- `协议`: 比如http、https、ws、wss
- `域名`: 包括主域名和子域名，需要做到全匹配。
- `端口号`

这个方案也被称为“协议/主机/端口元组”，或者直接是“元组”。（“元组”是指一组项目构成的整体，具有双重/三重/四重/五重等通用形式。）





在浏览器的同源策略（Same-Origin Policy）下，尽管大部分资源受到严格限制，

但 `<img src="...">`、`<link href="...">` 和 `<script src="...">` 这三个标签确实是允许**跨域加载资源**的。

它们之所以能够跨域，是基于历史原因和实际需求。这些标签的设计初衷就是为了从不同的源（Origin）加载外部资源，因为这是构建现代网页的基础。

- 网页需要加载来自不同 CDN（内容分发网络）或图库的图片，这是最常见的跨域需求。如果图片不能跨域，互联网将失去色彩。
- 





> **跨域并不是请求发不出去，请求能发出去，服务端能收到请求并正常返回结果，只是结果被浏览器拦截了。**
>
> 不仅仅是静态的资源。WebStorage、Cookie、IndexDB，在浏览器层面上都是以域这一概念来划分管理的。
>
> 而且这个划分管理行为，就是在浏览器本地生效。和服务器、其他客户端没有直接关系。
>





当一个项目变大时，把所有的内容架构在一个域名网站或者后台服务器是不现实的。

虽然这种安全措施可用于防止恶意行为，但也可能会阻止已知来源之间开展的合法交互。





### 非同源数据存储访问

**WebStorage** 是 HTML5 引入的更现代的存储机制，主要分为两类：LocalStorage 和 SessionStorage。它们都提供键值对的存储方式，但用途和生命周期不同。





- `localStorage`、`IndexedDB` 是浏览器常用的本地化存储方案，两者都是以源进行分割。每一个源下的脚本，都只能够访问同源中的缓存数据，不能实现跨域访问。
- `Cookie`的匹配规则与上面二者又略有差异，主要差异在于`子域`的`cookie`会默认使用在`父域`上。详细的规则可以参考另一篇笔记 [浏览器原理 - 缓存之cookie](https://github.com/HXWfromDJTU/blog/issues/22)
- `DOM` 如果两个网页不同源，就无法拿到对方的`DOM`。
  比如项目中制作的`Telegram`登录，授权`Button`是一段插入`<Iframe>`的脚本。`Ifream`本身的域名是`auth.telegram.io`。那么域名为`abc.io`的业务页面，则不能`Ifream`中的`DOM`进行访问。



不仅仅是静态的资源。WebStorage、Cookie、IndexDB，在浏览器层面上都是以域这一概念来划分管理的。

而且这个划分管理行为，就是在浏览器本地生效，和服务器、其他客户端没有直接关系。



## 为什么只有浏览器有同源策略



### 浏览器是个公共应用

无论是在PC还是移动设备商，你的 Chrome 和 Firefox 是所有网站应用的载体。

你在访问淘宝网的时候，相当于从 [www.taobao.com](http://www.taobao.com/) 的服务器上下载了对应的 html、css、js资源，页面也从 `api.taobao.com` (JSONP 也好, CORS 也罢）获取了商品数据。



页面 `JavaScrip`t 把获取到的热门商品数据缓存到了本地的 `LocalStorage` 中，用于优化体验。

你点击登陆时，通过访问 `api.taobao.com/login` 接口完成了授权登录，服务器下发 Token 到 cookie 中。

同样的，在京东、在亚马逊、在你的个站、甚至在恶意网站进行访问后，网站的数据都会被下载到设备本地，并且通过浏览器这一个应用所管理着。



用浏览器打开一个网站，呈现在我们面前的都是数据，有服务端存储的（如：数据库、内存、文件系统等）、客户端存储的（如：本地Cookies、Flash Cookies等）、传输中的（如：JSON数据、XML数据等），还有文本数据（如：HTML、JavaScript、CSS等）、多媒体数据（如：Flash、Mp3等）、图片数据等。



`跨站攻击`发生在浏览器客户端，而`SQL注入攻击`由于针对的对象是数据库，一般情况下，数据库都在服务端，所以SQL注入是发生在服务端的攻击



### 资源以域划分，是浏览器的本地行为

接触过客户端的同学一定知道，在安卓 和 iOS上的两个App的本地数据，没有对方的允许是不能够直接本访问的，控制权在于App开发方本身，而提供保障的则是系统(Android 和 iOS)本身。

相同的情况类比一下，把浏览器当做系统本身(Chrome Book 请给我打钱)，把各个站点相当于“系统上”的一个个App。

下面的页面各位 FEer一定很熟悉，这是Chrome浏览器对于页面中所有加载的静态资源的域名划分。



## CORS

[跨域资源共享](https://fetch.spec.whatwg.org/#http-cors-protocol) (CORS) 规范是由[万维网联盟 (W3C)](https://www.w3.org/) 制定的，该规范旨在克服上述限制。

**跨源资源共享**（[CORS](https://developer.mozilla.org/zh-CN/docs/Glossary/CORS)，或通俗地译为跨域资源共享）是一种基于 [HTTP](https://developer.mozilla.org/zh-CN/docs/Glossary/HTTP) 头的机制，该机制通过允许服务器标示除了它自己以外的其他[源](https://developer.mozilla.org/zh-CN/docs/Glossary/Origin)（域、协议或端口），使得浏览器允许这些源访问加载自己的资源。



CORS，全名为跨域资源共享，是为了让不同网站的页面之间互相访问数据的机制。简单来说，CORS 的工作机制是这样的：

网站 A 请求网站 B 的资源，网站 A 发起的请求会在 `Origin` 请求头上带上自己的源（`origin`）信息，

如果网站 B 返回的响应头里有`Access-Control-Allow-Origin`响应头，且响应头的值是网站 A 的源（或者是`*`），那么网站 A 就能成功访问到这份资源，否则就报跨域错误。



浏览器在哪些情况下会发起 CORS 请求，哪些情况下发起非 CORS 请求，是有严格规定的。比如在一般的 `<img>`标签下发起的就是个非 CORS 请求，而在`XHR/fetch`下默认发起的就是 CORS 请求；

还比如在一般的`<script>`标签下发起的是非 CORS 请求（所以才能有 jsonp），而在新的 `<script type="module"`下发起的是 CORS 请求。



CORS 请求会带上 `Origin`请求头，用来向别人的网站表明自己是谁；非 CORS 请求不带`Origin`头。

根据网站有没有根据 `Origin`请求头动态返回不同的`Access-Control-Allow-Origin`响应头，我把 CORS 请求的响应分成了两种类型：



## 无条件型 CORS 响应

将`Access-Control-Allow-Origin`固定写死为`*`（允许任意网站访问）、或者特定的某一个源（只允许这一个网站访问），不论请求头里的 `Origin`是什么，甚至没有 `Origin`也一样返回那个值。



## **条件型 CORS 响应**





https://zhuanlan.zhihu.com/p/38972475

https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CORS







# CGI

通用网关接口（CGI），CGI 就是规定要传哪些数据，以什么样的格式传递给后方处理这个请求的协议。

CGI是一种标准机制，Web服务器可通过它将（通常是通过Web表 达提供的）查询交给专用程序（如你编写的Python程序），并以网页的方式显示查询结果。

这是一种创建Web应用的简单方式，让你无需编写专用的应用程序服务器。



CGI是一种通信协议，它把用户传递过来的数据转变成一个k－v的字典。这个字典中不光有用户的数据，还有HTTP协议的参数。

它做的就是把数据，组织成一个固定结构形式的数据。方便任何符合CGI协议的程序都可以调用！

但是CGI不是负责通信（传输数据）的，通信的话是通过socket，也就是`server`，例如上面例子中，是通过Apache进行通信。

之后调用CGI脚本，把数据转变成符合CGI协议的数据结构，用于后面的数据处理！



它是网页的表单和你写的程序之间通信的一种协议。可以用任何语言写一个CGI脚本，这些语言只要能接收输入输出信息，读取环境变量。

所以，几乎所有的编程语言都能写一个CGI脚本，例如：python，C，甚至是shell脚本。



典型的CGI脚本做了如下的事情：

1. 读取用户提交表单的信息。
2. 处理这些信息（也就是实现业务）。
3. 输出，返回html响应（返回处理完的数据）。





当用户填写完表单，点击提交按钮的时候。CGI脚本接收用户表单的数据，这些数据都是k－v的集合的形式（也就是python中的字典）



CGI接收的用户数据，是通过HTTP协议传递过来的。而选用不同的"Method"：GET或POST对CGI的接收没有任何影响。





# WebSocket协议

众所周知，Web 应用的交互过程通常是客户端通过浏览器发出一个请求，服务器端接收请求后进行处理并返回结果给客户端，客户端浏览器将信息呈现，这种机制对于信息变化不是特别频繁的应用尚可。

但对于实时要求高、海量并发的应用来说显得捉襟见肘，尤其在当前业界移动互联网蓬勃发展的趋势下，高并发与用户实时响应是 Web 应用经常面临的问题，比如金融证券的实时信息，Web 导航应用中的地理位置获取，社交网络的实时消息推送等。

**传统的请求-响应模式的 Web 开发在处理此类业务场景时，通常采用实时通讯方案**：**客户端轮询**

>  客户端按照某个时间间隔不断地向服务端发送请求，请求服务端的最新数据然后更新客户端显示。这种方式实际上浪费了大量流量并且对服务端造成了很大压力。



对于第1次听说WebSocket技术的人来说，WebSockert 和 Socker 两者有什么区别？WebSockert  是仅仅将`socket`的概念移植到浏览器中的实现吗？

我们知道，在网络中的两个应用程序（进程）需要全双工相互通信（全双工即双方可同时向对方发送消息），需要用到的就是`socket`，它能够提供端对端通信。

对于程序员来讲，他只需要在某个应用程序的一端（暂且称之为客户端）创建一个socket实例并且提供它所要连接一端（暂且称之为服务端）的IP地址和端口，而另外一端（服务端）创建另一个socket并绑定本地端口进行监听，然后客户端进行连接服务端，服务端接受连接之后双方建立了一个端对端的TCP连接，在该连接上就可以双向通讯了，而且一旦建立这个连接之后，通信双方就没有客户端服务端之分了，提供的就是端对端通信了。



我们可以采取这种方式构建一个桌面版的im程序，让不同主机上的用户发送消息。从本质上来说，socket并不是一个新的协议，它只是为了便于程序员进行网络编程而对tcp/ip协议族通信机制的一种封装。

websocket是html5规范中的一个部分，它借鉴了socket这种思想，为web应用程序客户端和服务端之间（注意是客户端服务端）提供了一种全双工通信机制。

同时，它又是一种新的应用层协议，websocket协议是为了提供web应用程序和服务端全双工通信而专门制定的一种应用层协议，通常它表示为：ws://echo.websocket.org/?encoding=text HTTP/1.1，可以看到除了前面的协议名和http不同之外，它的表示地址就是传统的url地址。





既然是基于浏览器端的web技术，那么它的通信肯定少不了http,websocket本身虽然也是一种新的应用层协议，但是它也不能够脱离http而单独存在。





WebSocket技术出现之前，Web端实现即时通讯的方法有哪些?



WebSocket 的实现分为客户端和服务端两部分，客户端（通常为浏览器）发出 WebSocket 连接请求，服务端响应，实现类似 TCP 握手的动作，从而在浏览器客户端和 WebSocket 服务端之间形成一条 HTTP 长连接快速通道。

两者之间后续进行直接的数据互相传送，不再需要发起连接和响应。



ser

# Chrome调试技巧

浏览器网络控制台会记录每个请求的调用栈（Initiator/启动器），可协助调试者定位到发起请求的代码位置

initiator 的这个单词翻译过来是“发起者”，所以在Network 的initiator这列可以看到是哪一行代码是发起请求的发起者。

鼠标悬停在这个initiator上，你可以看到完整的调用信息，不论是自己的文件还是外部引用的文件。



在标头选项卡中，可以找到“Referer”字段，该字段显示了该请求是从哪个页面或 URL 中发出的。

如果您希望查看请求是从哪个 JS 文件中发出的，可以在“标头”选项卡中查找“Initiator”字段，该字段显示了发起该请求的 JS 文件路径。

注意：在某些情况下，该字段可能会显示“(index)”或者“(unknown)”等值，这意味着浏览器无法确定请求的确切来源。





# OAuth协议



如果你开车去酒店赴宴，你经常会苦于找不到停车位而耽误很多时间。是否有好办法可以避免这个问题呢？有的，听说有一些豪车的车主就不担心这个问题。豪车一般配备两种钥匙：主钥匙和泊车钥匙。当你到酒店后，只需要将泊车钥匙交给服务生，停车的事情就由服务生去处理。与主钥匙相比，这种泊车钥匙的使用功能是受限制的：它只能启动发动机并让车行驶一段有限的距离，可以锁车，但无法打开后备箱，无法使用车内其他设备。这里就体现了一种简单的“开放授权”思想：通过一把泊车钥匙，车主便能将汽车的部分使用功能（如启动发动机、行驶一段有限的距离）授权给服务生。

授权是一个古老的概念，它是一个多用户系统必须支持的功能特性。比如，Alice和Bob都是Google的用户，那么Alice应该可以将自己的照片授权给Bob访问。但请注意到，这种授权是一种封闭授权，它只支持系统内部用户之间的相互授权，而不能支持与其他外部系统或用户之间的授权。比如说，Alice想使用“网易印像服务”将她的部分照片冲印出来，她怎么能做到呢？

肯定有人会说，Alice可以将自己的Google用户名和密码告诉网易印像服务，事情不就解决了吗？是的，但只有毫不关注安全和隐私的同学才会出此“绝招”。那么我们就来想一想，这一“绝招”存在哪些问题？(1) 网易印像服务可能会缓存Alice的用户名和密码，而且可能没有加密保护。它一旦遭到攻击，Alice就会躺着中枪。(2) 网易印像服务可以访问Alice在Google上的所有资源，Alice无法对他们进行最小的权限控制，比如只允许访问某一张照片，1小时内访问有效。(3) Alice无法撤消她的单个授权，除非Alice更新密码。

在以Web服务为核心的云计算时代，像用户Alice的这种授权需求变得日益迫切与兴盛，“开放授权(Open Authorization)”也正因此而生，意在帮助Alice将她的资源授权给第三方应用，支持细粒度的权限控制，并且不会泄漏Alice的密码或其它认证凭据。

根据应用场景的不同，目前实现开放授权的方法分为两种：一种是使用OAuth协议[1]；另一种是使用IAM服务[2]。OAuth协议主要适用于针对个人用户对资源的开放授权，比如Google的用户Alice。OAuth的特点是“现场授权”或“在线授权”：客户端主要通过浏览器去访问资源，授权时需要认证Alice的资源所有者身份，并且需要Alice现场审批。OAuth一般在SNS服务中广泛使用，如微博。IAM服务则不同，它的特点是“预先授权”或“离线授权”：客户端主要通过REST API方式去访问资源，资源所有者可以预先知道第三方应用所需要的资源请求，一次授权之后，很少会变更。IAM服务一般在云计算服务中使用，如AWS服务、阿里云计算服务。







- **RO** (resource owner): 资源所有者，对资源具有授权能力的人。如上文中的用户Alice。

- **RS** (resource server): 资源服务器，它存储资源，并处理对资源的访问请求。如Google资源服务器，它所保管的资源就是用户Alice的照片。

- **Client**: 第三方应用，它获得RO的授权后便可以去访问RO的资源。如网易印像服务。

此外，为了支持开放授权功能以及更好地描述开放授权协议，OAuth引入了第四个参与实体：

- **AS** (authorization server): 授权服务器，它认证RO的身份，为RO提供授权审批流程，并最终颁发授权令牌(Access Token)。

​	读者请注意，为了便于协议的描述，这里只是在逻辑上把AS与RS区分开来；在物理上，AS与RS的功能可以由同一个服务器来提供服务。





在开放授权中，第三方应用(Client)可能是一个Web站点，也可能是在浏览器中运行的一段JavaScript代码，还可能是安装在本地的一个应用程序。

这些第三方应用都有各自的安全特性。

对于Web站点来说，它与RO浏览器是分离的，它可以自己保存协议中的敏感数据，这些密钥可以不暴露给RO；

对于JavaScript代码和本地安全的应用程序来说，它本来就运行在RO的浏览器中，RO是可以访问到Client在协议中的敏感数据。

OAuth为了支持这些不同类型的第三方应用，提出了多种授权类型，如

- 授权码 (Authorization Code Grant)
- 隐式授权 (Implicit Grant)
- RO凭证授权 (Resource Owner Password Credentials Grant)
- Client凭证授权 (Client Credentials Grant)





# generate_204

generate_204 是一个网络请求的特殊 URL，通常用于检测网络连接是否正常。当设备连接到一个需要认证的网络时，例如公共 Wi-Fi 或企业网络，设备会在浏览器中请求 generate_204 页面，以验证网络连接是否成功。

具体来说，当设备连接到一个需要认证的网络时，设备会尝试访问一个特定的 URL（通常是 generate_204）来检测网络连接状态。

如果网络连接正常，服务器会返回一个非空的 HTTP 响应，通常是一个空白页面或一个特定的响应码（如 204 No Content）。这表明设备已成功连接到网络，并且可以正常访问互联网。

如果设备无法访问 generate_204 页面或收到其他响应（如重定向或错误页面），通常会触发设备的网络连接状态提示，提示用户进行认证或重新登录，以便设备能够正常访问网络。



HTTP 204 No Content 是标准的 HTTP 响应状态码，其规范可以在 IETF 的 RFC 7231 中找到。RFC 7231 定义了 HTTP/1.1 协议的语义和内容。

具体来说，在 RFC 7231 中，HTTP 204 No Content 的定义如下：

RFC 7231 - Hypertext Transfer Protocol (HTTP/1.1): Semantics and Content

> The 204 (No Content) status code indicates that the server has successfully fulfilled the request and that there is no additional content to send in the response payload body.

简而言之，HTTP 204 No Content 响应状态码表示服务器已成功处理请求，并且在响应的载荷体中没有额外的内容需要发送。





# Unicode控制字符

https://www.secrss.com/articles/35688

https://tttang.com/archive/1339/

https://github.blog/changelog/2021-10-31-warning-about-bidirectional-unicode-text/



剑桥大学的研究人员在11月1日公开了一个影响大多数编译器和软件开发环境的漏洞，并命名为Trojan Source。该漏洞存在于Unicode中，有两种利用方法：

- 第一种是使用Unicode的Bidi算法（CVE-2021-42574），对字符进行视觉上的重新排序，使其呈现与编译器和解释器所不同的逻辑顺序；

- 第二种是同形文字攻击(CVE-2021-42694)，也就是利用在视觉上看起来相似的不同字符。该漏洞适用于C、C++、C#、JavaScript、Java等广泛使用的编程语言，可以用于供应链攻击。







让攻击者更隐蔽的将恶意代码注入到软件项目中，让使用者在使用到该有问题的项目代码时不容易发现藏在其中的恶意代码

由于编译后的代码文件逻辑因为 Trojan-Source 的攻击方法从而发生改变，导致运行后很有可能发生本身电脑中毒，以及盗取本机信息这类的攻击事件。





## 字符重排序

Unicode标准规定，内存表示顺序称为逻辑顺序，当文本在一行的时候，大多数脚本从左往右显示字符。然而，也有一些脚本（如阿拉伯语或希伯来语）显示文本的自然顺序是从右往左。如果所有文本为统一的方向，那么显示的文本顺序则是明确的顺序。但是如果方向不一致，那么显示的顺序也会发生歧义。

所以规定了每个字符都有一个隐式双向类型。从左到右和从右到左的双向类型称为强类型，具有这些类型的字符被称为强方向字符。与数字相关的双向类型被称为弱类型，具有这些类型的字符被称为弱方向字符。除了方向格式码，剩下的双向类型和字符被称为中性。

因为在某些场景中，有的语言是从右往左的，有的是从左往右的，然后实现了一个双向的算法 `Bidirectional algorithm`，又叫bidi，标准bidi算法提供的显示顺序还不够，所以对于这些情况，提供了覆盖控制字符。Bidi算法覆盖是不可见的字符，从而可以切换字符组的显示顺序。





因为大多数设计比较好的编程语言，以及编译器，都不允许我们在源代码中来使用任意控制字符，因为如果使用了任意控制字符后，会被当作影响逻辑的控制字符，所以在源代码中来使用Bidi从而覆盖字符篡改，会导致编译器解析语法错误，所以在利用的方式中，可以使用注释或者字符串。

- 注释：很多的编程语言允许注释中出现所有的文本字符，因为在预编译时，编译器会实现忽略的规则，所以在注释中出现任意控制字符，会被编译器和解析器忽略。
- 字符串：很多的编程语也允许字符串可以包含任意字符，同理也包括任意控制字符。



注释和字符串都有特定于语法的语义，从而来表示它们的开始和结束，但是任意控制字符并不遵守这些规则，因此，通过将任意控制字符专门放在注释和字符串中，从而可以瞒住大多数编译器，让编译器以接受的方式将它们偷偷放入源代码中。





```bash
#!/bin/bash
access_level="user"
if [ $access_level != 'noneU+202EU+2066' ]; then # Check if admin U+2069U+2066' -a $access_level != 'user
    echo "You are an admin"
fi
```

```bash
#!/bin/bash
access_level="user"
if [ $access_level != 'none' ]; then # Check if admin ' -a $access_level != 'user
    echo "You are an admin"
fi
```

https://github.com/nickboucher/trojan-source



## [同形字符](https://tttang.com/archive/1339/#toc_)