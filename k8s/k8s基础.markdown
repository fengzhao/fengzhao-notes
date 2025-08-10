# k8s概述



## 什么是k8s

Kubernetes 是 Google 团队发起的一个开源项目，它的目标是管理跨多个主机的容器，用于自动部署、扩展和管理容器化的应用程序，主要实现语言为 Go 语言。

Kubernetes  是一个跨多主机的容器编排工具，它使用共享网络将多个主机（）构建成一个统一的集群。

其中一个或少量几个主机运行为主节点 （master node） 作为控制中心负载管理整个集群。

余下所有主机运行为工作节点（Work Node），他们本地和外部资源接收请求并以 Pod （容器组）形式运行工作负载。

它抽象了数据中心的硬件基础设施，使得对外暴露的只是一个巨大的资源池。它让我们在部署和运行组件时，不用关注底层的服务器。

Kubernetes 是希腊语中的 "舵手" 的意思。



近年来，应用程序的开发部署是如何变化的。变化主要是两方面导致的：

一方面是大型单体应用被拆解为更多的小型微服务。

另一方面是应用所依赖的基础架构的变化。



将复杂的大型单体应用拆分为小的可独立部署的微服务组件，每个微服务以独立的进程运行，并通过简单且定义良好的接口（API）与其他服务通信。

服务之间可以通过 HTTP 这样的同步协议通讯，或通过像 AMQP 这样的异步协议通信。



**迈向持续交付：DevOps 和 无运维**

理想情况是，开发者是部署程序本身，不需要知道硬件基础设施的任何情况，也不需要和运维团队交涉，这被叫做 NoOps。

很明显，你仍然需要有一些人来关注硬件基础设施，但这些人不需要再处理应用程序的独特性。

当一个应用程序仅有较少数量的大组件构成时（即单体架构）。完全可以接收给每个组件分配专用的虚拟机。给每个组件提供操作系统来隔离环境。

但是当这些组件开始变小且数量变多时，又不想浪费硬件资源。



## k8s功能



特点

- 声明式API：Declarative API，只用告诉其结果，余下的事情交给系统即可；
- 控制器模式：声明式 API 的后端，负载将现实状态转为用户期望的状态；
- Platform for Platform 
  - 纳管各种基础设施，统一到 Kubernetes API 之上
  - 存储、消息队列，监控、日志





## k8s基本概念



### **集群**

一个 Kubernetes 集群由一组被称作节点的机器组成。这些节点上运行 Kubernetes 所管理的容器化应用。

**一个集群具有至少一个工作节点和至少一个主节点。**

k8s集群分为两类节点

- master node
  - **Master 负责管理集群**, master 协调集群中的所有活动，例如调度应用程序、维护应用程序的所需状态、扩展应用程序和滚动更新。
  - 主节点，承载着 Kubernetes 控制和管理整个集群系统的控制面板。
- worker node (node)
  - **节点是 Kubernetes 集群中的工作机器，可以是物理机或虚拟机。**
  - 每个工作节点都有一个 kubelet，它是管理节点并与 Kubernetes Master 节点进行通信的代理。
  - 节点上还应具有处理容器操作的容器运行时，例如 [Docker](https://www.docker.com/) 或 [rkt](https://coreos.com/rkt/)。



一个 Kubernetes 工作集群至少有三个节点。master 管理集群， node 用于托管正在运行的应用程序。

当您在 Kubernetes 上部署应用程序时，您可以告诉 master 启动应用程序容器。master 调度容器在集群的工作节点上运行。

 节点使用 Master 公开的 Kubernetes API 与 Master 通信。用户也可以直接使用 Kubernetes 的 API 与集群交互。



### 控制平面

在 Kubernetes（k8s）中，**“控制平面”（Control Plane）** 是一个官方标准术语。

> **控制平面是 Kubernetes 集群的“大脑”**，负责管理集群的状态、调度工作负载、监控节点健康、处理用户请求等。 

它运行在 **主节点（Master Node）** 上（或高可用架构中的多个控制节点上），由一组核心组件构成。



**master 节点核心组件**

这些组件可以运行在单个 master 节点上，**也可以通过副本机制运行在多个 master 节点上以确保其高可用性。**

- etcd 是兼具一致性和高可用性的键值数据库，可以作为保存 Kubernetes 所有集群数据的后台数据库。可以内置在 master 中，也可以放到外面。
  
  - **键值存储（Key-Value Store）**：etcd 最基本的功能是作为键值存储，它允许用户存储和检索键值对。每个键都是唯一的，并且与一个值相关联。
  - **分布式（Distributed）**：etcd 是一个分布式数据库，这意味着它可以在多个节点上运行，并且每个节点都包含完整的数据副本。这种分布式的特性使得 etcd 具有高可用性和容错性，即使部分节点发生故障，整个系统仍然可以继续运行。
  - **一致性（Consistent）**：etcd 使用 Raft 一致性算法来确保所有节点上的数据副本保持一致。Raft 是一种为管理复制日志而设计的共识算法，它能够在网络不稳定或节点故障的情况下保持数据的一致性。
  
  - **存储集群状态**：etcd 存储了 Kubernetes 集群中的所有对象的状态信息，包括 Pods、Nodes、Services、Replication Controllers 等。这些信息对于集群的正常运行至关重要，因为它们用于调度任务、网络路由、服务发现等。
  - **服务发现**：etcd 可以帮助 Kubernetes 实现服务发现机制。当 Pod 被创建或更新时，其相关信息会被写入 etcd，其他 Pod 可以通过查询 etcd 来发现和使用这些服务。
  - **配置共享**：etcd 还用于存储集群的配置信息，如网络配置、API 服务器地址等。这些信息可以被集群中的任何组件访问，以实现配置信息的共享和动态更新。
  - **领导者选举**：在分布式系统中，领导者选举是一个常见的需求。etcd 提供了领导者选举的功能，使得 Kubernetes 集群中的组件（如 Controller Manager、Scheduler 等）可以通过选举来确定哪个节点应该担任领导者的角色。
  
  https://tzfun.github.io/etcd-workbench/
  
- kube-apiserver : 集群控制的入口，提供 HTTP REST 服务，主节点上负责提供 Kubernetes API 服务的组件；它是 Kubernetes 控制面的前端。
  
  - 它提供了 Kubernetes 各类资源对象（Pod、RC、Service 等）的增删改查及 watch 等 HTTP REST 接口，是整个系统的管理入口。
  
- kube-scheduler : 负责 Pod 的调度，该组件监视那些新创建的未指定运行节点的 Pod，并选择节点让 Pod 在上面运行。

- kube-controller-manager :  Kubernetes 集群中所有资源对象的自动化控制中心
  - 
  - 节点控制器（Node Controller）: 负责在节点出现故障时进行通知和响应。
  - 副本控制器（Replication Controller）: 负责为系统中的每个副本控制器对象维护正确数量的 Pod。
  - 端点控制器（Endpoints Controller）: 填充端点(Endpoints)对象(即加入 Service 与 Pod)。
  - 服务帐户和令牌控制器（Service Account & Token Controllers）: 为新的命名空间创建默认帐户和 API 访问令牌.

启动一个 nginx 服务，客户端向 apiserver 发送



**node 节点的组件**

- kubelet : 负责 Pod 的创建、启动、监控、重启、销毁等工作，同时与 Master 节点协作，实现集群管理的基本功能。
- kube-proxy : 实现 Kubernetes Service 的通信和负载均衡，负责组件之间的负载均衡网络流量。
- 运行容器化(Pod)应用
- Container Runtime ： 容器运行时环境， [Docker](http://www.docker.com/)、 [containerd](https://containerd.io/)、[cri-o](https://cri-o.io/)、 [rktlet](https://github.com/kubernetes-incubator/rktlet)  等等。

```shell
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

#　kubectl是一个用于操作kubernetes集群的命令行工具

kubectl version --client --output=yaml    

# 用法
kubectl [command] [TYPE] [NAME] [flags]

command: command意指你想对某些资源所进行的操作，常用的有create、get、describe、delete等。

TYPE: 声明command需要操作的资源类型，TYPE对大小写、单数、复数不敏感，支持缩写。

NAME: 即资源的名称，NAME是大小写敏感的。如果不指定某个资源的名称，则显示所有资源，如kubectl get pods 会显示Default命名空间下所有的pod

```



### k8s 核心概念

Pod: Pod 是 Kubernetes 最基本的部署调度单元。每个 Pod 可以由一个或多个业务容器和一个根容器(Pause 容器)组成。一个 Pod 表示某个应用的一个实例。

- kubernetes 中的大多数资源都可以缩写：replicationcontrollers是rc ，pods是po ，service是 svc 

- Pod: Pod 是 Kubernetes 最基本的部署调度单元。每个 Pod 可以由一个或多个业务容器和一个根容器(Pause 容器)组成。

  - 一个 pod 表示某个应用的一个实例，可以包含多个容器。

  - 一个 pod 中的容器共享命名空间（network 和 UTS ），每个 pod 内的容器共享同一个独立的主机名和网络接口。

  - 同样，这些容器也都在相同的IPC命名空间下运行，因此能够通过IPC进行通信。

    > 在最新版的 kubernetes 和 docker 版本中，它们也能够共享相同的 PID 命名空间，不过默认是未开启的。
    >
    > 当同一个 pod 中的容器使用单独的PID命名空间时，在容器中执行 ps aux 就只会看到容器自己的进程。
    >
    > 由于一个 pod 中的容器共享 network 命名空间，他们共享相同的 IP地址和端口空间。
    >
    > 所以同一pod中的容器运行的多个进程不能绑定到相同的端口号。
    >
    > 一个 pod 中的所有容器都具有相同的 loopback 网络接口，因此容器内可以通过 localhost 连接同一 pod 中的其他容器。

  

  - 当一个 pod 包含多个容器时，这些容器总是被调度到同一个工作节点上。

  - > 容器被设计为每个容器只运行一个进程。这是 docker 和 kubernetes 的设计哲学
    >
    > 由于不能将多个进程聚集在一个单独的容器中，所以
    >
    > kubernetes 通过

- ReplicationController 它确保始终存在运行中的 pod 实例，用于描述 pod 副本的数量。

  查看 kubectl get replicationcontrollers 或者   kubectl get rc

  增加期望副本数   kubectl scale  rc  rc_name --replicas=3

  再回头看 pods 时应该是3个了 kubetctl get pods 

  > 注意，kubernetes 的基本原则之一：不是告诉kubernetes应该执行什么操作，而是声明性的概念系统的期望状态。
  >
  > 并让 kubernetes 检查当前状态是否与期望的状态一致。

- ReplicaSet：是 Pod 副本的抽象，用于解决 Pod 的扩容和伸缩。

- Deployment：Deployment 表示部署，在内部使用 ReplicaSet 来实现。可以通过 Deployment 来生成相应的 ReplicaSet 完成 Pod 副本的创建。

- pod 是短暂的，可能由于各种原因pod挂掉，pod消失后，ReplicationController会启动新的pod，

- Service：Service 是 Kubernetes 最重要的资源对象。Kubernetes 中的 Service 对象可以对应微服务架构中的微服务。

  Service 的存在就是为了解决老pod挂了之后，启动的新pod地址发生变化，service 主要就是为了在固定的IP:port上对外暴露pod

  当一个服务创建后，在其生命周期内，IP地址不会变更，客户端应该通过其固定IP地址连接服务。

  服务表示一组或多组提供相同服务的pod的静态地址，到达服务IP:port的请求会被转发到术语该服务的一个容器的IP:port  

  Service 定义了服务的访问入口，服务的调用者通过这个地址访问 Service 后端的 Pod 副本实例。

  Service 通过 Label Selector 同后端的 Pod 副本建立关系，Deployment 保证后端Pod 副本的数量，也就是保证服务的伸缩性。

- label ：

- 

- namespace 
  - 用来隔离 pod 的运行环境 （默认情况下，pod 是可以互相访问的）
  - 使用场景
    - 多租户 k8s 集群
    - 多个不同项目环境





### kubectl

`kubectl` 本质上就是一个 **Kubernetes REST API 客户端**，它其实就是跟`api server`通讯。

```
kubectl config set-cluster kubernetes     \
--certificate-authority=/etc/kubernetes/pki/ca.pem     \
--embed-certs=true     --server=https://127.0.0.1:8443     \
--kubeconfig=/etc/kubernetes/bootstrap-kubelet.kubeconfig
```



**TLS Bootstrapping**

> 在一个 Kubernetes 集群中，工作节点上的组件（kubelet 和 kube-proxy）需要与 Kubernetes 控制平面组件通信，尤其是 kube-apiserver。
>
>  为了确保通信本身是私密的、不被干扰，并且确保集群的每个组件都在与另一个可信的组件通信， 我们强烈建议使用节点上的客户端 TLS 证书。
>
> 
>
> **TLS Bootstrapping** 是一种机制，允许 **未认证的 kubelet** 使用一个**临时的 Bootstrap Token** 向 API Server 发起连接请求，并申请一个**正式的客户端证书（client certificate）**，用于后续的身份认证。 



````bash
# 看集群节点
kubectl get nodes
kubectl describe node <node-name>   # 查看节点详细信息（资源、状态、污点等）

# 看集群组件状态（api-server、controller-manager、scheduler 等）
kubectl get componentstatuses       # 在新版本可能需要用 kubectl get --raw /healthz



# 看 Pod 列表
kubectl get pods -n <namespace>      # 默认namespace是 default
kubectl get pods -o wide -A          # 带 IP、节点信息，可以看到pod运行在哪个节点上

# 查看 Pod 详细状态
kubectl describe pod <pod-name> -n <namespace>

# 查看 Pod 日志
kubectl logs <pod-name> -n <namespace>
kubectl logs -f <pod-name> -n <namespace>   # 持续跟随日志
kubectl logs <pod-name> -c <container-name> # 多容器 Pod 指定容器

# 如果 Pod 崩溃/重启，查看上一次容器的日志
kubectl logs --previous <pod-name> -n <namespace>



# 进入容器交互终端
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh
kubectl exec -it <pod-name> -n <namespace> -- /bin/bash


# 查看 Service
kubectl get svc -n <namespace>
kubectl describe svc <svc-name> -n <namespace>

# 查看 Endpoint（服务实际指向的 Pod）
kubectl get endpoints -n <namespace>

# 看 Ingress
kubectl get ingress -n <namespace>
kubectl describe ingress <ing-name> -n <namespace>


# 查看命名空间事件（常用于找启动失败、调度失败原因）
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp


# 查看 Deployment、ReplicaSet、StatefulSet
kubectl get deploy -n <namespace>
kubectl describe deploy <deploy-name> -n <namespace>

# 查看资源使用情况（需 metrics-server）
kubectl top nodes
kubectl top pods -n <namespace>


# 查看资源 YAML
kubectl get pod <pod-name> -n <namespace> -o yaml

````





### Kubelet

Kubernetes 的设计是 **每个 Kubernetes 节点上都有一个 Kubelet 进程**，它是节点上的主要代理进程，负责：

- 管理该节点上的 Pod 和容器生命周期
- 与 API Server 通信
- 汇报节点状态和资源使用情况
- 通过 HTTP(S) 提供一些状态/指标接口



它的可执行文件是二进制文件`/usr/local/bin/kubelet`，配置文件通常是 `/etc/kubernetes/kubelet-conf.yml`

Kubelet 会通过 HTTP(S) 暴露多个端点（这些端点不会直接被访问和采集，通常被api server来代理），常见的有：

| 端点                | 作用                                                         |
| ------------------- | ------------------------------------------------------------ |
| `/metrics`          | 普通 Prometheus 格式指标（包含 Go runtime、自身性能指标）    |
| `/metrics/cadvisor` | 容器级别指标（cAdvisor 提供的 CPU、内存、磁盘、网络等）      |
| `/metrics/resource` | **metrics-server 专用的资源指标**（CPU/内存使用率，来源于 cAdvisor） |
| `/stats/summary`    | 原始资源统计数据（metrics-server 早期版本也会用到）          |



```bash
# 可以直接看看 kubelet 提供的数据（通过 API Server 代理）

kubectl get --raw "/api/v1/nodes/k8s-master01/proxy/metrics/resource"


# 看到 CPU 使用纳秒数、内存字节数等即时指标，这些就是 metrics-server 聚合的原始数据。
```





### 水平伸缩应用

```shell
# 使用最简单的命令在k8s中运行一个node.js应用
kubectl run kubia --image=luksa/kubia --port=8080 --generator=run/v1

# 列出pods
kubectl get pods

# 列出pods详细信息，包括pod运行的节点
kubectl get pods -o wide

# 创建服务对象
kubectl expose rc kubia --type=LoadBalancer --name kubia-http

# 查看服务
kubectl get services

# 查看ReplicationController
kube get rc 

# 增加期望的pod副本数
kubectl scale  rc  rc_name --replicas=3


# 当有多个pods时，请求会被随机调度到不同的pod，服务做为负载均衡挡在多个pod前面。


# 在kubernetes中，pod运行在哪个节点并不重要，只要它被调度到一个可以提供pod正常运行所需的cpu和内存的节点上就可以了

kubectl get pods -o wide 

kubectl describe pod kubia-hczji
```



### kubernetes各组件通讯

**kubeconfig** 是一种用于配置集群访问权限的文件机制。里面包含了连接 Kubernetes 集群所需的所有信息。



一个 kubeconfig 文件通常以 YAML 格式存储，其中组织了以下核心信息：

1. **clusters**：集群列表。每个集群都包含其 API 服务器的地址和用于验证其身份的证书信息。

2. **users**：用户列表。每个用户都包含用于向集群进行身份验证的凭证，比如客户端证书、令牌（token）或用户名/密码。

3. **contexts**：上下文列表。每个上下文都是一个三元组，由 **（集群、用户、命名空间）** 组成。

   一个上下文定义了当前操作的目标集群、使用的用户身份以及默认操作的命名空间。



当使用 `kubectl` 等命令行工具时，它会读取 kubeconfig 文件，并根据你选择的 **“当前上下文”** 来决定连接哪个集群、使用哪个身份认证、以及默认操作哪个命名空间。



## 为什么是pod？

一个 pod 是一组紧密关联的容器，它们总是一起运行在同一个工作节点上，以及同一个Linux命名空间中。



**容器的单进程模型**

**容器的“单进程模型”，并不是指容器里只能运行“一个”进程，而是指容器没有管理多个进程的能力。**



**容器和虚拟机对进程的管理能力是有着巨大差异的。不管在容器中还是虚拟机中都有一个1号进程，虚拟机中是 [systemd](https://man7.org/linux/man-pages/man1/init.1.html) 进程，容器中是 [entrypoint](https://docs.docker.com/engine/reference/builder/#entrypoint) 启动进程**。

然后其他进程都是1号进程的子进程，或者子进程的子进程，递归下去。这里的主要差异就体现在 systemd 进程对僵尸进程回收的能力。



**对于正常的使用情况，子进程的创建一般需要父进程通过系统调用 [wait() 或者 waitpid()](https://man7.org/linux/man-pages/man2/waitpid.2.html) 来等待子进程结束，从而回收子进程的资源。**

**除了这种方式外，还可以通过异步的方式来进行回收，这种方式的基础是子进程结束之后会向父进程发送 `SIGCHLD` 信号，基于此，父进程注册一个 `SIGCHLD` 信号的处理函数来进行子进程的资源回收就可以了**。记住这两种方式，后面还会涉及到。



> 僵尸进程：子进程终止后，其父进程没有对其资源进行回收，于是该子进程就变成了”僵尸进程“。在内核中，维护了一个僵尸进程的信息集合（包括PID, termination status, resource usage information）
>
> 只要僵尸进程未被移除（即通过系统调用wait()），那么一个僵尸进程就会占据内核进程表中的一个条目，一旦这张表被填满了，就不能再创建新的进程了。这也就是僵尸进程的危害。



僵尸进程的最大危害是对资源的一种永久性占用，比如进程号，系统会有一个最大的进程数 n 的限制，也就意味一旦 1 到 n 进程号都被占用，系统将不能创建任何进程和线程（进程和线程对于 OS 而言，使用同一种数据结构来表示，task_struct）。这个时候对于用户的一个直观感受就是 shell 无法执行任何命令，这个原因是 shell 执行命令的本质是 fork

如果子进程退出后，父进程没有对子进程残留的资源进行回收，就会产生僵尸进程。



那么如果父进程先于子进程退出的话，子进程的资源该由谁来回收呢？

父进程先于子进程退出，我们一般将还在运行的子进程称为孤儿进程，那么孤儿进程的资源谁来回收呢？

类 Unix 系统针对这种情况会将这些孤儿进程的父进程置为 1 号进程（也就是 systemd 进程），然后由 systemd 来对孤儿进程的资源进行回收。



因为容器里 PID=1 的进程就是应用业务本身，其他的进程都是这个 PID=1 进程的子进程。

可是用户编写的业务应用，并不能够像正常Linux操作系统里的 `init` 进程或者 `systemd` 那样拥有进程管理的功能。

比如，你的容器应用是一个 Java Web 程序（PID=1），然后你执行 docker exec 在后台启动了一个 Nginx 进程（PID=3）。

可是，当这个 Nginx 进程异常退出的时候，你该怎么知道呢？这个进程退出后的垃圾收集工作，又应该由谁去做呢？

在容器中，1 号进程一般是 entrypoint 进程，针对上面这种 **将孤儿进程的父进程置为 1 号进程进而避免僵尸进程** 处理方式，容器是处理不了的。

进而就会导致容器中在孤儿进程这种异常场景下僵尸进程无法彻底处理的窘境。

所以说，容器的单进程模型的本质其实是容器中的 1 号进程并不具有管理多进程、多线程等复杂场景下的能力。



如果一定要在容器中处理这些复杂情况，那么需要开发者对 entrypoint 进程赋予这种能力。这无疑是加重了开发者的心智负担，这是任何一项大众技术或者平台框架都不愿看到的尴尬之地。





除了「开发者自己赋予 entrypoint 进程管理多进程的能力」这一思路，目前的做法是，通过 Kubernetes 来管理容器。



在一个真正的操作系统里，进程并不是“孤苦伶仃”地独自运行的，而是以进程组的方式，“有原则的”组织在一起。

在这个进程的树状图中，每一个进程后面括号里的数字，就是它的进程组 ID（Process Group ID, PGID），对于操作系统来说，这样的进程组更方便管理。



举个例子，Linux 操作系统只需要将信号，比如 SIGKILL 信号，发送给一个进程组，那么该进程组中的所有进程就都会收到这个信号而终止运行。



**Kubernetes 项目所做的，其实就是将“进程组”的概念映射到了容器技术中，并使其成为了这个云计算“操作系统”里的“一等公民”。**



已知 rsyslogd 由三个进程组成：一个 `imklog` 模块，一个 `imuxsock` 模块，一个 `rsyslogd` 自己的 main 函数主进程。

这三个进程一定要运行在同一个namespace上，否则，它们之间基于 Socket 的通信和文件交换，都会出现问题。



对于这样三个必须要耦合在一起的进程。但不能将多个进程聚集在一个单独的容器中，我们需要另一种更高级的结构来组织容器。



k8s 可以将多个容器编排到一个 pod 里面，共享同一个 Linux Namespace。这项技术的本质是使用 k8s 提供一个 pause 镜像，也就是说先启动一个 pause 容器，相当于实例化出 Namespace，然后其他容器加入这个 Namespace 从而实现 Namespace 的共享。



一个有 A、B 两个容器的 Pod，不就是等同于一个容器（容器 A）共享另外一个容器（容器 B）的网络和 Volume 等namespace吗？

通过类似  docker run --net --volumes-from 这样的命令就能实现，如果这样做，容器 B 就必须比容器 A 先启动，这样一个 Pod 里的多个容器就不是对等关系，而是有先后依赖关系。



**在 Kubernetes 项目里，Pod 的实现需要使用一个中间容器，这个容器叫作 Infra 容器。**

在这个 Pod 中，Infra 容器永远都是第一个被创建的容器，而其他用户定义的容器，则通过 Join Network Namespace 的方式，与 Infra 容器关联在一起。

很容易理解，在Kubernetes 项目里，Infra 容器一定要占用极少的资源，所以它使用的是一个非常特殊的镜像，叫作：k8s.gcr.io/pause

这个镜像是一个用汇编语言编写的、永远处于“暂停”状态的容器，解压后的大小也只有 100~200 KB 左右。

在 Infra 容器“Hold 住”Network Namespace 后，用户容器就可以加入到 Infra 容器的 Network Namespace 当中了。

所以，如果你查看这些容器在宿主机上的 Namespace 文件（这个Namespace 文件的路径，我已经在前面的内容中介绍过），它们指向的值一定是完全一样的。



这也就意味着，对于 Pod 内的容器 A 和容器 B 来说：

- 它们可以直接使用 localhost 进行通信；
- 它们看到的网络设备跟 Infra 容器看到的完全一样；
- 一个 Pod 只有一个 IP 地址，也就是这个 Pod 的 Network Namespace 对应的 IP 地址；
- 当然，其他的所有网络资源，都是一个 Pod 一份，并且被该 Pod 中的所有容器共享；
- Pod 的生命周期只跟 Infra 容器一致，而与容器 A 和 B 无关。





Pod 是 `Kubernetes` 项目与其他单容器项目相比最大的不同，也是一位容器技术初学者需要面对的第一个与常规认知不一致的知识点。

现在仍有很多人把容器跟虚拟机相提并论，他们把容器当做性能更好的虚拟机，喜欢讨论如何把应用从虚拟机无缝地迁移到容器中。

但实际上，无论是从具体的实现原理，还是从使用方法、特性、功能等方面，容器与虚拟机几乎没有任何相似的地方；也不存在一种普遍的方法，能够把虚拟机里的应用无缝迁移到容器中。

因为，容器的性能优势，必然伴随着相应缺陷，即：它不能像虚拟机那样，完全模拟本地物理机环境中的部署方法。

所以，这个“上云”工作的完成，最终还是要靠深入理解容器的本质，即：进程。

实际上，一个运行在虚拟机里的应用，哪怕再简单，也是被管理在 systemd 或者 supervisord 之下的一组进程，而不是一个进程。这跟本地物理机上应用的运行方式其实是一样的。

这也是为什么，从物理机到虚拟机之间的应用迁移，往往并不困难。

可是对于容器来说，一个容器永远只能管理一个进程。更确切地说，一个容器，就是一个进程。这是容器技术的“天性”，不可能被修改。

所以，将一个原本运行在虚拟机里的应用，“无缝迁移”到容器中的想法，实际上跟容器的本质是相悖的。

这也是当初 Swarm 项目无法成长起来的重要原因之一：一旦到了真正的生产环境上，Swarm 这种单容器的工作方式，就难以描述真实世界里复杂的应用架构了。



Pod 是 Kubernetes 里的**原子调度单位**。这就意味着，Kubernetes 项目的调度器，是统一按照 Pod 而非容器的资源需求进行计算的。

所以，像 imklog、imuxsock 和 main 函数主进程这样的三个容器，正是一个典型的由三个容器组成的 Pod。

Kubernetes 项目在调度时，自然就会去选择可用内存等于 3 GB 的 node-1 节点进行绑定，而根本不会考虑 node-2。

像这样容器间的紧密协作，我们可以称为“超亲密关系”。这些具有“超亲密关系”容器的典型特征包括但不限于：

- 互相之间会发生直接的文件交换、
- 使用 localhost 或者 Socket 文件进行本地通信、
- 会发生非常频繁的远程调用、
- 需要共享某些 Linux Namespace（比如，一个容器要加入另一个容器的 Network Namespace）等等。

这也就意味着，并不是所有有“关系”的容器都属于同一个 Pod。比如，PHP 应用容器和 MySQL虽然会发生访问关系，但并没有必要、也不应该部署在同一台机器上，它们更适合做成两个 Pod。







### 通过 pod 合理管理容器

将 pod 视为独立的机器，其中每个机器只托管一个特定的应用。过去我们比较习惯于将各种应用程序塞进同一台主机。

由于 pod 比较轻量级，我们可以在几乎不导致任何额外的开销的前提下拥有更多的 pod 。 一般做法是将应用程序组织到多个 pod 中，每个 pod 只包含紧密相关的组件或进程 。 



**将多层应用分散到多个 pod 中**

虽然可以在单个 pod 中同时运行 web 服务和数据库这两个容器，但是这种方式并不值得推荐。

同一个 pod 的所有容器总是运行在一起。如果 web 和数据库在同一个 pod 中，那么两者将始终在同一个计算机上运行。



**基于扩容考虑而分割到多个 pod 中**

另一个不应该将应用程序都放到单一 pod 中的原因就是扩缩容。pod 也是扩缩容的基本单位。

对于 kubernetes ，它不能横向扩容单个容器，只能扩缩整个 pod 。

通常，web 和数据库有不同的扩缩容需求，所以我们倾向于分别独立地扩缩他们。数据库这样的后端服务，通常比无状态的前端web服务更多扩展。



**何时在 pod 中使用多个容器**

将多个容器添加到单个 pod 的主要原因是应用可能由一个主进程和一个或多个辅助进程组成。pod 应该包含紧密耦合的容器组（通常是一个主容器和支持主容器的其他容器）

比如，pod 中的主容器可以是一个仅服务于某个目录文件中的web服务，另一个容器（所谓sidecar）定期从外部源下载资源存储到这个服务器目录中。 



**决定何时在 pod 中使用多个容器**

当决定是将两个容器放入一个 pod 还是两个单独的 pod 时，我们应该问自己如下问题：

- 他们必须要一起运行还是可以分开在不同的主机运行？
- 他们代表的一个整体还是相互独立的组件？
- 他们必须一起扩缩容还是可以分别进行？

基本上，我们总是应该倾向于在单独的 pod 中运行容器，除非有特定的原因要求它们是同一 pod 的一部分。



**以 YAML 或 JSON 描述文件创建 pod**

pod 和其他 kubernetes 资源通常是通过向 kubernetes REST API 提供 JSON 或 YAML 描述文件来创建的。



```yaml
---
apiVersion: v1
kind: Pod
  metadata: "包括名称，命名空间，标签，关于该容器的其他信息"
  spec: "包含pod内容的实际说明，例如 pod 的容器，卷和其他数据"
  status: "包含运行中的pod的当前信息，例如 pod 所处的条件，容器的描述和状态，以及内部IP和其他基本信息"

# status部分包含只读的运行时数据，该数据展示了给定时刻的资源状态。而在创建新的pod时，永远不需要提供status部分


---

apiVersion: v1
kind: pod
metadata: 
    name: kubia-manual  # pod名称
spec:
   containers:
   - image: luksa:kubia # 创建容器所用镜像
     name: kubia        # 镜像名称
     ports:
     - containerPort: 8080  # 应用监听端口
       protocol: tcp

# 在pod定义中指定端口纯粹是展示性的，忽略他们对于客户端是否可以通过端口访问到pod不会带来任何影响。

# 请求kubectl来解释资源对象的定义，分别列出 apiVersion，kind，metadata，spec，status这些字段的含义。

# 请求pod中的定义
# kubectl explain pods 

# 深入理解pod.spec中各属性的定义
# kubectl explain pod.spec 

# 使用kubectl create命令从yaml中创建pod
# kubectl create -f kubia-manual.yaml
# kubectl create -f 命令可以从yaml或json中创建任何资源，不只是pod
```



**得到运行中pod的完整定义**

```shell
kubectl get po kubia-manaul -o yaml
```





**在 pod 列表中查看新创建的 pod**

```shell
kubectl get pods
```



**查看应用程序日志**

小型 node.js 应用将日志记录到进程的标准输出，容器化应用程序通常会将日志记录到标准输出和标准错误。而不是写入文件。

我们要 ssh 登陆到 pod 运行的节点上，在 docker 中，我们通常用 docker logs containerID 来查看容器的日志



如果 pod 包含多个容器，在运行 kubectl logs -c 容器名称 来显式指定容器名称



```
```





#### 使用标签来组织pod

在实际部署应用程序时，大多数用户最终将运行很多 pod 。随着 pod 数量的增加，将它们分类到子集的需求也就明显了。

在微服务架构中，部署的微服务数量可以轻松超过20个甚至更多。这些组件可能是副本（同一组件的多个副本）或多个不同的版本（dev,stable,beta）。如果没有有效的组织管理，将导致巨大的混乱。

**标签是一种简单却功能强大的 kubernetes 特性，不仅可以组织 pod ，也可以组织 kubernetes 所有资源。**

标签是可以附加到资源的任意键值对。一个资源可以拥有多个标签。可以通过标签来选择特定的资源。

举个例子，在微服务中，组织两个标签：

- app 用于指定 pod 属于哪个应用，组件或微服务。
- rel 用于指定 pod 中运行的应用程序版本是 stable,beta,canary。



**创建 pod 时指定标签**

现在，可以通过创建一个带有两个标签的 pod 的YAML文件 **kubia-manual-with-labels.yaml**

```YAML
---
# https://github.com/luksa/kubernetes-in-action/blob/master/Chapter03/kubia-manual-with-labels.yaml
apiVersion: v1
kind: Pod
metadata:
  name: kubia-manual-v2
  labels:
    creation_method: manual
    env: prod
spec:
  containers:
  - image: luksa/kubia
    name: kubia
    ports:
    - name: http
      containerPort: 8080
      protocol: TCP
```

其中，metadata.label 部分指定了 creation_method = manual 和 env = prod 两个标签。

```shell
# 创建pod
kubectl create -f kubia-manual-with-labels.yaml

# 查看pod,列出lable字段
kubectl get po --show-labels

# 将每个label做为输出的列字段
kubectl get po -L creation_method,env

# 为已存在的pod添加label
kubectl label po kubia-manual creation_method=manual
# 为已存在的pod修改现有label,带上--overwrite选项
kubectl label po kubia-manual-v2 env=debug --overrite


# 通过一定标签规则选择pod

```

##### 修改现有pod 上的标签

```bash
#为 pod kubia-manual添加creation_method=manual 标签
kubectl label po kubia-manual creation_method=manual 

#修改env=test为env=debug
kubectl label po kubia-manual-v2 env=debug --overwrite 


# 使用标签选择器过滤出pod （或者 !=、env in 、env not in）  
kubectl get po -l creation_method=manual 

```



#### 使用标签来组织工作节点

如前所述，pod 并不是唯一可以附加标签的 kubernetes 资源。标签可以附加到任何 kubernetes 对象上。包括节点。

通常，当运维团队向集群中添加新节点时，可以通过附加标签来对节点进行分类。比如根据硬件类型分类。GPU



```shell
# 通过kube get nodes来获取node信息
# 然后对某个node添加标签
kubectl label node gke-kubia-85f6-node-0rrx gpu=true

# 列出带有某个标签的node
kube get nodes -l gpu=true
```



##### **将pod调度到特定节点**

某些情况下，pod 需要被调度到符合条件的节点中。

假设现在有一个需要gpu来执行其工作的pod，为了让调度器将其调度到适当GPU的节点上，可以使用如下pod定义文件。

```yaml
---
# https://github.com/luksa/kubernetes-in-action/blob/master/Chapter03/kubia-gpu.yaml
apiVersion: v1
kind: Pod
metadata:
  name: kubia-gpu
spec:
  nodeSelector:
    gpu: "true"
  containers:
  - image: luksa/kubia
    name: kubia
```

**通常，我们不应该强调将 pod 直接调度到某一个节点上，虽然 kubernetes 可以这样做，因为这样会使应用程序与基础架构强耦合。违背了 kubernetes 对运行在其上的应用程序隐藏实际的基础架构的整个构想。**

所以更好的做法是通过标签的方式来描述 pod 对节点的需求，从而让调度器只在提供符合需求的节点中进行选择。



#### 注解 pod 



除标签外，pod 和其他对象还可以包含注解。注解也是键值对。所以它们本质上与标签非常相似。但与标签不同，注解不是为了保存标识信息而存在。它们不能像标签一样用于对对象进行分组。

向 kubernetes 引入新特性时，



**查找对象的注解**

```bash
kubectl get po kubia-zxzij -o yaml
```





**添加和修改注解**

可以在创建 pod 的时候添加注解，也可以在现有的 pod 中添加或修改注解。

```shell
kubectl annotate  pod kubia-manual mycompany.com/someannotation="foo bar" 
```



### 使用命名空间对资源分组

**命名空间（Namespace）**是 Kubernetes 提供的一种将集群资源进行逻辑分组和隔离的机制。

- **隔离和组织资源：** 命名空间的主要作用是为 Kubernetes 中的资源（如 Pods、Services、Deployments 等）提供一个“作用域”。在一个集群中，你可以为不同的项目、团队或环境（如开发、测试、生产）创建各自独立的命名空间。这样可以避免不同团队或项目之间的资源名称冲突，即使两个命名空间里都有一个叫 `nginx` 的 Pod，它们也是完全独立的。
- **权限控制：** 命名空间是实现权限管理的重要工具。你可以通过配置 **RBAC (基于角色的访问控制)** 规则，限制某个用户或团队只能访问或操作特定命名空间内的资源，从而增强集群的安全性。



**kubernetes 命名空间**，简单地为对象提供了一个作用域。我们并不会将所有资源都放在同一个命名空间中。而是将它们组织到多个命名空间中。这样允许我们多次使用相同的资源名称（跨不同的命名空间）

在使用多个 namespace 的前提下，我们将包含大量组件的复杂系统拆分为更小的不同组。**典型的多租户场景**

如果有多个用户和用户组在使用同一个集群，并且它们都管理各自独特的资源集合。那么它们就应该分别使用各自的命名空间。这样一来，它们就不用特别担心无意中修改或删除其他用户的资源。

命名空间的隔离只是逻辑上的隔离，不同命名空间之间的 pod 并不存在网络隔离，它们之间可以通过IP地址进行通讯。资源名称只需在命名空间内保持唯一即可。

```bash
# 查看集群内的所有namespace
kubectl get ns

# 查看某个namespace下的pod
kubectl get po --namespace kube-system

# 


# 可以使用 --namespace 或其简写 -n 标志来指定要查看的命名空间。
kubectl get pods --namespace=kube-system

# 查看所有命名空间的 Pods
kubectl get pods -A

# 如果你经常在一个命名空间里工作，可以把它设置为你的默认命名空间，这样后续的 kubectl 命令就不用每次都手动指定了。
kubectl config set-context --current --namespace=my-dev-ns
```

#### 创建 namespace

命名空间和其他资源一样，可以通过把YAML提交给`Kunernetes API Server`来创建该资源。



#### 管理命名空间中的对象

如果想要在 namespace 中创建资源，可以选择在 YAML 的 metadata 字段中添加一个 namespace: custom-namespace 属性。

也可以在 `kubectl create` 命令中创建资源时指定命名空间。-n 来指定资源所属 namespace 。

比如，创建 pod 时使用 :

```shell
# 创建pod时指定pod所属的命名空间
kubectl create -f kubia-manual.yaml -n custom-namespace
```

### 停止和移除 pod 

```shell
# 按照名称来删除pod。删除多个pod则用空格分割多个pod名称
# 在删除pod的过程中，实际上是指示kubernetes终止该pod中的所有容器，发送 SIGTERM 信号并等待30s使其正常关闭。
kubectl delete po kubia-gpu  pod1 pod2


#　使用标签选择器删除
kubectl delete po -l creation_method=manual


# 通过删除命名空间来删除其空间下的所有pod


#　删除命名空间下的所有资源,kubectl命令有上下文，这是指删除当前上下文的命名空间中的所有资源
#　第一个 all 指删除所有资源类型
#　--all 指定删除所有资源实例
kubectl delete all --all
```



### 标签

通过标签来组织 pod 和其他所有 kubernetes 资源对象。标签是可以附加到资源的任意键值对。

不仅仅是pod，其实是node也可以可以打标签的，比如添加node工作节点，可以打上标签，指定硬件类型等等。比如GPU节点，超高性能SSD节点等等。

标签可以在资源对象创建时跟着一起打上，也可以后续修改。





当谈到使用标签（Labels）来控制 Kubernetes 调度时，我们通常指的是以下三种核心机制：

1. **节点亲和性（Node Affinity）**：Pod 喜欢（或必须）被调度到哪些节点上。
2. **节点污点（Taints）**：节点排斥 Pod，除非 Pod 明确允许被调度到该节点上。
3. **节点容忍度（Tolerations）**：Pod 允许被调度到有污点的节点上。

这三个机制协同工作，共同决定了 Pod 最终会运行在哪个节点上。



节点亲和性（Node Affinity）是 Pod 的一个属性，它告诉调度器这个 Pod 更倾向于（或必须）被调度到具有特定**标签**的节点上。这是一种“拉”（pull）机制，Pod 主动选择节点。





### pod注解

注解其实也是键值对，本质上跟标签有点类似。但是作用不同，不是用于保存标识信息或者分组而存在的。**相对而言，标签应该简单，注解应包含相对更多的数据。**

注解也一样，可以跟着资源对象创建而创建，也可以后续修改

### 外部跟pod通讯

将本地网络端口转发到pod中

```bash
# 出于调试等目的，将宿主机的5000端口映射到pod的6000端口上
kubectl port-forward pod/mypod 5000 6000
```





## 副本机制和控制器

**pod 代表了 kubernetes 中的基本部署单元，虽然我们也可以手动创建管理它们。在实际应用中，我们几乎不会去手动管理 pod 。**而是使用 `ReplicationController `或 `Deployment` 这样的资源对象来管理 pod 。

只要将 pod 调度到某个节点，该节点上的 kubelet 就会运行 pod 的容器，如果容器主进程崩溃，kubelet 会将容器重启。

如果是直接创建pod，pod被调度到某个node上，但是如果整个node挂了，那么节点上的pod也都会挂掉不会被调度到其他node上。



### 保持 pod 健康

使用 kubernetes 的一个主要好处是，可以声明一个容器列表，由 kubernetes 来保持容器在集群中的运行。由 kuberneter 自动选择调度节点。

只要将 pod 调度到某个节点，该节点上的 kubelet 就会运行 pod 的容器。只要该pod存在，就会保持运行。如果容器主进程挂掉，kubelet就会自动重启容器。



### 存活探针（liveness probe）

kubernetes 可以通过 **存活探针** 检查容器是否还在运行。可以为 pod 中的每个容器单独指定存活探针。

**kubernetes 容器探测机制**

- 基于 `HTTP GET` 的存活探针，对容器的IP地址端口执行 `HTTP GET` 请求。通过状态码判断
- TCP套接字探针，尝试建立TCP链接，不能建立则重启容器。
- Exec 探针在容器内执行任意命令，通过返回的状态码，来确定是否探测成功。



#### 基于 HTTP 的存活探针

```shell
# 基于下面那段node应用来构建docker image
FROM node:7
ADD app.js /app.js
ENTRYPOINT ["node", "app.js"]


# 这是一个简单的nodejs应用，启动http服务后被访问超过5次，就会返回http500状态码
# https://github.com/luksa/kubernetes-in-action/blob/master/Chapter04/kubia-unhealthy/app.js



# 基于下面这个YAML文件创建pod
# https://github.com/luksa/kubernetes-in-action/blob/master/Chapter04/kubia-liveness-probe.yaml

apiVersion: v1
kind: Pod
metadata:
  name: kubia-liveness
spec:
  containers:
  - image: luksa/kubia-unhealthy
    name: kubia
    livenessProbe:
      httpGet:
        path: /
        port: 8080   
	initialDelaySeconds: 15
	periodSeconds: 20
    timeoutSeconds: 5
    failureThreshold: 5




# livenessProbe定义了HTTP存活探针，Kunernetes会定期请求这个pod的8080端口，路径是/

# initialDelaySeconds:容器启动后，在第一次执行探针之前需要等待的秒数。这给了容器足够的时间来初始化和启动，避免探针过早失败。默认是15秒
# periodSeconds: 探针执行频率：即每隔多少秒执行一次探针。默认是10秒
# timeoutSeconds:探测超时时间。如果探针在设定的时间内没有得到响应，则会被判定为失败。默认是1秒
# failureThreshold:探针被认定为失败之前，需要连续失败的次数。默认是3次

```

> 当容器被强行终止时，会创建一个全新的容器——而不是重启原来的容器。
>
> 查看日志是



#### 配置探针属性

在 `kubectl describe pod kubia-liveness` 中，可以看到探针的一些属性：

- delay（延迟）       delay=0s 部分指示容器启动后立刻开始探测。
- timeout（超时）  timeout=1s 部分指示容器必须在1s内响应
- period（周期）    period=10s 只是每10s进行一次探测
- 





在 Pod 的 YAML 配置中，`livenessProbe` 是定义在每个**容器**（`containers`）下的。这意味着你可以为 Pod 中的每个容器单独设置一个存活探针。

**定义探针时可以自定义这些参数，如果没有设置初始延时，探针将在启动时立即开始探测容器，通常会导致探测失败。**



**存活探针，对于生产上运行的pod，一定要定义一个存活探针**





### ReplicationController

ReplicationController是一种Kubernetes资源对象，也是一类控制器，可确保它的pod始终保持运行状态。如果pod因任何原因消失（例如节点从集群中消失或由于该pod已从节点中逐出），则rc会注意到缺少了pod并创建替代pod。

一般而言，rc旨在创建和管理一个pod的多副本，rc 会持续监控正在运行的 pod 列表，并保证相应类型 的 pod 数量与期望相符。少了会创建副本，对了会删除多余的副本。



**rc 协调流程**

rc 的主要工作是确保 pod 数量始终与其标签选择器匹配



一个 rc 主要有三个部分：

- `label selector` 确定 rc 作用域的 pod 范围 
- `relica count` 确定 pod 副本数量，指定应运行 pod 的数量
- `pod template` 用于创建新 pod 副本的模板

**rc 中的标签选择器，副本数量都可以随时修改，但是只有副本数量的变更会影响现有 pod** 



> 更改标签选择器和 pod 模板对现有 pod 没有影响。更改标签选择器会使现有的 pod 脱离 rc 的范围。在创建 Pod 后，ReplicationController 也不关心其 pod 的实际“内容”（容器镜像、环境变量及其他）。
>
> 因此，该模板仅影响此 ReplicationController 创建的新 pod。可以将其视为创建新 pod 的曲奇切模（cookie cutter）。
>
> 《 Kubernetes In Action 》

ReplicationController 的 pod 模板可以随时修改。更改 pod 就像用一个曲奇刀替换另一个。它只会影响你之后切出的曲奇，并且不会影响你已经剪切的曲奇。

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: kubia
spec:
  replicas: 3
  selector:								# 这个选择器决定了rc作用域中有哪些pod
    app: nginx
  # 这里定义的就是 cookie cutter
  template:							    # 创建新pod所用的pod模板
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

Kubernetes 会创建一个名为`kubia`的新rc，它确保符合标签选择器app=nginx的pod实例时钟是三个。

**模板中的 pod 标签必须和 rc 的标签选择器匹配，否则，rc 将会无休止的创建新容器。**

如果你想切出不一样的饼干，更换模具即可，至于之前已经做好的饼干，你也无法改变了。就像你曾经走过的路啊，终究会是你人生的烙印。

```shell
kubectl create -f kuba-rc.yaml

# 获取rc的信息
kubectl get rc

# 获取rc的详细信息
kubectl describe rc kubia

```





由 rc 创建的 pod 并不是绑定到 rc 中。在任何时刻，rc 只管理与 rc 标签选择器匹配的 pod 。通过直接修改 pod 的标签，可以将其从 rc 的作用域中添加或删除。

当你向 rc 管理的 pod 添加其他标签，它并不关心，因为对于 rc 来说，并没有什么变化，rc 只关注匹配到标签的 pod 。

**从 rc 中删除 pod** 

当你想操作特定 pod 时，从 rc 管理范围内移除某个 pod 很有用，







#### 伸缩集群的声明式方法

**在 kubernetes 中水平伸缩 pod 只是陈述式的：“ 我想要运行 x 个实例 ” 。你不是告诉 kubernetes 做什么或如何去做。只是指定了期望的状态。**

这种声明式做法使得与 kubernetes 集群的交互更容易。试想，如果你必须手动确认当前运行的实例数量，再去指定 kubernetes 运行多少个实例。工作容易出错且更复杂。



#### 删除 rc



### ReplicaSet

最初，ReplicationController 是用于复制和异常时重新调度节点的唯一组件。后来引入了 RepliaSet 这种资源。它是新一代的 rc。请记住，始终使用 rs ，而不是使用 rc 。



ReplicaSet 的行为与 rc 完全相同，但 pod 的选择器的表达能力更强。

- 单个 rc 无法同时匹配两个标签，即无法匹配到同时存在 env=pro 和 env=dev 的容器。而 RepliaSet 可以。 
- rc 无法通过标签名来匹配 pod 。即 rc 无法匹配 env=* 的容器。



**ReplicationController** 只支持**基于等值**的标签选择器。这意味着它只能通过 "key=value" 的方式来匹配 Pod，例如 `app=nginx`。

**ReplicaSet** 支持**基于集合**的标签选择器。这使得它的匹配规则更灵活、更强大，例如它可以匹配 `app in (nginx, httpd)` 或者 `tier notin (frontend, backend)`，甚至是 `env=*` 这种。

由于 ReplicaSet 的选择器功能更强，它能够更精确地控制和管理 Pod，因此 Kubernetes 官方**更推荐使用 ReplicaSet**。

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
spec:
  # 副本数量，这里设置为3
  replicas: 3
  # 标签选择器，用于查找和管理Pod
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      # Pod的标签，必须和上面的选择器匹配
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```



```shell
kubectl get rs 

kubectl describe  rs 

# 更加丰富的选择器，可以对key-value选择运算符
selector:
  matchExpresssions:
  	- key: app
	  operator: In
	  values:
	    - kubia


# 运算符有:In,NotIn,Exists,DoesNotExist四种方式
```



### DaemonSet

rc 和 rc 都用于在 kubernetes 集群上部署特定数量的 pod 。但是当你希望在集群中的每个节点上都要运行 pod 时（并且每个节点正好要运行一个 pod ）。

例如，希望在每个节点上运行日志收集器和资源监控器。另一个典型的例子是 kubernetes 自己的 `kube-proxy` 进程。它需要运行在所有节点上才能工作。

在二进制部署Kubernetes场景，`kube-proxy`是在node上运行的二进制进程，而不是被打到pod中运行。如果节点下线，DaemonSet不会再其他地方重新创建pod，但是如果有新节点加入集群，DaemonSet立即会部署一个新pod实例。

DaemonSet的目的是运行系统服务，即使是再不可调度的节点上，系统服务通常也需要要运行



### job

Job 表示一次性任务，运行完成后就会停止。比如说爬虫这种就很适合pod，以及某些定时任务，数据同步任务等等





## 服务：让客户端发现 pod 并与之通信

现在已经学习过了 pod ，以及如何通过 rs 和类似资源部署运行。尽管特定的 pod 可以独立的应对外部刺激，现在大多数应用都需要根据外部请求做出响应。

例如，就微服务而言，pod 通常需要对来自集群内部的其他 pod ，以及来自外部客户端的 HTTP 请求做出响应。



在没有 kubernetes 的世界，一般需要在配置文件中明确指出服务端的IP地址来使用。在 Kubernetes 中并不适用。

- pod 是短暂的，它们随时会被启动或者关闭。

- kubernetes 在pod启动前会给已经调度到node上的pod分配IP提前，客户端不能提前知道提供服务的pod地址。

- 水平伸缩意味着多个pod可能会提供相同的服务——每个pod都有自己的ip，客户端无需关心pod数量以及各自对应ip

  

**服务是一种做为一组功能相同的 pod 提供单一不变的接入点的资源。kubernets 使用服务来暴露应用。**

**当服务存在时，它的 IP 地址和端口不会变。客户端通过 IP 地址和端口号建立连接，这些连接会被路由到提供该服务的任意一个 pod 上。** 





### 创建服务

创建服务一般有两种方法：

```shell
#　创建一个服务对象
kubectl expose rc kubia --type=LoadBalancer --name kubia-http


```

通过YAML描述文件来创建服务，定义服务的端口，服务将连接转到的容器端口，标签选择器匹配到的 pod 都属于该服务。

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kubia
spec:
  ports:
  - port: 80					#  服务端口
    targetPort: 8080			#  后端提供服务，服务转发要连接到pod上的端口
  selector:
    app: kubia
```

通过 `kubernetes create` 命令创建服务后，可以在命名空间下列出所有服务资源 `kubectl get svc `

列表可以显示出分配给服务的 IP 地址，一般是集群内部的地址，只能在集群内部被访问。但是服务一般要被集群内部其他 pod 访问，以及外部客户端访问。

先看内部访问的几种方法：

- 创建一个 pod ，它将请求发送到服务的集群 IP 并记录响应
- 通过 ssh 远程到其中一个 kubernetes 节点上，然后执行 curl 命令
- 通过 kubectl exec 命令在一个已存在的 pod 中执行 curl 命令



可以使用 `kubectl exec` 命令远程地在一个已经存在的 pod 容器上执行任何命令。使用 `kubectl get pod` 列出所有 pod 

```shell
kubectl exec kubia-7nogl -- curl http://10.111.249.153

# 双斜杠代表着 kubectl 命令的结束。表示后面的命令其实是在pod内的容器上运行

# 当一个 Pod 包含多个容器时，kubectl exec 命令默认会选择 Pod 定义中列出的第一个容器来执行操作。
# 如果你想在 Pod 的特定容器上运行命令，你需要使用 --container 或 -c 参数来明确指定容器的名称。

kubectl exec kubia-7nogl -c proxy -- curl http://10.111.249.153

```



### 同一个服务暴露多个端口

创建的服务可以暴露一个端口，也可以暴露多个端口。比如，pod 监听两个端口，http 监听 8080 端口，https 监听 8443 端口。

可以在一个服务中暴露 80 和 443 端口，并分别转发到 pod 中的对应端口。通过一个集群IP，使用一个服务将多个端口暴露出来。

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kubia
spec:
  ports:
  - name: http
    port: 80
    targetPort: 8080
  - name: https
    port: 443
    targetPort: 8443
  selector:
    app: kubia
```

标签选择器将应用于整个服务，如果



### 使用命名的端口

可以看到上面这种方式，在 pod 定义中直接指定端口号，然后在服务的定义中也直接硬编码写端口号，一旦 pod 修改端口号，svc 中的定义也需要修改。

使用命名端口的意思：即在 pod 定义中为端口命名，在 svc 中直接将端口转发到名称中。

```yaml
kind: pod
spec:
  containers:
  - name: kubia
  	ports:
  	- name: http
      ContainerPort: 80
  	- name: https
      ContainerPort: 80
  
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kubia
spec:
  ports:
  - name: http
    port: 80
    targetPort: http
  - name: https
    port: 443
    targetPort: https
  selector:
    app: kubia
```





### 服务发现

通过创建服务，可以通过一个单一稳定的 IP 地址访问到 pod。在服务的整个生命周期内这个IP地址保持不变（pod后面的pod可能删除重建，IP地址也会变化，数量可能也会增减）

客户端 pod 如何知道服务的 IP 地址和端口呢？Kubenretes提供了服务发现机制



#### 通过环境变量发现服务

在 pod 开始运行的时候，kubernetes 会初始化一系列的环境变量指向现在存在的服务。

如果你创建的服务早于客户端 pod 的创建，pod 上的进程可以根据环境变量获得服务的 IP 地址和端口号。但是如果服务晚于pod的创建，pod诞生时自然无法设置服务的环境变量。



#### 通过 DNS 发现服务

在 kube-system 命名空间下，其中一个 pod 被称为 kube-dns 。这个 pod 运行 DNS 服务。在集群中的其他 pod 都被配置为使用其做为 DNS。

kubernetes 通过修改每个容器的 /etc/resolv.conf 文件实现。

运行在 pod 上的进程 DNS 查询都会被 kubernetes 自身的 DNS 服务器响应。该服务器知道系统中运行的所有服务。

> **pod 是否使用内部的 DNS 服务是根据 pod 中的 spec 的 dnsPolicy 属性来决定的。**



每个服务从内部 DNS 服务器中获得一个 DNS 条目，客户端的 pod 在知道服务名称的情况下通过**全限定域名（FQDN）**来访问。





### 连接集群外部的服务

服务并不是直接和 pod 相连接的。

如果创建了不包含选择器的服务，kubernetes 将不会创建 Endpoint 资源，（毕竟，缺少选择器，将不会知道服务中包含那些 pod ）



这样就需要



Endpoint 是一个单独的资源并不是服务的一个属性。由于创建的资源中并不包含选择器，相关的 Endpint 资源并没有自动创建，所以必须手动创建。

```
root@k8s-master01:~#
root@k8s-master01:~# kubectl describe svc
Name:                     kubernetes
Namespace:                default
Labels:                   component=apiserver
                          provider=kubernetes
Annotations:              <none>
Selector:                 <none>
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.96.0.1
IPs:                      10.96.0.1
Port:                     https  443/TCP
TargetPort:               6443/TCP
Endpoints:                10.10.20.151:6443,10.10.20.152:6443,10.10.20.153:6443
Session Affinity:         None
Internal Traffic Policy:  Cluster
Events:                   <none>
root@k8s-master01:~#
```





### 将服务暴露给外部客户端



有几种方式可以在外部访问服务：

- 将服务的类型设置为 NodePort —— 每个集群节点都会在节点上打开一个端口。
- 



#### NodePort 

这种服务的工作原理：它在集群的**每个节点**（Node）上都开启一个静态端口（例如 `30001`）。所有发送到任意节点的这个静态端口的流量，都会被自动转发到 Service 对应的 Pod 上。

- **端口范围**：这个静态端口通常在 `30000-32767` 这个范围内。
- **简单**：无需额外的配置或云服务，只要知道任意一个节点的 IP 和 NodePort 端口，就可以访问服务。
- **适用于开发和测试**：因为它不需要额外的基础设施，非常适合本地开发、演示和快速测试。



将一组 pod 公开给外部客户端的第一种方法是创建一个服务并将其类型设置为 NodePort 

通过创建的 `NodePort` 服务，可以让 kubernetes 在其所有节点上打开一个端口（所有节点上都是用相同的端口号，这是也是NodePort名字原来），并将在该端口接收到的流量重定向给服务（其实是服务背后的pod）。

这与常规服务类似（它们实际的类型是 ClusterIP），但是不仅可以通过服务的内部集群 IP 访问 NodePort 服务。还可以通过任何节点的 IP 和预留节点端口访问 NodePort 服务。当尝试与 NodePort 服务交互式，意义更大。





```yaml
# https://github.com/luksa/kubernetes-in-action/blob/master/Chapter05/kubia-svc-nodeport.yaml
---

apiVersion: v1
kind: Service
metadata:
  name: kubia-nodeport
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 30123
  selector:
    app: kubia

# Type设置svc的类型为NodePort
# port: 80 服务器集群IP的端口号
# targetPort: 8080 背后pod的目标端口号
# nodePort: 30123 通过集群节点的30123端口号可以访问服务
```



查看 NodePort 类型的服务

```shell
kubectl get svc kubia-nodeport 

```



NodePort 暴露的服务，是通过将所有 pod 所在节点上对外暴露的方式提供，一旦其中一个节点挂掉，那么直接访问这个节点自然也无法成功。

**找到节点 IP** 

可以在节点的 JSON 或者 YAML 描述中找到IP。



#### 通过负载均衡器暴露服务

`LoadBalancer` 是在云环境中暴露服务的标准方式

当你创建一个 `LoadBalancer` 类型的 Service 时，Kubernetes 会请求底层的云服务商（如 AWS, GCP, Azure）创建一个外部负载均衡器。这个负载均衡器会获得一个独立的**公网 IP 地址**。

所有外部流量都通过这个公网 IP 地址进入，然后由负载均衡器将流量分发到集群中的各个节点上，再由节点转发给对应的 Pod。



k8s 并没有为裸机集群实现负载均衡器，因此我们只有在以下 IaaS 平台（GCP, AWS, Azure）上才能使用 LoadBalancer 类型的 service。

因此裸机集群只能使用 NodePort 或者 `externalIPs service` 来对面暴露服务，然而这两种方式和 `LoadBalancer service` 相比都有很大的缺点。

而 `MetalLB` 的出现就是为了解决这个问题。







#### 通过 Ingress 暴露服务

**Ingress 是 Kubernetes 中用于管理对集群内服务的外部访问的 API 对象。** 它主要提供 HTTP 和 HTTPS 路由。

Ingress 本身只是一个**规则集合**，它并没有实际的流量处理能力。要让 Ingress 规则生效，你需要一个**Ingress 控制器（Ingress Controller）**。

Ingress 控制器是 Kubernetes 集群中一个真正的应用程序，它负责监听 Ingress 资源的变化，并根据这些规则来配置一个反向代理或负载均衡器。常见的 Ingress 控制器有：

- **Nginx Ingress Controller**：最常用和最流行的选择。
- **Traefik**：轻量级且功能强大。
- **HAProxy**
- **GCE/AWS Load Balancer**：云服务商的负载均衡器。



想象一下，你没有 Ingress。如果你想让外部用户访问你的两个服务（比如 `blog` 和 `shop`），你可能有以下两种选择：

1. **使用 `LoadBalancer` 类型的 Service**：你需要为每个服务创建一个 `LoadBalancer`，这会产生两个独立的公网 IP。如果你有 10 个服务，就需要 10 个公网 IP，成本很高。
2. **使用 `NodePort` 类型的 Service**：你需要给每个服务分配一个 `NodePort` 端口，然后通过 `NodeIP:Port` 的方式访问。这不仅端口不友好，而且缺乏高可用性。

Ingress 的出现，就是为了解决这些问题。它允许你用**一个统一的入口**（一个公网 IP 或一个负载均衡器）来管理所有服务的外部访问。



可以将 `Ingress` 理解为 Service 的网关，它是所有流量的入口，通过 `Ingress` 我们就能以一个集群外部可访问的 URL 来访问集群内部的 Service。

根据 Ingress NGINX Controller [官方的部署文档](https://kubernetes.github.io/ingress-nginx/deploy/)，我们大致有两种方式来部署它：

- 第一种是通过 Helm 部署
- 第二种是通过 `kubectl apply` 部署

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```





## kubernetes-api

Kubernetes API 使你可以查询和操纵 Kubernetes 中对象的状态。 **Kubernetes 控制平面的核心是 API Server 和它暴露的 HTTP API。** 用户、集群的不同部分以及外部组件都通过 API 服务器相互通信。

```bash
# 查看所有API
kubectl api-resources


# 要查看Kubernetes 集群的API，可以使用 kubectl api-versions 命令来获取支持的API 版本列表，或者使用 kubectl explain 命令来获取特定资源类型的API 详细信息。
kubectl api-versions


# kubectl explain 命令可以用来查看Kubernetes 资源类型的API 详细信息，包括字段、类型和描述。
kubectl explain pod


# 此外，kubectl get --raw 命令可以直接访问Kubernetes API 服务器，用于更底层的调试和探索。
kubectl get --raw /api/v1/namespaces/kube-system/pods

```





# kubernetes 学习资料

>  
>
>  kubernetes-in-action-second-edition
>
>  https://livebook.manning.com/book/kubernetes-in-action-second-edition/
>
>  代码 https://github.com/luksa/kubernetes-in-action-2nd-edition
>
>  What happens when I type kubectl run?
>
>  https://github.com/jamiehannaford/what-happens-when-k8s/blob/master/zh-cn/README.md
>
>  
>
>  
>
>  
>
>  才云科技 kubernetes 学习路径规划
>
>  https://github.com/caicloud/kube-ladder







# 部署k8s集群



生产环境部署k8s集群



- kubeadm
- 二进制





## kubeadm 简介

[kubeadm](https://github.com/kubernetes/kubernetes/tree/master/cmd/kubeadm)是 一位17岁的芬兰高中生Lucas Kaldstrom的作品，他用业余时间完成的一个社区项目。





## **containerd** 

`ctr` 是 **containerd** 的官方命令行客户端工具，类似于 `docker` CLI，但更底层、更简洁，适用于调试和直接操作 containerd（常用于 Kubernetes 节点，因为 K8s 从 v1.24+ 默认使用 containerd 作为容器运行时）。



```
ctr images ls
ctr images pull
```





# 深入理解 Kubeenetes 编排对象



Kubernetes 系统是一套分布式容器应用编排系统，当我们用它来承载业务负载时主要使用的编排对象有 Deployment、ReplicaSet、StatefulSet、DaemonSet 等。

读者可能好奇的地方是 Kubernetes 管理的对象不是 Pod 吗？为什么不去讲讲如何灵活配置 Pod 参数。其实这些对象都是对 Pod 对象的扩展封装。并且这些对象作为核心工作负载 API 固化在 Kubernetes 系统中了。

所以 ，我们有必要认真的回顾和理解这些编排对象，依据生产实践的场景需要，合理的配置这些编排对象，让 Kubernetes 系统能更好的支持我们的业务需要。



## ReplicationController

**ReplicationController副本控制器** 确保在任何时候都有特定数量的 Pod 副本处于运行状态。 换句话说，ReplicationController 确保一个 Pod 或一组同类的 Pod 总是可用的。





## deployment



```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```





通过编写YAML文件创建出来的Secret对象只有一个。

但它的data字段，却以Key-Value的格式保存了两份Secret数据。其中，“user”就是第一份数据的Key，“pass”是第二份数据的Key。

需要注意的是，Secret对象要求这些数据必须是经过Base64转码的，以免出现明文密码的安全隐患。

像这样创建的Secret对象，它里面的内容仅仅是经过了转码，并没有被加密。在生产环境中，你需要在Kubernetes中开启Secret的加密插件，增强数据的安全性。

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  user: YWRtaW4=
  pass: MWYyZDFlMmU2N2Rm
```





```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-projected-volume 
spec:
  containers:
  - name: test-secret-volume
    image: busybox
    args:
    - sleep
    - "86400"
    volumeMounts:
    - name: mysql-cred
      mountPath: "/projected-volume"
      readOnly: true
  volumes:
  - name: mysql-cred
    projected:
      sources:
      - secret:
          name: user
      - secret:
          name: pass
```





# Kubernetes网络



**Kubernetes 网络模型规定**

- **K8s 的网络模型要求每个 Pod 都有一个唯一的 IP 地址，即使这些 Pod 分布在不同的 worker 节点上。**

- **在跨节点的情况下 Pod 也必须可以通过 IP 地址访问。任意两个 pod 之间其实是可以直接通信的，无需经过显式地使用 NAT 来接收数据和地址的转换；**



**也就是说，Pod 的 IP 地址必须始终对集群中其他 Pod 可见；且从 Pod 内部和从 Pod 外部来看，Pod 的IP地址都是相同的。**

**Kubernetes 网络模型要求 Pod 的 IP 在整个网络中都可访问，但是并不具体指定如何实现这一点。**



为了实现这个网络模型，CoreOS 团队发起了 CNI 项目（后来 CNI 进了 CNCF 孵化），CNI (Container Network Interface) 定义了实现容器之间网络连通性和释放网络资源等相关操作的接口规范。

这套接口进而由具体的 CNI 插件去实现，CNI 插件负责为 Pod 分配 IP 地址，并处理跨节点的网络路由等具体的工作。

Kubernetes 定义了一种简单、一致的网络模型，基于扁平网络结构的设计，无需将主机端口与网络端口进行映射便可以进行高效地通讯，也无需其他组件进行转发。该模型也使应用程序很容易从虚拟机或者主机物理机迁移到 Kubernetes 管理的 pod 中。



所谓 **网络栈**：网卡（Network Interface）、回环设备（Loopback Device）、路由表（Routing Table）和 iptables 规则。对于一个进程来说，这些要素，其实就构成了它发起和响应网络请求的基本环境。



在docker场景下，被限制在 `Network Namespace` 里的容器进程，实际上是通过 `Veth Pair` 设备 + **宿主机网桥**的方式，实现了跟同宿主内其他容器的数据交换。

当从宿主机上直接访问该宿主机内其他容器的 IP 地址时，这个请求的数据包，也是先根据路由规则到达 docker0 网桥，然后被转发到对应的 Veth Pair 设备，最后出现在容器里。

当一个容器试图连接到另外一个宿主机时，比如：ping 10.168.0.3，它发出的请求数据包，首先经过 docker0 网桥出现在宿主机上。

然后根据宿主机的路由表里的直连路由规则（10.168.0.0/24 via eth0)），对 `10.168.0.3` 的访问请求就会交给宿主机的 `eth0` 处理。





在 Kubernetes 中，每一个 Pod 都有一个真实的 IP 地址，并且每一个 Pod 都可以使用此 IP 地址与 其他 Pod 通信。

本章节可以帮助我们理解 Kubernetes 是如何在 Pod-to-Pod 通信中使用真实 IP 的，不管两个 Pod 是在同一个节点上，还是集群中的不同节点上。

我们将首先讨论通信中的两个 Pod 在同一个节点上的情况，以避免引入跨节点网络的复杂性。





从 Pod 的视角来看，Pod 是在其自身所在的 `network namespace` 与同一宿主节点上另外一个pod的 `network namespace`进程通信。

由于`network namespace`隔离了网络相关的全局资源，因此从网络角度来看，一个`network namespace`可以看做一个独立的虚拟机；

即使在同一个主机上创建的两个`network namespace`，相互之间缺省也是不能进行网络通信的。



容器 veth 又是一个虚拟网络接口，因此它和 TUN/TAP 或者其他物理网络接口一样，也都能配置 mac/ip 地址（但是并不是一定得配 mac/ip 地址）。

其主要作用就是连接不同的网络，比如在容器网络中，用于将容器的 namespace 与 root namespace 的网桥 br0 相连。

容器网络中，容器侧的 veth 自身设置了 ip/mac 地址并被重命名为 eth0，作为容 器的网络接口使用，而主机侧的 veth 则直接连接在 docker0/br0 上面。



veth实现了点对点的虚拟连接，可以通过veth连接两个namespace，如果我们需要将3个或者多个namespace接入同一个二层网络时，就不能只使用veth了。

在物理网络中，如果需要连接多个主机，我们会使用网桥，或者又称为交换机。Linux也提供了网桥的虚拟实现。



在Linux上不同的多个 network namespace 可以由 Linux 内核模块 `bridge` 提供行通信。

Linux Bridge 是工作在链路层的网络交换机，由 Linux 内核模块 `bridge` 提供，它负责在所有连接 到它的接口之间转发链路层数据包。

为连接 pod 的 network namespace，可以将 **veth pair** 的一段指定到 root network namespace，另一端指定到 Pod 的 network namespace。

每一组 **veth pair** 类似于一条网线，连接两端，并可以使流量通过。节点上有多少个 Pod，就会设置多少组 **veth pair**。





**容器跨主通信**

在 Docker 的默认配置下，一台宿主机上的 docker0 网桥，和其他宿主机上的 docker0 网桥，没有任何关联，它们互相之间也没办法连通。所以，连接在这些网桥上的容器，自然也没办法进行通信了。

为了解决这个**容器跨主通信**的问题，k8s 制定了 CNI 规范，然后社区里依据该规范出现了各种各样的容器网络方案。



其中 Flannel 是最早实现的，也是最简单的一个。



底层网络 *Underlay Network* 

顾名思义是指网络设备基础设施，如交换机，路由器, *DWDM* 使用网络介质将其链接成的物理网络拓扑，负责网络之间的数据包传输。



*underlay network* 可以是二层，也可以是三层；

二层 *underlay network* 的典型例子是以太网 *Ethernet*，三层是 *underlay network* 的典型例子是互联网 *Internet*。



在kubernetes中，*underlay network* 中比较典型的例子是通过将宿主机作为路由器设备。

**Pod 的网络则通过学习成路由条目从而实现跨节点通讯。**



通过软件的方式，创建一个整个集群“公用”的网桥，然后把集群里的所有容器都连接到这个网桥上。

构建这种容器网络的核心在于：我们需要在已有的宿主机网络上，再通过软件构建一个覆盖在已有宿主机网络之上的、可以把所有容器连通在一起的虚拟网络。

所以，这种技术就被称为：Overlay Network（覆盖网络）。

这个 Overlay Network 本身，可以由每台宿主机上的一个“特殊网桥”共同组成。

比如，当Node 1 上的 Container 1 要访问 Node 2 上的 Container 3 的时候，Node 1 上的“特殊网桥”在收到数据包之后，能够通过某种方式，把数据包发送到正确的宿主机，比如 Node 2上。

而 Node 2 上的“特殊网桥”在收到数据包后，也能够通过某种方式，把数据包转发给正确的容器，比如 Container 3。

甚至每台宿主机上，都不需要有一个这种特殊的网桥，而仅仅通过某种方式配置宿主机的路由表，就能够把数据包转发到正确的宿主机上。

那就是用户的容器都连接在 docker0 网桥上。而网络插件则在宿主机上创建了一个特殊的设备（UDP 模式创建的是 TUN 设备，VXLAN 模式创建的则是VTEP 设备），docker0 与这个设备之间，通过 IP 转发（路由表）进行协作。

然后，网络插件真正要做的事情，则是通过某种方法，把不同宿主机上的特殊设备连通，从而达到容器跨主机通信的目的。



Flannel 项目是 CoreOS 公司主推的容器网络方案。

事实上，Flannel 项目本身只是一个框架，真正为我们提供容器网络功能的，是 Flannel 的后端实现：

- UDP
- host-gw
- VXLAN

1、容器正常构造业务TCP报文，源和目的分别为各自容器的IP

2、宿主机1上的docker0接收到报文。报文进入宿主机内核。（flanneld进程已给宿主机注入路由规则，报文被路由至这个TUN设备，继而发给flanneld进程）

3、在由 Flannel 管理的容器网络里，一台宿主机上的所有容器，都属于该宿主机被分配的一个“子网”

Flannel UDP 模式提供的其实是一个三层的 Overlay 网络，即：它首先对发出端的IP包进行 UDP 封装，然后在接收端进行解封装拿到原始的 IP 包，进而把这个 IP 包转发给目标容器。

这就好比，Flannel 在不同宿主机上的两个容器之间打通了一条"隧道"，使得这两个容器可以直接使用 IP 地址进行通信，而无需关心容器和宿主机的分布情况。

相比于两台宿主机之间的直接通信，基于 Flannel UDP 模式的容器通信多了一个额外的步骤，即 flanneld 的处理过程。

而这个过程，由于使用到了 flannel0 这个 TUN 设备，仅在发出IP包的过程中，就需要经过三次用户态与内核态之间的数据拷贝

Flannel 进行 UDP 封装（Encapsulation）和解封装（Decapsulation）的过程，也都是在用户态完成的。

在 Linux 操作系统中，上述这些上下文切换和用户态操作的代价其实是比较高的，这也正是造成 Flannel UDP 模式性能不好的主要原因。

**我们在进行系统级编程的时候，有一个非常重要的优化原则，就是要减少用户态到内核态的切换次数，并且把核心的处理逻辑都放在内核态进行**

VxLAN，即 Virtual Extensible LAN（虚拟可扩展局域网），是 Linux 内核本身就支持的一种网络虚似化技术。

所以说，VxLAN 可以完全在内核态实现上述封装和解封装的工作，从而通过与前面相似的“隧道”机制，构建出覆盖网络（Overlay Network）

VXLAN 的覆盖网络的设计思想是：

在现有的三层网络之上，“覆盖”一层虚拟的、由内核 VXLAN模块负责维护的二层网络，使得连接在这个 VXLAN 二层网络上的“主机”（虚拟机或者容器都可以）之间，可以像在同一个局域网（LAN）里那样自由通信。当然，实际上，这些“主机”可能分布在不同的宿主机上，甚至是分布在不同的物理机房里。

为了能够在二层网络上打通“隧道”，VXLAN 会在宿主机上设置一个特殊的网络设备作为“隧道”的两端。这个设备就叫作 VTEP，即：VXLAN Tunnel End Point（虚拟隧道端点，其实就是Flannel）。

flanneld进程:

- 创建和配置 flannel.1 设备、配置宿主机路由、配置 ARP 和 FDB 表里的信息
- 







## kube-apiserver

在大多数 Kubernetes 集群中（尤其是用 `kubeadm` 安装的），默认的 Service 网段是：

```
--service-cluster-ip-range=10.96.0.0/12
```

这个网段范围很大（从 `10.96.0.0` 到 `10.111.255.255`），Kubernetes 会从这个范围内为每个 Service 分配一个 ClusterIP。

虽然 IP 是自动分配的，但 **CoreDNS 的 Service 通常被手动设置为 `10.96.0.10`**，或在初始化时由 `kubeadm` 固定分配。

```bash
$ kubectl get svc -n kube-system kube-dns

NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   3d
```



```
--service-cluster-ip-range
```



## 集群内各组件通讯

在 Kubernetes 集群中，**各控制平面组件之间的通信**（如 `kubelet`、`kube-controller-manager`、`kube-scheduler`、`kubectl` 等与 `kube-apiserver` 的通信）都依赖于 **kubeconfig 文件** 来完成身份认证和连接配置。

这些 `kubeconfig` 文件是实现 **安全、可信通信的核心机制**，它们定义了：

- 连接哪个集群（apiserver 地址）
- 使用什么证书或 token 认证
- 属于哪个用户/角色





在 Kubernetes 集群中：

- 所有组件（包括 kubelet）都需要通过 **TLS 证书** 与 `kube-apiserver` 安全通信
- 但 kubelet 本身还没有证书 → 无法认证 → 无法请求证书

👉 这是一个“先有鸡还是先有蛋”的问题。



# 开源项目



## Volcano

Volcano是[CNCF](https://www.cncf.io/) 下首个也是唯一的基于Kubernetes的容器批量计算平台，主要用于高性能计算场景。它提供了Kubernetes目前缺 少的一套机制，这些机制通常是机器学习大数据应用、科学计算、特效渲染等多种高性能工作负载所需的。作为一个通用批处理平台，Volcano与几乎所有的主流计算框 架无缝对接，如[Spark](https://spark.apache.org/) 、[TensorFlow](https://tensorflow.google.cn/) 、[PyTorch](https://pytorch.org/) 、 [Flink](https://flink.apache.org/) 、[Argo](https://argoproj.github.io/) 、[MindSpore](https://www.mindspore.cn/) 、 [PaddlePaddle](https://www.paddlepaddle.org.cn/)，[Ray](https://www.ray.io/)等。它还提供了包括异构设备调度，网络拓扑感知调度，多集群调度，在离线混部调度等多种调度能力。Volcano的设计 理念建立在15年来多种系统和平台大规模运行各种高性能工作负载的使用经验之上，并结合来自开源社区的最佳思想和实践。



## Kuboard 

Kuboard 是一款免费的 Kubernetes 管理工具，提供了丰富的功能，结合已有或新建的代码仓库、镜像仓库、CI/CD工具等，可以便捷的搭建一个生产可用的 Kubernetes 容器云平台，轻松管理和运行云原生应用。您也可以直接将 Kuboard 安装到现有的 Kubernetes 集群，通过 Kuboard 提供的 Kubernetes RBAC 管理界面，将 Kubernetes 提供的能力开放给您的开发/测试团队。

https://github.com/zxh326/kite



## LuBan

LuBan运维平台是一个基于Go语言+Vue开发的Kubernetes多集群管理平台，可以兼容不同云厂商Kubernetes集群，同时，平台还集成CMDB资产管理。方便用户管理集群、节点等基础资源。通过使用LuBan运维平台，可以提升运维效率，降低维护成本。

https://github.com/dnsjia/luban





## karmada

Karmada（Kubernetes Armada）是一个 Kubernetes 管理系统，使您能够在多个 Kubernetes 集群和云中运行云原生应用程序，而无需更改应用程序。

通过使用 Kubernetes 原生 API 并提供先进的调度功能，Karmada 实现了真正的开放式、多云 Kubernetes。

https://karmada.io/

## KubeBlocks

https://cn.kubeblocks.io/docs/preview/user-docs/overview/introduction



## KubeVela 

https://kubevela.io/zh/docs/

## Kube-OVN

https://kube-ovn.readthedocs.io/zh-cn/latest/



## kubeasz

https://github.com/easzlab/



## deploy-microservices-to-a-Kubernetes-cluster

https://github.com/xiaojiaqi/deploy-microservices-to-a-Kubernetes-cluster





# 镜像仓库



k8s中涉及到的仓库有如下

> docker.elastic.co
> docker.io
> gcr.io
> ghcr.io
> k8s.gcr.io
> registry.k8s.io
> mcr.microsoft.com
> nvcr.io
> quay.io





 containerd 1.5 版本之后推荐的，比修改主配置文件 `/etc/containerd/config.toml` 更灵活。

基于**主机名**（hostname）的目录结构。对于每一个你需要配置的镜像仓库，你都需要在这个目录下创建一个以该仓库域名命名的子目录。

```bash
/etc/containerd/certs.d/
└── docker.io/
│   └── hosts.toml
└── my-private-registry.com/
│   ├── hosts.toml
│   └── ca.crt
└── my-insecure-registry:5000/
    └── hosts.toml
```

每个子目录内部，核心配置文件是 **`hosts.toml`**。这个文件定义了 containerd 如何与该仓库进行通信：



```
mkdir -p /etc/containerd/certs.d/docker.io
mkdir -p /etc/containerd/certs.d/registry.k8s.io

touch /etc/containerd/certs.d/docker.io/hosts.toml
touch /etc/containerd/certs.d/registry.k8s.io/hosts.toml
```



```
cat>/etc/containerd/certs.d/docker.io/hosts.toml<<EOF
server = "https://docker.io"

[host."https://docker.m.daocloud.io"]
  capabilities = ["pull", "resolve"]
[host."https://dockerproxy.com/"]
  capabilities = ["pull", "resolve"]
[host."https://docker.1ms.run/"]
  capabilities = ["pull", "resolve"]
  
EOF
```













# 附录



## kube-API



```bash
root@k8s-master01:~#
root@k8s-master01:~# kubectl api-resources
NAME                                SHORTNAMES                          APIVERSION                        NAMESPACED   KIND
bindings                                                                v1                                true         Binding
componentstatuses                   cs                                  v1                                false        ComponentStatus
configmaps                          cm                                  v1                                true         ConfigMap
endpoints                           ep                                  v1                                true         Endpoints
events                              ev                                  v1                                true         Event
limitranges                         limits                              v1                                true         LimitRange
namespaces                          ns                                  v1                                false        Namespace
nodes                               no                                  v1                                false        Node
persistentvolumeclaims              pvc                                 v1                                true         PersistentVolumeClaim
persistentvolumes                   pv                                  v1                                false        PersistentVolume
pods                                po                                  v1                                true         Pod
podtemplates                                                            v1                                true         PodTemplate
replicationcontrollers              rc                                  v1                                true         ReplicationController
resourcequotas                      quota                               v1                                true         ResourceQuota
secrets                                                                 v1                                true         Secret
serviceaccounts                     sa                                  v1                                true         ServiceAccount
services                            svc                                 v1                                true         Service
mutatingwebhookconfigurations                                           admissionregistration.k8s.io/v1   false        MutatingWebhookConfiguration
validatingadmissionpolicies                                             admissionregistration.k8s.io/v1   false        ValidatingAdmissionPolicy
validatingadmissionpolicybindings                                       admissionregistration.k8s.io/v1   false        ValidatingAdmissionPolicyBinding
validatingwebhookconfigurations                                         admissionregistration.k8s.io/v1   false        ValidatingWebhookConfiguration
customresourcedefinitions           crd,crds                            apiextensions.k8s.io/v1           false        CustomResourceDefinition
apiservices                                                             apiregistration.k8s.io/v1         false        APIService
controllerrevisions                                                     apps/v1                           true         ControllerRevision
daemonsets                          ds                                  apps/v1                           true         DaemonSet
deployments                         deploy                              apps/v1                           true         Deployment
replicasets                         rs                                  apps/v1                           true         ReplicaSet
statefulsets                        sts                                 apps/v1                           true         StatefulSet
selfsubjectreviews                                                      authentication.k8s.io/v1          false        SelfSubjectReview
tokenreviews                                                            authentication.k8s.io/v1          false        TokenReview
localsubjectaccessreviews                                               authorization.k8s.io/v1           true         LocalSubjectAccessReview
selfsubjectaccessreviews                                                authorization.k8s.io/v1           false        SelfSubjectAccessReview
selfsubjectrulesreviews                                                 authorization.k8s.io/v1           false        SelfSubjectRulesReview
subjectaccessreviews                                                    authorization.k8s.io/v1           false        SubjectAccessReview
horizontalpodautoscalers            hpa                                 autoscaling/v2                    true         HorizontalPodAutoscaler
cronjobs                            cj                                  batch/v1                          true         CronJob
jobs                                                                    batch/v1                          true         Job
certificatesigningrequests          csr                                 certificates.k8s.io/v1            false        CertificateSigningRequest
ciliumcidrgroups                    ccg                                 cilium.io/v2                      false        CiliumCIDRGroup
ciliumclusterwidenetworkpolicies    ccnp                                cilium.io/v2                      false        CiliumClusterwideNetworkPolicy
ciliumendpoints                     cep,ciliumep                        cilium.io/v2                      true         CiliumEndpoint
ciliumidentities                    ciliumid                            cilium.io/v2                      false        CiliumIdentity
ciliuml2announcementpolicies        l2announcement                      cilium.io/v2alpha1                false        CiliumL2AnnouncementPolicy
ciliumloadbalancerippools           ippools,ippool,lbippool,lbippools   cilium.io/v2                      false        CiliumLoadBalancerIPPool
ciliumnetworkpolicies               cnp,ciliumnp                        cilium.io/v2                      true         CiliumNetworkPolicy
ciliumnodeconfigs                                                       cilium.io/v2                      true         CiliumNodeConfig
ciliumnodes                         cn,ciliumn                          cilium.io/v2                      false        CiliumNode
ciliumpodippools                    cpip                                cilium.io/v2alpha1                false        CiliumPodIPPool
leases                                                                  coordination.k8s.io/v1            true         Lease
endpointslices                                                          discovery.k8s.io/v1               true         EndpointSlice
events                              ev                                  events.k8s.io/v1                  true         Event
flowschemas                                                             flowcontrol.apiserver.k8s.io/v1   false        FlowSchema
prioritylevelconfigurations                                             flowcontrol.apiserver.k8s.io/v1   false        PriorityLevelConfiguration
ingressclasses                                                          networking.k8s.io/v1              false        IngressClass
ingresses                           ing                                 networking.k8s.io/v1              true         Ingress
ipaddresses                         ip                                  networking.k8s.io/v1              false        IPAddress
networkpolicies                     netpol                              networking.k8s.io/v1              true         NetworkPolicy
servicecidrs                                                            networking.k8s.io/v1              false        ServiceCIDR
runtimeclasses                                                          node.k8s.io/v1                    false        RuntimeClass
poddisruptionbudgets                pdb                                 policy/v1                         true         PodDisruptionBudget
clusterrolebindings                                                     rbac.authorization.k8s.io/v1      false        ClusterRoleBinding
clusterroles                                                            rbac.authorization.k8s.io/v1      false        ClusterRole
rolebindings                                                            rbac.authorization.k8s.io/v1      true         RoleBinding
roles                                                                   rbac.authorization.k8s.io/v1      true         Role
priorityclasses                     pc                                  scheduling.k8s.io/v1              false        PriorityClass
csidrivers                                                              storage.k8s.io/v1                 false        CSIDriver
csinodes                                                                storage.k8s.io/v1                 false        CSINode
csistoragecapacities                                                    storage.k8s.io/v1                 true         CSIStorageCapacity
storageclasses                      sc                                  storage.k8s.io/v1                 false        StorageClass
volumeattachments                                                       storage.k8s.io/v1                 false        VolumeAttachment
root@k8s-master01:~#


oot@k8s-master01:~#
root@k8s-master01:~#
root@k8s-master01:~# kubectl api-versions
admissionregistration.k8s.io/v1
apiextensions.k8s.io/v1
apiregistration.k8s.io/v1
apps/v1
authentication.k8s.io/v1
authorization.k8s.io/v1
autoscaling/v1
autoscaling/v2
batch/v1
certificates.k8s.io/v1
cilium.io/v2
cilium.io/v2alpha1
coordination.k8s.io/v1
discovery.k8s.io/v1
events.k8s.io/v1
flowcontrol.apiserver.k8s.io/v1
networking.k8s.io/v1
node.k8s.io/v1
policy/v1
rbac.authorization.k8s.io/v1
scheduling.k8s.io/v1
storage.k8s.io/v1
v1
root@k8s-master01:~#
```



# 问题



### 为什么 Cilium Agent 会崩溃？

`cilium-agent` 是 Cilium 的核心，负责在节点上管理网络、应用策略、处理流量。它启动时会进行一系列严格的自检。如果环境不满足要求，它通常会选择直接报错退出，而不是带病运行。

最常见的崩溃原因包括：

1. **内核版本不满足要求 (最常见!)**: Cilium 严重依赖 Linux 内核的 eBPF 功能。如果你的操作系统内核版本太低，或者缺少必要的内核模块，Cilium Agent 在初始化 eBPF 时会失败，然后直接崩溃。这是新部署 Cilium 时最常见的问题。
2. **缺少 BPF 文件系统**: Cilium 需要 BPF 文件系统挂载在 `/sys/fs/bpf`。虽然有一个 `mount-bpf-fs` 的 Init Container 专门做这件事，但如果因为某些权限或系统设置导致挂载失败，主容器依然会失败。
3. **无法连接到 Kubernetes API Server**: Cilium Agent 需要与 `kube-apiserver` 通信来获取 Pods、Services 等信息。如果因为网络问题或 RBAC 权限问题无法连接，它可能会退出。
4. **配置错误**: `cilium-config` ConfigMap 中的配置有误，例如启用了某个与内核不兼容的特性。
5. **节点上存在冲突的网络配置**: 例如，之前安装的其他 CNI 插件没有清理干净，留下了冲突的 iptables 规则或网络设备。