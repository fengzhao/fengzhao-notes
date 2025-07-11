

# JWT

JSON Web Token（JWT）是为了在网络应用环境间传递声明而执行的一种基于 JSON 的开放标准（RFC 7519）。来自 JWT RFC 7519 标准化的摘要说明：JSON Web Token 是一种紧凑的，URL 安全的方式，表示要在双方之间传输的声明。

JWT 一般被用来在身份提供者和服务提供者间传递被认证的用户身份信息，以便于从资源服务器获取资源，也可以增加一些额外的其它业务逻辑所必须的声明信息，该 Token 也可直接被用于认证，也可被加密。



Json Web Token（JWT），是为了在网络应用环境间传递声明而执行的一种基于JSON的开放标准[RFC7519](https://tools.ietf.org/html/rfc7519?spm=a2c4g.11186623.2.18.661d167c396yae)。

JWT一般可以用作独立的身份验证令牌，可以包含用户标识、用户角色和权限等信息，以便于从资源服务器获取资源，也可以增加一些额外的其他业务逻辑所必须的声明信息，特别适用于分布式站点的登录场景。



**JWT（Json Web Token）是一种服务端向客户端发放令牌的认证方式。**

客户端用户名密码登录时，服务端会生成一个令牌返回给客户端；客户端随后在向服务端请求时只需携带这个令牌，服务端通过校验令牌来验证是否是来自合法的客户端，进而决定是否向客户端返回应答。

从机制可以看到，这种基于请求中携带令牌来维护认证的客户端连接的方式解决了早期服务端存储会话的各种有状态问题。



JWT（JSON Web Tokens）是一种用于安全的传递信息而采用的一种标准。在 Web 系统中，使用加密的Json来生成Token在服务端与客户端无状态传输，代替了之前常用的Session。



1、在用户登录时，当服务器端验证了用户名和密码的正确性后，会根据用户的信息，如用户 ID 和用户名称，加上服务器端存储的 JWT 秘钥一起来生成一个 JWT 字符串，也就是我们所说的 Token，这个 Token 是 Encoded 编码过的。

​	在服务器端生成一个 JSON 格式的令牌以表示用户的身份和其他相关数据。令牌包含了用户的身份信息和其他声明（声明可以包含用户角色、权限等）。

2、服务器将令牌签名后发送给客户端。

​	





JWT 是以 Header、Payload、Signature 以 Base64 做做编码，并且以`.` 来做分开（例如： `xxxxxx.yyyyyy.zzzzz` ）。

JWT 本质上就是一组字串，通过（`.`）切分成三个为 Base64 编码的部分：

 

如上面的例子所示，JWT 就是一个字符串，由三部分构成：

- Header（头部）描述 JWT 的元数据，定义了生成签名的算法以及 `Token` 的类型。Header 被 Base64Url 编码后成为 JWT 的第一部分。
- Payload（数据）用来存放实际需要传递的数据，包含声明（Claims），如`sub`（subject，主题）、`jti`（JWT ID）。Payload 被 Base64Url 编码后成为 JWT 的第二部分。
- Signature（签名）服务器通过 Payload、Header 和一个密钥(Secret)使用 Header 里面指定的签名算法（默认是 HMAC SHA256）生成。生成的签名会成为 JWT 的第三部分。





###### Header





JWT 是无状态的，服务器不需要在存储中查找和读取用户的会话数据。**服务器可以直接验证和解析 JWT，这有助于提高性能**，尤其是在分布式系统中。



https://blog.csdn.net/m0_73556978/article/details/136701750



# Token和JWT区别