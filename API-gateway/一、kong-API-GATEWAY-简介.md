　　　

# 简介



Kong（https://github.com/Kong/kong）是一个云原生，高效，可扩展的分布式 API 网关。 

自 2015 年在 github 开源后，广泛受到关注，目前在 github 上已收获 28.7k+ 的 star，其核心价值在于高性能和可扩展性。







## 为什么使用API-Gateway



1. 方便客户端维护-- 每个请求方不用管理多个api url，统一访问api-gateway即可

2. 接口重构时调用方不须了解接口本身等拆分和聚合

3. 客户端无须关心接口协议

4. 统一权限控制、接口请求访问日志统计

5. 安全，是保护内部服务而设计的一道屏障
6. **开源**-最大好处



  当然也有一个很大的缺点，api-gw很可能成为性能瓶颈，因为所有的请求都经过这里，可以通过横向扩展和限流解决这个问题。



在众多API GATEWAY框架中，Mashape开源的高性能高可用API网关和API服务管理层——[KONG](https://link.jianshu.com/?t=https://getkong.org/)（基于NGINX）特点尤为突出，它可以通过插件扩展已有功能，这些插件（使用lua编写）在API请求响应循环的生命周期中被执行。

于此同时，KONG本身提供包括HTTP基本认证、密钥认证、CORS、TCP、UDP、文件日志、API请求限流、请求转发及NGINX监控等基本功能。

目前，Kong在Mashape管理了超过15,000个API，为200,000开发者提供了每月数十亿的请求支持。

Kong是一款基于Nginx_Lua模块写的高可用，由于Kong是基于Nginx的，所以可以水平扩展多个Kong服务器，通过前置的负载均衡配置把请求均匀地分发到各个Server，来应对大批量的网络请求。

