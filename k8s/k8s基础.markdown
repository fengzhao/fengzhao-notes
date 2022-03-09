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



将复杂的大型单体应用拆分为小的可独立部署的微服务组件，每个微服务以独立的进程运行，并通过简单且定义良好的接口（API）与其他服务通信。服务之间可以通过 HTTP 这样的同步协议通讯，或通过像 AMQP 这样的异步协议通信。



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

**master 节点中的组件**

这些组件可以运行在单个 master 节点上，**也可以通过副本运行在多个 master 节点上以确保高可用性。**

- etcd 是兼具一致性和高可用性的键值数据库，可以作为保存 Kubernetes 所有集群数据的后台数据库。可以内置在 master 中，也可以放到外面。
  - 用来注册节点，持久化存储集群配置。

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

但与标签不同，注解不是为了保存标识信息而存在。它们不能像标签一样用于对对象进行分组。

向 kubernetes 引入新特性时，



**查找对象的注解**





**添加和修改注解**

可以在创建 pod 的时候添加注解，也可以在现有的 pod 中添加或修改注解。

```shell
kubectl annotate  pod kubia-manual mycompany.com/someannotation="foo bar" 

```



### 使用命名空间对资源分组

kubernetes 命名空间简单地为对象名称提供了一个作用域。我们并不会将所有资源都放在同一个命名空间中。

而是将它们组织到多个命名空间中。这样允许我们多次使用相同的资源名称（跨不同的命名空间）



在使用多个 namespace 的前提下，我们将包含大量组件的复杂系统拆分为更小的不同组。

如果有多个用户和用户组在使用同一个集群，并且它们都管理各自独特的资源集合。那么它们就应该分别使用各自的命名空间。

这样一来，它们就不用特别担心无意中修改或删除其他用户的资源。

命名空间的隔离只是逻辑上的隔离，不同命名空间之间的 pod 并不存在网络隔离，它们之间可以通过IP地址进行通讯。

```shell
# 查看集群内的所有namespace
kubectl get ns

# 查看某个namespace下的pod
kubectl get po --namespace kube-system

# 
```



#### 创建 namespace

命名空间和其他资源一样，可以通过把YAML提交给Kunernetes API Server来创建该资源。









#### 管理命名空间中的对象

如果想要在 namespace 中创建资源，可以选择在 YAML 的 metadata 字段中添加一个 namespace: custom-namespace 属性。

也可以在 kubectl create 命令中创建资源时指定命名空间。-n 来指定资源所属 namespace 。

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


# 删除命名空间来删除其空间下的所有pod


#　删除命名空间下的所有资源,kubectl命令有上下文，这是指删除上下文的命名空间中的所有资源
#　第一个 all 指删除所有资源类型
#　--all 指定删除所有资源实例
kubectl delete all --all



```







## 副本机制和控制器



**pod 代表了 kubernetes 中的基本部署单元，我们也可以手动创建管理它们。在实际应用中，我们几乎不会去手动管理 pod 。**

而是使用 ReplicationController 或 Deployment 这样的资源来管理 pod 。

只要将 pod 调度到某个节点，该节点上的 kubelet 就会运行 pod 的容器，如果容器主进程崩溃，kubelet 会将容器重启。



### 保持 pod 健康

使用 kubernetes 的一个主要好处是，可以声明一个容器列表，由 kubernetes 来保持容器在集群中的运行。由 kuberneter 自动选择调度节点。

只要将 pod 调度到某个节点，该节点上的 kubelet 就会运行 pod 的容器。

### 存活探针（liveness probe）



kubernetes 可以通过 **存活探针** 检查容器是否还在运行。可以为 pod 中的每个容器单独指定存活探针。

**kubernetes 容器探测机制**

- 基于 HTTP GET 的存活探针，对容器的IP地址端口执行 HTTP GET 请求。通过状态码判断
- TCP套接字探针，
- Exec 探针在容器内执行任意命令，通过返回的状态码，来确定是否探测成功。



#### 基于 HTTP 的存活探针



```shell
# 基于下面那段node应用来构建docker image
FROM node:7
ADD app.js /app.js
ENTRYPOINT ["node", "app.js"]


# 这是一个简单的nodejs应用，启动后被访问超过5，就会返回http500状态码
const http = require('http');
const os = require('os');

console.log("Kubia server starting...");

var requestCount = 0;

var handler = function(request, response) {
  console.log("Received request from " + request.connection.remoteAddress);
  requestCount++;
  if (requestCount > 5) {
    response.writeHead(500);
    response.end("I'm not well. Please restart me!");
    return;
  }
  response.writeHead(200);
  response.end("You've hit " + os.hostname() + "\n");
};

var www = http.createServer(handler);
www.listen(8080);



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
```



1



> 当容器被强行终止时，会创建一个全新的容器——而不是重启原来的容器。



#### 配置探针的属性

在 kubectl describe pod kubia-liveness 中，可以看到探针的一些属性

- delay（延迟）       delay=0s 部分指示容器启动后立刻开始探测。
- timeout（超时）  timeout=1s 部分指示容器必须在1s内响应
- period（周期）    period=10s 只是每10s进行一次探测
- 



定义探针时可以自定义这些参数，

如果没有设置初始延时，探针将在启动时立即开始探测容器，通常会导致探测失败。





### ReplicationController

rc 是 kubernetes 中的一种资源，可确保它的 pod 始终保持运行。如果 pod 因任何原因消失（节点从集群中消失，或者 pod 被节点逐出）。



rc 会持续监控正在运行的 pod 列表，并保证 相应 类型 的 pod 数量与期望相符。少了会创建副本，对了会删除多余的副本。

**rc 协调流程**

rc 的工作是确保 pod 数量始终与其标签选择器匹配。



一个 rc 主要有三个部分：

- label 确定 rc 作用域的 pod 范围 
- relica count 确定 pod 副本数量，指定应运行 pod 的数量
- pod template 用于创建新 pod 副本的模板

**rc 中的标签选择器，副本数量都可以随时修改，但是只有副本数量的变更会影响现有 pod** 



> 更改标签选择器和 pod 模板对现有 pod 没有影响。更改标签选择器会使现有的 pod 脱离 rc 的范围。
>
> 在创建 Pod 后，ReplicationController 也不关心其 pod 的实际“内容”（容器镜像、环境变量及其他）。
>
> 因此，该模板仅影响此 ReplicationController 创建的新 pod。可以将其视为创建新 pod 的曲奇切模（cookie cutter）。
>
> 《 Kubernetes In Action 》

ReplicationController 的 pod 模板可以随时修改。更改 pod 就像用一个曲奇刀替换另一个。它只会影响你之后切出的曲奇，并且不会影响你已经剪切的曲奇。

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    app: nginx
  # 这里定义的就是 cookie cutter
  template:
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

**模板中的 pod 标签必须和 rc 的标签选择器匹配，否则，rc 将会无休止的创建新容器。**

如果你想切出不一样的饼干，更换模具即可，至于之前已经做好的饼干，你也无法改变了。

就像你曾经走过的路啊，终究会是你人生的烙印。

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

在 kubernetes 中水平伸缩 pod 只是陈述式的：“ 我想要运行 x 个实例 ” 。

你不是告诉 kubernetes 做什么或如何去做。只是指定了期望的状态。

这种声明式做法使得与 kubernetes 集群的交互更容易。试想，如果你必须手动确认当前运行的实例数量，再去指定 kubernetes 运行多少个实例。工作容易出错且更复杂。



#### 删除 rc



### 使用 replicaSet 而不是 rc

最初，ReplicationController 是用于复制和异常时重新调度节点的唯一组件。后来引入了 RepliaSet 这种资源。它是新一代的 rc。

请记住，始终使用 rs ，而不是使用 rc 。



ReplicaSet 的行为与 rc 完全相同，但 pod 的选择器的表达能力更强。

- 单个 rc 无法同时匹配两个标签，即无法匹配到同时存在 env=pro 和 env=dev 的容器。而 RepliaSet 可以。 
- rc 无法通过标签名来匹配 pod 。即 rc 无法匹配 env=* 的容器。



#### 创建和检查rs

```shell
kubectl get rs 

kubectl describe  rs 
```

rs 的 YAML 定义



### 使用 DaemonSet 在节点上运行 pod

rc 和 rc 都用于在 kubernetes 集群上部署特定数量的 pod 。但是当你希望在集群中的每个节点上运行 pod 时（并且每个节点正好要运行一个 pod ）。

例如，希望在每个节点上运行日志收集器和资源监控器。另一个典型的例子是 kubernetes 自己的 kube-proxy 进程。它需要运行在所有节点上才能工作。





### 运行执行单个任务的 pod 





## 服务：让客户端发现 pod 并与之通信

现在已经学习过了 pod ，以及如何通过 rs 和类似资源部署运行。尽管特定的 pod 可以独立的应对外部刺激，现在大多数应用都需要根据外部请求做出响应。

例如，就微服务而言，pod 通常需要对来自集群内部的其他 pod ，以及来自外部客户端的 HTTP 请求做出响应。



在没有 kubernetes 的世界，一般需要在配置文件中明确指出服务端的IP地址来使用。在 Kubernetes 中并不适用。

- pod 是短暂的，它们随时会被启动或者关闭。



kubernetes 服务是一种做为一组功能相同的 pod 提供单一不变的接入点的资源。kubernets 使用服务来暴露应用。

当服务存在时，它的 IP 地址和端口不会变。客户端通过 IP 地址和端口号建立连接，这些连接会被路由到提供该服务的任意一个 pod 上。 



### 创建服务

创建服务一般有两种方法，有



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
  - port: 80
    targetPort: 8080
  selector:
    app: kubia
```

通过 kubernetes create 命令创建服务后，可以在命名空间下列出所有服务资源 kubectl get svc 

列表可以显示出分配给服务的 IP 地址，一般是集群内部的地址，只能在集群内部被访问。服务一般要被集群内部其他 pod 访问，以及外部客户端访问。

先看内部访问的几种方法：

- 创建一个 pod ，它将请求发送到服务的集群 IP 并记录响应
- 通过 ssh 远程到其中一个 kubernetes 节点上，然后执行 curl 命令
- 通过 kubectl exec 命令在一个已存在的 pod 中执行 curl 命令



可以使用 kubectl exec 命令远程地在一个已经存在的 pod 容器上执行任何命令。使用 kubectl get pod 列出所有 pod 

```shell
kubectl exec kubia-7nogl -- curl http://10.111.249.153

# 双斜杠代表着 kubectl 命令的结束。
```



### 同一个服务暴露多个端口

创建的服务可以暴露一个端口，也可以暴露多个端口。

比如，pod 监听两个端口，http 监听 8080 端口，https 监听 8443 端口。

可以在一个服务中暴露 80 和 443 端口，并分别转发到 pod 中的对应端口。通过一个集群IP，使用一个服务将多个端口暴露出来。

```shell
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

使用命名端口的意思，即在 pod 定义中为端口命名，在 svc 中直接将端口转发到名称中。



### 服务发现

通过创建服务，可以通过一个单一稳定的 IP 地址访问到 pod。在服务器的整个生命周期内这个IP地址保持不变。

客户端 pod 如何知道服务的 IP 地址和端口？





#### 通过环境变量发现服务

在 pod 开始运行的时候，kubernetes 会初始化一系列的环境变量指向现在存在的服务。

如果你创建的服务早于客户端 pod 的创建，pod 上的进程可以根据环境变量获得服务的 IP 地址和端口号。







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





### 将服务暴露给外部客户端



有几种方式可以在外部访问服务：

- 将服务的类型设置为 NodePort —— 每个集群节点都会在节点上打开一个端口。
- 



#### NodePort 

将一组 pod 公开给外部客户端的第一种方法是创建一个服务并将其类型设置为 NodePort 。

通过创建的 NodePort 服务，可以让 kubernetes 在其所有节点上保留一个端口（所有节点上都是用相同的端口号）

这与常规服务类似（它们实际的类型 ClusterIP），但是不仅可以通过服务的内部集群 IP 访问 NodePort 服务。

还可以通过任何节点的 IP 和预留节点端口访问 NodePort 服务。

当尝试与 NodePort 服务交互式，意义更大。



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





#### 通过 Ingress 暴露服务



Ingress 





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







