## DevOps监控理念

devops基本理念：

1. if you can’t measure it, you can’t improve it
2. you build it,you run it, you monitor it. 谁开发，谁运维，谁监控

四种主要的监控方式

1. Logging
2. Tracing
3. Metric
4. Healthchecks

监控是分层次的， 以metric 为例

1. 系统层，比如cpu、内存监控，面向运维人员
2. 应用层，应用出错、请求延迟等，业务开发、框架开发人员
3. 业务层，比如下了多少订单等，业务开发人员





## 监控的目标

在《SRE: Google运维解密》一书中指出，监控系统需要能够有效的支持白盒监控和黑盒监控。

通过白盒能够了解其内部的实际运行状态，通过对监控指标的观察能够预判可能出现的问题，从而对潜在的不确定因素进行优化。

而黑盒监控，常见的如HTTP探针，TCP探针等，可以在系统或者服务在发生故障时能够快速通知相关的人员进行处理。



通过建立完善的监控体系，从而达到以下目的：

- 长期趋势分析：通过对监控样本数据的持续收集和统计，对监控指标进行长期趋势分析。例如，通过对磁盘空间增长率的判断，我们可以提前预测在未来什么时间节点上需要对资源进行扩容。
- 对照分析：两个版本的系统运行资源使用情况的差异如何？在不同容量情况下系统的并发和负载变化如何？通过监控能够方便的对系统进行跟踪和比较。
- 告警：当系统出现或者即将出现故障时，监控系统需要迅速反应并通知管理员，从而能够对问题进行快速的处理或者提前预防问题的发生，避免出现对业务的影响。
- 故障分析与定位：当问题发生后，需要对问题进行调查和处理。通过对不同监控监控以及历史数据的分析，能够找到并解决根源问题。
- 数据可视化：通过可视化仪表盘能够直接获取系统的运行状态、资源使用情况、以及服务运行状态等直观的信息。



## 可观测性

**指标监控**

通常使用折线图形态呈现在图表上，比如某个机器的 CPU 利用率、某个数据库实例的流量或者网站的在线人数，都可以体现为随着时间而变化的趋势图。

指标监控只能处理数字，但它的历史数据存储成本较低，实时性好，生态庞大，是可观测性领域里最重要的一根支柱。



**日志**

从日志中可以得到很多信息，对于了解软件的运行情况、业务的运营情况都很关键。比如操作系统的日志、接入层的日志、服务运行日志，都是重要的数据源。

处理日志这个场景，也有很多专门的系统，比如开源产品 ELK 和 Loki，商业产品 Splunk 和 Datadog



**链路追踪**

服务之间有错综复杂的调用关系，一个问题具体是哪个模块导致的，排查起来其实非常困难。
链路追踪的思路是以请求串联上下游模块，为每个请求生成一个随机字符串作为请求 ID。服务之间互相调用的时候，把这个 ID 逐层往下传递，每层分别耗费了多长时间，是否正常处理，都可以收集起来附到这个请求 ID 上。后面追查问题时，拿着请求 ID 就可以把串联的所有信息提取出来。链路追踪这个领域也有很多产品，比如 Skywalking、Jaeger、Zipkin 等，都是个中翘楚。



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



在应用程序中，通常会记录日志以便事后分析，在很多情况下是产生了问题之后，再去查看日志是一种事后的静态分析。

在很多时候，我们可能需要了解整个系统在当前，或者某一时刻运行的情况。比如：

- 每秒钟的请求数是多少（TPS）？

- 请求处理的最长耗时？

- 请求处理正确响应率？

以及系统运行出错率等等一系列的实时数据。通过 Metrics 监控这些指标的度量，可以来告诉我们应用是否健康。

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



Prometheus 中的 metric 种类：



- gauge   （测量仪/计量器），当期值的一次快照测量，可增可减。比如磁盘使用率、当前同时在线用户数。
  - 它可以表示一个**既可以增加, 又可以减少**的度量指标值。
  - 它是最简单和最基本的Metrics类型，只有一个简单的返回值，通常用来记录一些对象或者事物的**瞬时值**。
  - 典型的应用场景：温度，内存使用量
- counter（计数器）它是一种**累计型**的度量指标，数值只能**单调递增**。
  - 计数器的典型应用场景： http 请求数、下单数，任务完成次数，错误出现次数。
- Histogram（直方图），通过分桶方式统计样本分布
  - Histrogram可以计算最大/小值、平均值，方差，分位数（如中位数，或者95th分位数），如75%,90%,98%,99%的数据在哪个范围内。
  - 直方图的典型使用场景包括：流量最大值，流量最小值，流量平均值等



1. counter（计数器），始终增加，比如 http 请求数、下单数
2. gauge（测量仪/计量器），当期值的一次快照测量，可增可减。比如磁盘使用率、当前同时在线用户数
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

export VERSION=2.4.3
curl -LO  https://github.com/prometheus/prometheus/releases/download/v$VERSION/prometheus-$VERSION.linux-amd64.tar.gz

wget  https://github.com/prometheus/prometheus/releases/download/v2.21.0/prometheus-2.21.0.linux-amd64.tar.gz

tar -zxvf prometheus-2.27.0.linux-amd64.tar.gz  -C /usr/local

mv /usr/local/prometheus-2.27.0.linux-amd64  /usr/local/prometheus

# ubuntu18.04
vim /etc/systemd/system/prometheus.service
# centos7
vim /usr/lib/systemd/system/prometheus.service 
 
[Unit]
Description=prometheus
After=network.target 

[Service]
User=prometheus
Group=prometheus
WorkingDirectory=/usr/local/prometheus
ExecStart=/usr/local/prometheus/prometheus

[Install]
WantedBy=multi-user.target


useradd prometheus 
chown -R prometheus:prometheus  /usr/local/prometheus/


# 启动管理
systemctl start prometheus 
systemctl status prometheus
# 开机自启
systemctl enable prometheus



# 默认情况下prometheus会将采集的数据到本机当目录下的data目录中， 存储数据的大小受限和扩展不便。
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



#### 指标类型

- counter: 单调递增的计数器，如果标识已经服务的请求数量可以使用该类型。

- Guage: 仪表盘类型， 可以任意上升或者下降的度量类型。

- Histogram：直方图类型， 可以通过该类型获取分位数，计算分位点数据是在服务端完成的。

- Summary： 摘要类型，类似于直方图，计算分位点数据是在客户端完成的







## 安装





```shell
# https://github.com/prometheus/node_exporter

cd /usr/local/

wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz

tar -zxvf node_exporter-1.1.2.linux-amd64.tar.gz

mv node_exporter-0.18.1.linux-amd64 /usr/local/node_exporter

ln -s /usr/local/node_exporter/node_exporter /usr/local/bin/node_exporter

useradd -r -s /bin/nologin node_exporter

mkdir -p /var/lib/node_exporter/textfile_collector 

chown -R node_exporter:node_exporter /var/lib/node_exporter/textfile_collector 

mkdir -p /etc/sysconfig/

touch /etc/sysconfig/node_exporter
# OPTIONS="--collector.textfile.directory /var/lib/node_exporter/textfile_collector"

touch /etc/systemd/system/node_exporter.service

[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter --log.level=error
ExecStop=/usr/bin/killall node_exporter
MemoryLimit=300M #限制内存使用最多300M
CPUQuota=100% #限制CPU使用最多一个核

[Install]
WantedBy=multi-user.target
```













## influxdb时序数据库


```shell
# influxdb的官方文档地址为： https://docs.influxdata.com/influxdb/v2.0/get-started/?t=Linux
# 可以根据不同系统进行下载，这里使用官方提供的deb包进行安装。

# debian & ubuntu
wget https://dl.influxdata.com/influxdb/releases/influxdb2-2.0.6-amd64.deb
sudo dpkg -i influxdb2-2.0.6-amd64.deb


# rhel & centos
wget https://dl.influxdata.com/influxdb/releases/influxdb2-2.0.6.x86_64.rpm
sudo yum localinstall influxdb2-2.0.6.x86_64.rpm

sudo service influxdb start
sudo service influxdb status 

# 要注意设置服务器时区
timedatectl set-timezone  Asia/Shanghai

# 配置目录
# 时序数据目录   Time series data: /var/lib/influxdb/engine/
# 键值数据墓库   Key-value data: /var/lib/influxdb/influxd.bolt
# influx CLI configurations: ~/.influxdbv2/configs (see influx config for more information) .

# 默认地，InfluxDB 使用 TCP 8086 端口来提供客户端和服务端的  InfluxDB HTTP API 通讯。
```















https://xinlichao.cn/back-end/java/prometheus/