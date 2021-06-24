> Web应用防护系统（也称为：网站应用级入侵防御系统。英文：Web Application Firewall，简称： WAF）。
>
> 利用国际上公认的一种说法：Web应用防火墙是通过执行一系列针对HTTP/HTTPS的安全策略来专门为Web应用提供保护的一款产品。
>
> Web应用防火墙（Web Application Firewall，简称  WAF）为您的网站或App业务提供一站式安全防护。
>
> WAF可以有效识别Web业务流量的恶意特征，在对流量进行清洗和过滤后，将正常、安全的流量返回给服务器。
>
> 避免网站服务器被恶意入侵导致服务器性能异常等问题，保障网站的业务安全和数据安全。



**WAF 主要功能**

- 提供Web应用攻击防护。
- 缓解恶意CC攻击，过滤恶意的Bot流量，保障服务器性能正常。
- 提供业务风控方案，解决业务接口被恶意滥刷等业务安全风险。
- 提供网站一键HTTPS和HTTP回源，降低源站负载压力。
- 支持对HTTP和HTTPS流量进行精准的访问控制。
- 支持超长时长的全量日志实时存储、分析和自定义报表服务，支持日志线上同步第三方平台，助力满足等保合规要求。

[阿里云WAF](https://help.aliyun.com/document_detail/149485.html?spm=a2c4g.11186623.6.577.4dc842eauvprOo)

常见Web应用攻击防护

- 防御OWASP常见威胁：支持防御以下常见威胁：
  - SQL注入
  - XSS跨站
  - Webshell上传
  - 后门隔离保护
  - 命令注入
  - 非法HTTP协议请求
  - 常见Web服务器漏洞攻击
  - 核心文件非授权访问
  - 路径穿越
  - 扫描防护等。
- 网站隐身：不对攻击者暴露站点地址、避免其绕过Web应用防火墙直接攻击。
- 0day补丁定期及时更新：防护规则与淘宝同步，及时更新最新漏洞补丁，第一时间全球同步下发最新补丁，对网站进行安全防护。
- 友好的观察模式：针对网站新上线的业务开启观察模式，对于匹配中防护规则的疑似攻击只告警不阻断，方便统计业务误报状况。





















# openresty安装





# WAF部署



```shell
git clone https://github.com/unixhot/waf.git

cp -r ./waf/waf /usr/local/openresty/nginx/conf/

vim /usr/local/openresty/nginx/conf/nginx.conf
#在http{}中增加，注意路径，同时WAF日志默认存放在/tmp/日期_waf.log
#WAF
lua_shared_dict limit 50m;
lua_package_path "/usr/local/openresty/nginx/conf/waf/?.lua";
init_by_lua_file "/usr/local/openresty/nginx/conf/waf/init.lua";
access_by_lua_file "/usr/local/openresty/nginx/conf/waf/access.lua";


```

