

# Grafana Loki 概述

`Grafana Loki` 是一套可以组合成一个功能齐全的日志堆栈组件。

与其他日志记录系统不同，Loki 是基于仅索引有关日志元数据的想法而构建的：**标签**（就像 Prometheus 标签一样）。

日志数据本身被压缩然后并存储在对象存储（例如 S3 或 GCS）的块中，甚至存储在本地文件系统上，轻量级的索引和高度压缩的块简化了操作，并显著降低了 Loki 的成本，Loki 更适合中小团队。

由于 Loki 使用和 Prometheus 类似的标签概念，所以如果你熟悉 Prometheus 那么将很容易上手，也可以直接和 Grafana 集成，只需要添加 Loki 数据源就可以开始查询日志数据了。



Loki 还提供了一个专门用于日志查询的 `LogQL` 查询语句，类似于 `PromQL`，通过 LogQL 我们可以很容易查询到需要的日志，也可以很轻松获取监控指标。

Loki 还能够将 LogQL 查询直接转换为 Prometheus 指标。

此外 Loki 允许我们定义有关 LogQL 指标的报警，并可以将它们和 Alertmanager 进行对接。



Grafana Loki 主要由 3 部分组成:

- `loki`: 日志记录引擎，负责存储日志和处理查询
- `promtail`: 代理，负责收集日志并将其发送给 loki
- `grafana`: UI 界面







# 数据存储



loki 数据分为两种，索引和日志块：

- **Index（索引）**
  - 这是一个**key/value结构的查找表**，存储了标签（元数据）与日志数据块位置之间的映射关系。
  - 索引告诉 Loki，对于某个特定的标签组合，去哪里找到相关的日志数据块(value)。
  - key 是日志 labels 的哈希，value 包含日志存在哪个分片（chunks）上、分片大小、日志时间范围等信息。

- **Chunks（数据块/日志数据）**:
  - 这是实际的**日志内容**，被压缩后以数据块的形式存储。
  - 这些数据块通常按照流（由一组标签定义）进行组织。



目前（从 Loki 2.0 推出 `boltdb-shipper`，到 Loki 2.8 推荐 `TSDB`）

Loki 的推荐架构是 **Single Store**，这意味着它**只需要一个统一的存储后端**（通常是对象存储）来存储**所有数据**（包括 Chunks 和 Index）。

- 以 TSDB 格式存储。15 分钟存一次对象存储。

- 日志分片数据，压缩，存在对象存储中。Ingester 定期将日志分片存到对象存储中。

# loki架构

Grafana Loki 采用基于微服务的架构，设计为水平可伸缩的分布式系统。该系统包含多个可以独立并行运行的组件。

Grafana Loki 的设计将所有组件的代码编译到一个单一二进制文件或 Docker 镜像中。`-target` 命令行标志控制该二进制文件作为哪些组件运行。



## Distributor

`Distributor`是Loki日志写入的最前端，当它收到日志时会验证其正确性，之后会将日志切成块（chunk）后，转给`Ingester`负责存储。

- **Distributor (分发器)**:
  - Loki 是接收日志的第一站。
  - 它是一个**无状态**的组件，可以水平扩展来处理高流量。
  - 主要职责：**验证、预处理、限流、分发**。
- **Stream (流)**:
  - 一个 **唯一的标签集** 就构成一个 stream。
  - 例如，`{app="nginx", env="prod"}` 是一个 stream，`{app="nginx", env="staging"}` 是另一个 stream。
  - 所有拥有相同标签集的日志行都属于同一个 stream。
- **Limits (限制)**:
  - 为了保护 Loki 集群的稳定性，防止被恶意或配置错误的客户端“打爆”而设置的一系列规则。
  - **高基数 (High Cardinality)** 的 stream（即不同组合的标签集太多）是 Loki 性能的天敌，因此限制 stream 数量至关重要。
- **Tenant (租户)**:
  - Loki 支持多租户架构，允许不同的团队、应用或客户共享同一个 Loki 集群，但数据互相隔离。
  - 租户信息通常通过 HTTP Header (`X-Scope-OrgID`) 传递。



当 Promtail 或其他客户端将一批日志（a batch of logs）发送给 distributor 时，distributor 会执行以下一系列严格的验证检查。

如果任何一项检查失败，该批日志就会被拒绝，并向客户端返回 `4xx` 错误码。



主要的验证内容包括：

1. **最大 Label 数量**:
   - **做什么**: 检查一个 stream 中的标签数量是否超过了设定的上限 (e.g., `max_labels_per_stream`)。
   - **为什么**: 防止标签滥用，过多的标签会增加索引的复杂度和存储。
2. **Label 名称/值的长度**:
   - **做什么**: 检查每个标签的名称 (key) 和值 (value) 的长度是否超过上限 (e.g., `max_label_name_length`, `max_label_value_length`)。
   - **为什么**: 同样是为了防止索引膨胀和不规范的数据。
3. **最大日志行大小**:
   - **做什么**: 检查单条日志的字节大小是否超过上限 (e.g., `max_line_size`)。
   - **为什么**: 防止单条过大的日志（如一个完整的 stack trace）消耗过多内存和存储。
4. **时间戳验证**:
   - **做什么**: 确保日志的时间戳不是太旧或太超前 (e.g., `reject_old_samples`)。
   - **为什么**: 保证日志数据的时序性，防止乱序数据影响存储和查询效率。
5. **摄入速率限制 (Ingestion Rate Limit)**:
   - **做什么**: 这是**最重要**的限制之一。它通过令牌桶算法限制每个租户每秒可以发送的数据量（字节/秒）和日志行数（行/秒）。(e.g., `ingestion_rate_mb`, `ingestion_burst_size_mb`)
   - **为什么**: 防止任何一个租户因为日志流量突增（“日志雪崩”）而耗尽整个集群的资源，影响其他租户。这是解决“**嘈杂邻居**”（Noisy Neighbor）问题的关键。
6. **最大活跃 Stream 数量 (Max Active Streams)**:
   - **做什么**: 限制单个租户在一段时间内可以拥有的活跃 stream 的总数 (e.g., `max_active_streams_per_user`)。
   - **为什么**: 这是**为了对抗高基数问题**。每个活跃的 stream 都会在 ingester 中占用一定的内存。如果一个租户创建了数百万个 stream（例如，把用户ID、请求ID等动态值放进了 label），会迅速耗尽 ingester 的内存（OOM），导致集群崩溃。



`distributor` 通过对每个 stream 进行一系列严格的验证，扮演了 Loki 集群守护神的角色。

它利用一个分层的限制系统（优先使用租户特定限制，否则回退到全局限制），来达到以下目的：

- **保障系统稳定性**: 防止因为流量或高基数问题导致服务崩溃。
- **实现多租户公平性**: 确保没有租户能过度消耗资源，影响他人。
- **提升性能**: 通过限制高基数，间接保证了查询性能。
- **提供灵活性**: 允许管理员为不同级别的用户或团队分配不同的资源配额。



## Ingester

`Ingester`主要负责将从收集器()接收到的日志数据**==写入==**到后端存储，如DynamoDB，S3，Cassandra等），同时它还会将日志信息发送给`Querier`组件。





- Querier

`Querier`主要负责从`Ingester`和后端存储里面提取日志，并用LogQL查询语言处理后返回给客户端

- Query Frontend

`Query frontend`主要提供查询API，它可以将一条大的查询请求拆分成多条让`Querier`并行查询，并汇总后返回。

它是一个可选的部署组件，通常我们部署它用来防止大型查询在单个查询器中引起内存不足的问题。







## loki生态体系工具

`logcli` 是 **Loki 的官方 CLI 客户端**，用于直接查询 Loki 实例中的日志数据，功能类似于 `curl` + PromQL 的组合，但专为日志设计。

#### 🔧 功能：

- 执行 LogQL 查询（Loki 的查询语言）
- 查看日志流（`--tail` 模式）
- 支持认证（API Key、Bearer Token、Basic Auth）
- 输出格式化（JSON、logfmt 等）



###  **Loki 的健康探测工具（Canary）**

#### ✅ 作用：

`loki-canary` 是一个“金丝雀”测试工具，用于**持续写入和读取测试日志到 Loki**，验证 Loki 的写入和查询是否正常。

#### 🔧 功能：

- 持续向 Loki 发送模拟日志（可指定标签）
- 定期查询自己写入的日志，验证可读性
- 如果写入或查询失败，可触发告警（集成 Prometheus）
- 可用于监控 Loki 集群的可用性和延迟





## Promtail



`Promtail` 是一个Agent，用于将本地日志内容发送到Loki。通常，它部署在需要监控的每台机器上。

其主要功能包括：

1. 发现目标：Promtail能够主动探测并发现需要监控的目标。
2. 为日志流添加标签：Promtail可以给日志流附加标签，以便更好地进行过滤和查询。
3. 将日志推送至Loki：Promtail将处理后的日志推送到Loki中进行存储和分析。



目前，`Promtail` 可以从两个来源获取日志：本地日志文件和`systemd journal`日志（仅适用于AMD64架构的机器）。





在Promtail能够将日志文件的数据发送到Loki之前，它需要获取有关其环境的信息。具体来说，这意味着发现将日志行发送到需要监控的文件的应用程序。

Promtail使用了与Prometheus相同的服务发现机制，尽管目前它仅支持静态和Kubernetes服务发现。

这个限制是因为Promtail作为一个守护程序部署在每台本地机器上，并且无法从其他机器上发现标签。



Kubernetes服务发现从Kubernetes API服务器获取所需的标签，而静态服务发现通常涵盖其他所有用例。

与Prometheus一样，Promtail使用`scrape_configs`配置段进行配置。

通过`relabel_configs`，可以对要获取的内容、要丢弃的内容以及要附加到日志行的最终元数据进行精细控制。



### 管道

管道用于转换单个日志行、其标签和其时间戳。管道由一组**阶段**组成。有 4 种类型的阶段：

- **解析阶段**解析当前日志行并从中提取数据。然后，提取的数据可供其他阶段使用。
- **转换阶段**转换先前阶段提取的数据。
- **操作阶段**获取先前阶段提取的数据并对其执行某些操作。操作可以
  - 添加或修改日志行的现有标签
  - 更改日志行的时间戳
  - 更改日志行的内容
  - 根据提取的数据创建指标
- **过滤阶段**可以选择性地应用一部分阶段或根据某些条件丢弃条目



典型的管道会以解析阶段开始（例如 [正则表达式](https://grafana.org.cn/docs/loki/latest/send-data/promtail/stages/regex/) 或 [JSON](https://grafana.org.cn/docs/loki/latest/send-data/promtail/stages/json/) 阶段）来从日志行中提取数据。然后会有一系列操作阶段来对提取的数据进行处理。

另一个常见的阶段是 [匹配](https://grafana.org.cn/docs/loki/latest/send-data/promtail/stages/match/) 阶段，用于根据 [LogQL 流选择器和过滤器表达式](https://grafana.org.cn/docs/loki/latest/query/) 选择性地应用阶段或丢弃条目。





最常见的操作阶段是 [标签](https://grafana.org.cn/docs/loki/latest/send-data/promtail/stages/labels/) 阶段，用于将提取的数据转换为标签。

运行时配置









处理Java应用的日志是需要关注多行日志模式的，即一条日志可能由多行文本组成。



```
2023-05-28 16:43:20	
[pool-8-thread-1] dev ERROR com.myapp.ProjectQuery myapp-name - query error
org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.exceptions.TooManyResultsException: Expected one result (or null) to be returned by selectOne(), but found: 2
	at org.mybatis.spring.MyBatisExceptionTranslator.translateExceptionIfPossible(MyBatisExceptionTranslator.java:77)
	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:446)
	at com.sun.proxy.$Proxy108.selectOne(Unknown Source)
	at org.mybatis.spring.SqlSessionTemplate.selectOne(SqlSessionTemplate.java:166)
	at org.apache.ibatis.binding.MapperMethod.execute(MapperMethod.java:83)
	at org.apache.ibatis.binding.MapperProxy.invoke(MapperProxy.java:59)


```



针对这个例子，Java应用使用logback将日志按照固定格式落盘，可以让在同一服务器节点上的Promtail跟踪日志文件，解析日志并将日志发送到Loki。





## 实例

处理java应用的日志是需要关注多行日志模式的，即一条日志可能由多行文本组成：

```

```



`





文件配置

```yaml
# Promtail可以作为HTTP服务器
server:
  disable: true

# 配置Promtail如何连接到Loki的实例，配置了loki write的地址，以及使用的租户id
clients:
- url: http://loki-write:3100/loki/api/v1/push
  tenant_id: org1

# 设置了Promtail读取日志文件时，记录读取哪个到哪个文件的哪个位置
positions:
  filename: /app/logs/positions.yaml


target_config:
  sync_period: 10s


# 抓取任务
scrape_configs:

# 配置了一个job：将跟踪匹配本地/app/logs/*/*.log的日志，收集Java的日志
- job_name: java_logs
  static_configs:
  - targets:
      - localhost
    labels:
      job: java_logs
      __path__: /app/logs/*/*.log
  
	# 7个 pipeline stage
  pipeline_stages:  
	# multiline: 将多行合并成一个多行块，然后将其传递到管道中的下一个阶段。通过firstline首行正则表达式来识别新的块。不匹配该表达式的任何行都被视为前一个匹配块的一部分。这个正则其实就是说年月日开头的才叫一行
  - multiline:
      firstline: '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}'
      max_lines: 256
      max_wait_time: 5s
  
  # 
  - regex:
      expression: '^(?P<time>\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}) (?P<message>\[(?P<thread>.*?)\] (?P<profileName>[^\s]+) (?P<level>[^\s]+) (?P<logger>[^\s]+) (?P<contextName>[^\s]+) - [\s\S]*)'
  - labels:
      contextName:
      profileName:
      level:
      
  - timestamp:
      source: time
      format: '2006-01-02 15:04:05.999'
      location: "UTC"
  - drop:
      older_than: 120h
      drop_counter_reason: "line_too_old"
  - labeldrop:
    - filename
  -  output:
      source: message










# Configures global settings which impact all targets.
[global: 
	<global_config>]

server:
  http_listen_port: 9080
  grpc_listen_port: 0

# positions 属性配置了 Promtail 保存文件的位置，表示它已经读到了日志文件的什么位置。当 Promtail 重新启动时需要它，以允许它从中断的地方继续读取日志。
positions:
  filename: ./positions.yaml

clients:
  - url: http://10.60.134.55:8094/loki/api/v1/push #日志服务器loki地址和端口


# 抓取日志：发现日志文件并从中提取标签
scrape_configs:

 - job_name: local-a
   static_configs:
   - targets:
       - 10.60.134.60
   - labels:
      job: zcbachend-172.29.21.22-1
      host: 10.60.134.60
      __path__: /jiuqi/zichan/zichanyitihuazhenghexiangmu-8084/backend/server.log  #本机日志路径
      
      
```













https://www.cnblogs.com/guangdelw/p/18308042