# SRE概述



> SRE is what you get when you treat operations as if it’s a software problem. 
>
> Our mission is to protect, provide for, and progress the software and systems behind all of Google’s public services — Google Search, Ads, Gmail, Android, YouTube, and App Engine, to name just a few
>
> — with an ever-watchful eye on their availability, latency, performance, and capacity

SRE 的全称是：Site Reliability Engineering，即网站可靠性工程。相应的，做这份工作的人叫 Site Reliability Engineer ——网站可靠性工程师，缩写也是 SRE。



谷歌的 SRE 是一个真实具体的岗位，也有明晰的岗位职责。Google在2003 年首创了第一个SRE（Site Reliability Engineering，服务可靠性工程）团队，通过系统架构设计、运维流程改善等各种方法，来确保系统运行的更可靠。

2014年，Google公开了这套SRE方法论和经验，后来也成了许多企业运维网站和线上服务可靠性的重要参考。

Google 在自己的网站对 SRE 有权威的解释：https://sre.google/





SRE 的首要工作任务是保证 SLA。SLA (服务水平协议)是 service-level agreement 的缩写。SLA 是指定要提供的服务、支持方式、时间、地点、费用、性能、处罚和相关各方的责任的整个协议。

对于WEB来说，SLA 一般指的是系统的指标，比方说：

- 系统可用性（availability）达到 99.99%；
- 对于 95% 的请求，响应延迟（latency）低于 200 毫秒等等。
- **恢复时间目标** (RTO)，即可以接受的最长应用宕机时间。此数值通常作为服务等级协议 (SLA) 的一部分进行定义。
- **恢复点目标** (RPO)，即可能由于重大事件而丢失应用中数据的最长可接受时长。此指标因数据的使用方式而异。

通常，RTO 和 RPO 值越低（应用必须越快地从中断中恢复），应用运行费用越高。

- RPO， Recovery Point  Objective，数据恢复点目标，主要指的是业务系统所能容忍的数据丢失量。零RPO，指的是已提交的数据都不会被丢失。单个RPO的范围通常为24小时、12小时、8小时、4小时。以秒为单位测量到接近零。只要对生产系统的影响最小，8小时以上的RPO就可以利用现有的备份解决方案。4小时的RPO将需要计划的快照复制，而接近零的RPO将需要连续复制。在RPO和RTO都接近于零的情况下，将连续复制与故障转移服务结合使用，以实现接近100%的应用程序和数据可用性。

- RTO，RecoveryTime Objective，数据恢复时间，是指灾难发生后，从IT系统宕机导致业务停顿之刻开始，到IT系统恢复至可以支持各部门运作，业务恢复运营之时，此两点之间的时间段。也就是从灾难发生到业务系统恢复服务功能所需要的最短时间周期，此两点之间的时间段称为RTO。RTO不仅仅是业务损失和恢复之间的持续时间。这个目标还包括IT部门必须采取的步骤来恢复应用程序及其数据。如果IT已经投入高优先级应用程序的故障转移服务，那么它们可以在几秒钟内安全地表达RTO(IT部门必须恢复本地环境，但由于应用程序正在云中进行处理，因此IT部门可能需要一些时间)。

- SLA 是指定要提供的服务、支持方式、时间、地点、费用、性能、处罚和相关各方的责任的整个协议。

- SLO（服务质量目标） 是 SLA 的特定可测量特征，用于定量描述服务可靠性的成都。例如可用性、吞吐量、频率、响应时间或质量。SLA 可以包含许多 SLO。RTO 和 RPO 是可测量的，应被视为 SLO。

Google 出了三本 SRE 相关图书（都是 O'REILY 出品，都可以直接在线阅读）分别是：

- 《Building Secure and Reliable Systems》    

- 《The Site Reliability Workbook》                 

- 《Site Reliability Engineering》    SRE Google 运维解密                  

- 《Software Engineering at Google》Google软件工程



SRE的职责确保站点的可用，为了达到这个目的，他需要对站点涉及的系统、组件熟悉，需要关注生产运行时的状态。

为此，他需要有很多工具和系统支撑其完成上述工作，比如自动化发布系统，监控系统，日志系统，服务器资源分配和编排等，这些工具需要他们自己完成开发和维护。

SRE是一个综合素质很高的全能手，需要懂服务器基础架构、操作系统、网络、中间件容器、常用编程语言、全局的架构意识、非常强的问题分析能力、极高的抗压能力（以便沉着高效地排障），他们还需要懂性能调优理论...

SRE的核系职责并不只是将"所有工作"都自动化，并保持 on-call 状态。

SRE的工作是Develop+Operate的结合，SRE是DevOps的实践者，他们的工作内容和职责和传统运维工程师差不多：发布、部署、监控、排障，目标一致。

但是SRE的手段更加自动化，更高效，这种高效来源于自动化工具、监控工具的支撑，更因为其作为这些工具的开发者，不断优化和调整，使整个工具箱使起来更加得心应手，这也是DevOps的魅力所在。



分布式环境运维大不同于传统运维

在分布式环境下，系统的复杂度增大、维护目标增多，按照传统的手工或者半自动维护来做，是不行的。

- 事务性的工作工具化。 比如：版本发布、服务器监控。
- 让系统自反馈。 完善的监控告警机制，完善的日志记录和分析体制，可视化系统的健康状态，使得系统变得可追踪和调校。
- 分布式策略应对巨量运维对象。 负载均衡、流控、数据完整性、批处理的变得不一样，需要重新设计和实践。同时，更要重视连锁式故障。

分布式共识问题是指“在不稳定的通信环境下一组进程之间对某项事情达成一致的问题”。

分布式共识系统可以用来解决：领头人选举、关键共享状态、分布式锁等问题。或者绝对点，所有的分布式问题都应当考虑到分布式共识的问题。

分布式共识的理论基础和实现都不是很好理解，抽时间搞清楚是大有裨益的，这里罗列一下几个关键词：

- 拜占庭问题
- 可复制状态机
- Paxos算法
- Zookeeper
- Chubby





https://arthurchiao.art/blog/sre-notes-zh/

https://b-ok.global/

https://sre.google/books/

https://sre.google/books/building-secure-reliable-systems/

https://sre.google/workbook/table-of-contents/

https://sre.google/sre-book/table-of-contents/

https://static.googleusercontent.com/media/sre.google/zh-CN//static/pdf/building_secure_and_reliable_systems.pdf

https://zhuanlan.zhihu.com/p/22354002

https://www.ershicimi.com/