# CNI

CNI (Container Network Interface容器网络接口)是云原生计算基金会(CNCF)的一个项目。它为容器提供了一种基于插件结构的标准化网络解决方案。

它定义了一个规范，同时提供了一个Go语言的库(Library），用于开发在Linux容器中配置网络接口的插件，CNI项目还内置提供了一系列受支持的插件。



以往，容器的网络层是和具体的底层网络环境高度相关的，不同的网络服务提供商有不同的实现。

CNI抽象出了一套标准的网络服务接口，从而屏蔽了上层网络和底层网络提供商的网络实现之间的差异。

并且，通过插件结构，它让容器在网络层的具体实现变得可插拔了，所以非常灵活。

**CNI只关心容器创建时的网络分配，以及当容器被删除时已经分配网络资源的释放。** 

CNI作为容器网络的标准，使得各个容器管理平台可以通过相同的接口调用各种各样的网络插件来为容器配置网络。



Kubernetes就内置了CNI并通过CNI配置网络

CNI隶属于[CNCF(Cloud Native Computing Foundation)](https://cncf.io/)，在GitHub上有两个项目。其中，[`cni`项目](https://github.com/containernetworking/cni)包含了它的[规范](https://github.com/containernetworking/cni/blob/master/SPEC.md)和一个用Go语言编写的库。

我们可以利用这个库编写自己的CNI插件对容器网络进行配置。另一个[`plugins`项目](https://github.com/containernetworking/plugins)，包含了一系列作为参考实现的标准插件。

这些插件彼此独立，但根据需要也可以组合起来使用，比如：flannel插件底层就是调用的bridge插件来完成bridge和veth的创建的。

当然，还有很多第三方开发的插件，它们不在这个项目里。



CNI规范文档主要用来说明容器运行时(runtimes)和插件(plugins)之间的接口。CNI规范还提出了以下一般性建议:

- 容器运行时必须在调用任何CNI插件之前为容器创建一个新的network namespace
- 之后，容器运行时必须确定这个容器应该属于哪些网络，以及对于每个网络确定必须要执行哪些插件
- 网络的配置是JSON格式的，可以方便地存储在文件中。网络配置包含一些必填字段(如`name`, `type`)以及一些插件的特定字段。网络配置允许字段在调用之间更改值。因此存在一个可选字段“args”包含变化的信息。
- 容器运行时必须按顺序为每个网络执行相应的插件将容器添加到每个网络
- 在容器生命周期结束后，容器运行时必须以相反的顺序执行插件，以断开容器与网络的连接
- 容器运行时不能为同一个容器调用并行操作，但允许为不同的容器调用并行操作
- CNI接口定义了ADD,DEL,VERSION,CHECK等接口。容器运行时必须对一个容器进行的ADD和DEL操作进行排序，这样ADD最终总是在对应的DEL之后，DEL可以跟随其他DEL，插件应该允许多个DEL(即插件的DEL应该是幂等的)
- 容器必须由ContainerID唯一标识。存储状态的插件应该使用主键(network name, CNI_CONTAINERID, CNI_IFNAME)
- 如果没有相应的DEL，容器运行时不能对同一个(network name, CNI_CONTAINERID, CNI_IFNAME)调用两次ADD，这意味着只有在每次添加都使用不同的接口名时，才能将给定的ContainerID多次添加到特定的网络中
- CNI结构中的字段(如Network Configuration和CNI Plugin Result)除非特别标记为可选，都是必需的



# CNI Library（CNI库)



CNI库用于开发CNI插件，项目的地址是`https://github.com/containernetworking/cni`。当前项目源码的包结构如下:

```fallback
|-cni
  |- cnitool   - 可编译为一个命令行小工具cnitool，可用来执行CNI配置，在已经创建好的network namespace中添加、删除网络接口
  |- libcni    - CNI接口供容器运行时调用，转发调用具体的CNI插件。可以看出cnitool也是通过调用libcni实现其功能的
  |- pkg
    |- invoke
    |- skel    - 为CNI插件提供骨架代码，实现了参数的解析和校验
    ......
```

CNI库十分重要，k8s这类容器管理平台，containerd 这类容器运行时都依赖这个库与CNI插件进行交互。flannel、calico等CNI插件的开发也都依赖这个库。



# CNI项目内置插件

CNI项目还内置提供了一系列受支持的插件，即作为插件开发的参考实现，也可以直接使用。



内置插件项目的地址是 https://github.com/containernetworking/plugins 



从功能的角度可以划分为以下三类:

- 主插件: 用于创建网络设备
  - bridge: 创建一个网桥设备，并添加宿主机和容器到该网桥
  - ipvlan: 为容器添加ipvlan网络接口
  - loopback: 设置lo网络接口的状态为up
  - macvlan: 创建一个新的MAC地址，并将所有流量转发到容器
  - ptp: 创建Veth对
  - vlan: 分配一个vlan设备
  - host-device: 将已存在的设备移入容器内
- IPAM插件: 用于IP地址的分配
  - dhcp: 在宿主机上运行dhcp守护程序，代表容器发出dhcp请求
  - host-local: 维护一个分配ip的本地数据库
  - static: 为容器分配一个静态IPv4/IPv6地址，主要用于调试
- Meta插件: 其他插件，非单独使用插件
  - flannel: flannel网络方案的CNI插件，根据flannel的配置文件创建网络接口
  - tuning: 调整现有网络接口的sysctl参数
  - portmap: 一个基于iptables的portmapping插件。将端口从主机的地址空间映射到容器
  - bandwidth: 允许使用TBF进行限流的插件
  - sbr: 一个为网络接口配置基于源路由的插件
  - firewall: 过iptables给容器网络的进出流量进行一系列限制的插件



# 概述

本文为Linux平台上的容器应用提供了一个基于插件的通用网络解决方案，即容器网络接口CNI。

为了达到本文的目的，我们明确地定义了如下3个(个人标注：估计是笔误，4个)术语：

- 容器（container）：容器是一个网络隔离域，然而具体的隔离技术在本标准中并没有定义。这可以是一个 [network namespace](http://man7.org/linux/man-pages/man7/namespaces.7.html)，或者是虚拟机等等。
- 网络（network）：用于标识一组唯一寻址且可以互相通信的对象集合。这可以是单个独立的容器（如上定义的），一台机器，或者是其它的一些网络设备（比如路由器）。容器可以在逻辑上被添加到1个或多个网络中，或者从中移除。
- 运行时（runtime）是调用CNI插件的程序。
- 插件（plugin）是实现指定网络配置的程序。

本文为了阐明运行时（runtime）和插件（plugin）之间的接口。

下文中的关键词“必须”、“不允许”、“要求”、“应该”、“不应该”、“建议”、“可能”、“可选”的用法和RFC 2119指定的一致。

# 总结

CNI标准定义了：

1. 为管理员定义的网络配置标准格式
2. 容器运行时向网络插件发送请求的协议
3. 基于提供的配置，插件的执行过程
4. 插件将功能委托给其他插件的过程
5. 插件返回给运行时（runtime）的结果数据格式

# 第一章：网络配置格式

CNI为系统管理员定义了网络配置格式。它包含了给容器运行时和所调用插件使用的指令。在插件执行的时候，由容器运行时按照标准格式翻译和格式化配置，然后传递给插件。

一般来说，这个网络配置格式是比较固定的。通常我们可以认为它是有落盘到硬盘上的，虽然CNI标准并没有明确要求这一点（个人标注：比如kubernetes平台中主机目录/etc/cni/net.d/下放的配置文件）。

## 配置格式

一个网络配置是包含有如下关键词的JSON对象：

- cniVersion (string): CNI版本号遵循《语义化版本规范》Semantic Version 2.0。当前是"1.0.0"版本。
- name (string): 网络名称。一台主机（或者是其它管理域）上的所有网络配置应该都有唯一的名称。必须以字母或数字开头，随后可以跟随一个或多个字母或数字、下划线、逗号或者短横杠。
- disableCheck (boolean): 要么是true或者是false。如果disable为true，运行时则一定不能为当前网络配置列表调用CHECK接口。这个可以允许管理员在知道一些插件组合会返回伪造错误的时候阻止进行CHECK。
- plugins (list): CNI插件列表以及它们的配置列表，即插件配置对象（个人标注：即下一章节的插件配置对象）的列表。

### 插件配置对象：

插件配置对象可能会包含这里定义的配置项以外的配置项。如章节3里定义的所述，运行时**必须**不加改变的传递这些配置项给插件。

#### 必备的关键词，协议中使用：

- type (string): 用来匹配硬盘上CNI插件二进制的名称。**必须**不能包含系统文件路径不允许包含的字符，比如/或者\。

#### 可选的关键词：

- capabilities (dictionary)：章节3里定义。

#### 保留的关键词，协议中使用：

这些关键词由运行时在运行的时候生成，因此不能在配置中使用（个人标注：因为运行时本来就会生成这些配置项，所以插件不能在配置文件中再重新定义这些配置项从而导致冲突）。

- runtimeConfig
- args
- 以cni.dev/开头的所有关键词

#### 众所皆知的、可选的关键词：

这些关键词没有被协议使用，但是对于插件有着标准的含义。插件应该遵循这些关键词的本意来使用这些关键词。

- ipMasq (boolean): 如果插件支持，在主机上为该网络建立一个IP映射。当这个主机是作为子网的网关时，这往往是必须的。因为我们无法直接路由到容器所分配的IP上。
- ipam (dictionary): IPAM（IP地址管理）指定配置的字典：
  - type (string): 执行要调用的IPAM插件的文件名称。必须不能包含系统文件路径不允许包含的字符，比如/或者\。
- dns (dictionary, 可选): DNS指定配置的字典：
  - nameservers (strings列表，可选): 该网络已知的、按照优先级排序的DNS服务器列表。该列表的每一项都是包含IPv4或者IPv6地址的字符串。
  - domain (string, 可选): 用于短主机名解析的本地域
  - search (strings列表，可选): 用于短主机名解析的、按照优先级排序的搜索域列表。对于大部分的DNS服务器，这个配置比domian配置更合适。
  - options (strings列表，可选): 可以传递给DNS服务器的配置列表。

#### 其它关键词：

插件可以自定义额外的它们能接受的关键词，同时在接收到未知的关键词时可以响应错误。运行时在解析和格式化插件配置对象的时候，必须保留自己未知的关键词配置。（个人标注：这里即允许插件支持定制化参数，用户通过在网络配置文件中指定从而进行传参赋值）

## 配置举例：

```json
{
  "cniVersion": "1.0.0",
  "name": "dbnet",
  "plugins": [
    {
      "type": "bridge",
      // plugin specific parameters
      "bridge": "cni0",
      "keyA": ["some more", "plugin specific", "configuration"],
      
      "ipam": {
        "type": "host-local",
        // ipam specific
        "subnet": "10.1.0.0/16",
        "gateway": "10.1.0.1",
        "routes": [
            {"dst": "0.0.0.0/0"}
        ]
      },
      "dns": {
        "nameservers": [ "10.1.0.1" ]
      }
    },
    {
      "type": "tuning",
      "capabilities": {
        "mac": true
      },
      "sysctl": {
        "net.core.somaxconn": "500"
      }
    },
    {
        "type": "portmap",
        "capabilities": {"portMappings": true}
    }
  ]
}
```

（个人标注：上面就给出了网络配置的示例，plugins配置项就是插件配置对象的示例，其中配置了多个插件，每个插件有自己的配置；比如bridge插件就配置的比较全面，包括配置了ipam和dns等，bridge、keyA就是bridge插件的定制参数）

# 第二章：调用协议

## 概述

CNI标准协议是基于那些被容器运行时调用的插件二进制文件的。CNI定义了插件二进制和容器运行时之间的协议。

一个CNI插件负责通过某些方式为容器配置网络接口。插件可以分为2类：

- 接口类（interface）插件：在容器内创建一个网络接口，并保证这个接口的联通性。
- 链式（chained）插件：用于变更一个已经创建的网络接口的配置。

容器运行时通过环境变量和配置(configuration)的方式传递参数给插件。它通过标准输入stdin提供配置参数。当执行成功的时候，插件通过标准输出stdout返回结果给容器运行时，执行失败的时候通过标准错误输出stderr返回错误信息。配置参数和返回结果都是JSON格式的。

参数(Parameters)定义了运行时特定的设置，然而配置(configuration)则是对于任意给定网络都是一致的。

容器运行时必须在运行时的网络域中调用插件。（在大部分情况下，这都是根网络命名空间/ dom0）（个人标注：即容器运行时都是在宿主机网络空间下调用插件二进制的）

## 参数（Parameters）

协议参数是通过OS环境变量传递给插件的。

- CNI_COMMAND：标识期望的操作。包括ADD、DEL、CHECK、或者是VERSION。（个人标注：即所有插件都应该实现这些操作，比如cni插件中常见的cmdAdd、cmdDel就是这些操作的函数入口）
- CNI_CONTAINERID：容器ID。容器的唯一明文标识，由容器运行时分配。必须不能为空。必须以字母或数字开头，可以随后紧接着一个或多个字母、数字、下划线、点或短横线。
- CNI_NETNS：容器隔离域的引用。如果使用网络命名空间，那这个是网络空间的路径（比如/run/netns/[nsname]）
- CNI_IFNAME：要在容器内创建的网络接口名称；如果插件无法使用该接口名称，则必须返回错误。
- CNI_ARGS：在调用时用户传递的额外参数。字符数字类型的键值对，通过分号分割，比如"FOO=BAR;ABC=123"
- CNI_PATH：搜索可执行插件文件的路径列表。路径由操作系统指定的列表分隔符分隔，比如Linux是冒号，Windowns是分号。

## 错误

在执行成功的时候，插件必须返回值0；而执行出错的时候返回非0值。如果插件遇到一个错误，那它应该输出一个error结构的结果（见下文）。

## CNI操作集

CNI定义了4个操作：ADD、DEL、CHECK和VERSION（个人标注：早期是没有CHECK操作的，应该是最近版本引入的）。这些通过环境变量CNI_COMMAND传递给插件。

### ADD：添加容器到网络中，或者修改配置

- 在CNI_NETNS中为容器创建一张CNI_IFNAME指定的网卡，或者是
- 在CNI_NETNS中为容器修改CNI_IFNAME指定网卡的配置。

如果CNI插件执行成功，则它必须在标准输出stdout中返回一个result结构的结果信息（result结构见下文）。如果传递给插件的输入配置中有包含prevResult，那插件必须要处理这个prevResult，可能是往下传递，或者是进行修改。

如果在容器内已经存在了同名的网卡，则插件必须返回错误。

容器运行时不能为相同的CNI_CONTAINERID、CNI_IFNAME组连续调用2次ADD操作（在中间没有调用DEL的情况下）。这意味着一个容器只能通过不同的网络接口名称接入一个特定的网络。

#### 输入

运行时会在标准输入stdin中提供JSON序列化的插件配置。

必须传递的环境变量：

- CNI_COMMAND
- CNI_CONTAINERID
- CNI_NETNS
- CNI_IFNAME

可选的环境变量：

- CNI_ARGS
- CNI_PATH

### DEL：从网络中移除容器，或者是还原配置修改

一个CNI插件在接收到DEL命令的时候，应该

- 在CNI_NETNS为容器删除CNI_IFNAME指定的网卡，或者是
- 还原所有在插件ADD操作里生效的配置

插件一般应该执行DEL操作后不产生错误，即使过程中有些资源已经不存在了。举个例子，一个IPAM插件在容器的网络空间已经不存在的时候也应该释放已分配的IP，然后返回成功。除非对于插件的IPAM管理来说这个网络空间是至关重要的。虽然DHCP通常会在容器的网络接口上发送一个释放报文，但是因为DHCP通常有个租期，所以这个释放的动作就不是那么重要了，即使是失败了也不应该返回错误。再举个例子，bridge插件应该委托DEL操作给IPAM插件，即使容器网络空间或者容器网卡已经不存在的时候，也由IPAM插件去清理它自己的资源。

对于同一对CNI_CONTAINERID、CNI_IFNAME，即使是在请求中的网卡或者其他已添加的配置都已经不存在的时候，插件也必须可以接受多次重复调用DEL操作，然后返回成功。

#### 输入：

运行时会在标准输入stdin中提供JSON序列化的插件配置。

必须传递的环境变量：

- CNI_COMMAND
- CNI_CONTAINERID
- CNI_IFNAME

可选的环境变量：

- CNI_NETNS
- CNI_ARGS
- CNI_PATH

### CHECK：检查容器的网络是符合预期的

CHECK提供给容器运行时探测一个现有容器的网络状态。

#### 插件的注意事项：

- 插件必须从prevResult中来获取预期的网卡和网卡地址。
- 插件必须允许随后的链式插件来获取修改后的网络资源，比如ADD操作里的路由。
- 在一个CNI创建的资源（比如网卡、IP地址、路由）有在prevResult中列出，但是实际资源又不存在或者状态异常的时候，插件应该返回错误。
- 以下其它没有在CNI执行结果返回的资源类型在资源不存在或者状态异常的时候，插件也应该返回错误：
  - 防火墙规则
  - 流量整形控制规则
  - 预留IP
  - 扩展的其它依赖等等
- 当插件确认容器是网络不可达的时候，插件也应该返回错误。
- 插件必须要处理在ADD操作后被立马调用的CHECK操作，因此对于异步资源插件要能够接受一个合理的收敛延迟。
- 插件必须要能够调用任何功能下放（delegated）插件（比如IPAM插件）的CHECK操作，然后传递任何返回的错误给当前插件的调用者。

#### 运行时的注意事项：

- 运行时在容器还没有做过ADD操作，或者是在最后一个ADD操作后又执行了DEL操作之后，不可以再调用CHECK操作。
- 如果在配置中有将disableCheck置为true的时候，运行时也不应该调用CHECK操作。
- 在一个链式调用中如果某个插件返回了错误，运行时可以选择停止继续调用CHECK操作。
- 在一个成功的ADD操作后，在这个容器被通过DEL操作从该网络删除之前，运行时都可以立马调用CHECK操作。
- 运行时可以认为CHECK失败意味着容器当前处于错误配置状态。

#### 输入：

运行时会在标准输入stdin中提供JSON序列化的插件配置。

必须传递的环境变量：

- CNI_COMMAND
- CNI_CONTAINERID
- CNI_NETNS
- CNI_IFNAME

可选的环境变量：

- CNI_ARGS
- CNI_PATH

除了CNI_PATH，所有的参数都必须和调用ADD操作时的参数保持一致。

### VERSION：探测插件支持的版本

插件应该通过标准输出stdout返回一个版本结果结构的输出（见下文）。

#### 输入：

JOSN序列化的对象，包含以下关键词：

- cniVersion：当前使用的协议版本

必须传递的环境变量：

- CNI_COMMAND

# 第三章：网络配置的执行

本章节描述了容器运行时是如何转义网络配置（章节1中定义的网络配置），然后照此调用插件。容器运行时可能会在容器内add、delete或者check一个网络配置。对应的，运行时就是调用一系列插件的ADD、DELETE或者CHECK操作。本章节也定义了网络配置是如何格式化并传递给插件。

容器内一个网络配置的操作被称之为attachment。一个attachment可以用CNI_CONTAINERID、CNI_IFNAME组唯一识别。

## 生命周期和时序

- 容器运行时必须在调用任何插件前先为容器创建一个新的网络命名空间。
- 容器运行时不能对同一个容器并行调用多个操作，但是允许并行对不同容器调用操作。这包含跨attachment的场景（个人标注：这个应该是容器有多个attachment的时候，运行时也不能并行调用，即容器有多张网卡的时候要一张一张网卡串行处理）。
- 插件必须要能够处理多个容器的并行调用。如果有必要的话，插件必须实现共享资源的锁机制（比如IPAM数据库）。
- 容器运行时必须保证每个add操作最终都会有个对应的delete操作。唯一的意外只能是在出现灾难性错误的时候，比如节点丢失。一个delete即使是在add失败的时候也必须被调用。
- delete操作可以跟随多个delete操作。
- 在add和delete操作之间，网络配置不应该发生改变。
- 在attachment之间，网络配置也不应该发生改变。

## Attachment参数

因为在attachment之间网络配置不应该发生改变，所以有些确定的参数是在attachment之前由运行时提供的。即以下的参数：

- Container ID：容器的唯一明文标识，由运行时分配。参数不能为空。必须以字母或数字开头，其后可以跟随多个字母、数字、下划线、点或者短横线。在执行时，总是设置在CNI_CONTAINERID参数中。
- Namespace：容器隔离域的引用。如果使用网络隔离空间，则是一个网络隔离空间的路径（比如/run/netns/[nsname]）。在执行时，总是设置在CNI_NETNS参数中。
- 容器网卡名称：在容器内创建的网卡名称。在执行时，总是设置在CNI_IFNAME参数中。
- 通用参数：额外的参数，以键值对形式给出，和特定attachment关联。在执行时，总是设置在CNI_ARGS参数中。
- 特性参数：也是键值对。键是字符串类型，值则是任意JSON序列化的类型。键和值由convention（https://github.com/containernetworking/cni/blob/spec-v1.0.0/CONVENTIONS.md）定义。

此外，运行时还必须提供寻找CNI插件的路径列表。在调用的时候，这个也会通过CNI_PATH环境变量传递给插件。

## 添加attachment

对于网络配置中plugins参数中的每个配置，

1. 寻找type参数指定的二进制文件。如果不存在，则报错。
2. 从插件配置中获取请求参数，需要包含如下参数：
   1. 如果是plugins列表中的第一个插件，不需要提供上个插件的返回结果。
   2. 对于其它所有插件，prevResult是之前所有插件的返回结果。
3. 调用插件二进制，参数CNI_COMMAND置为ADD。上面定义的参数通过环境变量传入。
4. 如果插件返回错误，终止继续往下执行，然后返回错误给上层调用者。

运行时必须保存最后一个插件返回的结果，因为后续的check和delete操作也需要这些信息。

## 删除attachment

删除一个网络attachment基本和add操作相同，但是也有如下几点不同：

- plugins列表指定插件列表的调用顺序和add是相反的。
- 所提供的prevResult总是add操作最后返回的结果。

对于网络配置中plugins参数指定的插件列表，总是反序调用的，

1. 根据type参数查找指定的插件可执行二进制。如果不存在，则报错。
2. 从插件配置中获取请求参数，prevResult是前面add操作的返回结果。
3. 调用插件二进制，CNI_COMMAND置为DEL。上述获取的请求参数通过环境变量传给插件。
4. 如果插件返回错误，则终止继续调用，返回结果给上层调用者。

如果所有的插件都返回成功，则给调用者返回成功。

## 检查attachment

运行时可以向每个插件查询确认给定的attachment仍然是正常的。运行时调用的attachment参数必须和之前add操作给出的参数一致。

检查动作和add动作也基本相似，除了，

- prevResult总是add操作最后返回的结果。
- 如果网络配置指定了disableCheck，则总是返回成功给调用者。

对于网络配置中plugins指定的每个插件，

1. 根据type参数查找指定的插件可执行二进制。如果不存在，则报错。
2. 从插件配置中获取请求参数，prevResult是前面add操作的返回结果。
3. 调用插件二进制，CNI_COMMAND置为CHECK。上述获取的请求参数通过环境变量传给插件。
4. 如果插件返回错误，则终止继续调用，返回结果给上层调用者。

如果所有的插件都返回成功，则给调用者返回成功。

## 从插件配置中获取调用配置

网络配置格式（要调用的插件配置列表）必须转换成插件可以识别的格式（单个插件配置）。本节描述了这个转换过程。

单个插件调用的执行参数也是JSON格式的。它由插件配置组成，通常是不会改变了，除了一些规定的添加项和移除项。

以下字段必须在调用的时候由运行时添加到执行配置中：

- cniVersion：从网络配置的cniVersion字段获取。
- name：从网络配置的name字段获取。
- runtimeConfig：JSON格式的对象，由插件所提供特性和运行时所请求特性的组合。
- prevResult：JSON格式的对象，由之前插件返回的结果组成。这里的"之前插件"是由特定的操作定义的（add、delete或者是check）。

以下字段必须由运行时移除：

- capabilities

其它字段则应该不加修改的传递。

### 获取runtimeConfig

因为所有插件都提供了CNI_ARGS，但是并没有指明它们都必须被处理，因此Capability参数需要在配置中明确声明。运行时因此可以确定一个给定的网络配置是否支持某个特定capability。Capability并没有在本标准中定义，相反的，它们在convention（https://github.com/containernetworking/cni/blob/spec-v1.0.0/CONVENTIONS.md）中描述。

在章节1中定义可知，插件配置包含一个可选的参数，capabilities。下面的例子展示了一个插件支持了portMapping的特性：

```
{
  "type": "myPlugin",
  "capabilities": {
    "portMappings": true
  }
}
```

runtimeConfig参数是从网络配置的capabilities参数中提出的，然后运行时生成了capability参数。确切的说，插件支持的任何capability以及运行时提供的特性都应该填入runtimeConfig中。

因此，上面的例子最后就会生成如下的配置作为执行参数的一部分传递给插件：

```
{
  "type": "myPlugin",
  "runtimeConfig": {
    "portMappings": [ { "hostPort": 8080, "containerPort": 80, "protocol": "tcp" } ]
  }
  ...
}
```

# 第四章：插件委托（Delegation）

有些操作鉴于某些原因是无法由分离的插件链来合理实现的。相反，一个CNI插件可能会期望委托一些功能给其它插件来完成。比如一个常见的例子就是IP地址的分配。

作为插件操作的一部分，它可能被期望能够为网络接口分配（和管理）一个IP地址，然后配置和这个接口相关的路由。这会使插件变得非常灵活，但也给它带来了巨大的负担。很多的CNI插件不得不引入相同的代码来支持用户期望的不同IP管理机制（比如dhcp，host-local）。因此一个CNI插件可能就会选择将IP管理委托给另一个插件。

为了减轻插件的负担，以及使得IP管理策略和CNI插件类型是正交的（个人标注：这里的正交不知道该怎么理解），我们定义了另一种类型的插件，也就是IP地址管理插件（IPAM插件）。同时定义了插件委托功能给其它插件直接的交互协议。

在合适的时机调用IPAM插件是CNI插件的责任，而不是容器运行时的。IPAM插件必须确定网卡所使用的IP、子网、网关和路由，然后将这些信息返回给调用它的主插件。IPAM插件还可能通过某些协议比如dhcp获取信息，然后将数据保存在本地文件系统中，或者网络配置文件的ipam段里，等等。

## 委托插件协议

和CNI插件一样，被委托插件也是通过执行一个可执行文件来调用的。而这个可执行文件的搜索路径是预设的一个路径列表，即通过CNI_PATH传递给CNI插件的值。那些传递给CNI插件的环境变量必须原封不动的也传递给被委托插件。和CNI插件一样，被委托插件也是从标准输入stdin获取网络配置，并将结果输出到标准输出stdout。

上层调用插件必须把它接收到的完整网络配置也传递给被委托插件。换句话说，在IPAM的场景中，应该传递整个网络配置，而不仅仅是ipam这个段。

返回值为0则表示执行成功，同时标准输出stdout会输出一个Success类型结果。

### 被委托插件执行步骤

当一个插件要调用一个被委托插件，它必须：

- 通过搜索CNI_PATH环境变量指定的目录来寻找插件二进制。
- 调用执行找到的插件二进制，传递本插件接收到的环境变量和配置。
- 保证被委托插件的错误输出stderr是输出到调用插件的错误输出stderr中的。

如果本插件是被调用了CNI_COMMAND=CHECK或者是DEL，那它也必须调用被委托插件。如果任何的被委托插件返回了错误，则错误必须返回给上层插件。

如果是ADD操作时，如果一个被委托插件返回了错误，则上层插件必须在返回错误前调用DEL操作。

# 第五章：结果类型

插件可以返回以下三种结果类型的任意一种：

- Success
- Error
- _Version

## Success

如果传递给插件的请求配置中有包含preResult的，则必须也将preResult作为结果返回，而且插件可能会对这个preResult做修改。如果插件对其没有改动（这个会体现在Success结果中），则它必须返回一个和传入的prevResult相同的结果。

对于一个成功的ADD操作，插件必须返回一个包含如下keys的JSON对象：

- cniVersion：和输入时相同的版本号，即字符串"1.0.0"
- interfaces：attachment创建的网卡列表，包括任何主机级别的网卡：
  - name：网卡名称
  - mac：网卡硬件地址（如果合适的话）
  - sandbox：网卡的隔离域指针（比如网络命名空间的路径），或者在主机网络时是空值。如果是创建在容器内的网卡，则它是入参CNI_NETNS的值。
- ips：由该attachment分配的IP地址。插件可能会包含一些分配的和容器不相关的IP地址。
  - address(string)：CIDR格式的IP地址（比如192.168.1.3/24）
  - gateway(string)：子网的默认网关，如果存在的话。
  - interface(uint)：CNI插件结果里interfaces列表的索引，用于指示该IP是配置到哪行网卡上的。
- routes：该attachment创建的路由项：
  - dst：路由的目的地址，CIDR格式
  - gw：下一跳地址。如果没有指定，则使用ips列表中的gateway值。
- dns：DNS配置信息字典
  - nameservers(strings列表)：优先级排序的DNS服务器列表。列表中每一项都是要么是IPv4地址字符串，要么是IPv6地址字符串。
  - domain(string)：用于短主机名解析的本地域
  - search(strings列表)：用于短主机名解析的具有优先级排序的搜索域。对于大多数域名解析服务器来说，这个优先级比domain高。
  - options(strings列表)：可以传递给域名解析服务器的参数列表

### 被委托插件（IPAM）

被委托插件可能会省去不相关的部分。

被委托的IPAM插件必须返回一个简短的Success对象。特别的，它不包含interfaces列表，也不包含ips中的interface元素。

## Error

当插件遇到错误的时候，它们应该返回包含如下keys的JSON对象：

- cniVersion：和配置传入的值一样。
- code：错误码，参见下文的保留错误码。
- msg：描述错误的简短信息。
- details：描述错误的详细信息。

举个例子：

```
{
  "cniVersion": "1.0.0",
  "code": 7,
  "msg": "Invalid Configuration",
  "details": "Network 192.168.0.0/31 too small to allocate from."
}
```

错误码0-99被保留用于常见的错误。100以上的值可以由插件用于指示其自定义的错误。

| 错误码 | 错误描述                                                     |
| ------ | ------------------------------------------------------------ |
| 1      | CNI版本不兼容                                                |
| 2      | 网络配置中有不支持的字段。错误描述信息中必须包含不支持字段的key和键值。 |
| 3      | 容器未知或者不存在。该错误意味着运行时并不需要进行任何容器的网络清理（比如，为容器调用DEL操作）。 |
| 4      | 必配环境变量项不合法，比如CNI_COMMAN、CNI_CONTAINERID等。    |
| 5      | I/O错误。比如，从stdin读取网络配置失败。                     |
| 6      | 序列化内容错误。比如，从字节流中序列化网络配置失败，或者是从字符串中读取版本号失败。 |
| 7      | 不合法的网络配置。如果某些网络配置校验失败，就将会返回该错误。 |
| 11     | 稍后重试。如果插件发现有些短暂的条件需要清理，那它可以使用该错误码来通知运行时稍后重试相关操作。 |

另外，标准错误输出stderr将被用来输出非结构化的结果，比如日志。

## Version

对于VERSION操作，插件必须返回包含如下keys的JSON对象：

- cniVersion：入参cniVersion指定的值
- supportedVersions：支持的特定版本列表

举个例子，

```
{
    "cniVersion": "1.0.0",
    "supportedVersions": [ "0.1.0", "0.2.0", "0.3.0", "0.3.1", "0.4.0", "1.0.0" ]
}
```

# 附录：示例

我们假设使用章节1中的网络配置。对于该attachment，运行时生成portmap和mac特性参数，同时生成一般参数"argA=foo"。以下示例使用CNI_IFNAME=eth0。

## ADD示例

容器运行时对于add操作将会做如下几个步骤。

1.使用如下的JSON对象，CNI_COMMAND=ADD，调用bridge插件：

```
{
    "cniVersion": "1.0.0",
    "name": "dbnet",
    "type": "bridge",
    "bridge": "cni0",
    "keyA": ["some more", "plugin specific", "configuration"],
    "ipam": {
        "type": "host-local",
        "subnet": "10.1.0.0/16",
        "gateway": "10.1.0.1"
    },
    "dns": {
        "nameservers": [ "10.1.0.1" ]
    }
}
```

而bridge插件将其IPAM功能委托给了host-local插件，因此将会调用host-local二进制。调用host-local时会将其收到的参数原封不动地传递给它，CNI_COMMAND置为ADD。

假设host-local插件返回如下结果：

```
{
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1"
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
}
```

然后bridge插件将会根据返回的IPAM配置而配置网卡，同时返回如下结果给运行时：

```
{
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1",
          "interface": 2
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "interfaces": [
        {
            "name": "cni0",
            "mac": "00:11:22:33:44:55"
        },
        {
            "name": "veth3243",
            "mac": "55:44:33:22:11:11"
        },
        {
            "name": "eth0",
            "mac": "99:88:77:66:55:44",
            "sandbox": "/var/run/netns/blue"
        }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
}
```

2.然后，CNI_COMMAND置为ADD，调用tuning插件。要注意的是传入了prevResult参数，以及mac特性参数。传入的网络配置为：

```
{
  "cniVersion": "1.0.0",
  "name": "dbnet",
  "type": "tuning",
  "sysctl": {
    "net.core.somaxconn": "500"
  },
  "runtimeConfig": {
    "mac": "00:11:22:33:44:66"
  },
  "prevResult": {
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1",
          "interface": 2
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "interfaces": [
        {
            "name": "cni0",
            "mac": "00:11:22:33:44:55"
        },
        {
            "name": "veth3243",
            "mac": "55:44:33:22:11:11"
        },
        {
            "name": "eth0",
            "mac": "99:88:77:66:55:44",
            "sandbox": "/var/run/netns/blue"
        }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
  }
}
```

tuning插件返回了如下结果。可以看到其中mac地址已经变了。

```
{
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1",
          "interface": 2
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "interfaces": [
        {
            "name": "cni0",
            "mac": "00:11:22:33:44:55"
        },
        {
            "name": "veth3243",
            "mac": "55:44:33:22:11:11"
        },
        {
            "name": "eth0",
            "mac": "00:11:22:33:44:66",
            "sandbox": "/var/run/netns/blue"
        }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
}
```

3.最后，CNI_COMMAN置为ADD，调用portmap插件。要注意的是preResult是tuning插件返回的结果：

```
{
  "cniVersion": "1.0.0",
  "name": "dbnet",
  "type": "portmap",
  "runtimeConfig": {
    "portMappings" : [
      { "hostPort": 8080, "containerPort": 80, "protocol": "tcp" }
    ]
  },
  "prevResult": {
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1",
          "interface": 2
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "interfaces": [
        {
            "name": "cni0",
            "mac": "00:11:22:33:44:55"
        },
        {
            "name": "veth3243",
            "mac": "55:44:33:22:11:11"
        },
        {
            "name": "eth0",
            "mac": "00:11:22:33:44:66",
            "sandbox": "/var/run/netns/blue"
        }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
  }
}
```

portmap插件的返回结果将会和bridge插件返回的结果一样，因为插件并没有做什么会影响返回结果的改动（比如，它只是创建了iptables规则而已）。

## Check示例

在上述ADD操作的基础上，容器运行时可能会执行如下步骤来完成Check动作：

1.首先根据如下请求配置调用bridge插件，包括从Add操作返回的最终JSON响应作为preResult，包括已经被更改的mac地址，CNI_COMMAND置为CHECK，

```
{
  "cniVersion": "1.0.0",
  "name": "dbnet",
  "type": "bridge",
  "bridge": "cni0",
  "keyA": ["some more", "plugin specific", "configuration"],
  "ipam": {
    "type": "host-local",
    "subnet": "10.1.0.0/16",
    "gateway": "10.1.0.1"
  },
  "dns": {
    "nameservers": [ "10.1.0.1" ]
  },
  "prevResult": {
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1",
          "interface": 2
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "interfaces": [
        {
            "name": "cni0",
            "mac": "00:11:22:33:44:55"
        },
        {
            "name": "veth3243",
            "mac": "55:44:33:22:11:11"
        },
        {
            "name": "eth0",
            "mac": "00:11:22:33:44:66",
            "sandbox": "/var/run/netns/blue"
        }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
  }
}
```

然后bridge插件因为把IPAM委托给了host-local插件，因此它会调用host-local插件的CNI_COMMAND=CHECK。host-local插件直接返回。

假设bridge插件检查通过了，也没有在标准输出stdout中产生任何输出，而是直接返回返回值0。

2.然后运行时调用tuning插件，传入如下请求配置：

```
{
  "cniVersion": "1.0.0",
  "name": "dbnet",
  "type": "tuning",
  "sysctl": {
    "net.core.somaxconn": "500"
  },
  "runtimeConfig": {
    "mac": "00:11:22:33:44:66"
  },
  "prevResult": {
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1",
          "interface": 2
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "interfaces": [
        {
            "name": "cni0",
            "mac": "00:11:22:33:44:55"
        },
        {
            "name": "veth3243",
            "mac": "55:44:33:22:11:11"
        },
        {
            "name": "eth0",
            "mac": "00:11:22:33:44:66",
            "sandbox": "/var/run/netns/blue"
        }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
  }
}
```

同样的，tuning插件也是成功返回。

3.最后，调用portmap插件，入参如下：

```
{
  "cniVersion": "1.0.0",
  "name": "dbnet",
  "type": "portmap",
  "runtimeConfig": {
    "portMappings" : [
      { "hostPort": 8080, "containerPort": 80, "protocol": "tcp" }
    ]
  },
  "prevResult": {
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1",
          "interface": 2
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "interfaces": [
        {
            "name": "cni0",
            "mac": "00:11:22:33:44:55"
        },
        {
            "name": "veth3243",
            "mac": "55:44:33:22:11:11"
        },
        {
            "name": "eth0",
            "mac": "00:11:22:33:44:66",
            "sandbox": "/var/run/netns/blue"
        }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
  }
}
```

## Delete示例

给定和上文一样的网络配置JSON列表，容器运行时也将会执行如下步骤来完成Delete操作。需要注意的是插件的调用将会是和Add、Check动作相反。

1.首先，根据如下请求配置调用portmap插件，CNI_COMMAND置为DEL：

```
{
  "cniVersion": "1.0.0",
  "name": "dbnet",
  "type": "portmap",
  "runtimeConfig": {
    "portMappings" : [
      { "hostPort": 8080, "containerPort": 80, "protocol": "tcp" }
    ]
  },
  "prevResult": {
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1",
          "interface": 2
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "interfaces": [
        {
            "name": "cni0",
            "mac": "00:11:22:33:44:55"
        },
        {
            "name": "veth3243",
            "mac": "55:44:33:22:11:11"
        },
        {
            "name": "eth0",
            "mac": "00:11:22:33:44:66",
            "sandbox": "/var/run/netns/blue"
        }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
  }
}
```

2.然后，根据如下请求配置调用tuning插件，CNI_COMMAND置为DEL：

```
{
  "cniVersion": "1.0.0",
  "name": "dbnet",
  "type": "tuning",
  "sysctl": {
    "net.core.somaxconn": "500"
  },
  "runtimeConfig": {
    "mac": "00:11:22:33:44:66"
  },
  "prevResult": {
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1",
          "interface": 2
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "interfaces": [
        {
            "name": "cni0",
            "mac": "00:11:22:33:44:55"
        },
        {
            "name": "veth3243",
            "mac": "55:44:33:22:11:11"
        },
        {
            "name": "eth0",
            "mac": "00:11:22:33:44:66",
            "sandbox": "/var/run/netns/blue"
        }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
  }
}
```

3.最后，调用bridge插件：

```
{
  "cniVersion": "1.0.0",
  "name": "dbnet",
  "type": "bridge",
  "bridge": "cni0",
  "keyA": ["some more", "plugin specific", "configuration"],
  "ipam": {
    "type": "host-local",
    "subnet": "10.1.0.0/16",
    "gateway": "10.1.0.1"
  },
  "dns": {
    "nameservers": [ "10.1.0.1" ]
  },
  "prevResult": {
    "ips": [
        {
          "address": "10.1.0.5/16",
          "gateway": "10.1.0.1",
          "interface": 2
        }
    ],
    "routes": [
      {
        "dst": "0.0.0.0/0"
      }
    ],
    "interfaces": [
        {
            "name": "cni0",
            "mac": "00:11:22:33:44:55"
        },
        {
            "name": "veth3243",
            "mac": "55:44:33:22:11:11"
        },
        {
            "name": "eth0",
            "mac": "00:11:22:33:44:66",
            "sandbox": "/var/run/netns/blue"
        }
    ],
    "dns": {
      "nameservers": [ "10.1.0.1" ]
    }
  }
}
```

在bridge插件返回前，它将会调用被委托插件host-local，传入的CNI_COMMAND置为DEL。