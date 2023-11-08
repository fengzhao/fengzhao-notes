



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



# HTTP头部







原来在 http2.0 协议中，添加了 pseudo header names （伪头部字段）

在HTTP/2.0中，选择以冒号开头的伪头名称，因为这对于HTTP/1.1中的头名称是非法字符。HTTP/1.1不使用伪头名称。



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

- 用**十进制数字**表示的 Entity body 的字节数，是Headers中常见的一个字段。



**注意，这个大小是包含了所有内容编码的，比如，对文本文件进行了 gzip 压缩的话， Content-Length 首部就是压缩后的大小，而不是原始大小。**

Content-Length 首部对于**持久连接**是必不可少的。如果响应通过持久连接传送，就可能有另一条 HTTP 响应紧随其后。



客户端通过 Content-Length 首部就可以知道报文在何处结束，下一条报文从何处开始。因为连接是持久的，客户端无法依赖连接关闭来判别报文的结束。

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

- 网站服务器生成原始响应报文，其中有原始的 Content-Type 和 Content-Length 首部。
- 内容编码服务器（也可能是原始的服务器或缓存代理等）创建编码后的报文。
  - 编码后的报文有同样的 Content-Type 和  Content-Length ，可能不同（比如主体被压缩了）。
  - 内容编码服务器在编码后的报文中增加 Content-Encoding 首部，这样接收的应用程序就可以进行解码了。
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





分块编码把报文分割为若干个大小已知的块。块之间是紧挨着发送的，这样就不需要在发送之前知道整个报文的大小了。



若客户端和服务器之间不是持久连接，客户端就不需要知道它正在读取的主体的长度，而只需要读到服务器关闭主体连接为止。



当使用持久连接时，在服务器写主体之前，必须知道它的大小并在 Content-Length 首部中发送。如果服务器动态创建内容，就可能在发送之前无法知道主体的长度。



## 扩展头部









### X-Forwarded-For

X-Forwarded-For 是一个 HTTP 扩展头部。

HTTP/1.1（RFC 2616）协议并没有对它的定义，它最开始是由 Squid 这个缓存代理软件引入，用来表示 HTTP 请求端真实 IP。

如今它已经成为事实上的标准，被各大 HTTP 代理、负载均衡等转发服务广泛使用，并被写入 [RFC 7239](http://tools.ietf.org/html/rfc7239)（Forwarded HTTP Extension）标准之中。



> X-Forwarded-For 请求头格式
>
> X-Forwarded-For: client, proxy1, proxy2

可以看到，XFF 的内容由「英文逗号 + 空格」隔开的多个部分组成，最开始的是离服务端最远的设备 IP，然后是每一级代理设备的 IP。

如果一个 HTTP 请求到达最后端的 HTTP 服务器之前。

经过了三个代理 Proxy1、Proxy2、Proxy3，IP 分别为 IP1、IP2、IP3，用户真实 IP 为 IP0，那么按照 XFF 标准，服务端最终会收到以下信息：



> X-Forwarded-For: IP0, IP1, IP2



Proxy3 直连服务器，它会给 XFF 追加 IP2，表示它是在帮 Proxy2 转发请求。





**Remote Address** 

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



# 内容协商机制



在 [HTTP](https://developer.mozilla.org/zh-CN/docs/Glossary/HTTP) 协议中，***内容协商\***是一种机制，用于为同一 URI 提供资源不同的[表示](https://developer.mozilla.org/zh-CN/docs/Glossary/Representation_header)形式，以帮助用户代理指定最适合用户的表示形式（例如，哪种文档语言、哪种图片格式或者哪种内容编码）。





- **主动式内容协商**

- **响应式内容协商**





# 内容编码

HTTP 应用程序有时在发送之前需要对内容进行编码。

例如，在把很大的 HTML 文档发送给通过慢速连接连上来的客户端之前 , 服务器可能会对它进行压缩，这样有助于减少传输实体的时间。

服务器还可以把内容搅乱或加密，以此来防止未经授权的第三方看到文档的内容。



原始媒体/内容的类型通过 [`Content-Type`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Type) 首部给出，而 `Content-Encoding` 应用于数据的表示，或“编码形式”。

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



# HTTP报文

HTTP 报文是服务器和客户端之间交换数据的方式，有两种类型的消息︰

- 请求（requests）--由客户端发送用来触发一个服务器上的动作；
- 响应（responses）--来自服务器的应答。

请求



HTTP消息由采用 ASCII 编码的多行文本构成。在HTTP/1.1及早期版本中，这些消息通过连接公开地发送。

在HTTP/2中，为了优化和性能方面的改进，HTTP报文被分到多个HTTP帧中。





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

```
schema://<user>:<password>@host:port/path;<params>?<query_string>#frag
```



- 方案：访问服务器以获取资源时要使用哪种协议：http、https、ftp、
- 用户名：可选，某些方案访问资源时需要的用户名。一般在ftp比较多。
- 密码：可选，用户名后面可能要包含的密码，中间由冒号（:）分隔
- 主机：资源宿主服务器的主机名或点分 IP 地址（现在一般是域名或IP）
- 端口：服务器端口（http默认是80，https默认是443）
- 路径：请求路径
- 参数：请求参数
- 查询字符串
- 片段





## URL与URI区别





# URL编码



**问题: 从浏览器地址栏输入url到请求返回发生了什么？**

浏览器进行URL解析，url为啥要解析？



使用浏览器进行Http网络请求时，若请求query中包含中文，中文会被编码为 `%+16进制+16进制`形式。

但你真的深入了解过，为什么要进行这种转义编码吗？编码的原理又是什么？

例如，浏览器中进行百度搜索 "你好" 时，链接地址会被自动编码：

```
（编码前） https://www.baidu.com/s?wd=你好
（编码后）https://www.baidu.com/s?wd=%E4%BD%A0%E5%A5%BD
```


出现以上情况是网络请求前，浏览器对请求URL进行了`URL编码（URL Encoding）`。





RFC3986文档规定，URL中只允许包含英文字母（a-zA-Z）、数字（0-9）、-_.~4个特殊字符以及所有保留字符。 

RFC3986文档对URL的编解码问题做出了详细的建议，指出了哪些字符需要被编码才不会引起Url语义的转变，以及对为什么这些字符需要编码做出了相 应的解释。

URL参数字符串中使用`key=value`键值对这样的形式来传参，键值对之间以 `&` 符号分隔，如 /s?q=abc& ie=utf-8。

如果你的value字符串中包含了`=` 或者 `&`，那么势必会造成接收URL的服务器解析错误，因此必须将引起歧义的 `&` 和 `=` 符号进行转义，也就是对其进行编码。



如：最常使用的空格用%20来表示

```shell
# 比如在百度搜索"nginx http"
# 可以看到URL中的querystring就可以看到空格被编码为%20
https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=nginx%20http
https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=nginx%20http&fenlei=256&rsv_pq=0x9e752ae30002a7c3&rsv_t=b1d7VO8NNHhfki3WreWqLnUUfFwBN1D%2FoTGfja80r%2B%2FtaP%2BfllEKkA8rZtUq&rqlang=en&rsv_dl=tb&rsv_enter=1&rsv_sug3=22&rsv_sug1=15&rsv_sug7=100&rsv_sug2=0&rsv_btype=i&prefixsug=nginx%2520http&rsp=3&inputT=4996&rsv_sug4=4996
```



[参考](https://www.cnblogs.com/liuhongfeng/p/5006341.html)





**URL是否区分大小写？**

[参考](https://www.zhihu.com/question/19572705)

URL的基本结构是：[协议]://[域名]/[路径]

协议和域名部分不分大小写。路径部分是否区分大小写则不一定，要看具体网站后台是如何实现的。



有的网站，不区分，

**有的网站，有意将目录和文件名强制小写，比如新浪微博斜杠后面的用户名。** 



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



##### 断点续传主要原理是是HTTP1.1（RFC2616）中定义header中定义的Range和contentRange字段

**range** ： 用于请求头中，指定第一个字节的位置和最后一个字节的位置

```
Range:(unit=first byte pos)-[last byte pos] 
```

**Content-Range**： 用于响应头，指定整个实体中的一部分的插入位置，他也指示了整个实体的长度。

在服务器向客户端返回一个部分响应，它必须描述响应覆盖的范围和整个实体长度。



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

**一个 TCP 连接是通过四元组来唯一标识的：< 源 IP 地址:源端口号——目的 IP 地址:目的端口号 >**

**唯一标识：两条不同的 TCP 连接不能拥有 4 个完全相同的值（但不同连接的部分组件可以拥有相同的值）**

牢记这个概念，面试中可以避免踩很多坑。



### TCP 三次握手

为了实现可靠传输，发送方和接收方始终需要同步( SYNchronize )序号。 

需要注意的是， 序号并不是从 0 开始的， 而是由发送方随机选择的初始序列号 ( Initial Sequence Number, ISN )开始 。 

由于 TCP 是一个双向通信协议， 通信双方都有能力发送信息， 并接收响应。 因此， 通信双方都需要随机产生一个初始的序列号， 并且把这个起始值告诉对方。



所有 TCP 连接建立之前一开始都要经过三次握手，客户端与服务器在交换应用数据之前，必须就**起始分组序列号，以及其他一些连接相关的细节**达成一致。

**出于安全考虑，序列号由两端随机生成。**



- SYN 
  客户端选择一个随机序列号 x，并发送一个 SYN 分组，其中可能还包括其他 TCP标志和选项。

  

- SYN ACK 
  服务器给 x 加 1，并选择自己的一个随机序列号 y，追加自己的标志和选项，然后返回响应。

  

- ACK 
  客户端给 x 和 y 加 1 并发送握手期间的最后一个 ACK 分组。





![1602948494101](assets/1602948494101.png)





三次握手带来的延迟使得每创建一个新 TCP 连接都要付出很大代价。而这也决定了提高 TCP 应用性能的关键，在于想办法重用连接。



##### 为什么tcp要用三次握手？

TCP 需要 seq [序列号](https://www.zhihu.com/search?q=序列号&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A573627478})来做可靠重传或接收，而避免连接复用时无法分辨出 seq 是延迟或者是旧链接的 seq，因此需要三次握手来约定确定双方的 ISN（初始 seq 序列号）。



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

并行连接，意思就是打开多个TCP连接，HTTP 允许客户端打开多条 TCP 连接，并行地执行多个 HTTP 事务。

包含嵌入对象的组合页面如果能（通过并行连接）克服单条连接的空载时间和带宽限制，加载速度也会有所提高。



如果单条连接没有充分利用客户端的因特网带宽，可以将未用带宽分配来装载其他对象。

**即使并行连接的速度可能会更快，但并不一定总是更快。**

客户端的网络带宽不足时，大部分的时间可能都是用来传送数据的。

在这种情况下，一个连接到速度较快服务器上的HTTP 事务就会很容易地耗尽所有可用的 Modem 带宽。

如果并行加载多个对象，每个对象都会去竞争这有限的带宽，每个对象都会以较慢的速度按比例加载，这样带来的性能提升就很小，甚至没什么提升。



**并行连接的问题**

- 每个事务都会打开 / 关闭一条新的连接，会耗费时间和带宽。 
- 由于 TCP 慢启动特性的存在，每条新连接的性能都会有所降低。 
- 可打开的并行连接数量实际上是有限的。 （浏览器并发请求限制）



### HTTP Pipelining 

HTTP/1.1 存在一个问题，单个 TCP 连接在同一时刻只能处理一个请求。

意思是说：两个请求的生命周期不能重叠，任意两个 HTTP 请求从开始到结束的时间在同一个 TCP 连接里不能重叠。



 一个支持持久连接的客户端可以在一个TCP连接中发送多个请求（不需要等待任意请求的响应）。收到请求的服务器必须按照请求收到的顺序发送响应。







### 持久连接（TCP长连接）

https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Connection_management_in_HTTP_1.x

持久连接就是 TCP 连接的重用，一个 Web 页面上的大部分内嵌图片通常都来自同一个 Web 站点，而且相当一部分指向其他对象的超链通常都指向同一个站点。

> 初始化了对某服务器 HTTP 请求的应用程序很可能会在不久的将来对那台服务器发起更多的请求，这种特性称为站点局部性（site locality）

在`HTTP/1.0`中，一个 http 请求收到服务器响应后，默认会断开对应的 TCP 连接。

这样每次请求，都需要重新建立 TCP 连接，这样一直重复建立和断开的过程。简直就是灾难。



所以为了复用 TCP 连接。在 http/1.0 中规定了两个头部 Connection 和 keep-alive，可以设置头字段`Connection: keep-alive`。这是一个协商头部。

客户端可以通过包含 `Connection: Keep-Alive`请求头将一条 TCP 连接保持在打开状态。（客户端说，我想保持 TCP 长连接）

如果服务器愿意为了下一条 HTTP 请求，将 TCP 连接保持在打开状态，就在响应中包含相同的响应头部  `Connection: Keep-Alive` 。（服务器说，我支持 TCP 长连接）

这样 HTTP 请求完成后，就不会断开当前的 TCP 连接，后续的 HTTP 请求可以使用当前 TCP 连接进行通信。（这样，就维持了长连接）

在 chrome F12 中，点击一个 HTTP 事务，查看 timing 时，如果看到初始化连接和SSL开销消失了，说明使用的是同一个TCP连接。

如果响应头中没有 `Connection: Keep-Alive`，客户端就认为服务器不支持 keep-alive，会在发回响应报文之后主动关闭 TCP 连接。

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



HTTP 应用程序收到一条带有 Connection 首部的报文时，接收端会解析发送端请求的所有选项，并将其应用。然后会在将此报文转发给下一跳地址之前，删除Connection 首部以及 Connection 中列出的所有首部。









## 代理

代理就是帮助你（client）处理与服务器（server）连接请求的中间应用，我们称之为 proxy server。



### 正向代理

对于 client，想要连上 server，如果这个中间过程你知道代理服务器的存在，那这就是正向代理（即这个过程是 client 主动的过程）。

比如我们在 Chrome 上配置 SwitchOmega 工具来使用代理，设置一系列代理规则，可以先将请求发到代理服务器，由代理服务器再去发送请求。

比如我们在一些开发工具（比如 jetbrains idea）中，配置 proxy 来设置代理服务器。

比如我们在 ssh 或者一些网络应用的命令行工具时，也可以使用代理选项来使用代理服务器。

在很多网络请求场景中，都可以使用正向代理。



### 反向代理

对于 client，直接访问当目标服务器 server（proxy）。但目标服务器 server 可能会将请求转发到其它应用服务器 server（app）（即这个过程是 server 主动的过程）。

其对用户是透明的，如用户去访问 example.com，他并不知道该网站背后发生了什么事，一个 API 请求被转发到哪台服务器。

比如我们常用的 nginx，openresty 等软件。用于实现负载均衡和高可用。





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



# HTTP2 

HTTP/2 ， 简称 h2 ，是 WWW 所使用的 HTTP 协议的一个重大修订版本。其目的是提升加载 WEB 内容时的感知性能。

自 1999 年 HTTP/1.1 通过以来，Web 发生了天翻地覆的变化。最早大小只有几千字节、包含资源只有个位数，主要基于文本的网页。

如今已经发展成平均大小超过2MB，包含资源数平均数为140的富媒体网站。





《[HTTP/2: the Future of the Internet](https://http2.akamai.com/demo)》 是 Akamai 公司建立的一个官方的演示，用以说明 HTTP/2 相比于之前的 HTTP/1.1 在性能上的大幅度提升。

 同时请求 379 张图片，从Load time 的对比可以看出 HTTP/2 在速度上的优势。





## HTTP中的关键性能指标



DNS查找 





## HTTTP/1.1的问题



HTTP/2 可以让我们的应用更快、更简单、更稳定 - 这几词凑到一块是很罕见的！

HTTP/2 将很多以前我们在应用中针对 HTTP/1.1 想出来的“歪招儿”一笔勾销，把解决那些问题的方案内置在了传输层中。 

不仅如此，它还为我们进一步优化应用和提升性能提供了全新的机会！

HTTP/2 的主要目标是通过支持完整的请求与响应复用来减少延迟，通过有效压缩 HTTP 标头字段将协议开销降至最低，同时增加对请求优先级和服务器推送的支持。 

为达成这些目标，HTTP/2 还给我们带来了大量其他协议层面的辅助实现，例如新的流控制、错误处理和升级机制。

上述几种机制虽然不是全部，但却是最重要的，每一位网络开发者都应该理解并在自己的应用中加以利用。



**HTTP/2 没有改动 HTTP 的应用语义。 HTTP 方法、状态代码、URI 和标头字段等核心概念一如往常，这一点是非常重要的，可以理解为是向下兼容的。** 

不过，HTTP/2 修改了数据格式化（分帧）以及在客户端与服务器间传输的方式。这两点统帅全局，通过新的分帧层向我们的应用隐藏了所有复杂性。 

因此，所有现有的应用都可以不必修改而在新协议下运行。

**HTTP 2.0 性能增强的核心，全在于新增的二进制分帧层，它定义了如何封装 HTTP 消息并在客户端与服务器之间传输。**

![http2_binary_framing_layer](assets/http2_1.png.webp)



- **帧（Frame）**：HTTP/2 数据通信的最小单位。帧用来承载特定类型的数据，如 HTTP 首部、负荷；或者用来实现特定功能，例如打开、关闭流。每个帧都包含帧首部，其中会标识出当前帧所属的流；
- **消息（Message）**：指 HTTP/2 中逻辑上的 HTTP 消息。例如请求和响应等，消息由一个或多个帧组成；
- **流（Stream）**：存在于连接中的一个虚拟通道。流可以承载双向消息，每个流都有一个唯一的整数 ID；
- **连接（Connection）**：与 HTTP/1 相同，都是指对应的 TCP 连接；



- **在 HTTP/2 中，同域名下所有通信都在单个 TCP 连接上完成，这个连接可以承载任意数量的双向数据流。**

- **每个数据流都以消息的形式发送，而消息又由一个或多个帧组成。多个帧之间可以乱序发送，因为根据帧首部的流标识可以重新组装。**



**简言之，HTTP2.0把HTTP协议通信的基本单位缩小为一个一个的帧，这些帧对应着逻辑流中的消息。相应地，很多流可以并行的在同一个TCP连接上交换消息。**





### 

## 请求与响应复用

在 HTTP/1.x 中，每一个请求和响应都要占用一个 TCP 连接。

尽管有 Keep-Alive 机制可以复用，但在每个 TCP  连接上同时只能有一个请求 / 响应，这意味着完成响应之前，这个连接不能用于其他请求。

如果客户端要想发起多个并行请求以提升性能，则必须使用多个 TCP 连接。 

这是 HTTP/1.x 交付模型的直接结果，该模型可以保证每个连接每次只交付一个响应（响应排队）。 

更糟糕的是，这种模型也会导致队首阻塞，从而造成底层 TCP 连接的效率低下。



大多数 HTTP 传输都是短暂且急促的，而 TCP 则针对长时间的批量数据传输进行了优化。

 通过重用相同的连接，HTTP/2 既可以更有效地利用每个 TCP 连接，也可以显著降低整体协议开销。 









HTTP/2 中新的二进制分帧层突破了这些限制，实现了完整的请求和响应复用：客户端和服务器可以将 HTTP 消息分解为互不依赖的帧，然后交错发送，最后再在另一端把它们重新组装起来。

**简单来说， 就是在同一个TCP连接，同一时刻可以传输多个HTTP请求。**





> **HTTP/2 最大限度的兼容 HTTP/1.1 原有行为：**
>
> 1. **在应用层上修改，基于并充分挖掘 TCP 协议性能。**
> 2. **客户端向服务端发送 request 请求的模型没有变化。**
> 3. **scheme 没有发生变化，没有 http2://**
> 4. **使用 HTTP/1.X 的客户端和服务器可以无缝的通过代理方式转接到 HTTP/2 上。**
> 5. **不识别 HTTP/2 的代理服务器可以将请求降级到 HTTP/1.X。**



https://imququ.com/post/http2-and-wpo-2.html





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



## HTTP2 TLS 握手协商



HTTP 协议从诞生一直到 HTTP/2，都是依赖 TCP 传输数据。TCP 协议提供面向连接的可靠数据传输能力。当我们在浏览器输入网址按回车的时候，浏览器怎么确定要用 HTTP 协议的哪个版本来通信呢？



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

# cookie和session

HTTP Cookie（也叫 Web Cookie 或浏览器 Cookie）是服务器发送到用户浏览器并保存在本地的一小块数据。

它会在浏览器下次向同一服务器再发起请求时被携带并发送到服务器上。

（试想，如果没有 cookie，如果你进入一个购物网站并且尚未登陆，添加商品到购物车后，然后刷新页面，购物车就被清空。那会是多么麻烦）

通常，它用于告知服务端两个请求是否来自同一浏览器，如保持用户的登录状态。

Cookie 使基于[无状态](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview#HTTP_is_stateless_but_not_sessionless)的HTTP协议记录稳定的状态信息成为了可能。



Cookie 曾一度用于客户端数据的存储，因当时并没有其它合适的存储办法而作为唯一的存储手段，但现在随着现代浏览器开始支持各种各样的存储方式，Cookie 渐渐被淘汰。

由于服务器指定 Cookie 后，浏览器的每次请求都会携带 Cookie 数据，会带来额外的性能开销（尤其是在移动环境下）。

新的浏览器API已经允许开发者直接将数据存储到本地，如使用 [Web storage API](https://developer.mozilla.org/zh-CN/docs/Web/API/Web_Storage_API) （本地存储和会话存储）或 [IndexedDB](https://developer.mozilla.org/zh-CN/docs/Web/API/IndexedDB_API) 。





### cookie的过程

当服务器收到 HTTP 请求时，服务器可以在响应头里面添加一个 [`Set-Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Set-Cookie) 头部。

浏览器收到响应后通常会保存下 Cookie，之后对该服务器每一次请求中都通过 [`Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Cookie) 请求头部将 Cookie 信息发送给服务器。

另外，Cookie 的过期时间、域、路径、有效期、适用站点都可以根据需要来指定。

```shell
# 服务器返回的浏览器的响应头中添加这个头部，设置cookie
Set-Cookie: yummy_cookie=choco; tasty_cookie=strawberry



# 接下来浏览器对服务器的请求报文中都会携带这些cookie
GET /sample_page.html HTTP/1.1
Host: www.example.org
Cookie: yummy_cookie=choco; tasty_cookie=strawberry
```



### cookie的生命周期

Cookie 的生命周期可以通过两种方式定义：

- 会话期 Cookie 是最简单的 Cookie：浏览器关闭之后它会被自动删除，也就是说它仅在会话期内有效。会话期Cookie不需要指定过期时间（`Expires`）或者有效期（`Max-Age`）。需要注意的是，有些浏览器提供了会话恢复功能，这种情况下即使关闭了浏览器，会话期Cookie 也会被保留下来，就好像浏览器从来没有关闭一样，这会导致 Cookie 的生命周期无限期延长。

- 持久性 Cookie 的生命周期取决于过期时间（`Expires`）或有效期（`Max-Age`）指定的一段时间。

  例如：

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



# 认证

有数百万的人在用 Web 进行私人事务处理，访问私有的数据。通过 Web 可以很方便地访问这些信息，但仅仅是方便访问还是不够的。

我们要保证只有特定的人能看到我们的敏感信息并且能够执行我们的特权事务。**并不是所有的信息都能够公开发布的。**

服务器需要通过某种方式来了解用户身份。一旦服务器知道了用户身份，就可以判定用户可以访问的事务和资源了。

认证就意味着要证明你是谁。通常是通过提供用户名和密码来进行认证的。HTTP 为认证提供了一种原生工具。

尽管我们可以在HTTP 的认证形式和 cookie 基础之上 "运行自己的" 认证工具，但在很多情况下，HTTP 的原生认证功能就可以很好地满足要求。

**认证就是要给出一些身份证明。**当出示像护照或驾照那样有照片的身份证件时，就给出了一些证据，说明你就是你所声称的那个人。

在自动取款机上输入 PIN 码，或在计算机系统的对话框中输入了密码时，也是在证明你就是你所声称的那个人。

现在，这些策略都不是绝对有效的。密码可以被猜出来或被人偶然听到，身份证件可能被偷去或被伪造。

但每种证据都有助于构建合理的信任，说明你就是你所声称的那个人。



### HTTP 基本认证

HTTP basic 认证原生提供了一种 质询 / 响应（challenge/response）框架，简化了对用户的认证过程。它的具体过程如下：

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

- 签名可以证明是作者编写了这条报文。只有作者才会有最机密的私有密钥， 因
  此，只有作者才能计算出这些校验和。校验和就像来自作者的个人“签名”一样。



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

安全三要素是安全的基本组成元素，分别是机密性（Confidentiality）、完整性（Integrit）、可用性（Availability）。

​     

- **机密性：**要求保护数据内容不被泄漏，**加密是实现机密性要求的常用技术手段**。

- **完整性：**要求保护的数据内容是完整的、没有被篡改的。常见的保证一致性的技术手段是**数字签名**。
- **可用性：**要求保护的资源是“随需而得”。资源的范围很广，很多时候，资源的可用性主要是指数据的可用性。

在安全领域中，最基本的要素就是这三个，后来还有人想扩充这些要素，增加了 诸如可审计性、不可抵赖性等，但最重要的还是以上三个要素。

**在设计安全方案时，也要以这三个要素为基本的出发点，去全面地思考所要面对的问题。**



- 空间身份防假冒（冒充服务提供者，去诈骗用户。冒充信息发送方，去诈骗接收方，比如假传圣旨，伪造圣旨等）

- 信息防泄密（盗取用户信息，用户数据，防止信息在传输过程中被第三方读取到，比如战争时期的无线电监听，电文破译等）

- 内容防篡改（信息传输过程防止被第三方篡改）

- 行为抗抵赖（防止抵赖，比如看过不承认等）



通信，信息从发送方出产生，通过各种媒介传输到接收方，中间的传输信道一般被认为是不可信的。

从以前的信件，无线电报，现在的互联网通信等，信息都有可能被截取或被篡改。所以通讯加密这个需求自然而然就诞生了。

密码学的诞生，就是为了运用在战场。在公元前，战争之中出现了秘密书信。

在中国历史上最先的加密算法的记载出自于周朝兵书《六韬.龙韬》中的《阴符》和《阴书》。

在西方，在希罗多德（Herodotus）的《历史》中记载了公元前五世纪，希腊城邦和波斯帝国的战争中，普遍使用了移位法进行加密处理战争通信信息。



相传凯撒大帝为了防止敌人窃取信息，就使用加密的方式传递信息。

当时的加密方式很是的简单，就是对二十几个罗马字母创建一张对照表，将明文对应成为密文。

这种方式其实持续了好久。甚至在二战时期，日本的电报加密就是采用的这种原始加密方式。

在计算机诞生之前，以前就有通信需求，在古代，我们是通过书信等方式通讯。

一战二战时期电报兴起，电报是通过无线电波和电磁波来发送和传递信息的。只要电磁波频率和波长被捕获，电磁波中携带的信息就可以被接收。



HTTP1.1 有以下安全性问题：

1. 使用明文(不加密)进行通信，内容可能会被窃听；（即信息传输可能会被窃听）
2. 不验证通信方的身份，通信方的身份有可能遭遇伪装；（中间人攻击）
3. 无法证明报文的完整性，报文有可能遭篡改。

由于 HTTP 设计之初没有考虑到这几点，所以基于 HTTP 的这些应用都会存在安全问题。当初设计 HTTPS 是为了满足哪些需求？



**兼容性**

因为是先有 HTTP 再有 HTTPS。所以，HTTPS 的设计者肯定要考虑到对原有 HTTP 的兼容性。

这里所说的兼容性包括很多方面。比如已有的 Web 应用要尽可能无缝地迁移到 HTTPS



1. HTTPS 还是要基于 TCP 来传输
2. 单独使用一个新的协议，把 HTTP 协议包裹起来。所谓的“HTTP over SSL”，实际上是在原有的 HTTP 数据外面加了一层 SSL 的封装。HTTP 协议原有的 GET、POST 之类的机制，基本上原封不动



**保密性/防泄密**

HTTPS 需要做到足够好的保密性。

首先要能够对抗“嗅探”（圈内行话叫 Sniffer）。所谓的“嗅探”，通俗而言就是监视你的网络传输流量。

如果你使用【明文】的 HTTP 上网，那么监视者通过嗅探，就知道你在访问哪些网站的哪些页面。

嗅探是最低级的攻击手法。除了嗅探，HTTPS 还需要能对抗其它一些稍微高级的攻击手法——比如“重放攻击”



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

而且如果用 HTTP 协议进行通信，HTTP 本身没有加密功能，所以也无法做到对**通信整体**(**使用 HTTP 协议通信的请求和响应的内容**)进行加密。

即，HTTP 报文使用明文(指未经过加密的报文)方式发送。



在互联网整个信息传输链路中各个环节都可能被监听。就算是加密通信，也能被监听到通信内容，只不过监听者看到的是密文。

要解决 HTTP 上面 3 个大的安全问题，第一步就是要先进行加密通信。

于是在传输层增加了一层 SSL（Secure Sockets Layer 安全套接层）/ TLS (Transport Layer Security 安全层传输协议) 来加密 HTTP 的通信内容。



能让 HTTPS 带来安全性的是其背后的 TLS 协议。它源于九十年代中期在 Netscape 上开发的称为安全套接字层(SSL)的协议。

到 20 世纪 90 年代末，Netscape 将 SSL 移交给了 IETF，IETF 将其重命名为 TLS，并从此成为该协议的管理者。

许多人仍将 Web 加密称作 SSL，即使绝大多数服务已切换到仅支持 TLS。



HTTPS (HTTP Secure) 并不是新协议，而是 HTTP 先和 SSL（Secure Sockets Layer 安全套接层）/ TLS (Transport Layer Security 安全层传输协议) 通信，再由 SSL/TLS 和 TCP 通信。也就是说 HTTPS 使用了隧道进行通信。



为什么不直接对 HTTP 报文进行加密，这样就不需要 SSL/TLS 这一层了。

如果直接对 HTTP 报文进行加密也可以做到加密通信，但是虽然解决了第一条，但是后面 2 条就不好解决了。



### 加密算法



#### 摘要算法/哈希函数

消息摘要算法是密码学算法中非常重要的一个分支，它通过对所有数据提取指纹信息以实现数据签名、数据完整性校验等功能，由于其不可逆性，有时候会被用做敏感信息的加密。消息摘要算法也被称为哈希（Hash）算法或散列算法。

**任何消息经过散列函数处理后，都会获得唯一的散列值，这一过程称为 “消息摘要”，其散列值称为 “数字指纹”，其算法自然就是 “消息摘要算法”了。**

**哈希函数**，或者叫**散列函数**，是一种从任何一种数据中创建一个**数字指纹**（也叫数字摘要）的方法，散列函数把数据压缩（或者放大）成一个长度固定的字符串。







> 注意：用于保护密码的哈希函数和你在数据结构中学到的哈希函数是不同的。比如用于实现哈希表这之类数据结构的哈希函数，它们的目标是快速查找，而不是高安全性。只有**加密哈希函数**才能用于保护密码，例如SHA256，SHA512，RipeMD和WHIRLPOOL。

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





单向散列技术是为了保证信息的完整性，防止信息被篡改的一项技术。

**只有输入是相同的明文数据并且采用相同的消息摘要算法，得出来的密文才是一样的。**

其加密过程的计算量是比较大的，所以在以前计算设备的性能不是那么高的情况下，它只适合于少量数据的加密，比如计算机的口令。

现在计算机的性能发展的越来越快，它的应用领域也越来越广。

使用场景：

- 用户密码存储：将用户密码计算摘要后存入数据库中。谁都不知道明文。用户输入明文后，单向计算出摘要后再匹配检查是否输入正确。

- 数据签名：一般地，把对一个信息的摘要称为该消息的指纹或数字签名。数字签名是保证信息的完整性和不可否认性的方法。**数据的完整性是指信宿接收到的消息一定是信源发送的信息，而中间绝无任何更改；信息的不可否认性是指信源不能否认曾经发送过的信息。**其实，通过数字签名还能实现对信源的身份识别（认证），即确定 “信源” 是否是信宿意定的通信伙伴。 数字签名应该具有唯一性，即不同的消息的签名是不一样的；同时还应具有不可伪造性，即不可能找到另一个消息，使其签名与已有的消息的签名一样；还应具有不可逆性，即无法根据签名还原被签名的消息的任何信息。这些特征恰恰都是消息摘要算法的特征，所以消息摘要算法适合作为数字签名算法。

  

- 文件防篡改：很多网站提供文件下载，网站中同时提供了消息摘要值，比如md5或sha256，用户下载文件到本地后，可以检查本地文件的摘要值与网上对比。GNU/Linux中有各种命令可以快速查看文件的摘要：md5sum , sha512sum，sha256sum 等

无论是文本文件，二进制文件，还是其他的什么可以读入内存的二进制序列。都可以计算摘要。



##### 常见摘要算法

**消息摘要算法主要分为三大类：**

- **MD（Message Digest，消息摘要算法）**
- **SHA-1（Secure Hash Algorithm，安全散列算法）**
- **MAC（Message Authentication Code，消息认证码算法）。**





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

> 在不考虑UNICODE编码中电脑键盘未标明的特殊字符，我们构建密码时，我们通常选择字符范围是：
>
> - 数字：0~9 共10位 
>
> - 大小写英文字母：a~z A~Z 共52位
>
> - 特殊字符：“ !"#$%&&#039;()*+,-./:;<=>?@[\]^_`{|}~” 不包含两边引号共33位（其中包含空格）



如果要评判一则口令是强是弱，就必须先考虑影响口令强度的因素：**复杂性和长度**，因为我们在输入口令时只有这两种维度的选择：

- 要么多输入一些特殊字符增强复杂性。

- 要么多输入一些混合字符/字母增加口令长度


在不考虑拖库、社工等口令获取方式的前提条件下，通常情况下，破解口令仅有暴力破解的方式可以选择，其中亦包括字典攻击和彩虹表破解。



在纯粹的暴力破解中，攻击者需要逐一长度地尝试口令可能组合的方式，是ATM机般的纯数字组合，还是12306般的纯数字字母组合，亦或是正常电商那般可以混合输入数字、字母和特殊字符。假设一则口令P的长度是L，可选择的组合形式范围的长度是S，那么即便是在“暴力破解”这种残暴字眼的手段中，运气不好的情况下仍然需要最多尝试S的L次方。

> 口令是否安全的原则取决于攻击者能否在可容忍的时间内破解出真实口令，而是否有耐心进行暴力破解往往决定于攻击者的目的及成效：
>
> 一名仅为破解电子书小说压缩包的宅男不大可能会浪费一天以上时间等待口令的“出现”。



如果我们将SL当作口令强度的评测标准，显而易见，在口令长度相同的情况下，我们可选择的组合方式和范围内越大则口令强度越强，即S越大，SL的值越大。

另一方面，在可选择的组合方式和范围有限的情况下，口令长度越长则口令强度越强，即L越大，SL的值越大。

由于SL是指数级的增长，所以口令的高复杂度并不意味着口令的高强度，比如：

16位纯数字的口令的组合方式有10的16次方，而8位数字/字母/特殊字符混合口令的组合方式仅约为95的8次方。

从暴力破解的难度上看，前者比后者要高出一个数量级。



穷举出16位纯数字的密码，一共有 1,0000,0000,0000,0000 种情况。每种情况



**查表法**

查表法对于破解一系列算法相同的哈希值有着无与伦比的效率。

主要的思想就是预计算密码字典中的每个密码，然后把哈希值和对应的密码储存到一个用于快速查询的数据结构中。

一个良好的查表实现可以每秒进行数百次哈希查询，即使表中储存了几十亿个哈希值。



彩虹表

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



另外在多方通信中，密钥的管理也会非常的麻烦。在数据传送前，发送方和接收方必须商定好密钥，然后使双方都能保存好密钥。其次如果一方的密钥被泄露，那么加密信息也就不安全了。另外，每对用户每次使用对称加密算法时，都需要使用其他人不知道的唯一秘密钥，也就是说每一组收发方所使用的密钥都是唯一的，例如：A电脑与B、C、D都有通信，那么A就得存储与B、C、D三台电脑通信所用的密钥。这会使得收、发双方所拥有的钥匙数量巨大，密钥管理成为双方的负担。





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









### 身份认证/加签验签/

**基于某些“私密的共享信息”**

为了解释“私密的共享信息”这个概念，咱们先抛开“信息安全”，谈谈日常生活中的某个场景。
假设你有一个久未联系的老朋友。因为时间久远，你已经没有此人的联系方式了。某天，此人突然给你发了一封电子邮件。
那么，你如何确保——发邮件的人确实是你的老朋友？

有一个办法就是：你用邮件向对方询问某个私密的事情（这个事情只有你和你的这个朋友知道，其他人不知道）。如果对方能够回答出来，那么对方【很有可能】确实是你的老朋友。

从这个例子可以看出，如果通讯双方具有某些“私密的共享信息”（只有双方知道，第三方不知道），就能以此为基础，进行身份认证，从而建立信任。



**基于双方都信任的“公证人”**

“私密的共享信息”，通常需要双方互相比较熟悉，才行得通。如果双方本来就互不相识，如何进行身份认证以建立信任关系捏？
这时候还有另一个办法——依靠双方都信任的某个“公证人”来建立信任关系。
如今 C2C 模式的电子商务，其实用的就是这种方式——由电商平台充当公证人，让买家与卖家建立某种程度的信任关系。
考虑到如今的网购已经相当普及，大伙儿应该对这类模式很熟悉吧。所以俺就不浪费口水了。



对于 SSL/TLS 的应用场景，由于双方（“浏览器”和“网站服务器”）通常都是素不相识，显然【不可能】采用第一种方式（私密的共享信息），而只能采用第二种方式（依赖双方都信任的“公证人”）。

那么，谁来充当这个公证人？这时候，CA 就华丽地登场啦。所谓的 CA，就是“数字证书认证机构”的缩写，英文全称叫做“Certificate Authority”。



### 国密证书

国密证书，是指采用国密算法加密签名的证书。

各大浏览器，预置的都是国际知名各大 CA 的根证书，而国密 CA 作为后来者，还没有大范围使用，所以国际上主流的浏览器（firefox、chrome、safari等）连国密都不支持，更别提预置国密相关根证书。

国产密码算法（国密算法）是指国家密码局认定的国产商用密码算法，在金融领域目前主要使用公开的SM2、SM3、SM4三类算法，分别是非对称算法、哈希算法和对称算法。

SM2算法：SM2椭圆曲线公钥密码算法是我国自主设计的公钥密码算法，包括SM2-1椭圆曲线数字签名算法，SM2-2椭圆曲线密钥交换协议，SM2-3椭圆曲线公钥加密算法，分别用于实现数字签名密钥协商和数据加密等功能。SM2算法与RSA算法不同的是，SM2算法是基于椭圆曲线上点群离散对数难题，相对于RSA算法，256位的SM2密码强度已经比2048位的RSA密码强度要高。

SM3算法：SM3杂凑算法是我国自主设计的密码杂凑算法，适用于商用密码应用中的数字签名和验证消息认证码的生成与验证以及随机数的生成，可满足多种密码应用的安全需求。为了保证杂凑算法的安全性，其产生的杂凑值的长度不应太短，例如MD5输出128比特杂凑值，输出长度太短，影响其安全性SHA-1算法的输出长度为160比特，SM3算法的输出长度为256比特，因此SM3算法的安全性要高于MD5算法和SHA-1算法。

SM4算法：SM4分组密码算法是我国自主设计的分组对称密码算法，用于实现数据的加密/解密运算，以保证数据和信息的机密性。要保证一个对称密码算法的安全性的基本条件是其具备足够的密钥长度，SM4算法与AES算法具有相同的密钥长度分组长度128比特，因此在安全性上高于3DES算法。







## 三、HTTPS 加密了哪些内容？



HTTPS 会加密 URL 吗？

HTTPS 会加密头部吗？

浏览器显示信息是已经解密后的信息，所以不要误以为 URL 没有加密。

如果你用抓包工具，抓包 HTTPS 的数据的话，你是什么都看不到的，如下图，只会显示“Application Data”，表示这是一个已经加密的 HTTP 应用数据。



HTTPS 可以看到请求的域名吗？

从上面我们知道，HTTPS 是已经把  HTTP Header + HTTP Body 整个加密的，所以我们是无法从加密的 HTTP 数据中获取请求的域名的。

但是我们可以在 TLS 握手过程中看到域名信息。TLS 第一次握手的 “Client Hello” 消息中，有个 server name 字段，它就是请求的域名地址。



## 四、TLS基本概念

### CA 机构

CA: 证书授权中心 (certificate authority)

类似于国家出入境管理处一样，给别人颁发护照；也类似于国家工商管理局一样，给公司/企业颁发营业执照。

为了让服务端的公钥被大家信任，各种网站的HTTPS服务端的证书都是由 CA （Certificate Authority，证书认证机构）签发的。

CA 就是网络世界里的公安局、公证中心，具有极高的可信度，所以由它来给各个公钥签名，信任的一方签发的证书，那必然证书也是被信任的。

CA（Certificate Authority）即数字证书颁发机构，主要负责发放和管理数字证书，SSL证书就是CA机构颁发的。



- 认证CA，只有通过WebTrust国际安全审计认证，根证书才能预装到主流的操作系统和浏览器中，成为全球可信的ssl证书颁发机构。
- 自建CA，在一些内部或测试场景中，也可以自签CA



只有通过 WebTrust 国际安全审计认证，根证书才能预装到主流的浏览器而成为一个全球可信的认证机构。

Webtrust 认证是各大主流的浏览器、微软等大厂商支持的标准，是规范 CA 机构运营服务的国际标准。

在操作系统和浏览器厂商根证书植入项目中，必要的条件就是要通过 Webtrust 认证，才能实现浏览器与数字证书的无缝嵌入。



目前市场上大部分用户使用的SSL证书都是国外品牌。常见CA机构：

- 沃通CA 
- DigiCert
- GlobalSign
- letsencrypt



CA 对公钥的签名认证也是有格式的，不是简单地把公钥绑定在持有者身份上就完事了，还要包含序列号、用途、颁发者、有效时间等等，把这些打成一个包再签名，完整地证明公钥关联的各种信息，形成“数字证书”。

证书里的证明对象是一个“实体”（Common Name），可以证明任何东西，但是在互联网的环境下，这个“实体”就通常是域名了。



**证书体系**

CA 中心为每个使用公开密钥的用户发放一个数字证书，数字证书的作用是证明证书中列出的用户合法拥有证书中列出的公开密钥。

CA 机构的数字签名使得攻击者不能伪造和篡改证书。



**数字证书的实质是证书权威机构（CA）用自己的私钥，对普通用户提交的公钥和名称的绑定关系的数字签名。**





不过 CA 如何证明自己呢？这本质还是信任链的问题。“小一点”的 CA 可以让“大 CA” 签名认证，但链条的最后，也就是 Root  CA，就只能自己证明自己了，这个就叫“自签名证书”（Self-Signed Certificate）或者“根证书”（Root  Certificate）。对于根证书我们必须无条件相信，否则整个证书信任链就走不下去了。

有了这个证书体系，**操作系统和浏览器都内置了各大 CA 的根证书**，上网的时候只要服务器发过来它的证书，就可以验证证书里的签名，顺着证书链（Certificate Chain）一层层地验证，直到找到根证书，就能够确定证书是可信的，从而里面的公钥也是可信的。

**根证书是自签名证书，也就是自己证明自己，是信任的起点，所以作为用户，也就是“你”，就必须信任它，否则就没有从它开始的整个证书链。**

**所谓自签名，就是用证书里的公钥来证明证书里的公钥，自己证明自己。**



假设现在有一个三级的证书体系（Root CA=> 一级 CA=> 二级 CA），它是如何完成证书信任链验证过程的呢？

前面我们说过，由于操作系统和浏览器都内置了各大 CA 的根证书，上网的时候只需要服务器发送来它的证书，就可以验证证书里的签名，顺着证书链（Certficate Chain）一层层地验证，直到找到根证书。

如果服务器返回的是一个二级证书，操作系统和浏览器内置的根证书（根公钥）只能解密根证书签名的证书，无法解密二级证书，只有使用一级证书的（公钥）才能解密二级证书，那么操作系统和浏览器是如何自上而下地层层解析得到根证书的呢？其实**服务器返回的是一个证书链，然后操作系统或浏览器就可以使用信任的根证书（根公钥）解析根证书得到一级证书的公钥+摘要验签，然后拿一级证书的公钥解密一级证书得到二级证书的公钥+摘要验签，再然后拿二级证书的公钥解密二级证书得到服务器的公钥和摘要验签名，验证过程就此结束！**

服务器在握手的时候会返回整个证书链，但通常为了节约数据量，不会包含最终的根证书，因为根证书通常已经在浏览器或者操作系统里内置了。

在这样一条信任链中，CA  的诚实可信是公钥信任体系的信任根。一旦计算机的“受信任根证书颁发机构”列表中，混入了不可信任的根证书，就可以随时签发任何名称的数字证书。由于计算机对所有受信任更证书所签发的数字证书基于不区分的平等信任，混入信任列表的恶意根证书签发的伪造证书将会危害计算机的所有安全通信，机密的信息会被解析窃听，显示为有效的数字签名和安全的 HTTPS 的连接其实际是不可信的。









默认地，这些

在 HTTP 里面，各种网站的**HTTPS证书**都是要向**CA**来申请，验证之后签发的。



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

申请者首先在本地生成一个密钥对，利用这个私钥对"我们需要提供的信息（域名）"进行加密，从而生成证书请求文件(.csr)，这个证书请求文件其实就是私钥对应的公钥证书的原始文件，里面含有对应的公钥信息；

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



2)  [身份验证](https://support.huaweicloud.com/ccm_faq/ccm_01_0135.html)：按照CA中心的规范，申请数字证书，必须配合完成域名授权验证来证明您对所申请绑定的域名的所有权。



所以对于所有的申请者，CA都要确保申请者确实是有这个域名的控制权，才能给他签发证书。即要验证申请人的身份。

行业的标准叫做 [ACME Challenge](https://letsencrypt.org/zh-cn/docs/challenge-types/)，大致的原理是：申请者向（CA）证明自己是 super-bank.com, 你让 `super-bank.com/.well-known/acme-challenge/foo` 这个 URL 返回 `bar` 这个 text，来证明你有控制权，我就给你发证书。（其实还支持 DNS TXT 等其他的方式）



- DNS验证：CA指定一条DNS记录，你去你的域名商处添加一条DNS解析，CA来验证。

- 文件验证：将CA指定的txt文件部署到你的域名下，CA来验证。

- 邮箱验证：邮箱验证指通过回复邮件的方式来验证域名所有权。

  [域名验证方式](https://cloud.tencent.com/document/product/400/4142)



2）审核信息：CA 机构通过线上、线下等多种手段验证申请者提供信息的真实性，如组织是否存在、企业是否合法，是否拥有域名的所有权等。



3）签发证书：如信息审核通过，CA 机构会向申请者签发认证文件：HTTPS证书。

- HTTPS证书包含以下信息：

  - 申请者公钥、申请者的组织信息和个人信息、签发机构 CA 的信息、有效时间、证书序列号等信息的明文。
  - 同时包含一个签名（CA自证这个证书是这个CA签发的）

- 这个签名算法：

  - 首先，使用散列函数计算公开的明文信息的信息摘要，得到HASH值，然后用 **CA 的私钥** 对信息摘要进行加密，密文即签名。

  - （注意CA的公钥是）
  
    

> 我们可以拿到证书之后，可以在线查看证书的信息。
>
> [证书信息查看](https://myssl.com/cert_decode.html)





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









### TLS握手流程

**一般情况下，不管 TLS 握手次数如何，都得先经过 TCP 三次握手后才能进行**。

因为 HTTPS 都是基于 TCP 传输协议实现的，得先建立完可靠的 TCP 连接才能做 TLS 握手的事情。



「HTTPS 中的 TLS 握手过程可以同时进行三次握手」

- **客户端和服务端都开启了 TCP Fast Open 功能，且 TLS 版本是 1.3；**
- **客户端和服务端已经完成过一次通信。**



https://aandds.com/blog/network-tls.html#2fa47076





和 HTTP/1.x 一样，目前受到主流支持的 TLS 协议版本是 1.1 和 1.2，分别发布于 2006年和2008年，也都已经落后于时代的需求了。

在2018年8月份，IETF终于宣布TLS 1.3规范正式发布了。



TLS 握手中的确切步骤将根据所使用的密钥交换算法的种类和双方支持的密码套件而有所不同。

RSA 密钥交换算法虽然现在被认为不安全，但曾在 1.3 之前的 TLS 版本中使用。





- 客户端问候：握手开始，Client 先发送 ClientHello ，在这条消息中，Client 会上报它支持的所有“能力”。
  - client_version 中标识了 Client 能支持的最高 TLS 版本号；
  - random 中标识了 Client 生成的随机数，用于预备主密钥和主密钥以及密钥块的生成，总长度是 32 字节，其中前 4 个字节是时间戳，后 28 个字节是随机数；
  - cipher_suites 标识了 Client 能够支持的密码套件。
  - extensions 中标识了 Client 能够支持的所有扩展。



- Server 在收到 ClientHello 之后，如果能够继续协商，就会发送 ServerHello，否则发送 Hello Request 重新协商。在 ServerHello 中，Server 会结合 Client 的能力，选择出双方都支持的协议版本以及密码套件进行下一步的握手流程。server_version 中标识了经过协商以后，Server 选出了双方都支持的协议版本。random 中标识了 Server 生成的随机数，用于预备主密钥和主密钥以及密钥块的生成，总长度是 32 字节，其中前 4 个字节是时间戳，后 28 个字节是随机数；cipher_suites 标识了经过协商以后，Server 选出了双方都支持的密码套件。extensions 中标识了 Server 处理 Client 的 extensions 之后的结果。



- 



### 信任和责任

我们在互联网上的每一动作都需要一个基本的信任体系。当你通过浏览器去访问你的银行账户或你喜爱的社交媒体时，你肯定希望你访问的那个网站就是你在浏览器输入的那个网站。这种期望就基于一个基本的信任体系，这就是我们常听见的web PKI(Public Key Infrastructure)系统。



从一个较高的层次来看，PKI系统就像一个公证人，它通过签发数字证书来赋予服务器为网站提供服务的能力。这个数字证书就是我们常说的证书了，它包括了网站的域名，组织名称，有效期和一个公钥。对于每一个公钥来说，都有一个对应的私钥。如果服务器需要使用指定证书去为网站提供HTTPS服务，那么这个服务器就需要证明对该私钥的所有权。



网站获取数字证书的第三方机构就是CA机构(Certificate Authorities) CA机构在颁发证书前会验证操作者的域名所有权。如果一个数字证书是由一个浏览器信任的CA颁发的，那么该证书就可以用于HTTPS站点了。所有的这些验证都是浏览器内部实现的，给用户的唯一感知的只是浏览器上一个小绿锁🔐，或是出错时的一个错误。



PKI系统本身是很好的，但是作为一个信任系统，依然存在很多风险。一个最基本的风险就是，CA机构可以为任何网站颁发证书。这就意味着，[Hong Kong Post Office](https://bugzilla.mozilla.org/show_bug.cgi?id=408949)可以为gmail.com或facebook.com签发证书，而且被大部分浏览器信任。更糟糕的是，如果CA被黑客攻击了，那么黑客可以在CA毫无知觉的情况下颁发任何证书，从而导致用户处于一个高风险的处境中。



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



**证书透明度**

如果公钥固定机制也不起作用了，那么我们怎么去探测CA的一些错误？这时CT就应运而生。

CT的目标就是让所有的证书透明，这样误颁发的证书也能被发现，从而可以采取相应的应对措施。



通过一系列的事件，人们发现整个安全体系理论上看似乎无懈可击，实际上脆弱不堪，给人一种无力感，不少大牛包括一些互联网巨头开始关注并思考这个问题。Ben Laurie 和 Adam Langley 首先构思了“证书透明度”，并将一个框架实现开发为开源项目，2013 年 3 月，Google 推出其首个证书透明度日志。证书透明度是针对 CA 机构颁发证书的过程不透明而提出来的，俗话说，没有监督的权力是腐败的根源，要让权力在阳光下运行，这也是证书透明度的主要理念，它不是为了推翻 CA，而是让证书的签发过程透明化，一旦有人造假或人为失误，将立即暴露在阳光下，无所遁形。

证书透明度主要有三个部分：

- 证书透明度日志(Certificate logs)
- 证书监控(Certificate monitors)
- 证书审计(Certificate auditors)



### 证书交叉认证

在 PKI 证书体系中，**信任是通过逐级签名以及对这些签名的验证来实现的**。 

对大部分客户端系统来说，这些系统中会存在一个或多个受信的根证书发证机构的证书， 其公钥是通过这些系统本身的更新机制派发的。

根证书发证机构的证书通常是自签名的，更新相对来说比较麻烦（它通常依赖于操作系统的在线或离线更新机制）， 因此这些证书的私钥事关重大，因此人们通常不希望经常更新它们，因而证书发证机构在绝大多数时候并不会使用这些私钥来签署证书。取而代之的是，他们会创建一些称为中级发证机构的证书用来签署日常的证书，这样根证书的私钥可以采用更为严密的方法来保护， 例如可以把它们从网络上彻底断开，而中级发证机构的证书则可以以较高的频率进行密钥轮换，借此来避免其私钥暴露导致的风险。

一个新的发证机构进入市场时，其自签名的根证书往往不会被已经在市场上的客户端系统认可， 因此这样一来新的发证机构想要获得用户就必须想办法解决能被用户承认这个问题。 一旦获得了一定的知名度并证明了自己的可靠性， 这些发证机构便可以遵循一定的流程获得主流浏览器或操作系统的认可， 并将自己的根证书也加入到它们的受信根证书列表中了。 所以，在起步阶段，新的发证机构往往会要求一些已经存在的根证书去对其根证书进行交叉签署， 在客户端验证证书有效性时，由于这些根证书在他们看来是一个经过了受信根证书签名的中级证书而不是一个普通的不受信自签名根证书， 因此也就不会给出无法验证证书是否有效的提示，而是能够正确地对其有效性进行验证了。

Let’s Encrypt 在起步阶段正是采用了这种做法。通俗地说，它的中级发证机构的证书被两家根证书机构同时签名， 其一是它自己的 ISRG Root，另一个是另一家根证书机构 IdenTrust 的 DST Root X3。初期，由于 DST Root X3 已经被许多操作系统和浏览器认证过，因此为其普及起到了非常重要的作用。

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

















### 域名发散和域名收敛



​	

> 今日头条面试题之一
>
> 
>
> 网页中的图片资源为什么分放在不同的域名下 ?  
>
> 比如知乎中的图片资源的URL通常是 https://pic1.zhimg.com/013926975_im.jpg ，与主站的域名不同。





在大型网站中，我们发现页面资源经常使用不同的域名进行引用。

例如126邮箱的部分js、css、图片存放于http://mimg.127.net/域名下，京东的部分静态图片存放在http://img11.360buyimg.com域名下。

那这样做究竟有什么好处呢，和性能又有什么关系呢，下面进行具体分析。

首先，浏览器对域名的请求限制。

- **浏览器针对同一个域名的并发请求是有限制的，Chrome 和 edge 都是 6 个。即在Chrome中访问 zhihu.com 时，同时最多只能有 6 个TCP连接。**

- **浏览器对并发请求的数目限制是针对域名的，即针对同一域名（包括二级域名）在同一时间支持的并发请求数量的限制。**

如果请求数目超出限制，则会阻塞。因此，网站中对一些静态资源，使用不同的一级域名，可以提升浏览器并行请求的数目，加速界面资源的获取速度。





**浏览器为什么要针对同一域名的tcp并发连接数要设限制？**

- 由于 TCP 协议的限制，PC 端只有65536个端口可用以向外部发出连接，而操作系统对半开连接数也有限制以保护操作系统的 TCP\IP 协议栈资源不被迅速耗尽，因此浏览器不好发出太多的 TCP 连接，而是采取用完了之后再重复利用 TCP 连接或者干脆重新建立 TCP 连接的方法。

- 如果采用阻塞的套接字模型来建立连接，同时发出多个连接会导致浏览器不得不多开几个线程，而线程有时候算不得是轻量级资源，毕竟做一次上下文切换开销不小。

- 这是浏览器作为一个有良知的客户端在保护服务器。就像[以太网](https://www.zhihu.com/search?q=以太网&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A15691654})的冲突检测机制，客户端在使用公共资源的时候必须要自行决定一个等待期。

  - 当超过2个客户端要使用公共资源时，强势的那个邪恶的客户端可能会导致弱势的客户端完全无法访问公共资源。
  - 从前[迅雷](https://www.zhihu.com/search?q=迅雷&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A15691654})被喷就是因为它不是一个有良知的客户端，它作为 HTTP [协议客户端](https://www.zhihu.com/search?q=协议客户端&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A15691654})没有考虑到服务器的压力，作为 BT 客户端没有考虑到自己回馈上传量的义务。

  

- 

  

  

**修改并发请求数量**

浏览器这样做出发点是好的，但有时候我们想要个性化定制（比如做个插件开个挂之类的😈）就没那么方便了，那能不能修改限制上限呢？

- Chrome 的并发请求数量是不能修改的，因为已经固定写到源码中了，具体可以查看这个[链接](https://chromium.googlesource.com/chromium/src/+/65.0.3325.162/net/socket/client_socket_pool_manager.cc#44)

- Firefox 是可以修改的，想要修改首先在地址栏输入 `about:config`，搜索 `http.max` 关键字。下面这两个列都可以修改。
  - `network.http.max-connections` 为全局 HTTP 同时最大的连接数量，默认为 900；
  - `network.http.max-persistent-connections-per-server` 为单个域名最大链接数量，默认为 6；





**域名发散**

针对浏览器这种并发限制，在前端性能优化手段上，很自然就会诞生域名发散的技术：

> 将部分静态资源跟主站放在不同的域名之下。以提供最大并行度，让客户端加载静态资源更为迅速







**域名收敛**

域名收敛的意思就是建议将静态资源只放在一个域名下面，而非发散情况下的多个域名下。

域名发散可以突破浏览器的域名并发限制，那么为要反其道而行之呢？

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





# 浏览器进程模型



传统的浏览器被设计为显示网页，而Chrome的设计目标是支撑“Web App”（当时的js和相关技术已经相当发达了，Gmail等服务也很成功）。

这就要求Chrome提供一个类似于“[操作系统](https://www.zhihu.com/search?q=操作系统&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A999401453})”感觉的架构，支持App的运行。而App会变得相当的复杂，这就难以避免出现bug，然后crash。

同时浏览器也要面临可能运行“[恶意代码](https://www.zhihu.com/search?q=恶意代码&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A999401453})”。

流览器不能决定上面的js怎么写，会不会以某种形式有意无意的攻击浏览器的渲染引擎。如果将所有这些App和[浏览器](https://www.zhihu.com/search?q=浏览器&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A999401453})实现在一个进程里，一旦挂，就全挂。

因此Chrome一开始就设计为把**隔离性**作为基本的设计原则，用进程的隔离性来实现对App的隔离。这样用户就不用担心：

- 一个Web App挂掉造成其他所有的Web App全部挂掉（稳定性）
- 一个Web App可以以某种形式访问其他App的数据（安全性）

以及Web App之间是并发的，可以提供更好的响应，一个App的渲染卡顿不会影响其他App的渲染（性能）（当然这点线程也能做到）

因此，这样看起来用进程实现非常自然。





目前世界上使用率最高的浏览器是 [Chrome](https://www.google.com/chrome/)，它的核心是 [Chromium](https://www.chromium.org/chromium-projects/)（Chrome 的开发实验版），微软的 [Edge](https://www.microsoft.com/en-us/edge) 以及国内的大部分主流浏览器，都是基于 Chromium 二次开发而来，它们都有一个共同的特点：**多进程架构**。

当我们用 Chrome 打开一个页面时，会同时启动多个进程

(Chrome 使用了由 Apple 发展来的号称 “地表最快” 的 [Webkit](https://webkit.org/) 排版引擎，搭载 Google 独家开发的 [V8](https://v8.dev/) Javascript 引擎)

**高性能的 Web 应用的设计和优化都离不开浏览器的多进程架构**，接下来我会以 Chrome 为例，带你了解多进程架构。





Chromium里有三种进程——浏览器、渲染器和插件。

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



我们在设置 DNS 解析记录会有一个 ttl 值(time to live)，单位是秒，意思是这个记录最大有效期是多少秒。

**经过实验，OS 缓存DNS解析记录时会参考 ttl 值，但是不完全等于 ttl 值，而浏览器 DNS 缓存的时间跟 ttl 值无关，每种浏览器都使用一个固定值。**



- 在Chrome地址栏中输入chrome://net-internals/#dns 就可以看各域名的DNS 缓存时间。默认，Chrome对每个域名会默认缓存60s。
  - 注意，

- 



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

一个 URL 常常需要代表若干不同的资源。例如那种需要以多种语言提供其内容的网站站点。如果某个站点（比如 Joe 的五金商店这样的站点）有说法语的和说英语的两种用户，它可能想用这两种语言提供网站站点信息。但在这种情况下，当用户请求 http://www.joes-hardware.com 时，服务器应当发送哪种版本呢？法文版还是英文版？



**Google 建议对每种语言版本的网页使用不同的网址，而不是使用 Cookie 或浏览器设置来调整网页上的内容语言。**

世界各国谷歌网址是由Google加上不同国家和地区顶级域名（ccTLD）后缀组成的。为了适应不同国家地区的搜索习惯，提供最精确的搜索结果，谷歌在全世界主要国家地区都有对应的不同网址。

比如，美国谷歌：google.com（美国不使用google.us），德国谷歌：google.de等等。不同国家的谷歌，搜索同一个关键词，结果都是不一样的，这也就是地域化的区别。

用户在访问谷歌时，也会优先跳转到相应国家的Google网址。 因此，如果是针对某个国家地区做SEO，那么在验证结果的时候，一定要使用该国家的谷歌进行搜索，这样才能得到最准确的结果。

**固定访问谷歌地址**

使用google.com/ncr来访问Google，ncr是No Country Redirect的缩写，此时Google会重定向请求到主站google.com，而不会定向到访问IP所在的Google域名了。





# 跨域





浏览器同源策略









资源`URL`的以下三项中都相同时才认为两个资源是`同源的`

- `协议`: 比如http、https、ws、wss
- `域名`: 包括主域名和子域名，需要做到全匹配。
- `端口号`

这个方案也被称为“协议/主机/端口元组”，或者直接是“元组”。（“元组”是指一组项目构成的整体，具有双重/三重/四重/五重等通用形式。）





### 非同源数据存储访问

- `localStorage`、`IndexedDB` 是浏览器常用的本地化存储方案，两者都是以源进行分割。每一个源下的脚本，都只能够访问同源中的缓存数据，不能实现跨域访问。
- `Cookie`的匹配规则与上面二者又略有差异，主要差异在于`子域`的`cookie`会默认使用在`父域`上。详细的规则可以参考另一篇笔记 [浏览器原理 - 缓存之cookie](https://github.com/HXWfromDJTU/blog/issues/22)
- `DOM` 如果两个网页不同源，就无法拿到对方的`DOM`。
  比如项目中制作的`Telegram`登录，授权`Button`是一段插入`<Iframe>`的脚本。`Ifream`本身的域名是`auth.telegram.io`。那么域名为`abc.io`的业务页面，则不能`Ifream`中的`DOM`进行访问。



## 为什么只有浏览器有同源策略

### 浏览器是个公共应用

无论是在PC还是移动设备商，你的 Chrome 和 Firefox 是所有网站应用的载体。

你在访问 淘宝网 的时候，相当于从 [www.taobao.com](http://www.taobao.com/) 的服务器上下载了 对应的 html、css、js资源，页面也从 api.taobao.com (JSONP 也好, CORS 也罢）获取了商品数据。

页面 JavaScript 把获取到的热门商品数据缓存到了本地的 localstorage 中，用于优化体验。

你点击登陆时，通过访问 api.taobao.com/login 接口完成了授权登录，服务器下发 Token 到 cookie 中。

同样的，在京东、在亚马逊、在你的个站、甚至在恶意网站进行访问后，网站的数据都会被下载到设备本地，并且通过浏览器这一个应用所管理着。

### 资源以域划分，是浏览器的本地行为

接触过客户端的同学一定知道，在安卓 和 iOS上的两个App的本地数据，没有对方的允许是不能够直接本访问的，控制权在于App开发方本身，而提供保障的则是系统(Android 和 iOS)本身。

相同的情况类比一下，把浏览器当做系统本身(Chrome Book 请给我打钱)，把各个站点相当于“系统上”的一个个App。

下面的页面各位 FEer一定很熟悉，这是Chrome浏览器对于页面中所有加载的静态资源的域名划分。