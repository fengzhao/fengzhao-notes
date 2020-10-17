

# Nginx启用HTTP2







The `ngx_http_v2_module` 模块(1.9.5) 提供了 [HTTP/2](https://tools.ietf.org/html/rfc7540) 的支持，并且取代了 [ngx_http_spdy_module](http://nginx.org/en/docs/http/ngx_http_spdy_module.html) 模块。

这个模块不会被默认编译，编译的时候带上 --with-http_v2_module 配置参数。











### 已存在的问题（Known Issues）



在 1.19.1 版本之前，

