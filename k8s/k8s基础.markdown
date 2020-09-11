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

- ReplicaSet：是 Pod 副本的抽象，用于解决 Pod 的扩容和伸缩

- Deployment：Deployment 表示部署，在内部使用 ReplicaSet 来实现。可以通过 Deployment 来生成相应的 ReplicaSet 完成 Pod 副本的创建

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





### 通过 pod 合理管理容器



将 pod 视为独立的机器，其中每个机器只托管一个特定的应用。过去我们比较习惯于将各种应用程序塞进同一台主机。

由于 pod 比较轻量级，我们可以在几乎不导致任何额外的开销的前提下拥有更多的 pod 。 

一般做法是将应用程序组织到多个 pod 中，每个 pod 只包含紧密相关的组件或进程 。 



**将多层应用分散到多个 pod 中**

虽然可以在单个 pod 中同时运行 web 服务和数据库这两个容器，但是这种方式并不值得推荐。

同一个 pod 的所有容器总是运行在一起。如果 web 和数据库在同一个 pod 中，那么两者将始终在同一个计算机上运行。

如果你有一个双



**基于扩容考虑而分割到多个 pod 中**

另一个不应该将应用程序都放到单一 pod 中的原因就是扩缩容。pod 也是扩缩容的基本单位。

对于 kubernetes ，它不能横向扩容单个容器，只能扩缩整个 pod 。

通常，web 和数据库有不同的扩缩容需求，所以我们倾向于分别独立地扩缩他们。

数据库这样的后端服务，通常比无状态的前端web服务更多扩展。



**何时在 pod 中使用多个容器**

将多个容器添加到单个 pod 的主要原因是应用可能由一个主进程和一个或多个辅助进程组成。

pod 应该包含紧密耦合的容器组



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





#### 使用标签来组织pod



在实际部署应用程序时，大多数用户最终将运行很多 pod 。随着 pod 数量的增加，将它们分类到子集的需求也就明显了。

在微服务架构中，部署的微服务数量可以轻松超过20个甚至更多。这些组件可能是副本（同一组件的多个副本）或多个不同的版本（dev,stable,beta）

如果没有有效的组织管理，将导致巨大的混乱。

标签是一种简单却功能强大的 kubernetes 特性，不仅可以组织 pod ，也可以组织 kubernetes 所有资源。

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
    - containerPort: 8080
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



**将pod调度到特定节点**

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





通常，我们不应该强调将 pod 直接调度到某一个节点上，虽然 kubernetes 可以这样做，因为这样会使应用程序与基础架构强耦合。

违背了 kubernetes 对运行在其上的应用程序隐藏实际的基础架构的整个构想。

所以更好的做法是通过标签的方式来描述 pod 对节点的需求，从而让调度器只在提供符合需求的节点中进行选择。



#### 注解 pod 



除标签外，pod 和其他对象还可以包含注解。注解也是键值对。所以它们本质上与标签非常相似。

但与标签不同，注解不是为了保存标识信息而存在。

向 kubernetes 引入新特性



**查找对象的注解**





**添加和修改注解**

可以在创建 pod 的时候添加注解，也可以在现有的 pod 中添加或修改注解。

```shell
kubectl annotate  pod kubia-manual mycompany.com/someannotation="foo bar" 

```



