# kafka概述



Kafka 是一种高吞吐、分布式、基于发布和订阅模型的消息系统，最初是由 LinkedIn 公司采用 Scala 和 Java 开发的开源流处理软件平台，目前是 Apache 的开源项目。

Kafka 用于离线和在线消息的消费，将消息数据按顺序保存在磁盘上，并在集群内以副本的形式存储以防止数据丢失。

Kafka 可以依赖 ZooKeeper 进行集群管理，并且受到越来越多的分布式处理系统的青睐，比如 Storm、Spark、Flink 等都支持与 Kafka 集成，用于实时流式计算。