### Nginx 路径指令

在 nginx 中，root 和 alias 指令都是用于访问服务器本地文件的。



```nginx
[root]
语法：root path
默认值：root html
配置上下文段：http、server、location、if

[alias]
语法：alias path
配置上下文段：location
```



root是用于设置请求的根路径的。可以存在于 http 、server 、location、if 指令块中。



```nginx
# 当请求URL是 /i/top.gif 时，在服务器中的资源就是/data/w3/top.gif 
location /i/ {
    root /data/w3;
}

# 在 alias 中，请求 www.example.com/i/index.html 时，就会找 /data/w3/index.html 
location /blog {
    alias /root/deploy/static-file/blog/;
}
```





