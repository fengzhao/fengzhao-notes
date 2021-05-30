# 简介



ETCD 是 CoreOS团队于2013年6月发起的开源项目，它是一个高可用的分布式键值数据库，可用于**配置共享**和**服务发现**。

ETCD 内部采用 raft 一致性算法，基于 Go 语言实现。

> A highly-available key value store for shared configuration and service discovery.

实际上，etcd 作为一个受到 Zookeeper 和 doozer 启发而催生的项目，除了拥有与之类似的功能外，更具有以下4个特点



- 简单：安装配置使用简单，提供 HTTP API

- 安全：支持 SSL 证书

- 可靠：采用 raft 算法，实现分布式系统数据的可用性和一致性
- 快速：每个实例每秒支持一千次写操作。



在 CAP 理论上，zookeeper和etcd都是强一致的（满足CAP的CP），意味着无论你访问任意节点，都将获得最终一致的数据视图。

这里最终一致比较重要，因为zk使用的paxos和etcd使用的raft都是quorum机制（大多数同意原则）。

所以部分节点可能因为任何原因延迟收到更新，但数据将最终一致，高度可靠。

**应用案例**

- Kubernetes（etcd是服务发现和存储集群状态和配置的后端）
- OpenStack（etcd作为配置存储、分布式密钥锁定等的可选提供者）
- Rook（etcd是Rook的编排引擎）
- 



## 安装



去 [GitHub releases page](https://github.com/etcd-io/etcd/releases)上，根据自己的系统下载对应的软件包，下载完成后解压。



```shell
ETCD_VER=v3.2.32

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GITHUB_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

/tmp/etcd-download-test/etcd --version
ETCDCTL_API=3 /tmp/etcd-download-test/etcdctl version
```





## 使用



通过 etcdctl 可以使用 ETCD。假设使用 v3 版本，且集群设置如下

```shell
# 将上述命令写到 ~/.bashrc 文件中，每次登陆后即设置环境变量
export ETCDCTL_API=3
HOST_1=192.168.4.96
HOST_2=192.168.4.100
HOST_3=192.168.4.101
ENDPOINTS=$HOST_1:2379,$HOST_2:2379,$HOST_3:2379


# 集群健康状态检查
etcdctl --cacert=/opt/etcd/ssl/ca.pem  \
	--cert=/opt/etcd/ssl/server.pem \
	--key=/opt/etcd/ssl/server-key.pem \
    --endpoints=$ENDPOINTS endpoint health


```







# 应用场景



## 服务发现

服务发现（Service Discovery）要解决的是分布式系统中最常见的问题之一，即在同一个分布式集群中的进程或服务如何才能找到对方并建立连接。



从本质上说，服务发现就是要了解集群中是否有进程在监听 upd 或者 tcp 端口，并且通过名字就可以进行查找和链接。

要解决服务发现的问题，需要下面三大支柱，缺一不可。

- 一个强一致性、高可用的服务存储目录。
  - 基于 Ralf 算法 的etcd 天生就是这样一个强一致性、高可用的服务存储目录。
- 一种注册服务和健康服务健康状况的机制。
  - 用户可以在 etcd 中注册服务，并且对注册的服务配置`key TTL`，定时保持服务的心跳以达到监控健康状态的效果。
- 一种查找和连接服务的机制。
  - 通过在 etcd 指定的主题下注册的服务业能在对应的主题下查找到。
  - 为了确保连接，我们可以在每个服务机器上都部署一个 proxy 模式的 etcd，这样就可以确保访问 etcd 集群的服务都能够互相连接。

 

**在微服务协同工作架构中，服务动态添加。**

随着Docker容器的流行，多种微服务共同协作，构成一个功能相对强大的架构的案例越来越多。

透明化的动态添加这些服务的需求也日益强烈。通过服务发现机制，在etcd中注册某个服务名字的目录，在该目录下存储可用的服务节点的IP。

在使用服务的过程中，只要从服务目录下查找可用的服务节点进行使用即可。













# etcd数据备份与恢复



```shell
# 单机备份，执行etcd备份数据的恢复的机器必须和原先etcd所在机器一致

etcdctl --endpoints="https://10.25.72.62:2379" \
--cert=/etc/etcd/ssl/etcd.pem \
--key=/etc/etcd/ssl/etcd-key.pem \
--cacert=/etc/kubernetes/ssl/ca.pem \
snapshot save snapshot.db
```







https://cizixs.com/2016/08/02/intro-to-etcd/

https://tonydeng.github.io/2015/10/19/etcd-application-scenarios/

[http://jm.taobao.org/2018/06/26/聊聊微服务的服务注册与发现/](http://jm.taobao.org/2018/06/26/聊聊微服务的服务注册与发现/)



http://ldaysjun.com/2019/01/14/Microservice/micro3/



etcd备份与恢复

https://www.cnblogs.com/lvcisco/p/10310332.html