# DHCP协议





DHCP是一种应用层协议，建立在 UDP 协议之上。





DHCP（Dynamic Host Configuration Protocol，动态主机配置协议）通常被应用在大型的局域网络环境中。

主要作用是集中的管理、分配IP地址，使网络环境中的主机动态的获得IP地址、Gateway地址、DNS服务器地址等信息，并能够提升地址的使用率。



DHCP协议采用客户端/服务器模型，主机地址的动态分配任务由网络主机驱动。

当DHCP服务器接收到来自网络主机申请地址的信息时，才会向网络主机发送相关的地址配置等信息，以实现网络主机地址信息的动态配置。





## DHCP 的组件

使用 DHCP 时，了解所有的组件很重要，下面我为你列出了一些 DHCP 的组件和它们的作用都是什么。

- `DHCP Server`：DHCP 服务器，负责处理来自客户端或中继的地址分配、地址续租、地址释放等请求，为客户端分配IP地址和其他网络配置信息。

- `DHCP Client`：DHCP 客户端，通过与DHCP服务器进行报文交互，获取IP地址和其他网络配置信息，完成自身的地址配置。DHCP 的客户端可以是**计算机、移动设备或者其他需要连接到网络的任何设备，默认情况下，大多数配置为接收 DHCP 信息**。

- `DHCP Relay`：DHCP中继，负责转发来自客户端方向或服务器方向的DHCP报文，协助DHCP客户端和DHCP服务器完成地址配置功能。如果DHCP服务器和DHCP客户端不在同一个网段范围内，则需要通过DHCP中继来转发报文，这样可以避免在每个网段范围内都部署DHCP服务器，既节省了成本，又便于进行集中管理。

- `Ip address pool`: 你得有 IP 地址池啊，虽然说你 DHCP 提供服务，但是你也得有工具啊，没有工具玩儿啥？IP 地址池是 DHCP 客户端可用的地址范围，这个地址范围通常由最低 -> 最高顺序发送。

- `Subnet`：这个组件是子网，IP 网络可以划分一段一段的子网，子网更有助于网络管理。

- `Lease`：租期，这个表示的就是 IP 地址续约的期限，同时也代表了客户端保留 IP 地址信息的时间长度，一般租约到期时，客户端必须续约。

- `DHCP relay`：DHCP 中继器，这个一般比较难想到，DHCP 中继器一般是路由器或者主机。

  DHCP 中继器通常应对 DHCP 服务器和 DHCP 客户端不再同一个网断的情况，如果 DHCP 服务器和 DHCP 客户端在同一个网段下，那么客户端可以正确的获得动态分配的 IP 地址；如果不在的话，就需要使用 DHCP 中继器进行中继代理。



**DHCP服务器**



DHCP 服务器会维护 IP 地址池，在网络上启动时会将地址租借给启用 DHCP 的客户端。

由于 IP 地址是**动态的(临时分配)**而不是**静态的(永久分配)**，因此不再使用的 IP 地址会自动返回 IP 地址池中进行重新分配。

> 那么 DHCP 服务器由谁维护呢？

网络管理员负责建立 DHCP 服务器，并以租约的形式向启用 DHCP 的客户端提供地址配置，啊，既然不需要我管理，那就很舒服了～

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

- **DHCP OFFER** ：服务器接收到 `DHCPDISCOVER` 之后做出的响应，它包括了给予客户端的 IP 租约过期时间、服务器的识别符以及其他信息

- **DHCP REQUEST** ：客户端对于服务器发出的 `DHCPOFFER` 所做出的响应。在续约租期的时候同样会使用。

  - 客户端初始化后，发送广播的`DHCP REQUEST`消息来回应服务器的`DHCP OFFER`消息。
  - 客户端重启初始化后，发送广播的`DHCP REQUEST`消息来确认先前被分配的IP地址等配置信息。
  - 客户端已经和某个IP地绑定后，发送`DHCP REQUEST`消息来更新IP地址的租约.

- **DHCP ACK** ：服务器在接收到客户端发来的 `DHCPREQUEST` 之后发出的成功确认的报文。在建立连接的时候，客户端在接收到这个报文之后才会确认分配给它的 IP 和其他信息可以被允许使用。

- **DHCP NAK** ：DHCPACK 的相反的报文，表示服务器拒绝了客户端的请求。告知DHCP客户端无法分配合适IP地址。

- **DHCP DECLINE** :当客户端发现服务器分配的 IP 地址无法使用（如 IP 地址冲突时），将发出此报文，通知服务器禁止使用该 IP 地址。

- **DHCP RELEASE** ：一般出现在客户端关机、下线等状况。这个报文将会使 DHCP 服务器释放发出此报文的客户端的 IP 地址

- **DHCP INFORM** ：DHCP客户端获取IP地址后，如果需要向DHCP服务器获取更为详细的配置信息（网关地址、DNS服务器地址），则向DHCP服务器发送DHCP-INFORM请求消息。

  

  

  

  

DHCP 的工作机制比较简单，DHCP客户端向DHCP服务器动态地请求网络配置信息，DHCP服务器根据策略返回相应的配置信息（IP地址、子网掩码、缺省网关等网络参数）。

客户端和服务器之间交互的消息格式由固定格式的首部和可变的选项格式区域组成。

（一）发现阶段

当主机刚刚开机运行，此时他不知道此时网络中是否存在DHCP服务器，DHCP服务器是谁，因此它必须首先确定网络中的DHCP服务器身份。

因此，新上线主机会发送DHCP Discover报文， 该报文是一个**广播**报文，源IP地址为0.0.0.0，目的IP地址为255.255.255.255。源MAC地址为自己的MAC地址，目的MAC地址为ffff-ffff-ffff。

该报文会在二层网络中洪泛，因此如果网络中存在DHCP服务器，则DHCP服务器会收到该报文。

（二）提供阶段

当网络中的DHCP服务器收到了`DHCP Client`发送的DHCP报文后，DHCP就进入了提供阶段。在这个阶段，DHCP Server会根据管理员的相关配置，给DHCP Client提供一个可用的IP地址，同时给其提供DNS、子网掩码等信息。

DHCP Server会发送`DHCP Offer`信息给`DHCP Client`提供上述信息，该报文也是一个**广播**报文。

源IP地址为DHCP Server的IP地址，目的IP地址为DHCP Server给该DHCP Client分配的IP地址，源MAC地址为DHCP Server的MAC地址，目的MAC地址为DHCP Client的MAC地址。

（注，在这里有的设备上DHCP Offer报文也是广播，其实也能够实现DHCP的功能）

（三）请求阶段

在DHCP Client收到DHCP Server发送的DHCP Offer报文后，就进入了DHCP请求阶段，在DHCP请求阶段，DHCP Client已经得到了DHCP Server分配给它的IP地址，DHCP Client在得到该IP地址后，却不会马上使用.

DHCP Client会向DHCP Server发送DHCP Request报文，正式向DHCP Server申请使用该IP地址。

DHCP Request报文，源IP地址为0.0.0.0（因为这时还没有得到DHCP服务器的回应，因此此时这个IP地址还不能正常使用，因此在这里源IP地址还是0.0.0.0）。

目的地址为255.255.255.255。（注：在这里其实DHCP Client其实已经知道了DHCP Server的IP地址，因此其实这里使用DHCP Server的IP地址其实也是可以的.

因此，有些设备对此做了优化，因为这样可以减少网络中的广播洪范流量）源MAC和目的MAC地址分别是DHCP Client的和DHCP Server的MAC地址。

（四）确认阶段

当DHCP Server收到DHCP Client发送的DHCP Request报文后，DHCP进入确认阶段。DHCP Server会向DHCP Client发送DHCP Reply报文，表示同意DHCP Client使用该IP地址。

DHCP Reply报文（有时也被称为DHCP ACK报文），源IP地址为DHCP Server的IP地址，目的IP地址为DHCP Client的IP地址，源目MAC为DHCP Server和Client的MAC地址。



### 重启PC后的DHCP过程及DHCP续约机制



目前，PC机对于DHCP有记忆功能，会记住当前网络中DHCP服务器的IP地址和上次分配给自己的IP地址。

因此，当PC重启后，通常不会按照上述的4个步骤按部就班的申请IP地址，而是通常会直接进入第三个阶段，直接向DHCP Server发送DHCP Request报文，请求自己上一次获得的IP地址。

如果DHCP同意，则会回应DHCP Reply报文，如果该IP地址已经被占用，或者其他情况造成DHCP Server不把该IP地址分配给DHCP Client，则DCHP Server会回应DHCP NACK报文，表示拒绝。这时，PC就必须重新进行DHCP四个阶段。





DHCP存在租约和续约机制，在默认情况下，当PC机申请到一个DHCP地址后，使用时间为一天，管理员也可以手动修改该时间，最短为1小时。当PC申请的DHCP IP地址到达租约时间后，该IP地址就不可以继续使用，因此PC会在租约到期之前进行续约。

通常情况下，DHCP Client会进行两次续约，一次是在租约期的50%时候，DHCP Cient会向DHCP Server发送DHCP Reqruest报文，如果收到DHCP Server的回应，则续约成功。

第二次续约是在租约期的87.5%的时候，DHCP会再次向DHCP Server发送DHCP Reques报文，申请租约。如果此时仍为收到DHCP响应的DCHP ACK报文，则就必须要重新进行DHCP的四个阶段，重新申请IP地址。





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