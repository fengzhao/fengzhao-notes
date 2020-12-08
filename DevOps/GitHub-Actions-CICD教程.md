# Github Actions







GitHub Actions 是在 GitHub Universe 大会上发布的，被 Github 主管 Sam Lambert 称为 “再次改变软件开发” 的一款重磅功能。

于 2018 年 10 月推出，内测了一段时间后，于 2019 年 11 月 13 日正式上线。



简单说其实就是用于软件的构建编译的一个功能。



GitHub 会提供一个以下配置的服务器做为 runner：

- 2-core CPU
- 7 GB of RAM memory
- 14 GB of SSD disk space





GitHub Actions 是一个 `CI/CD（持续集成/持续部署）`工具，持续集成由很多操作组成，比如 **抓取代码**、**运行测试**、**登录远程服务器**、**发布到第三方服务** 等等。GitHub 把这些操作统称为 actions 。



actions 是 GitHub Actions 的核心，简单来说，它其实就是一段可以执行的代码，可以用来做很多事情。比如，你在 python 3.7 环境下写了一个 python 项目放到了 GitHub 上，但是考虑到其他用户的生产环境各异，可能在不同的环境中运行结果都不一样，甚至无法安装，这时你总不能在自己电脑上把所有的 python 环境都测试一遍吧

但是如果有了 GitHub Actions，你可以在 runner 服务器上部署一段 actions 代码来自动完成这项任务。你不仅可以指定它的操作系统（支持 Windows Server 2019、Ubuntu 18.04、Ubuntu 16.04 和 macOS Catalina 10.15），还可以指定触发时机、指定 python 版本、安装其他库等等

此外，它还可以用来做很多有趣的事，比如当有人向仓库里提交 issue 时，给你的微信发一条消息；爬取课程表，每天早上准时发到你的邮箱；当向 master 分支提交代码时，自动构建 Docker 镜像并打上标签发布到 Docker Hub 上 ……

慢慢的，你会发现很多操作在不同项目里面是类似的，完全可以共享。GitHub 也注意到了这一点，于是它允许开发者把每个操作写成独立的脚本文件，存放到代码仓库，使得其他开发者可以引用。





**`总而言之，GitHub Actions 就是为我们提供了一个高效易用的 CI/CD（持续集成/持续部署）工作流，帮助我们自动构建、测试、部署我们的代码`**













```yaml
# 工作流名称
name: Docker Image CI

# on设置触发工作流的事件：当有pull到master，pr到master，每隔十五分钟运行一次。三个条件满足一个都会运行。

# 事件列表 https://docs.github.com/cn/free-pro-team@latest/actions/reference/events-that-trigger-workflows
on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]
  schedule:
	- cron:  '*/15 * * * *' 


jobs: # 工作流的作业
  build:                       # 第一个job是build  
    name: build a test image   # 指定job名称，构建测试任务
    runs-on: ubuntu-latest     # 指定运行环境
	
    steps:                     # 作业包含一系列任务，用steps表示
      - uses: actions/checkout@v2  # 复用官方actions，签出代码
      with:  
    
    - name: Build the Docker image
      run: docker build . --file Dockerfile --tag kms-server:$(date +%s)
      
  
  second:
  	
  	name: build 

```











## 自动分发issue

https://github.com/pingcap/tidb/blob/master/.github/workflows/assign_project.yml











```yaml
# 自动分发issue
name: Auto Assign Project Local

# 当issues被打上标签即会触发
on:
  issues:
    types: [labeled]
env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

jobs:
  assign_one_project:
    runs-on: ubuntu-latest
    name: Assign to One Project
    steps:
    # 
    - name: Run issues assignment to project SIG Runtime Kanban
      uses: srggrs/assign-one-project-github-action@1.2.0
      if: |
        contains(github.event.issue.labels.*.name, 'component/coprocessor') ||
        contains(github.event.issue.labels.*.name, 'sig/executor') ||
        contains(github.event.issue.labels.*.name, 'component/expression')
      with:
        project: 'https://github.com/pingcap/tidb/projects/38'
        column_name: 'Issue Backlog: Need Triage'
    - name: Run issues assignment to project SIG Planner Kanban
      uses: srggrs/assign-one-project-github-action@1.2.0
      if: |
        contains(github.event.issue.labels.*.name, 'sig/planner') ||
        contains(github.event.issue.labels.*.name, 'component/statistics') ||
        contains(github.event.issue.labels.*.name, 'component/bindinfo')
      with:
        project: 'https://github.com/pingcap/tidb/projects/39'
        column_name: 'Issue Backlog: Need Triage'
    - name: Run issues assignment to Feature Request Kanban
      uses: srggrs/assign-one-project-github-action@1.2.0
      if: |
        contains(github.event.issue.labels.*.name, 'type/feature-request')
      with:
        project: 'https://github.com/pingcap/tidb/projects/41'
        column_name: 'Need Triage'
    - name: Run issues assignment to Robust test
      uses: srggrs/assign-one-project-github-action@1.2.0
      if: |
        contains(github.event.issue.labels.*.name, 'component/test')
      with:
        project: 'https://github.com/pingcap/tidb/projects/32'
        column_name: 'TODO/Help Wanted'
    - name: Run issues assignment to project UT Coverage
      uses: srggrs/assign-one-project-github-action@1.2.0
      if: |
        contains(github.event.issue.labels.*.name, 'type/UT-coverage')
      with:
        project: 'https://github.com/pingcap/tidb/projects/44'
        column_name: 'To do'
    - name: Run issues assignment to project SIG DDL Kanban
      uses: srggrs/assign-one-project-github-action@1.2.0
      if: |
        contains(github.event.issue.labels.*.name, 'sig/DDL') ||
        contains(github.event.issue.labels.*.name, 'component/binlog') ||
        contains(github.event.issue.labels.*.name, 'component/charset') ||
        contains(github.event.issue.labels.*.name, 'component/infoschema') ||
        contains(github.event.issue.labels.*.name, 'component/parser')
      with:
        project: 'https://github.com/pingcap/tidb/projects/40'
        column_name: 'Issue Backlog: Need Triage'
```









## 官方 Actions 





### ctions/checkout



https://github.com/actions/checkout

