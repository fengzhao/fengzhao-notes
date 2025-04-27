# 背景



获取客户IP是常见的需求，对于大流量的项目都会使用反向代理、负载均衡等，甚至多重代理，导致架构和网络都比较复杂，在这种情况下获取IP就不那么容易了。七层代理可以通过添加头信息来实现，如http协议的X-Forword-For，还比较方便；

四层代理基本无法简单的获取到客户端IP地址，像LVS的FULLNAT模式，前端LVS把真实IP写在TCP option里面，后端服务器用内核toa模块获取客户IP；haproxy配合TPROXY也是类似的方式实现，两者都需编译内核非常麻烦，这种情况下就可以考虑使用代理协议



代理协议即 [PROXY protocol](http://www.haproxy.org/download/1.8/doc/proxy-protocol.txt),是haproxy的作者Willy Tarreau于2010年开发和设计的一个Internet协议，通过为tcp添加一个很小的头信息，来方便的传递客户端信息（协议栈、源IP、目的IP、源端口、目的端口等)，在网络情况复杂又需要获取客户IP时非常有用。如：

- 多层NAT网络
- TCP代理（四层）或多层tcp代理
- https反向代理http(某些情况下由于Keep-alive导致不是每次请求都传递x-forword-for)

代理协议分为v1和v2两个版本，v1人类易读，v2是二进制格式，方便程序处理。Proxy protocol是比较新的协议，但目前已经有很多软件支持，如haproxy、nginx、apache、squid、mysql等等，要使用proxy protocol需要两个角色sender和receiver,sender在与receiver之间建立连接后，会先发送一个带有客户信息的tcp header,因为更改了tcp协议，需receiver也支持proxy protocol，否则不能识别tcp包头，导致无法成功建立连接。