## OpenVpn 简介



`OpenVPN` 是一个用于创建虚拟专用网络加密通道的软件包，最早由`James Yonan`编写。OpenVPN允许创建的VPN使用公开密钥、电子证书、或者用户名／密码来进行身份验证。

它大量使用了OpenSSL加密库中的SSLv3/TLSv1协议函数库。

当前 `OpenVPN` 能在 `Solaris`、`Linux`、`OpenBSD`、`FreeBSD`、`NetBSD`、`Mac OS X`与`Microsoft Windows`以及`Android`和`iOS`上运行，并包含了许多安全性的功能。

它并不是一个基于 Web 的 VPN 软件，也不与 IPsec 及其他 VPN 软件包兼容。



## 功能与端口



- OpenVPN所有的通信都基于一个单一的IP端口，默认且推荐使用UDP协议通讯，同时也支持TCP。IANA（Internet Assigned Numbers Authority）指定给OpenVPN的官方端口为1194。
  - OpenVPN 2.0以后版本每个进程可以同时管理数个并发的隧道。
- OpenVPN使用通用网络协议（TCP与UDP）的特点使它成为IPsec等协议的理想替代，尤其是在ISP（Internet service provider）过滤某些特定VPN协议的情况下。
- OpenVPN连接能通过大多数的代理服务器，并且能够在NAT的环境中很好地工作。
- 服务端具有向客户端“推送”某些网络配置信息的功能，这些信息包括：IP地址、路由设置等。
- OpenVPN提供了两种虚拟网络接口：通用Tun/Tap驱动，通过它们，可以创建三层IP隧道，或者虚拟二层以太网，后者可以传送任何类型的二层以太网络数据



## 使用场景



在常见的企业上云等场景，通常会在公有云创建 vpc ，然后在 vpc 中创建 ecs 用于部署企业生产项目应用。

如果企业内网与公有云 vpc 之间的网络打通的需求。

这时就可以借助 vpn 技术，给 vpc 内的一台 ecs 绑定弹性公网 ip ，部署 vpn 软件，企业运维人员就可以拨 vpn 连入 vpc 进行日常运维。



## openvpn 部署



默认情况下，客户端连接 VPN 成功后会自动增加一些路由，并把网关设置成 vpn 的，所以所有的流量都会通过 VPN 来传送。

但是如果使用 openvpn，可以自己修改路由，指定某些 ip 走 vpn，或者某些 ip 不走 vpn，从而达到节省流量或者提高访问速度的目的。



我们使用社区提供的[万能脚本](https://github.com/Nyr/openvpn-install)来进行安装部署和配置：

```shell
wget https://git.io/vpn -O openvpn-install.sh && bash openvpn-install.sh


```





### openvpn配置路由

默认情况下，客户端连接 VPN 成功后会自动增加一些路由，并把网关设置成 vpn 的，所以所有的流量都会通过 VPN 来传送。

但是如果使用 openvpn，可以自己修改路由，指定某些 ip 走 vpn，或者某些 ip 不走 vpn，从而达到节省流量或者提高访问速度的目的。

openvpn有两种方法修改路由表：



#### 从客户端处修改

这种情况只要改本地配置文件即可，服务器不需要修改。适合客户端比较多且网络条件比较复杂，某些客户端有定制路由的需求，或者临时有修改的情况。

例如打开 openvpn 的配置文件 open.ovpn。在 "max-routes 1000" 后加入相应的路由策略：



```
route 172.16.100.0 0.0.0.0 net_gateway
route 10.252.252.0 255.255.255.0 net_gateway
route 103.103.103.0 255.255.255.0 net_gateway
```















# 使用 ocserv 搭建企业级 OpenConnect VPN 网关