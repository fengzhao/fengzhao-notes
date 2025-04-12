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





## SSL缓存



在 Nginx 中配置 SSL 会话缓存可以提高 SSL 握手性能和服务器负载能力，因为 SSL 握手需要进行密钥协商和证书验证等操作，会占用服务器的计算资源。

通过使用 SSL 会话缓存，可以在客户端和服务器之间缓存 SSL 会话状态信息，从而加快 SSL 握手速度和减轻服务器负载。