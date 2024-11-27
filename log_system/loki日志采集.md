

# Grafana Loki 概述

`Grafana Loki` 是一套可以组合成一个功能齐全的日志堆栈组件，与其他日志记录系统不同，Loki 是基于仅索引有关日志元数据的想法而构建的：**标签**（就像 Prometheus 标签一样）。

日志数据本身被压缩然后并存储在对象存储（例如 S3 或 GCS）的块中，甚至存储在本地文件系统上，轻量级的索引和高度压缩的块简化了操作，并显著降低了 Loki 的成本，Loki 更适合中小团队。

由于 Loki 使用和 Prometheus 类似的标签概念，所以如果你熟悉 Prometheus 那么将很容易上手，也可以直接和 Grafana 集成，只需要添加 Loki 数据源就可以开始查询日志数据了。

Loki 还提供了一个专门用于日志查询的 `LogQL` 查询语句，类似于 `PromQL`，通过 LogQL 我们可以很容易查询到需要的日志，也可以很轻松获取监控指标。Loki 还能够将 LogQL 查询直接转换为 Prometheus 指标。

此外 Loki 允许我们定义有关 LogQL 指标的报警，并可以将它们和 Alertmanager 进行对接。



Grafana Loki 主要由 3 部分组成:

- `loki`: 日志记录引擎，负责存储日志和处理查询
- `promtail`: 代理，负责收集日志并将其发送给 loki
- `grafana`: UI 界面





























## Promtail





Promtail是一个Agent，用于将本地日志内容发送到Loki。通常，它部署在需要监控的每台机器上。

其主要功能包括：

1. 发现目标：Promtail能够主动探测并发现需要监控的目标。
2. 为日志流添加标签：Promtail可以给日志流附加标签，以便更好地进行过滤和查询。
3. 将日志推送至Loki：Promtail将处理后的日志推送到Loki中进行存储和分析。



目前，Promtail可以从两个来源获取日志：本地日志文件和systemd journal日志（仅适用于AMD64架构的机器）。





在Promtail能够将日志文件的数据发送到Loki之前，它需要获取有关其环境的信息。具体来说，这意味着发现将日志行发送到需要监控的文件的应用程序。

Promtail使用了与Prometheus相同的服务发现机制，尽管目前它仅支持静态和Kubernetes服务发现。这个限制是因为Promtail作为一个守护程序部署在每台本地机器上，并且无法从其他机器上发现标签。

Kubernetes服务发现从Kubernetes API服务器获取所需的标签，而静态服务发现通常涵盖其他所有用例。

与Prometheus一样，Promtail使用`scrape_configs`配置段进行配置。通过`relabel_configs`，可以对要获取的内容、要丢弃的内容以及要附加到日志行的最终元数据进行精细控制。



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









文件配置

```yaml
# 禁用Promtail的HTTP和gRPC服务监听
server:
  disable: true

# 配置了Promtail如何连接到Loki的实例，配置了loki write的地址，以及使用的租户id
clients:
- url: http://loki-write:3100/loki/api/v1/push
  tenant_id: org1

# 设置了Promtail读取日志文件时记录读取位置的文件
positions:
  filename: /app/logs/positions.yaml


target_config:
  sync_period: 10s

scrape_configs:

# 配置了一个job：java_logs，将跟踪匹配本地/app/logs/*/*.log的日志
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

