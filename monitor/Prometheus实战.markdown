## DevOps监控理念

devops基本理念：

1. if you can’t measure it,you can’t improve it
2. you build it,you run it, you monitor it. 谁开发，谁运维，谁监控，

四种主要的监控方式

1. Logging
2. Tracing
3. Metric
4. Healthchecks

监控是分层次的， 以metric 为例

1. 系统层，比如cpu、内存监控，面向运维人员
2. 应用层，应用出错、请求延迟等，业务开发、框架开发人员
3. 业务层，比如下了多少订单等，业务开发人员





## 监控的几个反模式

1. 事后监控，没有把监控作为系统的核心功能

2. 机械式监控，比如只监控cpu、内存等，程序出事了没报警。只监控http status=200，这样数据出错了也没有报警。

3. 不够准确的监控

4. 静态阈值，静态阈值几乎总是错误的，如果主机的CPU使用率超过80%就发出警报。这种检查通常是不灵活的布尔逻辑或者一段时间内的静态阈值，它们通常会匹配特定的结果或范围.

   这种模式 没有考虑到大多数复杂系统的动态性。为了更好地监控，我们需要查看数据窗口，而不是静态的时间点。

5. 不频繁的监控

6. 缺少自动化或自服务



一个良好的监控系统 应该能提供 全局视角，从最高层（业务）依次（到os）展开。同时它应该是：内置于应用程序设计、开发和部署的生命周期中。

很多团队都是按部就班的搭建监控系统：一个常见的例子是监控每台主机上的 CPU、内存和磁盘，但不监控可以指示主机上应用程序是否正常运行的关键服务。

如果应用程序在你 没有注意到的情况下发生故障，那么即使进行了监控，你也需要重新考虑正在监控的内容是否合理。

**根据服务价值设计自上而下（业务逻辑 ==> 应用程序 ==> 操作系统）**的监控系统是一个很好的方式，这会帮助明确应用程 序中更有价值的部分，并优先监控这些内容，再从技术堆栈中依次向下推进。

从业务逻辑和业务输出开始，向下到应用程序逻辑，最后到基础设施。这并不意味着你不需要收集基础设施或操作系统指标——它们在诊断和容量规划中很有帮助——但你不太可能使用这些来报告应用程序的价值。

如果无法从业务指标开始，则可试着从靠近用户侧的地方开始监控。因为他们才是最终的客 户，他们的体验是推动业务发展的动力。

> PS：只要业务没事，底层os一定没事， 底层os没事，业务逻辑不一定没事，监控要尽量能够反应用户的体验。



## metric 种类

Metrics，谷歌翻译就是度量的意思。当我们需要为某个系统某个服务做监控、做统计，就需要用到Metrics。

举个栗子，一个图片压缩服务：

1. 每秒钟的请求数是多少（TPS）？
2. 平均每个请求处理的时间？
3. 请求处理的最长耗时？
4. 等待处理的请求队列长度？

又或者一个缓存服务：

1. 缓存的命中率？
2. 平均查询缓存的时间？



Prometheus 中的 metric 种类

1. counter（计数器），始终增加，比如 http 请求数、下单数
2. gauge（测量仪），当期值的一次快照测量，可增可减。比如磁盘使用率、当前同时在线用户数
3. Histogram（直方图），通过分桶方式统计样本分布
4. Summary（汇总），根据样本统计出百分位，比如客户端计算

4个黄金指标可以在服务级别帮助衡量终端用户体验、服务中断、业务影响等层面的问题。

1. 延迟：服务请求所需时间。
2. 通讯量：监控当前系统的流量，用于衡量服务的容量需求。例如，在HTTP REST API中, 流量通常是每秒HTTP请求数；
3. 错误：监控当前系统所有发生的错误请求，衡量当前系统错误发生的速率。
4. 饱和度：衡量当前服务的饱和度。比如，“磁盘是否可能在4个小时候就满了”。

这四个指标并不是唯一的系统性能或状况的衡量标准，系统可以简单分为两类

1. 资源提供系统 - 对外提供简单的资源，比如CPU（计算资源），存储，网络带宽。 针对资源提供型系统，有一个更简单直观的USE标准
   1. Utilization - 往往体现为资源使用的百分比
   2. Saturation - 资源使用的饱和度或过载程度，**过载的系统往往意味着系统需要辅助的排队系统完成相关任务**。这个和上面的Utilization指标有一定的关系但衡量的是不同的状况，以CPU为例，Utilization往往是CPU的使用百分比而Saturation则是当前等待调度CPU的县城或进程队列长度
   3. Errors - 这个可能是使用资源的出错率或出错数量，比如网络的丢包率或误码率等等
2. 服务提供系统 - 对外提供更高层次与业务相关的任务处理能力，比如订票，购物等等。针对服务型系统，则往往用RED方式进行衡量
   1. Rate - 单位时间内完成服务请求的能力
   2. Errors - 错误率或错误数量：单位时间内服务出错的比列或数量
   3. Duration - 平均单次服务的持续时长（或用户得到服务响应的时延）

**Prometheus 提供的许多exporter 或者直接提供上述metric，或者通过计算可以得到上述metric**。或者反过来说，这些原则指导了exporter 去暴露哪些metric。







## Prometheus实战



普罗米修斯官网是 https://prometheus.io/

普罗米修斯最早是 SoundCloud 公司开发的开源的监控告警系统。在 2012年后，越来越多的公司组织开始使用。

现在已经是一个独立的开源项目。紧跟 kubernetes 之后，在 2016 年加入 CNCF （云原生计算基金会）



主要特性：

- 多维度数据模型
- 灵活的查询语言
- 不依赖任何分布式存储
- 常见方式是通过拉取方式采集数据
- 也可通过中间网关支持推送方式采集数据
- 通过服务发现或者静态配置来发现监控目标
- 支持多种图形界面展示方式





```shell
# 下载 

cd /usr/local/src/

wget  https://github.com/prometheus/prometheus/releases/download/v2.21.0/prometheus-2.21.0.linux-amd64.tar.gz

mkdir /usr/local/prometheus/

tar xf prometheus-2.21.0.linux-amd64.tar.gz  -C /usr/local/prometheus/

cd /usr/local/prometheus/

ln -s prometheus-2.21.0.linux-amd64  prometheus


#　配置文件

cd /usr/lib/systemd/system
 
vim  prometheus.service 

[Unit]
Description=prometheus
After=network.target 

[Service]
User=prometheus
Group=prometheus
WorkingDirectory=/usr/local/prometheus/prometheus
ExecStart=/usr/local/prometheus/prometheus/prometheus
[Install]
WantedBy=multi-user.target


# 启动管理
systemctl start prometheus 
systemctl status prometheus
# 开机自启
systemctl enable prometheus



# 默认情况下prometheus会将采集的数据防止到本机的data目录的， 存储数据的大小受限和扩展不便。
# 这是使用influxdb作为后端的数据库来存储数据。

# influxdb的官方文档地址为： https://docs.influxdata.com/influxdb/v1.7/introduction/downloading/ 
# 可以根据不同系统进行下载，这里使用官方提供的rpm进行安装。

cd /usr/local/src/
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.8.x86_64.rpm

sudo yum localinstall influxdb-1.7.8.x86_64.rpm

```







Prometheus 是将所有数据存为时序数据。

每个时序数据是由指标名称和可选的键值对（称之为标签）唯一标识。



![img](Prometheus实战.assets/429277-20190924170625913-1325486532.png)



#### 度量类型

- counter: 单调递增的计数器，如果标识已经服务的请求数量可以使用该类型。

- Guage: 仪表盘类型， 可以任意上升或者下降的度量类型。

- Histogram：直方图类型， 可以通过该类型获取分位数，计算分位点数据是在服务端完成的。

- Summary： 摘要类型，类似于直方图，计算分位点数据是在客户端完成的