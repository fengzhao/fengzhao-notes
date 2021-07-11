# wireguard简介



WireGuard 是由 Jason Donenfeld 等人用 C 语言编写的一个开源 VPN 协议，被视为下一代 VPN 协议。旨在解决许多困扰 IPSec/IKEv2、OpenVPN 或 L2TP 等其他 VPN 协议的问题。

它与 Tinc 和 MeshBird 等现代 VPN 产品有一些相似之处，即加密技术先进、配置简单。



> WireGuard is an open-source, free, modern, and fast VPN with state-of-the-art cryptography. 
>
> It is quicker and simpler as compared to IPSec and OpenVPN. Originally, released for the Linux kernel, 
>
> but it is getting cross-platform support for other operating systems too. 
>
> This page explains how to install and set up WireGuard VPN on Ubuntu 20.04 LTS Linux server.





2020年1月28日，Linux之父[Linus Torvalds](https://github.com/torvalds)正式将[WireGuard](https://www.wireguard.com/) merge[到Linux 5.6版本内核主线](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bd2463ac7d7ec51d432f23bf0e893fb371a908cd)。这意味着在Linux 5.6内核发布时，linux在内核层面将原生支持一个新的VPN协议栈：[WireGuard](https://git.zx2c4.com/wireguard)

VPN，全称Virtual Private Network（虚拟专用网络）。提起VPN，大陆的朋友想到的第一件事就是其他事情。

其实那件事情只是VPN的一个“小众”应用罢了^_^，企业网络才是VPN真正施展才能的地方。VPN支持在不安全的公网上建立一条加密的、安全的到企业内部网络的通道（隧道tunnel），这就好比专门架设了一个专用网络那样。

在WireGuard出现之前，VPN的隧道协议主要 有[PPTP](https://tools.ietf.org/html/rfc2637)、[L2TP](https://tools.ietf.org/html/rfc2661)和[IPSec](https://tools.ietf.org/html/rfc4301)等，其中 PPTP 和 L2TP 协议工作在 OSI 模型的第二层，又称为二层隧道协议；IPSec是第三层隧道协议。



利用 WireGuard 我们可以实现很多非常奇妙的功能，比如跨公有云组建 Kubernetes 集群，本地直接访问公有云 `Kubernetes` 集群中的 Pod IP 和 Service IP，在家中没有公网 IP 的情况下直连家中的设备等。







# 安装





```shell
#################### ubuntu
# Ubuntu ≥ 18.04
$ apt install wireguard
# Ubuntu ≤ 16.04
$ add-apt-repository ppa:wireguard/wireguard
$ apt-get update
$ apt-get install wireguard


#################### centos7
$ yum install epel-release https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
$ yum install yum-plugin-elrepo
$ yum install kmod-wireguard wireguard-tools
# 如果你使用的是非标准内核，需要安装 DKMS 包
$ yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
$ curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
$ yum install wireguard-dkms wireguard-tools


#################### 一键安装
 https://github.com/angristan/wireguard-install

#################### windows
https://download.wireguard.com/windows-client/wireguard-amd64-0.1.1.msi



```



