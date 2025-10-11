# DHCP协议



在常见的小型网络中（例如家庭网络和学生宿舍网），网络管理员都是采用手工分配IP地址的方法，而到了中、大型网络，这种方法就不太适用了。

在中、大型网络，特别是大型网络中，往往有超过100台的客户机，手动分配IP地址的方法就不太合适了。

因此，我们必须引入一种高效的IP地址分配方法，幸好，DHCP（Dynamic Host Configuration Protocol）为我们解决了这一难题。





DHCP是一种应用层协议，建立在 UDP 协议之上。

动态主机配置协议DHCP（Dynamic Host Configuration Protocol）是一种用于集中对用户IP地址进行动态管理和配置的协议。

通常被应用在大型的局域网络环境中。

DHCP采用**==客户端/服务器==**通信模式，由客户端向服务器提出配置申请，服务器返回为客户端分配的IP地址等相应的配置信息，以实现IP地址等信息的动态配置。

当DHCP服务器接收到来自网络主机申请地址的信息时，才会向网络主机发送相关的地址配置等信息，以实现网络主机地址信息的动态配置。



它的主要作用是集中的管理、分配IP地址，使网络环境中的主机动态的获得IP地址、Gateway地址、DNS服务器地址等信息，并能够提升地址的使用率。



## **目的**

连接到Internet的每台计算机需要在发送或接收数据报文前知道其IP地址。另外，计算机还需要其他信息，如路由器的地址、使用的子网掩码和DNS名字服务器的地址等。

BOOTP协议（BOOTSTRAP PROTOCOL）是一种较早出现的远程启动的协议，主要用于无磁盘的客户机从服务器得到自己的IP地址、服务器的IP地址、启动映象文件名、网关IP等等。

BOOTP设计用于相对静态的环境，其中每台主机都有一个永久的网络连接。



随着网络规模的扩大和网络复杂度的提高，网络配置变的越来越复杂，在计算机经常移动（如便携机或无线网络）和计算机的数量超过可分配的IP地址等情况下，原有针对静态主机配置的BOOTP协议已经越来越不能满足实际需求。

为方便用户快速地接入和退出网络、提高IP地址资源的利用率以及支持无盘网络工作站等应用，需要在BOOTP基础上制定一种自动机制来进行IP地址的分配。





## DHCP 的组件

使用 DHCP 时，了解所有的组件很重要，下面我为你列出了一些 DHCP 的组件和它们的作用都是什么

- `DHCP Server`：**DHCP 服务器**，负责处理来自客户端或中继的地址分配、地址续租、地址释放等请求，为客户端分配IP地址和其他网络配置信息。

- `DHCP Client`：**DHCP 客户端**，通过与DHCP服务器进行报文交互，获取IP地址和其他网络配置信息，完成自身的地址配置。

  - 在设备接口上配置DHCP Client功能，这样接口可以作为DHCP Client，使用DHCP协议从DHCP Server动态获得IP地址等参数，方便用户配置，也便于集中管理。
  - DHCP 的客户端可以是==**计算机、移动设备或者其他需要连接到网络的任何设备，默认情况下，大多数配置为接收 DHCP 信息**。==

- `DHCP Relay`：**DHCP中继**，负责转发来自客户端方向或服务器方向的DHCP报文，协助DHCP客户端和DHCP服务器完成地址配置功能。

  - 如果DHCP服务器和DHCP客户端不在同一个网段范围内，则需要通过DHCP中继来转发报文，这样可以避免在每个网段范围内都部署DHCP服务器，既节省了成本，又便于进行集中管理。
  - DHCP 中继器通常应对 DHCP 服务器和 DHCP 客户端不再同一个网段的情况，如果 DHCP 服务器和 DHCP 客户端在同一个网段下，那么客户端可以正确的获得动态分配的 IP 地址；如果不在的话，就需要使用 DHCP 中继器进行中继代理。

- `Ip address pool`: 你得有 IP 地址池啊，虽然说你 DHCP 提供服务，但是你也得有工具啊，没有工具玩儿啥？IP 地址池是 DHCP 客户端可用的地址范围，这个地址范围通常由最低 -> 最高顺序发送。

- `Subnet`：这个组件是子网，IP 网络可以划分一段一段的子网，子网更有助于网络管理。

- `Lease`：租期，这个表示的就是 IP 地址续约的期限，同时也代表了客户端保留 IP 地址信息的时间长度，一般租约到期时，客户端必须续约。

- `DHCP relay`：DHCP 中继器，这个一般比较难想到，DHCP 中继器一般是路由器或者主机。

  

**DHCP服务器**

DHCP 服务器会维护 IP 地址池，在网络上启动时会将地址租借给启用 DHCP 的客户端。

由于 IP 地址是**动态的(临时分配)**而不是**静态的(永久分配)**，因此不再使用的 IP 地址会自动返回 IP 地址池中进行重新分配。

> 那么 DHCP 服务器由谁维护呢？

网络管理员负责建立 DHCP 服务器，并以**==租约==**的形式向启用 DHCP 的客户端提供地址配置，啊，既然不需要我管理，那就很舒服了～

好了，现在你能舒舒服服的开发了，你用 postman 配了一条 192.168.1.4/x/x 的接口进行请求，请求能够顺利进行，但是过了一段时间后，你发现 192.168.1.4/x/x 这个接口请求不通了，这是为啥呢？

然后你用 `ipconfig` 查询了一下自己的 IP 地址，发现 IP 地址变成了 192.168.1.7，怎么我用着用着 IP 地址还改了？DHCP 是个垃圾，破玩意！！@#¥%¥%……¥%

其实，这也是一个 DHCP 服务器的一个功能，DHCP 服务器通常为每个客户端分配一个**唯一的动态 IP 地址**，当该 IP 地址的**客户端租约到期**时，该地址就会更改。



唯一意思说的就是，如果你手动设置了一个静态 IP，同时 DHCP 服务器分配了一个动态 IP，这个动态 IP 和静态 IP 一样，那么必然会有一个客户端无法上网。

> 我就遇到过这种情况，我使用虚拟机配置的静态 IP 是192.168.1.8，手机使用 DHCP 也同样配置了 192.168.1.8 的 IP 地址，此时我的虚拟机还没有接入网络，当我接入网络时，我怎样也连不上虚拟机了，一查才发现 IP 地址冲突了 ......

虽然 DHCP 服务器能提供 IP 地址，但是他怎么知道哪些 IP 地址空闲，哪些 IP 地址正在使用呢？



实际上，这些信息都配置在了`数据库`中，下面我们就来一起看一下 DHCP 服务器维护了哪些信息。

- 网络上所有有效的 TCP/IP 配置参数

这些参数主要包括**主机名（Host name）、DHCP 客户端（DHCP client）、域名（Domain name）、IP 地址IP address）、网关（Netmask）、广播地址（Broadcast address）、默认路由（default rooter）**。

- 有效的 IP 地址和排除的 IP 地址，保存在 IP 地址池中等待分配给客户端
- 为某些特定的 DHCP 客户端保留的地址，这些地址是静态 IP，这样可以将单个 IP 地址一致地分配给单个DHCP 客户端

好了，现在你知道 DHCP 服务器都需要保存哪些信息了，并且看过上面的内容，你应该知道一个 DHCP 的组件有哪些了，下面我们就来聊一聊 DHCP 中都有哪些组件，这些组件缺一不可。





## DHCP 报文



DHCP 报文共有一下几种类型：

- **DHCP DISCOVER** ：客户端开始 DHCP 过程发送的包，是 DHCP 协议的开始。

  - **==DHCP客户端首次登录网络时进行DHCP交互过程发送的第一个消息，用来寻找DHCP服务器。==**

- **DHCP OFFER** ：服务器接收到 `DHCPDISCOVER` 之后做出的响应，它包括了给予客户端的 IP 租约过期时间、服务器的识别符以及其他信息。

  - DHCP 响应报文（DHCPOFFER）本质上是一个**应用层协议**，使用 **UDP** 在传输层传输，并依赖 **IP** 和 **MAC** 地址进行寻址。
    - 应用层：**DHCPOFFER 报文**，包含 IP **租约过期时间**、**拟分配的 IP 地址**、**服务器标识符**（服务器 IP）、子网掩码、网关等配置信息。
    - 传输层：使用 **UDP 封装**。与 Discover 报文相反，服务器从 67 端口发出，发送给客户端的 68 端口。
    - 网络层：**源 IP：DHCP 服务器的 IP 地址** (例如 192.168.1.1)；**目的 IP：255.255.255.255** (**广播地址**)。此时客户端尚未配置 IP，因此服务器通常使用 **广播** 发送 Offer 报文，确保所有客户端都能收到，但客户端会根据报文内的事务 ID (Transaction ID) 识别是否是发给自己的。*（少数情况下服务器可能直接发送给客户端的 MAC 地址，但广播是最常见方式。）*
    - 

- **DHCP REQUEST** ：客户端对于服务器发出的 `DHCPOFFER` 所做出的响应。在续约租期的时候同样会使用。在如下场景都会发送这种包：

  - **==客户端初始化后==**，发送广播的`DHCP REQUEST`消息来回应服务器的`DHCP OFFER`消息。
  - 客户端重启初始化后，发送广播的`DHCP REQUEST`消息来确认先前被分配的IP地址等配置信息。
  - 客户端已经和某个IP地绑定后，发送`DHCP REQUEST`消息来更新IP地址的租约。
  - 

- **DHCP ACK** ：服务器在接收到客户端发来的 `DHCPREQUEST` 之后发出的成功确认的报文。**==客户端在接收到这个报文之后才会确认分配给它的 IP 和其他信息可以被允许使用。==**

- **DHCP NAK** ：DHCP ACK 的相反的报文，表示服务器拒绝了客户端的请求。告知DHCP客户端无法分配合适IP地址。

- **DHCP DECLINE** :当客户端发现服务器分配的 IP 地址无法使用（如 IP 地址冲突时）。将发出此报文通知服务器，并且会重新向服务器申请地址。

- **DHCP RELEASE** ：一般出现在客户端关机、下线等状况。这个报文将会使 DHCP 服务器释放发出此报文的客户端的 IP 地址

- **DHCP INFORM** ：DHCP客户端获取IP地址后，如果需要向DHCP服务器获取更为详细的配置信息（网关地址、DNS服务器地址），则向DHCP服务器发送DHCP-INFORM请求消息。

  

  
  
  
  
  

# DHCP工作机制

DHCP 的工作机制比较简单：

DHCP客户端向DHCP服务器动态地请求网络配置信息，DHCP服务器根据策略返回相应的配置信息（IP地址、子网掩码、缺省网关等网络参数）。

客户端和服务器之间交互的消息格式由固定格式的首部和可变的选项格式区域组成。



**（一）发现阶段**

当主机刚刚开机运行，此时它不知道此时网络中是否存在DHCP服务器，DHCP服务器是谁，因此它必须首先确定网络中的DHCP服务器身份。

因此，**==新上线主机会发送一个 DHCP Discover 报文， 该报文是一个广播报文，源IP地址为0.0.0.0，目的IP地址为255.255.255.255。==**

源MAC地址为自己的MAC地址，目的MAC地址为 `FFFF-FFFF-FFFF`

该报文会在二层网络中洪泛，因此如果网络中存在DHCP服务器，则DHCP服务器会收到该报文。

数据封装过程大致如下：

- 应用层：`DHCP Discover` 报文。**==客户端向网络发出请求，要求获取 IP 地址及配置信息。==**
- 传输层：使用 **UDP 封装**。客户端源端口是 **68**，目的端口是 **67**（DHCP 服务器端口）
- 网络层：IP头部，客户端不知道自己的 IP，所以 **源 IP** 是 **0.0.0.0**。客户端不知道服务器 IP，所以 **目的 IP** 是 **255.255.255.255**（**三层广播地址**）
- 数据链路层：客户端不知道 DHCP 服务器的 MAC 地址，所以 **目的 MAC 地址** 是 **FFFF.FFFF.FFFF**（**二层广播地址**）



**（二）提供阶段**

当网络中的DHCP服务器收到了`DHCP Client`发送的DHCP报文后，DHCP就进入了提供阶段。

在这个阶段，`DHCP Server`会根据管理员的相关配置，给`DHCP Client`提供一个可用的IP地址，同时给其提供DNS、子网掩码等信息。

==**响应一个 DHCP Offer 报文，`DHCP Server`会发送`DHCP Offer`信息给`DHCP Client`提供上述信息，该报文也是一个广播报文**。==

> 很多 DHCP 服务器（尤其是企业级和遵循严格标准的服务器）在发送 `DHCPOFFER` 之前，会采取措施进行 IP 地址冲突检测，其中最常见的方法之一就是发送 **ARP 广播**。

数据封装大致过程如下：

- 应用层：`DHCP OFFER` 报文。**==有字段标识这是Offer类型==**

- 传输层：使用 **UDP 封装**。数据从服务端发出，源端口是 **67**（DHCP服务器），目的端口是 **68**（客户端电脑）
- 网络层：源为DHCP服务器IP，目的IP地址为DHCP Server给该DHCP Client分配的IP地址。
- 数据链路层：源MAC地址为DHCP Server的MAC地址，目的MAC地址为DHCP Client的MAC地址。

（注，在这里有的设备上DHCP Offer报文也是广播，其实也能够实现DHCP的功能）



**（三）请求阶段**

在`DHCP Client`收到DHCP Server发送的DHCP Offer报文后，就进入了DHCP请求阶段。

在DHCP请求阶段，DHCP Client已经得到了DHCP Server分配给它的IP地址，DHCP Client在得到该IP地址后，却不会马上使用。

**==DHCP Client会向DHCP Server发送DHCP Request报文，来正式向DHCP Server申请使用该IP地址。==**



数据封装大致过程如下：

- 应用层：`DHCP OFFER` 报文。**==有字段标识这是Request类型==**
- 传输层：使用 **UDP 封装**。数据又从服务端发出，源端口是 **68**（客户端电脑），目的端口是 **67**（DHCP服务器）

- 网络层：

  - 源IP地址为0.0.0.0（因为这时还没有得到DHCP服务器的回应，因此此时这个IP地址还不能正常使用，因此在这里源IP地址还是0.0.0.0）。

  - 目的地址为255.255.255.255。（注：在这里其实DHCP Client其实已经知道了DHCP Server的IP地址，因此其实这里使用DHCP Server的IP地址其实也是可以的.

因此，有些设备对此做了优化，因为这样可以减少网络中的广播洪范流量）

- 源MAC和目的MAC地址分别是DHCP Client的和DHCP Server的MAC地址。



**（四）确认阶段**

当DHCP Server收到DHCP Client发送的DHCP Request报文后，DHCP进入确认阶段。DHCP Server会向DHCP Client发送DHCP Reply报文，表示同意DHCP Client使用该IP地址。

DHCP Reply 报文（有时也被称为DHCP ACK报文），源IP地址为DHCP Server的IP地址，目的IP地址为DHCP Client的IP地址，源目MAC为DHCP Server和Client的MAC地址。



### 重启PC后的DHCP过程及DHCP续约机制



目前，PC机对于DHCP有记忆功能，会记住当前网络中DHCP服务器的IP地址和上次分配给自己的IP地址。

因此，当PC重启后，通常不会按照上述的4个步骤按部就班的申请IP地址，而是通常会直接进入第三个阶段，直接向DHCP Server发送DHCP Request报文，请求自己上一次获得的IP地址。

如果DHCP Server同意，则会回应DHCP Reply报文，如果该IP地址已经被占用，或者其他情况造成DHCP Server不把该IP地址分配给DHCP Client，则DCHP Server会回应DHCP NACK报文，表示拒绝。这时，PC就必须重新进行DHCP四个阶段。





**==DHCP存在租约和续约机制==**，在默认情况下，当PC机申请到一个DHCP地址后，使用时间为一天，管理员也可以手动修改该时间，最短为1小时。

当PC申请的DHCP IP地址到达租约时间后，该IP地址就不可以继续使用，因此PC会在租约到期之前进行续约。



通常情况下，DHCP Client会进行两次续约，

第一次是在租约期的50%时候，DHCP Client会向DHCP Server发送DHCP Request报文，如果收到DHCP Server的回应，则续约成功。

第二次续约是在租约期的87.5%的时候，DHCP Client会再次向DHCP Server发送DHCP Request 报文，申请租约。



如果此时仍为收到DHCP响应的DCHP ACK报文，则就必须要重新进行DHCP的四个阶段，重新申请IP地址。





针对DHCP客户端的不同需求，不同的DHCP客户端使用的IP地址性质不同，有的DHCP客户端需要长期使用，有的DHCP客户端只是暂时借用。

DHCP服务器可以配置当前地址池中IP地址的**租用有效期限**，期满后DHCP服务器会收回该IP地址可继续分配给其它DHCP客户端使用。



如果用户希望针对某个DHCP客户端灵活配置地址租期，可以在DHCP客户端上配置期望地址租期：

当DHCP服务器分配地址租期时，会把DHCP客户端的期望地址租期和当前地址池中的地址租期比较，根据DHCP服务器自身分配规则提供合适的地址租期给DHCP客户端。



1. IP地址租约期限达到50%（T1）时，DHCP客户端会以单播的方式，向DHCP服务器发送DHCP REQUEST报文，请求更新IP地址租约。
   - 如果收到DHCP ACK报文，则租约更新成功；
   - 如果收到DHCP NAK报文，则重新发起申请过程。
2. IP地址租约期限达到87.5%（T2）时，如果仍未收到DHCP服务器的应答，DHCP客户端会向DHCP服务器发送更新其IP地址租约的广播报文。
   - 如果收到DHCP ACK报文，则租约更新成功；
   - 如果收到DHCP NAK报文，则重新发起申请过程。
3. 如果IP地址租约到期前都没有收到DHCP服务器的应答，DHCP客户端会停止使用此IP地址，重新发送DHCP DISCOVER报文请求新的IP地址。





## DHCP Snooping



目前[DHCP](https://info.support.huawei.com/info-finder/encyclopedia/zh/DHCP.html)协议（RFC2131）在应用的过程中遇到很多安全方面的问题，网络中存在一些针对DHCP的攻击，如DHCP Server仿冒者攻击、DHCP Server的拒绝服务攻击、仿冒DHCP报文攻击等。为了保证网络通信业务的安全性，引入DHCP Snooping技术。在DHCP Client和DHCP Server之间建立一道防火墙，以抵御网络中针对DHCP的各种攻击。





由于[DHCP](https://info.support.huawei.com/info-finder/encyclopedia/zh/DHCP.html) Server和DHCP Client之间没有认证机制，所以如果在网络上随意添加一台DHCP服务器，它就可以为客户端分配IP地址以及其他网络参数。

如果该DHCP服务器为用户分配错误的IP地址和其他网络参数，将会对网络造成非常大的危害。

https://info.support.huawei.com/info-finder/encyclopedia/zh/DHCP+Snooping.html









# DHCP 服务

一个由 [Internet Systems Consortium](https://www.isc.org/)(ISC)开发的开源DHCPv4/DHCPv6服务器。Kea是一个高性能的，可扩展的DHCP服务器引擎。通过[hooks library](https://kea.readthedocs.io/en/latest/arm/hooks.html)可以很容易的修改和扩展。

```bash
# install the build environment
sudo apt -y install automake libtool pkg-config build-essential ccache meson ninja-build libboost-all-dev liblog4cplus-dev
	
# install the dependencies
sudo apt -y install libboost-dev libboost-system-dev liblog4cplus-dev libssl-dev


# download package
wget https://downloads.isc.org/isc/kea/3.0.0/kea-3.0.0.tar.xz

```





