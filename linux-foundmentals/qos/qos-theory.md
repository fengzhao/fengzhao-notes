# linux下的QOS：理论篇

关于qos ，也是linux下面必备功能之一，一般只需要结合 iptables/etables/iproute2 和 tc 配合即可实现大部分功能。网上讲这么方面的资料很多，大部分都讲 tc 命令的应用。这里就先从理论入手。

QoS（Quality of Service）服务质量，是网络的一种安全机制, 是用来解决网络延迟和阻塞等问题的一种技术。

但是对关键应用和多媒体应用就十分必要。当网络过载或拥塞时，QoS 能确保重要业务量不受延迟或丢弃，同时保证网络的高效运行。

在网络总带宽固定的情况下，如果某类业务占用的带宽越多，那么其他业务能使用的带宽就越少，可能会影响其他业务的使用。

因此，网络管理者需要根据各种业务的特点来对网络资源进行合理的规划和分配，从而使网络资源得到高效利用



### QoS服务模型

通常QoS提供以下三种服务模型：

- Best-Effort service（尽力而为服务模型）（系统默认；PFIFO_FAST）
- Integrated service（综合服务模型，简称Int-Serv）
- Differentiated service（区分服务模型，简称Diff-Serv）



##### (1) Best-Effort服务模型

Best-Effort是一个单一的服务模型，也是最简单的服务模型。对 Best-Effort 服务模型，网络尽最大的可能性来发送报文。但对时延、可靠性等性能不提供任何保证。

Best-Effort 服务模型是网络的缺省服务模型，通过 FIFO 队列来实现。它适用于绝大多数网络应用，如 FTP、E-Mail 等。

##### (2) Int-Serv服务模型

Int-Serv 是一个综合服务模型，它可以满足多种 QoS需求。该模型使用资源预留协议（RSVP），RSVP 运行在从源端到目的端的每个设备上，可以监视每个流，以防止其消耗资源过多。

这种体系能够明确区分并保证每一个业务流的服务质量，为网络提供最细粒度化的服务质量区分。

但是，Inter-Serv模型对设备的要求很高，当网络中的数据流数量很大时，设备的存储和处理能力会遇到很大的压力。

Inter-Serv模型可扩展性很差，难以在 Internet 核心网络实施，前主要与 MPLS TE（Traffic Engineering，流量工程）结合使用.

##### (3) Diff-Serv服务模型

Diff-Serv是一个多服务模型，它可以满足不同的QoS需求。与Int-Serv不同，它不需要通知网络为每个业务预留资源。

区分服务实现简单，扩展性较好， 可以说是为现在的网络量身打做的。这个这种类型的QOS中，数据流是要进行分类的，然后，我们可以进一步的对各种不同类的流进行的控制。

这个控制的实现就是通过策略表来实现的。这样简单一说，我们就该知道了，实现他们是要有个类表，然后还得有个控制表—策略表.

它由 RFC2475 定义，在区分服务中，根据服务要求对不同业务的数据进行分类，对报文按类进行优先级标记，然后有差别地提供服务。







# Linux iproute2



iproute2 是 Linux 用户空间下的一个网络工具集，它主要包含网络控制和流量管理等功能。包括：路由，网络接口，隧道，流量控制，网络相关的驱动。



iproute2 是linux下管理控制TCP/IP网络和流量控制的新一代工具包，旨在替代老派的工具链net-tools。即大家比较熟悉的 ifconfig，arp，route，netstat 等命令。

net-tools通过procfs(/proc)和 ioctl 系统调用去访问和改变内核网络配置，而 iproute2 则通过netlink套接字接口与内核通讯。

抛开性能而言，net-tools 的用法给人的感觉是比较乱，而iproute2的用户接口相对net-tools来说相对来说，更加直观。

比如，各种网络资源（如link、IP地址、路由和隧道等）均使用合适的对象抽象去定义，使得用户可使用一致的语法去管理不同的对象.



iproute2 是一个基于 GPLv2 协议开源的项目。它的开发跟 Linux 内核中的网络组件的开发紧密相关。

2013年12月，它主要由 Stephen Hemminger and David Ahern 来维护。它的创始人现在在负责 Linux 内核的 QoS 。

iproute2 工具集包含如下命令：

- arpd                    
- bridge
- ctstat
- devlink
- ip
- lnstat
- nstat 
- rdma
- routef
- routel
- rtacct
- rtmon
- rtstat
- ss
- tc 
- tipc 
