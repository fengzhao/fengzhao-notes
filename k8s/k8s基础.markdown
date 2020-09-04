# k8s概述





## 什么是k8s



Kubernetes 是 Google 团队发起的一个开源项目，它的目标是管理跨多个主机的容器，用于自动部署、扩展和管理容器化的应用程序，主要实现语言为 Go 语言。

## k8s功能



## k8s基本组件

**集群**

一个 Kubernetes 集群由一组被称作节点的机器组成。这些节点上运行 Kubernetes 所管理的容器化应用。集群具有至少一个工作节点和至少一个主节点。

k8s集群分为两类节点

- master node
  - **Master 负责管理集群**, master 协调集群中的所有活动，例如调度应用程序、维护应用程序的所需状态、扩展应用程序和滚动更新。
  - 
- worker node (node)
  - **节点是 Kubernetes 集群中的工作机器，可以是物理机或虚拟机。**
  - 每个工作节点都有一个 kubelet，它是管理节点并与 Kubernetes Master 节点进行通信的代理。
  - 节点上还应具有处理容器操作的容器运行时，例如 [Docker](https://www.docker.com/) 或 [rkt](https://coreos.com/rkt/)。



一个 Kubernetes 工作集群至少有三个节点。master 管理集群， node 用于托管正在运行的应用程序。

当您在 Kubernetes 上部署应用程序时，您可以告诉 master 启动应用程序容器。Master 调度容器在集群的节点上运行。

 节点使用 Master 公开的 Kubernetes API 与 Master 通信。用户也可以直接使用 Kubernetes 的 API 与集群交互。

**master 节点的组件**

- etcd 是兼具一致性和高可用性的键值数据库，可以作为保存 Kubernetes 所有集群数据的后台数据库。可以内置在 master 中，也可以放到外面。
  - 用来注册节点

- kube-apiserver : 集群控制的入口，提供 HTTP REST 服务，主节点上负责提供 Kubernetes API 服务的组件；它是 Kubernetes 控制面的前端。
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
- kube-proxy : 实现 Kubernetes Service 的通信和负载均衡
- 运行容器化(Pod)应用
- Container Runtime ： 容器运行时环境， [Docker](http://www.docker.com/)、 [containerd](https://containerd.io/)、[cri-o](https://cri-o.io/)、 [rktlet](https://github.com/kubernetes-incubator/rktlet) 



### k8s 核心概念

Pod: Pod 是 Kubernetes 最基本的部署调度单元。每个 Pod 可以由一个或多个业务容器和一个根容器(Pause 容器)组成。一个 Pod 表示某个应用的一个实例。

- 一个 pod 中的容器共享网络命名空间
- Pod 是短暂的

- ReplicaSet：是 Pod 副本的抽象，用于解决 Pod 的扩容和伸缩

- Deployment：Deployment 表示部署，在内部使用 ReplicaSet 来实现。可以通过 Deployment 来生成相应的 ReplicaSet 完成 Pod 副本的创建

- Service：Service 是 Kubernetes 最重要的资源对象。Kubernetes 中的 Service 对象可以对应微服务架构中的微服务。

  Service 

  Service 定义了服务的访问入口，服务的调用者通过这个地址访问 Service 后端的 Pod 副本实例。

  Service 通过 Label Selector 同后端的 Pod 副本建立关系，Deployment 保证后端Pod 副本的数量，也就是保证服务的伸缩性。

- label ：
- 
- namespace 
  - 用来隔离 pod 的运行环境 （默认情况下，pod 是可以互相访问的）
  - 使用场景
    - 多租户 k8s 集群
    - 多个不同项目环境

