# Github Actions





GitHub Actions 是在 GitHub Universe 大会上发布的，被 Github 主管 Sam Lambert 称为 "再次改变软件开发" 的一款重磅功能。

于 2018 年 10 月推出，内测了一段时间后，于 2019 年 11 月 13 日正式上线。



GitHub 会提供一个以下配置的服务器做为 runner：

- 2-core CPU
- 7 GB of RAM memory
- 14 GB of SSD disk space



GitHub Actions 是一个 `CI/CD（持续集成/持续部署）`工具，持续集成由很多操作组成，比如 **抓取代码**、**运行测试**、**编译打包代码**、**登录远程服务器**、**发布到第三方服务** 等等。GitHub 把这些操作统称为 actions 。



持续集成 (CI) 是一种需要频繁提交代码到共享仓库的软件实践。 频繁提交代码能较早检测到错误，减少在查找错误来源时开发者需要调试的代码量。 频繁的代码更新也更便于从软件开发团队的不同成员合并更改。 这对开发者非常有益，他们可以将更多时间用于编写代码，而减少在调试错误或解决合并冲突上所花的时间。

提交代码到仓库时，可以持续创建并测试代码，以确保提交未引入错误。 您的测试可以包括代码语法检查（检查样式格式）、安全性检查、代码覆盖率、功能测试及其他自定义检查。

创建和测试代码需要服务器。 您可以在推送代码到仓库之前在本地创建并测试更新，也可以使用 CI 服务器检查仓库中的新代码提交。



actions 是 GitHub Actions 的核心，简单来说，它其实就是一段可以执行的代码，可以用来做很多事情。

比如，你在 python 3.7 环境下写了一个 python 项目放到了 GitHub 上，但是考虑到其他用户的生产环境各异，可能在不同的环境中运行结果都不一样，甚至无法安装，这时你总不能在自己电脑上把所有的 python 环境都测试一遍吧

但是如果有了 GitHub Actions，你可以在 runner 服务器上部署一段 actions 代码来自动完成这项任务。

你不仅可以指定它的操作系统（支持 Windows Server 2019、Ubuntu 18.04、Ubuntu 16.04 和 macOS Catalina 10.15），还可以指定触发时机、指定 python 版本、安装其他库等等



此外，它还可以用来做很多有趣的事，比如：

- 当有人向仓库里提交 issue 时，给你的微信发一条消息；

- 爬取课程表，每天早上准时发到你的邮箱；

- 当向 master 分支提交代码时，自动构建 Docker 镜像并打上标签发布到 Docker Hub 上 ……

  

慢慢的，会发现很多操作在不同项目里面是类似的，完全可以共享。GitHub 也注意到了这一点，于是它允许开发者把每个操作写成独立的脚本文件，存放到代码仓库，使得其他开发者可以引用。





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





## github actions 基本概念

关于 github actions 的免费额度和收费策略，可以参考 https://docs.github.com/cn/billing/managing-billing-for-github-actions/about-billing-for-github-actions



GitHub Actions 有一些自己的术语。

（1）**workflow** （工作流程）：持续集成一次运行的过程，就是一个 workflow。

（2）**job** （任务）：一个 workflow 由一个或多个 jobs 构成，含义是一次持续集成的运行，可以完成多个任务。

（3）**step**（步骤）：每个 job 由多个 step 构成，一步步完成。

（4）**action** （动作）：每个 step 可以依次执行一个或多个命令（action）。



**GitHub Actions 的配置文件叫做 workflow 文件，存放在代码仓库的`.github/workflows`目录中。**



workflow 文件采用 [YAML 格式](https://www.ruanyifeng.com/blog/2016/07/yaml.html)，文件名可以任意取，但是后缀名统一为`.yml`，比如`foo.yml`。

一个代码仓库可以有多个 workflow 文件。GitHub 只要发现`.github/workflows`目录里面有`.yml`文件，就会自动运行该文件。



```yaml
# .github/workflows/github-actions-demo.yml 
# 这个工作流文件，定义了工作流的规则，只要是有新的push，就在
name: GitHub Actions Demo
on: [push]
jobs:
  Explore-GitHub-Actions:
    runs-on: ubuntu-latest
    steps:
      - run: echo "🎉 The job was automatically triggered by a ${{ github.event_name }} event."
      - run: echo "🐧 This job is now running on a ${{ runner.os }} server hosted by GitHub!"
      - run: echo "🔎 The name of your branch is ${{ github.ref }} and your repository is ${{ github.repository }}."
      - name: Check out repository code
        uses: actions/checkout@v2
      - run: echo "💡 The ${{ github.repository }} repository has been cloned to the runner."
      - run: echo "🖥️ The workflow is now ready to test your code on the runner."
      - name: List files in the repository
        run: |
          ls ${{ github.workspace }}
      - run: echo "🍏 This job's status is ${{ job.status }}."
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























# 变量或密码







GitHub Actions 提供的 `CI/CD（持续集成/持续部署）` 服务非常方便，可以帮助我们自动完成一些功能。但是当我们在跑一些脚本的时候，不免会存放一些密码、密钥之类的内容。

我们期望跑脚本的同时，不以明文的方式存储这类密码。在部署场景中，你通常会需要令牌或密码之类的东西──GitHub Actions支持将这些作为密码保存在存储库中。

要设置密码，请转到 repo 的 “sesttings” 页签，然后选择“secrets”。你的密码名称将在你的工作流中用于引用数据，你可以将密码本身放入值中。