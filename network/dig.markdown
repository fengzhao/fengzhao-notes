# DNS 查询工具 -- dig|host|nslookup

### nslookup



nslookup 是 Windows 下的 DNS 查询工具，文档 <https://docs.microsoft.com/zh-cn/windows-server/administration/windows-commands/nslookup>



### host 





### dig





- @<DNS服务器地址> : 指定进行域名解析的域名服务器
- -4 : 使用IPv4
- -6 : 使用IPv6
- -b : 当本机具有多个IP地址，指定使用本机的哪个IP地址向域名服务器发送域名查询请求
- -t <类型> : 指定要查询的DNS数据类型
- -x : 执行逆向域名查询,可以查询IP地址到域名的映射关系
- +nssearch : 查找域名的权威域名服务器
- +short : 提供简要应答
- +trace : 显示DNS的整个查询过程
- +tcp : 使用tcp查询dns,默认是udp



