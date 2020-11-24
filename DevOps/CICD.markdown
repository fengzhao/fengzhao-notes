# CICD



- Continuous Integration (CI)       持续集成
- Continuous Delivery (CD)          持续交付
- Continuous Deployment (CD)   持续部署



持续集成的工作原理是将小的代码块推送到 Git 仓库中托管的应用程序代码库中。

并且每次推送时，都要运行一系列脚本来构建、测试和验证代码更改，然后再将其合并到主分支中。



持续交付和部署相当于更进一步的CI，可以在每次推送到仓库默认分支的同时将应用程序部署到生产环境。

这些方法使得可以在开发周期的早期发现bugs和errors，从而确保部署到生产环境的所有代码都符合为应用程序建立的代码标准。

GitLab CI/CD 由一个名为 .gitlab-ci.yml 的文件进行配置，改文件位于仓库的根目录下。文件中指定的脚本由 GitLab Runner 执行。





软件开发的持续方法基于自动执行脚本，以最大程度地减少在开发应用程序时引入错误的机会。从开发新代码到部署新代码，他们几乎不需要人工干预，甚至根本不需要干预。 

它涉及到在每次小的迭代中就不断地构建、测试和部署代码更改，从而减少了基于已经存在bug或失败的先前版本开发新代码的机会。

**Continuous Integration（持续集成）**

假设一个应用程序，其代码存储在 GitLab 的 Git 仓库中。开发人员每天都要多次推送代码更改。

对于每次向仓库的推送，都可以创建一组脚本来自动构建和测试你的应用程序，从而减少了向应用程序引入错误的机会。

这种做法称为持续集成，对于提交给应用程序（甚至是开发分支）的每项更改，它都会自动连续进行构建和测试，以确保所引入的更改通过你为应用程序建立的所有测试，准则和代码合规性标准。 

**Continuous Delivery（持续交付）**

持续交付是超越持续集成的更进一步的操作。应用程序不仅会在推送到代码库的每次代码更改时进行构建和测试，而且，尽管部署是手动触发的，但作为一个附加步骤，它也可以连续部署。

此方法可确保自动检查代码，但需要人工干预才能从策略上手动触发以必输此次变更。

**Continuous Deployment（持续部署）**

与持续交付类似，但不同之处在于，你无需将其手动部署，而是将其设置为自动部署。完全不需要人工干预即可部署你的应用程序





# gitlab CICD 实战





为了使用GitLab CI/CD，你需要一个托管在GitLab上的应用程序代码库，并且在根目录中的 .gitlab-ci.yml 文件中指定构建、测试和部署的脚本。

在这个文件中，你可以定义要运行的脚本，定义包含的依赖项，选择要按顺序运行的命令和要并行运行的命令，定义要在何处部署应用程序，以及指定是否 要自动运行脚本或手动触发脚本。 

为了可视化处理过程，假设添加到配置文件中的所有脚本与在计算机的终端上运行的命令相同。

一旦你已经添加了.gitlab-ci.yml到仓库中，GitLab将检测到该文件，并使用名为GitLab Runner的工具运行你的脚本。该工具的操作与终端类似。

这些脚本被分组到jobs，它们共同组成一个pipeline。一个最简单的.gitlab-ci.yml文件可能是这样的：





# Jenkins 持续集成



Jenkins 是一款流行的 开源持续集成工具 

官网是 https://jenkins.io 

Jenkins 的特征：

- 开源的 java 语言开发的持续集成工具
- 易于安装部署配置
- 丰富的插件
- 支持分布式构建





### 持续集成流程说明





- 首先，开发人员进行代码提交，提交到 git 仓库
- 在 jenkins 中使用 git 工具把 git 代码仓库拉取到集成服务器，再配合 jdk Maven 等工具完成代码编译，代码测试与审查



# 部署 GitLab



```shell
# CentOS7
sudo systemctl stop firewalld && sudo systemctl disable firewalld
sudo systemctl enable ssh && systemctl start sshd
sudo yum install -y curl policycoreutils-python openssh-server openssh-clients postfix
sudo systemctl enable postfix  && sudo systemctl start postfix


# 添加gitlab清华源，设置yum安装
vim  /etc/yum.repos.d/gitlab-ce.repo

[gitlab-ce]
name=Gitlab CE Repository
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el$releasever/
gpgcheck=0
enabled=1


# 设置外部访问域名并且安装
sudo EXTERNAL_URL="https://git.qh-1.cn" yum install -y gitlab-ce
sudo EXTERNAL_URL="http://git.qh-1.cn" yum install -y gitlab-ce

# 下载rpm安装包，支持离线安装
https://mirrors.tuna.tsinghua.edu.cn/gitlab-ee/yum/el7/gitlab-ee-13.1.6-ee.0.el7.x86_64.rpm
https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-13.0.12-ce.0.el7.x86_64.rpm



# debian

sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates
sudo apt-get install -y postfix

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-e/script.deb.sh | sudo bash

wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/debian/pool/buster/main/g/gitlab-ce/gitlab-ce_13.3.5-ce.0_amd64.deb
```



# 部署 jenkins 

```shell
# centos7 

# 安装 jenkins

# 安装jdk1.8
wget  https://repo.huaweicloud.com/java/jdk/8u181-b13/jdk-8u181-linux-x64.tar.gz
rpm -ivh https://repo.huaweicloud.com/java/jdk/8u181-b13/jdk-8u181-linux-x64.rpm
yum -y install git
# rpm 安装jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo yum install jenkins java-1.8.0-openjdk-devel
sudo systemctl daemon-reload

# jenkins官方镜像源
http://mirrors.jenkins.io/
# 清华大学jenkins镜像源
https://mirrors.tuna.tsinghua.edu.cn/jenkins/


# jenkins-war包下载
http://mirrors.jenkins.io/war-stable/latest/jenkins.war
# rpm包下载
http://mirrors.jenkins.io/redhat-stable/jenkins-2.235.3-1.1.noarch.rpm
# 所以也可以下载rpm包后，rpm -ivh 去安装

# jenkins进程通过systemctl start jenkins的方式启动

# /usr/lib/jenkins/jenkins.war    　　　　　WAR包 
# /etc/sysconfig/jenkins       　　　　　　　配置文件
# /var/lib/jenkins/        　　　　　　　　　默认的JENKINS_HOME目录
#　/var/log/jenkins/jenkins.log    　　　　Jenkins日志文件




# jenkins插件安装
# 插件下载地址为国内地址 



# 安装中文汉化插件

# jenkins用户角色权限插件

Role-Based 插件

#　修改权限策略为Role-Based，可以提升到更细致权限

# Global roles
# Project roles
# Slave roles



# 凭证管理插件 Credentials Binding 插件
```







# Jenkins 构建 Maven 项目







## 自由风格







## 流水线





















# Drone CI 工具





Drone 是一个基于 Docker 的持续集成平台，用 Go 语言编写。Drone 本身和所有插件都是镜像，易于使用。



- Drone 官网地址：[https://drone.io](https://drone.io/)
- Drone 的 GitHub 地址：https://github.com/drone/drone
- 简介：https://imnerd.org/drone.html



### drone 的基本概念

Drone 是一个基于 Docker 容器技术的可扩展的持续集成引擎，用于自动化测试与构建，甚至发布。

每个构建都在一个临时的Docker容器中执行，使开发人员能够完全控制其构建环境并保证隔离。

开发者只需在项目中包含 .drone.yml 文件，将代码推送到 git 仓库，Drone 就能够自动化的进行编译、测试、发布。



#### drone 的基本原理



Drone 的部署分为 `Server(Drone-Server)` 和 `Agent(Drone-agent)`:

- Server端：负责后台管理界面以及调度
- Agent端：负责具体的任务执行









drone 和 jenkins 不一样的是，drone 和gitlab，github 是无缝集成的，所以在搭建之前第一步需要你在gitlab上创建一个OAuth应用，这样drone才可以通过OAuth接口获取用户在 gitlab 上的所有信息。



gitlab创建oauth应用的方式很简单，直接登录点击设置然后点击application，输入名字并且赋予权限点击保存应用就好了



要注意的是Redirect URI这里一定要写drone的url加`/login`,比如下面

```
https://drone.example.cn/login
```

创建完成之后会有`Application ID`和`Secret`这两个东西之后的docker-compose.yaml需要这两个参数







### 安装



```she
docker pull drone/drone

docker pull drone/agent

docker pull drone/drone-runner-docker

docker pull drone/drone-runner-ssh


```





```yaml
version: "3"
services: 
  drone:
    image: "drone/drone:latest"
    container_name: "drone-server"
    restart: "always"
    volumes: 
      - "/etc/localtime:/etc/localtime"
      - "drone-data:/data"
    ports: 
      - "80:80"
    environment: 
      - "DRONE_AGENTS_ENABLED=true"
      - "DRONE_GITLAB_SERVER=https://git.qh-1.cn"
      - "DRONE_GITLAB_CLIENT_ID=client_id"
      - "DRONE_GITLAB_CLIENT_SECRET=client_secret"
      - "DRONE_RPC_SECRET=secret"
      - "DRONE_SERVER_HOST=drone.qh-1.cn"
      - "DRONE_SERVER_PROTO=http"

volumes:
  drone-data:
```







