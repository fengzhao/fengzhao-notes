# 概述

Zookeeper 分布式服务框架是Apache Hadoop 的一个子项目，它主要是用来解决分布式应用中经常遇到的一些数据管理问题。如：统一命名服务、状态同步服务、集群管理、分布式应用配置项的管理等

Zookeeper 作为一个分布式的服务框架，**主要用来解决分布式集群中应用系统的一致性问题。**



构建一个分布式应用是一个很复杂的事情，主要的原因是我们需要合理有效的处理分布式集群中的部分失败的问题。

例如，集群中的节点在相互通信时，A节点向B节点发送消息。A节点如果想知道消息是否发送成功，只能由B节点告诉A节点。那么如果B节点关机或者由于其他的原因脱离集群网络，问题就出现了。

A节点不断的向B发送消息，并且无法获得B的响应。B也没有办法通知A节点已经离线或者关机。集群中其他的节点完全不知道B发生了什么情况，还在不断的向B发送消息。



它能提供基于类似于文件系统的目录节点树方式的数据存储， Zookeeper 作用主要是用来维护和监控存储的数据的状态变化，通过监控这些数据状态的变化，从而达到基于数据的集群管理。

简单的说，zookeeper=文件系统+通知机制



ZooKeeper 作为一个分布式协调服务，给出了在分布式环境下一致性问题的工业解决方案，目前流行的很多开源框架技术背后都有 ZooKeeper 的身影。





## 数据模型

计算机最根本的作用其实就是处理和存储数据，作为一款分布式一致性框架，ZooKeeper 也是如此。数据模型就是 ZooKeeper 用来存储和处理数据的一种逻辑结构。





```
cd /data/
wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz


```



ZooKeeper 中的数据模型是一种树形结构，非常像电脑中的文件系统，有一个根文件夹，下面还有很多子文件夹。

ZooKeeper 的数据模型也具有一个固定的根节点（/），我们可以在根节点下创建子节点，并在子节点下继续创建下一级节点。

ZooKeeper 树中的每一层级用斜杠（/）分隔开，且只能用绝对路径（如“get /work/task1”）的方式查询 ZooKeeper 节点，而不能使用相对路径。





Znode有两种，分别为临时节点和持久节点。节点的类型在创建时即被确定，并且不能改变。

- 临时节点：该节点的生命周期依赖于创建它们的会话。一旦会话结束，临时节点将被自动删除，当然可以也可以手动删除。临时节点不允许拥有子节点。

  - 在平时的开发中，我们可以利用临时节点的这一特性来做服务器集群内机器运行情况的统计，将集群设置为“/servers”节点，并为集群下的每台服务器创建一个临时节点“/servers/host”，当服务器下线时该节点自动被删除，最后统计临时节点个数就可以知道集群中的运行情况。

- 永久节点：该节点的生命周期不依赖于会话，并且只有在客户端显示执行删除操作的时候，他们才能被删除。

- 有序节点：

  - 所谓节点有序是说在我们创建有序节点的时候，ZooKeeper 服务器会自动使用一个单调递增的数字作为后缀，追加到我们创建节点的后边。

    例如一个客户端创建了一个路径为 works/task- 的有序节点，那么 ZooKeeper 将会生成一个序号并追加到该节点的路径后，最后该节点的路径为 works/task-1。通过这种方式我们可以直观的查看到节点的创建顺序。



ZooKeeper 中的每个节点都维护有这些内容：一个二进制数组（byte data[]），用来存储节点的数据、ACL 访问控制信息、子节点数据（因为临时节点不允许有子节点，所以其子节点字段为 null），除此之外每个数据节点还有一个记录自身状态信息的字段 stat。



节点状态