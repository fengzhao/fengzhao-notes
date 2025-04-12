## 什么是 SSL 证书？

SSL(Secure Socket Layer 安全套接层)是基于HTTPS下的一个协议加密层。

最初是由网景公司（Netscape）研发，后被IETF（The Internet Engineering Task Force - 互联网工程任务组）标准化后写入（RFCRequest For Comments 请求注释），RFC里包含了很多互联网技术的规范！



SSL 是保护用户数据和防止身份被盗用的最佳方式。拥有 SSL 证书的网站可以告诉用户，他们可以放心的浏览，SSL 可以保护他们的数据安全。不同的 SSL 证书提供不同级别的验证。



https://ssl.do/ssl/



## 什么是 Let’s Encrypt





Let’s Encrypt 是国外一个公共的免费 SSL 项目，由 Linux 基金会托管。它的来头不小，由 Mozilla、思科、Akamai、IdenTrust 和 EFF 等组织发起，目的就是向网站自动签发和管理免费证书。

以便加速互联网由 HTTP 过渡到 HTTPS，目前 Facebook 等大公司开始加入赞助行列。

Let’s Encrypt 已经得了 IdenTrust 的交叉签名，这意味着其证书现在已经可以被 Mozilla、Google、Microsoft 和 Apple 等主流的浏览器所信任。

用户只需要在 Web 服务器证书链中配置交叉签名，浏览器客户端会自动处理好其它的一切，Let’s Encrypt 安装简单，使用非常方便。

**通过 Let’s encrypt 可以获得 90 天免费且可续期的 SSL 证书，而利用 acme.sh 可以自动生成和更新**。



### 什么是通配符证书

域名通配符证书类似 DNS 解析的泛域名概念，通配符证书就是证书中可以包含一个通配符。

主域名签发的通配符证书可以在所有子域名中使用，比如 `.example.com`、`bbs.example.com`。





### 申请通配符证书

Let’s Encrypt 上的证书申请是通过 ACME 协议来完成的。ACME 协议规范化了证书申请、更新、撤销等流程，实现了 Let’s Encrypt CA 自动化操作。

解决了传统的 CA 机构是人工手动处理证书申请、证书更新、证书撤销的效率和成本问题。





签发 SSL 证书需要证明这个域名是属于你的，即**域名所有权**，一般有两种方式验证：http 和 dns 验证。





https://sb.sb/blog/linux-acme-sh-lets-encrypt-ssl/





https://miaotony.xyz/2020/03/28/Server_IssueACertWithACME/





## TLS会话恢复

 TLS session resumption

TLS 会话恢复使用 session ticket 的机制在 **RFC 5077** 中进行了定义，该 RFC 于 **2008 年** 发布，适用于 TLS 1.2 版本。



在 Nginx 中配置 SSL 会话缓存可以提高 SSL 握手性能和服务器负载能力，因为 SSL 握手需要进行密钥协商和证书验证等操作，会占用服务器的计算资源。

通过使用 SSL 会话缓存，可以在客户端和服务器之间缓存 SSL 会话状态信息，从而加快 SSL 握手速度和减轻服务器负载。





```
Syntax: ssl_session_cache off | none | [builtin[:size]] [shared:name:size];
Default: ssl_session_cache none;
Context: http, server
```

设置存储会话参数的缓存的类型和大小。缓存可以是下面的类型中的任意一个：

- `off`    严格禁止使用会话缓存：nginx 显式地告诉客户端不重用会话

- `none`    不允许使用会话缓存：nginx 告诉客户端可能重用会话，但不真正地在缓存中存储会话参数

- `builtin`    OpenSSL 内置的缓存。仅能被一个工作进程使用。在会话中指定缓存大小。默认保存 20480 个会话。使用内置缓存将导致内存碎片

- `shared`    所有工作进程共享缓存。以字节为单位指定缓存大小；1M 大约可以存储 4000 个会话。每个共享缓存可以拥有任意的名称。可以在多个虚拟主机中使用具有相同名称的缓存。

  它还用于自动生成、存储和定期轮换 TLS 会话票据密钥（1.23.2），除非使用 `ssl_session_ticket_key` 指令显式地进行配置。可以同时使用这两种缓存类型，比如：









握手协议完成后，服务器端会在内存中保存会话信息，包括如下部分：

- 会话标识符（session identifier）：每个会话都有唯一编号。

- 证书（peer certificate）：对端的证书，一般情况下都为空。

- 压缩算法（compression method）：一般不启用。

- 密码套件（cipher spec）：客户端和服务器端协商出的密码套件。

- 密钥（master secret）：每个会话会保存一个主密钥，注意不是预备主密钥。

- 话可恢复标识（is resumable）：表示某个会话是否可恢复。

  

通过服务器保存的会话信息，最终能够生成 TLS 记录层协议所需要的加密参数（security parameters），从而能够保护应用层的数据。





每次建立新 SSL/TLS 连接都需要握手，如果会话中断，那么需要重新握手。此时，有两种方法恢复原来的 Session：

1. Session ID

Session ID 重用的前提是客户端和服务端都保存会话密钥。每次会话都有唯一的编号（Session ID）。会话中断，需要重连时，客户端只要给出该编号，并且服务器端拥有该记录，双方就可以重用已有的会话密钥，而不必重新生成。

客户端提供 Session ID，服务端确认该编号存在，双方不再进行握手阶段剩余的步骤，而是直接使用已有的会话密钥。

目前所有浏览器都支持 Session ID，但其缺点是：因为 Session ID 往往只保留在一台服务器上，所以如果客户端的请求发到另一台服务器，那么无法恢复会话。当然也可以要求负载均衡的时候只用 IP hash，尽管在实际情况中这么做不太现实。

Session ID 方案要求服务端记住会话状态，有违于 HTTP 服务无状态的特点。





