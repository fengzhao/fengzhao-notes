# WAF概述





> 
>
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





## WAF核心工作原理

Web Application Firewall ，可以用来屏蔽常见的网站漏洞攻击，如SQL注入，XML注入、XSS等。

WAF一般针对的是应用层而非网络层的入侵，从技术角度应该称之为Web IPS。其防护重点是SQL注入。



Web防火墙产品部署在Web服务器的前面，串行接入，不仅在硬件性能上要求高，而且不能影响Web服务，所以HA功能、Bypass功能都是必须的，而且还要与[负载均衡](https://link.zhihu.com/?target=https%3A//www.imperva-incapsula.cn/%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1/)、Web Cache，CDN 等Web服务器前的常见的产品协调部署。

 

[Web应用防火墙](https://link.zhihu.com/?target=https%3A//www.imperva-incapsula.cn/%E7%BD%91%E7%AB%99%E5%AE%89%E5%85%A8/waf/)的主要技术的对入侵的检测能力，尤其是对Web服务入侵的检测，Web防火墙最大的挑战是识别率，这并不是一个容易测量的指标，因为漏网进去的入侵者，并非都大肆张扬，比如给网页挂马，你很难察觉进来的是那一个，不知道当然也无法统计。



对于已知的攻击方式，可以谈识别率；对未知的攻击方式，你也只好等他自己“跳”出来才知道。

现在市场上大多数的产品是基于规则的WAF。

其原理是每一个会话或HTTP事务，都要经过一系列的测试，每一项测试都由一个过多个检测规则组成，如果测试没通过，请求就会被认为非法并拒绝。

基于规则的WAF很容易构建并且能有效的防范已知安全问题。当我们要制定自定义防御策略时使用它会更加便捷。

但是因为它们必须要首先确认每一个威胁的特点，所以要由一个强大的规则数据库支持。WAF生产商维护这个数据库，并且他们要提供自动更新的工具。

这个方法不能有效保护自己开发的WEB应用或者零日漏洞（攻击者使用的没有公开的漏洞），这些威胁使用基于异常的WAF更加有效。

 

异常保护的基本观念是建立一个保护层，这个保护层能够根据检测合法应用数据建立统计模型，以此模型为依据判别实际通信数据是否是攻击。理论上，一但构建成功，这个基于异常的系统应该能够探测出任何的异常情况。拥有了它，我们不再需要规则数据库而且零日攻击也不再成问题了。但基于异常保护的系统很难构建，所以并不常见。因为用户不了解它的工作原理也不相信它，所以它也就不如基于规则的WAF应用广范。

 

Imperva公司的WAF产品在提供入侵防护的同时，还提供了另外一个安全防护技术，就是对Web应用网页的自动学习功能，由于不同的网站不可能一样，所以网站自身页面的特性没有办法提前定义，所以imperva采用设备自动预学习方式，从而总结出本网站的页面的特点。具体的做法是这样的：

 

通过一段时间的用户访问，WAF记录了常用网页的访问模式，如一个网页中有几个输入点，输入的是什么类型的内容，通常情况的长度是多少…学习完毕后，定义出一个网页的正常使用模式，当今后有用户突破了这个模式，如一般的帐号输入不应该有特殊字符，而XML注入时需要有“<”之类的语言标记，WAF就会根据你预先定义的方式预警或阻断;再如密码长度一般不超过20位，在SQL注入时加入代码会很长，同样突破了网页访问的模式。

 

网页自学习技术，从Web服务自身的业务特定角度入手，不符合我的常规就是异常的，也是入侵检测技术的一种，比起单纯的Web防火墙来，不仅给入侵者“下通缉令”，而且建立进入自家的内部“规矩”，这一种双向的控制，显然比单向的要好。

 



### ModSecurity

ModSecurity 是一个开源的、生产级的 WAF 工具包，历史很悠久，比 Nginx 还要大几岁。

它开始于一个私人项目，后来被商业公司 Breach Security 收购，现在则是由TrustWave 公司的 SpiderLabs 团队负责维护。

ModSecurity 最早是 Apache 的一个模块，只能运行在 Apache 上。因为其品质出众，大受欢迎，后来的 2.x 版添加了 Nginx 和 IIS 支持，但因为底层架构存在差异，不够稳定。

所以，这两年 SpiderLabs 团队就开发了全新的 3.0 版本，移除了对 Apache 架构的依赖，使用新的“连接器”来集成进 Apache 或者 Nginx，比 2.x 版更加稳定和快速，误报率也更低。

ModSecurity 有两个核心组件。

- 第一个是“规则引擎”，它实现了自定义的“SecRule”语言，有自己特定的语法。但“SecRule”主要基于正则表达式，还是不够灵活，所以后来也引入了 Lua，实现了脚本化配置。ModSecurity 的规则引擎使用 C++11 实现，可以从GitHub上下载源码，然后集成进Nginx。因为它比较庞大，编译很费时间，所以最好编译成动态模块，在配置文件里用指令“load_module”加载。

- 只有引擎还不够，要让引擎运转起来，还需要完善的防御规则，所以 ModSecurity 的第二个核心组件就是它的“规则集”。ModSecurity 源码提供一个基本的规则配置文件“modsecurity.conf-recommended”，使用前要把它的后缀改成“conf”。有了规则集，就可以在 Nginx 配置文件里加载，然后启动规则引擎。



"SecRule"定义了很多的规则，基本的形式是SecRule 变量 运算符 动作”。不过 ModSecurity 的这套语法"自成一体"，比较复杂，要完全掌握不是一朝一夕的事情





可以把 modsecurity 简单理解成一个 Apache/Nginx 的扩展，它可以解析所有流经 Apache/Nginx 的 http 流量，且它内置了自己的规则语法解析器，所以 WAF 规则研发人员可以写出符合其语法的规则文件，并导入modsecurity，从而对恶意 http 请求产生告警或者拦截。


将 Modsecurity3 部署在了Nginx上作为WAF本身，然后通过Nginx反向代理到漏洞环境的方式，让每个漏洞环境发起的恶意http请求流量得以先流经modsecurity，再抵达真正的漏洞环境。（要实现这个目的，有很多种WAF架构都可以做到：反向代理、透明代理、流模式等）







### CRS详解

除基本的规则集之外，ModSecurity 还额外提供一个更完善的规则集，为网站提供全面可靠的保护。CRS 也是完全开源、免费的，可以从 GitHub 上下载。

这个规则集的全名叫“OWASP ModSecurity 核心规则集”（Open WebApplication Security Project ModSecurity Core Rule Set）

因为名字太长了，所以有时候会简称为"核心规则集"或者**"[CRS](https://github.com/coreruleset/coreruleset.git)"**

```
git clone https://github.com/coreruleset/coreruleset.git 
```









异常打分机制，CRS由一系列一条条的规则组成，每个规则是用来检测特定攻击的。

主要将HTTP报文（请求报文/响应报文）来进行规则匹配，来进行打分，当满足一定分数后，即 deny 拦截。

**默认情况下，ModSecurity核心规则集使用评分机制。对于请求违反的每条规则，都会增加一个分数。当所有请求规则都通过时，将分数与限制进行比较。**

**如果达到限制，则请求被阻止。同样的事情发生在响应中，我们希望避免信息泄露给客户端。**

```
SecRule REQUEST_HEADERS:Content-Length "!@rx ^\d+$" \
    "id:920160,\
    phase:1,\
    block,\
    t:none,\
    msg:'Content-Length HTTP header is not numeric',\
    logdata:'%{MATCHED_VAR}',\
    tag:'application-multi',\
    tag:'language-multi',\
    tag:'platform-multi',\
    tag:'attack-protocol',\
    tag:'paranoia-level/1',\
    tag:'OWASP_CRS',\
    tag:'capec/1000/210/272',\
    ver:'OWASP_CRS/3.4.0-dev',\
    severity:'CRITICAL',\
    setvar:'tx.anomaly_score_pl1=+%{tx.critical_anomaly_score}'"
```

















# ModSecurity-nginx

[Libmodsecurity](https://github.com/SpiderLabs/ModSecurity) 是 ModSecurity v3 项目的一个组成部分。该库代码库作为 ModSecurity 连接器的接口，接收 Web 流量并应用传统的 ModSecurity 处理。

总体而言，它提供了加载/解释以 ModSecurity SecRules 格式编写的规则并将其应用于通过连接器提供的 HTTP 内容的能力。



ModSecurity在最初设计的时候，它只是Apache的一个扩展模块，随着时间的推移、用户量的增加，为了满足用户的需求，该项目增加了对Nginx以及IIS的支持，但由于其本身是Apache的一个模块，因此在编译以及运行时，都离不开Apache这个主体，意思就是，即便是在Nginx上使用ModSecurity，但仍需先安装Apache。以上为ModSecurity v2版本的实现机制。



为了满足日益增长的对额外平台支持的需求，因此ModSecurity团队决定删除其对Apache的依赖，使其更加独立于平台，ModSecurity v3版本由此诞生，同时取了一个新名字：Libmodsecurity。ModSecurity v3版本可以不依赖WEB服务进行独立安装，但是如果需要与WEB服务进行联动工作时，则需要安装对应的Connector（连接器），如Nginx需要安装ModSecurity-nginx connector，Apache需要安装ModSecurity-apache connector。



> 最新结论（20220114）：请勿在Nginx使用ModSecurity V2版本，V2版本与Nginx存在兼容问题，且目前官方团队明确表示不会进行修复。

在ModSecurity v3之前的版本中，Nginx的兼容性较差，这是因为在ModSecurity在设计之初是作为Apache HTTP服务的一个模块进行设计开发的，所以导致ModSecurity严重依赖于Apache HTTP Server。随着时间的推移，由于大众需求，该项目已经扩展到其他平台，包括Nginx 和 IIS等。为了满足对额外平台的支持不断增长的需求，需要删除该项目下的 Apache 依赖项，使其更加独立于平台。在ModSecurity v3版本中进行了重构，整个项目完全进行重写，去除了Apache HTTP的依赖，可以完美兼容Nginx。新的ModSecurity v3版本中，核心功能转移到了名为 Libmodsecurity 的独立组件中，通过连接器连接到 Nginx 和 Apache。接收 Web 流量并应用传统的 ModSecurity 处理。



这里展示如何编译安装最新版的 Libmodsecurity 系统使用 Debian 11 。

```shell
# centos
yum install gcc gcc-c++ make automake autoconf libtool pcre  pcre-devel zlib openssl openssl-devel  gd gd-devel GeoIP GeoIP-devel GeoIP-data  libmaxminddb-devel

# ubuntu
apt-get install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev libgeoip-dev   geoip-database geoipupdate  libmaxminddb-dev

# ubuntu
apt -y install libyajl-dev libpcre++-dev libxml2-dev libgeoip1 libmaxminddb-dev libfuzzy-dev liblua5.3-dev liblmdb-dev libpcre2-dev liblmdb-dev libcurl4-openssl-dev

# 下载ngx_http_geoip2_module模块
git clone https://github.com/leev/ngx_http_geoip2_module.git /usr/local/src/ngx_http_geoip2_module

# 下载ModSecurity源代码
git clone https://github.com/owasp-modsecurity/ModSecurity.git /usr/local/src/ModSecurity


# 下载ModSecurity v3 Nginx Connector。目前最新的版本是V3，较此前的V2有一定的区别，使用时请注意区分版本。
# ModSecurity项目只提供了libmodsecurity组件库，在Nginx中应用时，还需要ModSecurity v3 Nginx Connector，将libmodsecurity和Nginx连接起来。
git clone  https://github.com/SpiderLabs/ModSecurity-nginx.git  /usr/local/src/ModSecurity-nginx


# 下载crs规则集，最新的仓库改地址
# git clone  https://github.com/SpiderLabs/ModSecurity.git  /usr/local/src/ModSecurity
git clone https://github.com/coreruleset/coreruleset.git /usr/local/src/coreruleset


# cd 到ModSecurity源码目录下按顺序执行，更新git子模块，并编译安装
cd /usr/local/src/ModSecurity
./build.sh
git submodule init
git submodule update
./configure --with-lmdb --with-pcre2  --prefix=/usr/local/modsecurity
sudo make && make install



# 下载编译安装nginx 
mkdir -p /usr/local/nginx
useradd nginx -s /sbin/nologin -M

# 永远去官网找最新版来编译 http://nginx.org/download/nginx-1.19.8.tar.gz
wget -P /usr/local/src/  http://nginx.org/download/nginx-1.22.0.tar.gz  
cd /usr/local/src/ &&  tar -zxvf nginx-1.22.0.tar.gz
cd  nginx-1.22.0
mkdir -p ~/.vim/  && cp -r contrib/vim/* ~/.vim/



./configure  --user=nginx  --group=nginx  \
    --prefix=/usr/local/nginx/  \
    --with-http_stub_status_module \
    --with-http_ssl_module  \
    --with-http_image_filter_module=dynamic \
    --with-http_geoip_module=dynamic \
    --add-module=/usr/local/src/ngx_http_geoip2_module \
    --add-module=/usr/local/src/ModSecurity-nginx

# 或者动态模块
./configure --add-dynamic-module=/path/to/ModSecurity-nginx --with-compat



make  && make install 
```





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



# 防CC攻击

在大规模CC攻击中，单台傀儡机发包的速率往往远超过正常用户的请求频率。针对这种场景，直接对请求源设置限速规则是最有效的办法。



# IP黑名单





东北大学网络威胁黑名单系统

http://antivirus.neu.edu.cn/ssh/lists/neu.txt



Linux上黑名单可以直接添加到 `/etc/hosts.deny` 里面，这样就可以拦截了，可以写一个脚本，放在crontab里面执行一下

```bash
#!/bin/sh
# Fetch NEU SSH Black list to /etc/hosts.deny
#

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

URL=http://antivirus.neu.edu.cn/ssh/lists/neu_sshbl_hosts.deny.gz
HOSTSDENY=/etc/hosts.deny
TMP_DIR=/dev/shm
FILE=hosts.deny

[ -d $TMP_DIR ] || TMP_DIR=/tmp

cd $TMP_DIR

curl --connect-timeout 60 $URL 2> /dev/null | gzip -dc > $FILE 2> /dev/null

LINES=`grep "^sshd:" $FILE | wc -l`

if [ $LINES -gt 10 ]
then
    sed -i '/^####SSH BlackList START####/,/^####SSH BlackList END####/d' $HOSTSDENY
    echo "####SSH BlackList START####" >> $HOSTSDENY
    cat $FILE >> $HOSTSDENY
    echo "####SSH BlackList END####" >> $HOSTSDENY
fi


#==========开始复制==========
ldd `which sshd` | grep libwrap # 确认sshd是否支持TCP Wrapper，输出类似:libwrap.so.0 => /lib/libwrap.so.0 (0x00bd1000)
cd /usr/local/bin/
wget antivirus.neu.edu.cn/ssh/soft/fetch_neusshbl.sh
chmod +x fetch_neusshbl.sh
cd /etc/cron.hourly/
ln -s /usr/local/bin/fetch_neusshbl.sh .
./fetch_neusshbl.sh
#=========结束复制==========
```

