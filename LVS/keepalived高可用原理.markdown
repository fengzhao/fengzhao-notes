# 简介



Keepalived 软件起初是专为 LVS 负载均衡软件设计的，用来管理并监控 LVS 集群系统中各个服务节点的状态，后来又加入了可以实现高可用的 VRRP 功能。

因此，Keepalived除了能够管理 LVS 软件外，还可以作为其他服务（例如：Nginx、Haproxy、MySQL等）的高可用解决方案软件。

Keepalived 软件主要通过 VRRP 协议实现高可用功能的，VRRP 是 Virtual Router Redundancy Protocol （虚拟路由器冗余协议）的缩写。VRRP 出现的目的就是为了解决动态路由单点故障问题的，它能够保证当个别节点宕机时，整个网络可以不间断的运行。

所以，Keepalived 一方面具有配置管理 LVS 的功能，同时还具有对 LVS 下面节点进行健康检查的功能，另一方面也可以实现系统网络服务的高可用功能。





Keepalived的主要目的就是它自身启动为一个服务，它工作在多个LVS主机节点上，当前活动的节点叫做Master备用节点叫做Backup。

Master会不停的向Backup节点通告自己的心跳，这种通告是基于VRRP协议的。

Backup节点一旦接收不到Master的通告信息，它就会把LVS的VIP拿过来，并且把ipvs的规则也拿过来，在自己身上生效，从而替代Master节点。







## Keepalived 原理

Keepalived 高可用服务对之间的故障切换转移，主要就是通过 **==VRRP 协议（虚拟路由冗余协议）==**来实现的。



### VRRP协议

**==VRRP 协议，全称 Virtual Router Redundancy Protocol，中文名为虚拟路由冗余协议==**。VRRP 的出现就是为了解决静态路由的单点故障问题，VRRP 协议是通过一种竞选机制来将路由的任务交给某台 VRRP 路由器的。

VRRP 协议早期是用来解决交换机/路由器等网络设备单点故障的。



**1）VRRP 原理描述（同样适用于 Keepalived 的工作原理）**

在一组 VRRP 路由器集群中，有多台物理 VRRP 路由器，但是这多台物理的机器并不是同时工作的，而是由一台称为 MASTER 的机器负责路由工作，其他的机器都是 BACKUP。

MASTER 角色并非一成不变，VRRP 协议会让每个 VRRP 路由参与竞选**==（一般是直接手动为每个路由器分配权重，权重高的获胜）==**，最终获胜的就是 MASTER。

MASTER 拥有虚拟路由器的 IP 地址，我们把这个 IP 地址称为 VIP，MASTER 负责转发发送给网关地址的数据包和响应 ARP 请求。



**2）VRRP 是如何工作的？**

VRRP 协议通过竞选机制来实现虚拟路由器的功能，所有的协议报文都是通过 **==IP 多播（默认的多播地址：224.0.0.18）==**形式进行发送。虚拟路由器由 VRID （范围0-255）和一组 IP 地址组成，对外表现为一个周知的 MAC 地址：00-00-5E-00-01-{VRID}。

所以，在一个虚拟路由器中，不管谁是 MASTER，对外都是相同的 MAC 地址和 IP 地址，如果其中一台虚拟路由器宕机，角色发生切换，那么客户端并不需要因为 MASTER 的变化修改自己的路由设置，可以做到透明的切换。

这样就实现了如果一台机器宕机，那么备用的机器会拥有 MASTER 上的 IP 地址，实现高可用功能。



**3）VRRP 是如何通信的？**

在一组虚拟路由器中，只有作为 MASTER 的 VRRP 路由器会一直**==周期性==**地以**==单播或组播==**的形式对外发送 VRRP 包，此时 BACKUP 不会抢占 MASTER 。

当 MASTER 不可用时，这个时候 BACKUP 就收不到来自 MASTER 的 VRRP 包了，此时多台 BACKUP 中优先级最高的路由器会去抢占为 MASTER。

这种抢占是非常快速的（可能只有1秒甚至更少），以保证服务的连续性。出于安全性考虑，VRRP 数据包使用了加密协议进行了加密。





## 单播和组播

在许多**现代企业网络**、**金融级专线**以及**公有云环境（如 AWS, 阿里云）**中，网络管理员为了防止广播风暴或基于安全合规考虑，通常会禁用二层组播（Multicast）。

在这种“组播禁区”里，VRRP 要想继续生存，就必须切换到**单播（Unicast）**模式。



**==为什么禁用组播？==**

- **网络风暴控制：** 组播在某些配置不当的情况下会退化为广播，占用大量带宽。
- **安全限制：** 组播报文容易被同网段的其他设备嗅探，单播则更加私密。
- **云架构限制：** 绝大多数公有云的底层网络（VPC）是基于 SDN（软件定义网络）实现的，天然不支持二层组播。



**==单播模式下的 VRRP 是如何工作的？==**

在单播模式下，VRRP 的“心跳”不再是向全组广播，而是变成了一场**“点对点对话”**：

1. **指定对端 IP：** 你必须在配置中显式告诉路由器 A：“你的伙伴是 192.168.1.2”，同时也告诉路由器 B：“你的伙伴是 192.168.1.1”。
2. **定向发送：** Master 发送 VRRP 报文时，目标 IP 不再是 `224.0.0.18`，而是对方的物理接口 IP。
3. **三层转发：** 这种报文就像普通的网页请求或文件传输一样，可以被路由器跨网段转发（如果需要）。



# keepalived配置文件详解



配置文件是以配置块的形式存在，每个配置块都在一个闭合的{}范围内，所以编辑的时候需要注意大括号的闭合问题。#和！开头都是注释。



```nginx
! Configuration File for keepalived

global_defs {
   # 表示keepalived在发生诸如切换操作时需要发送email通知以及email发送给哪些邮件地址邮件地址可以多个每行一个
   notification_email {      			
  		 acassen@firewall.loc     
   		 failover@firewall.loc
   		 sysadmin@firewall.loc
   }
   
   # 发件人信息
   notification_email_from Alexandre.Cassen@firewall.loc   
   smtp_server 192.168.200.1                         
   smtp_connect_timeout 30                                     
   router_id MASTER    	# 代表当前这台服务器（节点）的标识符。比如说MASTER/BACKUP
}


# VRRP实例配置范例
vrrp_instance VI_1 {
    state MASTER    		# 设置初始状态为主
    interface eth0    		# 设置绑定VIP的网卡
    virtual_router_id 51    # VRID，代表一个特定的虚拟路由器组。MASTER和BACKUP必须一致： 同一个高可用组内的所有成员，这个 ID 必须完全相同，否则它们无法互相识别心跳，会出现“双 Master”冲突。
    priority 100    		# 设置优先级，取值范围一般是
    advert_int 3 			# 发送 VRRP 通告报文（心跳包）的时间间隔。默认值通常为1秒。MASTER和BACKUP必须一致
    nopreempt    			# 设置为非抢占模式。通常建议只在优先级（Priority）较高的那台机器（原本的 Master）上配置。
    authentication {		
        auth_type PASS		# 认证机制
        auth_pass 1111		# 认证密码
    }
    
    # 单播
    unicast_src_ip 192.168.50.69    # 发送单播VRRP通告报文时使用的本地源IP地址
    unicast_peer {
        192.168.50.111    			# 用于接收VRRP通告报文的对端IP地址
        # 如果有多个备份节点，在这里继续换行添加 IP    
    }
    
    # 设置虚拟IP地址，即VIP地址
    virtual_ipaddress {
        192.168.50.161/24 dev eth0 label eth0:vip1    	
    }
    
    
    # 在 VRRP 状态发生变化时，自动触发外部脚本执行特定的操作
    notify_master "/etc/keepalived/notify_action.sh MASTER"		# 当节点从 Backup 变为 Master 时触发
    notify_backup "/etc/keepalived/notify_action.sh BACKUP"		# 当节点从 Master 变为 Backup 时触发
    notify_fault "/etc/keepalived/notify_action.sh FAULT"		# 当检测到故障（如网卡断开或脚本探测失败）时触发
    notify_stop "/etc/keepalived/notify_action.sh STOP"			# 当 Keepalived 服务被手动停止时触发
}



# 服务检查脚本：比如检查Nginx是否正常
vrrp_script check_nginx {
    script "/etc/keepalived/check_nginx.sh" # 脚本路径，也可以是命令如 "pidof nginx"
    interval 2                              # 每 2 秒执行一次
    timeout 1        						# 脚本执行超过 1 秒没返回结果，就视为失败
    weight -20                              # 如果失败，优先级减 20， （如果设为 -20，失败时 Priority 减 20；如果设为 0，失败直接进 FAULT）
    fall 3                                  # 连续失败 3 次才算真失败
    rise 2                                  # 连续成功 2 次才算恢复正常
    user root        						# 以哪个用户身份运行脚本
    init_fail        						# 启动时先假设脚本是失败的（等第一次探测成功再上线）
}

```







# keepalived + nginx 高可用







