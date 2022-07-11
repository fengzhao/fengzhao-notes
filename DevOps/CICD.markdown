# CICD



- Continuous Integration (CI)       持续集成
- Continuous Delivery (CD)           持续交付
- Continuous Deployment (CD)   持续部署



持续集成的工作原理是将小的代码块推送到 Git 仓库中托管的应用程序代码库中。

并且每次推送时，都要运行一系列脚本来构建、测试和验证代码更改，然后再将其合并到主分支中。



持续交付和部署相当于更进一步的 CI，可以在每次推送到仓库默认分支的同时将应用程序部署到生产环境。

这些方法使得可以在开发周期的早期发现 bugs 和 errors ，从而确保部署到生产环境的所有代码都符合为应用程序建立的代码标准。

GitLab CI/CD 由一个名为 .gitlab-ci.yml 的文件进行配置，改文件位于仓库的根目录下。文件中指定的脚本由 GitLab Runner 执行。



软件开发的持续方法基于自动执行脚本，以最大程度地减少在开发应用程序时引入错误的机会。

从开发新代码到部署新代码，他们几乎不需要人工干预，甚至根本不需要干预。 

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



GitLab CI/CD 是一款免费且自托管的内置于 GitLab CI/CD 的持续集成工具。GitLab CI/CD 有一个社区版本，提供了 git 仓库管理、问题跟踪、代码评审、wiki 和活动订阅。

许多公司在本地安装 GitLab CI/CD，并将它与 Active Directory 和 LDAP 服务器连接来进行安全授权和身份验证。

GitLab CI/CD 先前是作为一个独立项目发布的，并从 2015 年 9 月发布的 GitLab 8.0 正式版开始集成到 GitLab 主软件。

一个单独的 GitLab CI/CD 服务器可以管理 25000 多个用户，它还可以与多个活跃的服务器构成一个高可用性的配置。

**GitLab CI/CD 和 GitLab 是用 Ruby 和 Go 编写的，并在 MIT 许可证下发布。**

**除了其它 CI/CD 工具关注的 CI/CD 功能之外，GitLab CI/CD 还提供了计划、打包、源码管理、发布、配置和审查等功能。**

GitLab CI/CD 还提供了仓库，因此 GitLab CI/CD 的集成非常简单直接。在使用 GitLab CI/CD 时，phase 命令包含一系列阶段，这些阶段将按照精确的顺序实现或执行。



在实现后，每个作业都被描述和配置了各种选项。每个作业都是一个阶段的一个部分，会在相似的阶段与其它作业一起自动并行运行。

一旦你那样做，作业就被配置好了，你就可以运行 GitLab CI/CD 管道了。其结果会稍后演示，而且你可以检查某个阶段你指定的每一个作业的状态。



这也是 GitLab CI/CD 与其它用于 DevOps 测试的 CI/CD 工具的不同之处。



**为了使用 GitLab CI/CD，你需要一个托管在 GitLab上 的应用程序代码库，并且在根目录中的 .gitlab-ci.yml 文件中指定构建、测试和部署的脚本。**



在这个文件中，你可以定义要运行的脚本，定义包含的依赖项，选择要按顺序运行的命令和要并行运行的命令，定义要在何处部署应用程序，以及指定是否要自动运行脚本或手动触发脚本。 

为了可视化处理过程，假设添加到配置文件中的所有脚本与在计算机的终端上运行的命令相同。

一旦你已经添加了.gitlab-ci.yml到仓库中，GitLab 将检测到该文件，并使用名为 GitLab Runner 的工具运行你的脚本。该工具的操作与终端类似。

这些脚本被分组到jobs，它们共同组成一个pipeline。一个最简单的.gitlab-ci.yml文件可能是这样的：





- Continuous Integration (CI)       持续集成
- Continuous Delivery (CD)           持续交付
- Continuous Deployment (CD)   持续部署



## gitlab CICD 架构图

https://docs.gitlab.com/ee/ci/introduction/img/gitlab_workflow_example_extended_v12_3.png



## gitlab CICD 基本概念

CI/CD 是一种通过在应用开发阶段引入[自动化](https://www.redhat.com/zh/topics/automation/whats-it-automation)来频繁向客户交付应用的方法。

CI/CD 的核心概念是持续集成、[持续交付](https://www.redhat.com/zh/topics/devops/what-is-continuous-delivery)和持续部署。作为一个面向开发和运营团队的解决方案，CI/CD 主要针对在集成新代码时所引发的问题（亦称：“[集成地狱](https://www.solutionsiq.com/agile-glossary/integration-hell/)”）。

通过软件开发的持续方法，您可以持续构建、测试和部署迭代代码更改。

这种迭代过程有助于减少您基于有缺陷或失败的先前版本开发新代码的机会。

使用这种方法，您可以努力减少从开发新代码到部署的人工干预，甚至根本不需要干预。



## gitlab-runner 安装

https://blinkfox.github.io/2018/11/22/ruan-jian-gong-ju/devops/gitlab-ci-jie-shao-he-shi-yong/

.gitlab-ci.yml  是 gitlab 项目仓库根目录中的文件，它定义了一系列构建，测试，部署的脚本。



GitLab-Runner 就是一个用来执行 .gitlab-ci.yml 脚本的工具，是 gitlab 官方用 go 写的一个项目。

一般运行在单独的 CICD 专用的服务器上（**注意，一般尽量要跟 gitlab server 不是一台机器**）。

可以理解成，Runner 就像 agent ，GitLab server 就是 server，所有 agent 都要在 GitLab-CI 里面注册，并且表明自己是为哪个项目服务。

当相应的项目发生变化时，GitLab-CI 就会通知相应的 gitlab runner (工人) 执行对应的脚本任务。

分为两种方式：

```shell
# gitlab runner 安装

# 确定runner跟gitlab-server的版本号相同
cat /opt/gitlab/embedded/service/gitlab-rails/VERSION

# 二进制安装（Linux x86-64） ，强烈建议
# https://docs.gitlab.com/runner/install/linux-manually.html
sudo curl -L --output /usr/local/bin/gitlab-runner \
	"https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"

sudo chmod +x /usr/local/bin/gitlab-runner

sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner

sudo gitlab-runner start


# ================================================
# =========== 其他安装方式（不推荐) ==============
# ================================================

# ubuntu
curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb
dpkg -i gitlab-runner_amd64.deb

# RHEL
curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_<arch>.rpm
rpm -i gitlab-runner_<arch>.rpm



# 使用docker启动一个runner进程
docker run -d --name gitlab-runner --restart always \
     -v /srv/gitlab-runner/config:/etc/gitlab-runner \
     -v /var/run/docker.sock:/var/run/docker.sock \
     gitlab/gitlab-runner:latest

# 注册gitlab-runner(其实就是让gitlab-runner和项目关联起来)
# 指定gitlab地址，仓库token，cici的运行时为docker，构建环境为go环境
# 运行时环境可以是docker-ssh, parallels, shell, virtualbox, docker+machine, docker, ssh, docker-ssh+machine, kubernetes, custom
sudo gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "PROJECT_REGISTRATION_TOKEN" \
  --executor "docker" \
  --docker-image golang:1.16.6-alpine \
  --description "docker-runner" \
  --tag-list "docker,aws" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"



docker exec -it  gitlab-runner  register 
 --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "PROJECT_REGISTRATION_TOKEN" \
  --executor "docker" \
  --docker-image golang:1.16.6-alpine \
  --description "docker-runner" \
  --tag-list "docker,aws" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"


#　上面的注册其实会写到下面这些配置文件中
/etc/gitlab-runner/config.toml　 # 以root身份运行gitlab-runner服务时的配置文件
~/.gitlab-runner/config.toml     # 以非root身份运行gitlab-runner服务时的配置文件 
./config.toml                    # 项目配置文件 

```



## runner 配置说明

在 gitlab CICD 中







### runner 类型

- [Shared runners](https://docs.gitlab.com/ee/ci/runners/#shared-runners)    全局 runner ，对于整个 gitlab 实例里面的每个组和每个项目都适用。

- [Group runners](https://docs.gitlab.com/ee/ci/runners/#group-runners)     可以用于某个 group 里面的项目

- [Specific runners](https://docs.gitlab.com/ee/ci/runners/#specific-runners)   单独配置，某个runner仅用于某个特定项目





## 配置`.gitlab-ci.yml`文件

.gitlab-ci.yml 是在仓库项目根目录中的一个 yaml 格式的文件，它定义了 cicd 的主要任务。在这个文件中：

- 定义了 runner 需要执行的步骤和任务（顺序）。
- 当特定条件满足时，runner需要执行的任务。

例如，你需要定义一个任务（当有提交到任意分支（非默认分支）时，执行一系列构建测试。当提交到默认分支时，执行构建测试并发布到项目测试环境中）

```yaml
#  按照下面，一共4个job，3个stage
build-job:
  stage: build
  script:
    - echo "Hello, $GITLAB_USER_LOGIN!"

test-job1:
  stage: test
  script:
    - echo "This job tests something"


deploy-prod:
  stage: deploy
  script:
    - echo "This job deploys something from the $CI_COMMIT_BRANCH branch."
    

test-job2:
  stage: test
  script:
    - echo "This job tests something, but takes more time than test-job1."
    - echo "After the echo commands complete, it runs the sleep command for 20 seconds"
    - echo "which simulates a test that runs 20 seconds longer than test-job1"
    - sleep 20    
```

## .gitlab-ci.yml 语法检查

可以使用 CI Lint tool 检查器检查 .gitlab-ci.yml 文件格式。

GitLab CI / CD 的每个实例都有一个称为Lint的嵌入式调试工具，该工具可以验证.gitlab-ci.yml文件的内容。您可以在 ci/lint 项目名称空间页面下找到 Lint 。

例如，https://git.lug.ustc.edu.cn/fengzhao/fengzhao-notes/-/ci/lint 


## .gitlab-ci.yml 文件参考

使用GitLab自带的流水线，必须要定义流水线的内容，而定义内容的文件默认叫做.gitlab-ci.yml，使用yml的语法进行编写。
目前任务关键词有28个，全局的关键词有10个，两者重叠的有很多。掌握这些关键词的用法，你可以编写逻辑严谨，易于扩展的流水线。





**全局关键词**

有些关键词不是在一个job中定义的，这些关键词控制着整个流水线的行为或者导入附加的流水线配置。

- stages

  stages 是流水线的阶段，主要是用于定义阶段（每个stages阶段里面有一组任务），在流水线的最顶层定义。

  stages 定义的先后顺序决定了任务的先后顺序：

  - 同一个stage中的job会并行执行。
  - 后一个stage中的job会等前一个stage中的job全部执行成功后才继续执行。

```yaml
stages:
  - build
  - test
  - deploy
  
# 对于这样一个stages
# 1.build这个stage里面的job会被并行执行
# 2.如果build中的所有job执行成功，test中的job跟着继续被并行执行
# 3.如果test中的所有job执行成功，deploy中的job被并行执行
# 4.如果deploy中的所有job执行成功，这个流水线被标记为passed

# 如果任意一个job执行失败，流水线被标记为failed，后续stage中的job都不会执行，同一stage中的job不会被停止，会继续执行。
# 如果流水线中没有定义stages，那么 build,test,depoly就是默认的stages
# 如果定义了一个stage，没有job使用它，那么这个stage在流水线中是不可见的。
```



```shell
# 对于一个前端项目，每次提交，都执行：安装依赖，执行测试用例，编译打包，测试发布，生产发布
stages:
  - install_deps
  - test
  - build
  - deploy_test
  - deploy_production

cache:
  key: ${CI_BUILD_REF_NAME}
  paths:
    - node_modules/
    - dist/


# 安装依赖job，job所属的stage是install_deps
install_deps_job:
  stage: install_deps
  only:
    - develop
    - master
  script:
    - npm install


# 运行测试用例job，job所属的stage是test
test_job:
  stage: test
  only:
    - develop
    - master
  script:
    - npm run test


# 编译job，job所属的stage
build:
  stage: build
  only:
    - develop
    - master
  script:
    - npm run clean
    - npm run build:client
    - npm run build:server


# 部署测试服务器job，job所属的stage
deploy_test:
  stage: deploy_test
  only:
    - develop
  script:
    - pm2 delete app || true
    - pm2 start app.js --name app


# 部署生产服务器，job所属的stage
deploy_production:
  stage: deploy_production
  only:
    - master
  script:
    - bash scripts/deploy/deploy.sh
```





- workflow:rules

  workflow 用于配置规则，来确认是否执行流水线，workflow 在流水线最顶层定义。

  ```yaml
  workflow:
    # 规则一：
    rules:
      # if条件判断：如果提交信息带"draft"
      - if: $CI_COMMIT_MESSAGE =~ /-draft$/
      # 不执行流水线
        when: never
      # if判断：所有的push事件都会触发流水线执行，这个流水线是严格模式，只有这个规则才会执行
      - if: '$CI_PIPELINE_SOURCE == "push"'
  ```

  ```yaml
  workflow:
    rules:
      - if: '$CI_PIPELINE_SOURCE == "schedule"' # 计划流水线不执行
        when: never
      - if: '$CI_PIPELINE_SOURCE == "push"'     # push事件不执行
        when: never
      - when: always                            # 其他的事件都流水线
      
  ```

- include

  include 用于引进cicid配置文件外部的yaml配置。可以把长的 .gitlab-ci.yml 文件切割成多个文件来增加可读性，或者通过引用来避免多处重复写相同的配置。

  ```yaml
  include: 'configs/*.yml'
  
  include: 'configs/**.yml'
  
  include:
    - local: '/templates/.gitlab-ci-template.yml'
    
  include: '.gitlab-ci-production.yml'
  
  include:
    - project: 'my-group/my-project'
      ref: main
      file: '/templates/.gitlab-ci-template.yml
      
  include:
    - remote: 'https://gitlab.com/example-project/-/raw/main/.gitlab-ci.yml'    
  ```

  



- job

  job 是流水线中的任务，一条流水线可以有多个任务。**如果一个job没有stage阶段属性，那么这个job的默认stage就是Test**

- 

  

- script

当你使用自己的runner时，每个runner**默认**每次只能同时执行一个任务，Job可以并行执行（如果job运行在不同的runer中）

当然，也可以修改runner的concurrent属性大于1来设置一个runner并行执行多个job。



**job关键词**
script, after_script, allow_failure, artifacts, before_script, cache, coverage, dependencies, environment, except, extends, image, include, interruptible, only, pages, parallel, release, resource_group, retry, rules, services, stage, tags, timeout, trigger, variables, when

最常任务中最常用的是这七个`script`，`artifacts`，`stage`， `when`，`tags`，`image`，`cache`，
知道了这个七个关键词，一般的流水线随随便便拿下。

任务要执行的shell脚本内容，内容会被runner执行，在这里，你不需要使用git clone ....克隆当前的项目，来进行操作，因为在流水线中，每一个的job的执行都会将项目下载，恢复缓存这些流程，不需要你再使用脚本恢复。你只需要在这里写你的项目安装，编译执行，如
npm install 另外值得一提的是，脚本的工作目录就是当前项目的根目录，所有可以就像在本地开发一样。此外script可以是单行或者多行。





**stage**

- 

官方默认提供了五个阶段，可以保证按照先后顺序执行（同一个阶段中的任务可以并行执行，不同阶段的任务必须线性顺序执行）

- .pre            pre 这个stage被保证为是第一个stage，最先执行
- build
- test
- depoly
- .post          .post 个stage被保证为是最后一个stage，最后执行 



**注意，stages和stage不是一个概念。**





### CICD流水线



pipeline流水线是CICD的顶层组件，流水线定义了如下：

- jobs（任务），job定义了需要做什么，比如编译代码等，任务是流水线的最基本的单位。
- stages（阶段），stages定义了什么时候执行什么job，比如test测试的job要在编译的job后面执行。

job 是通过 runner 执行，多个job也可以在一个stage中并行执行（如果有足够多的runner）

如果一个stage中的job都执行完成，流水线就会跳到下一个job。

如果任意一个job失败，通常剩下的stage都不会执行。



一个典型的流水线，通常由如下四个stage组成（按照顺序执行）：

- 构建阶段：build stage，有一个 compile job（比如常见的java打jar包，go的编译阶段等）
- 测试阶段：test stage，有两个job：test1，test2
- 预发布阶段：staging stage，一个job：deploy-to-stage（发布到测试环境）
- 生产发布阶段：production stage，一个job：deploy-to-prod（发布到生产环境）



### 流水线类型

- [Basic pipelines](https://docs.gitlab.com/ee/ci/pipelines/pipeline_architectures.html#basic-pipelines) 
- [Directed Acyclic Graph Pipeline (DAG) pipelines](https://docs.gitlab.com/ee/ci/directed_acyclic_graph/index.html) 
- [Multi-project pipelines](https://docs.gitlab.com/ee/ci/pipelines/multi_project_pipelines.html) 
- [Parent-Child pipelines](https://docs.gitlab.com/ee/ci/pipelines/parent_child_pipelines.html) 
- [Pipelines for Merge Requests](https://docs.gitlab.com/ee/ci/pipelines/merge_request_pipelines.html) 
- [Pipelines for Merged Results](https://docs.gitlab.com/ee/ci/pipelines/pipelines_for_merged_results.html)
- [Merge Trains](https://docs.gitlab.com/ee/ci/pipelines/merge_trains.html)



#### 基本流水线





### 计划流水线

流水线通常是由外部条件触发的，比如一个分支被push到仓库。计划流水线就像定时任务一样，比如：

- Every month on the 22nd for a certain branch.
- Once every day



触发器流水线



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
- 在 jenkins 中使用 git 工具把 git 代码仓库拉取到集成服务器，再配合 jdk Maven 等工具完成代码编译，代码测试与审查。
- 









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
# https://www.cnblogs.com/hellxz/p/install_jenkins.html
# jenkins官方镜像源
http://mirrors.jenkins.io/
# 清华大学jenkins镜像源
https://mirrors.tuna.tsinghua.edu.cn/jenkins/
# 中文社区
# https://jenkins-zh.cn/tutorial/management/mirror/

# centos7 安装 jenkins

# 安装jdk1.8，直接安装rpm，或者下载二进制包并配置环境变量，安装maven，推荐都用二进制包安装
wget  https://repo.huaweicloud.com/java/jdk/8u181-b13/jdk-8u181-linux-x64.tar.gz
rpm -ivh https://repo.huaweicloud.com/java/jdk/8u181-b13/jdk-8u181-linux-x64.rpm
yum -y install git


# rpm 方式安装jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo yum install jenkins java-1.8.0-openjdk-devel
sudo systemctl daemon-reload

# rpm包下载，然后ivh安装
http://mirrors.jenkins.io/redhat-stable/jenkins-2.235.3-1.1.noarch.rpm
# 所以也可以下载rpm包后，rpm -ivh 去安装

# 如果是rpm安装的，则jenkins进程通过systemctl start jenkins的方式启动，相关路径如下
# /usr/lib/jenkins/jenkins.war    　　　　　WAR包 
# /etc/sysconfig/jenkins       　　　　　　　配置文件
# /var/lib/jenkins/        　　　　　　　　　 默认的JENKINS_HOME目录
#　/var/log/jenkins/jenkins.log    　　　　 Jenkins日志文件


# tomcat方式安装Jenkins，注意，用tomcat9
wget  https://mirrors.cnnic.cn/apache/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz
wget https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v9.0.64/bin/apache-tomcat-9.0.64.tar.gz
wget --no-check-certificate https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.13/bin/apache-tomcat-10.0.13.tar.gz
wget https://mirrors.cnnic.cn/apache/tomcat/tomcat-9/v9.0.55/bin/apache-tomcat-9.0.55.tar.gz

# jenkins-war包下载，一般推荐war包并放到tomcat的webapp中来安装jenkins
# wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
wget https://mirrors.huaweicloud.com/jenkins/war/latest/jenkins.war




# jenkins插件安装
# 插件下载地址为国内地址 



# 安装中文汉化插件

# jenkins用户角色权限插件

# Role-Based 插件

# 修改权限策略为Role-Based，可以提升到更细致权限

# Global roles
# Project roles
# Slave roles



# 凭证管理插件 Credentials Binding 插件
```











### docker 方式部署jenkins

```shell

mkdir -p /home/jenkins_root/{jenkins_data,jenkins_home}
chown -R 1000:1000  /home/jenkins_root/jenkins_data 
chown -R 1000:1000  /home/jenkins_root/jenkins_home


docker pull ghcr.io/fengzhao-study-notes/blueocean:latest


version: '2.4'
services:
  jkenkins:
    image: "ghcr.io/fengzhao-study-notes/blueocean"
    restart: always
    privileged: true
    ports:
     - "8088:8080"
    volumes:
     - "/home/jenkins_root/jenkins_data:/var/jenkins_home"
     - "/home/jenkins_root/jenkins_home:/home"
     - "/var/run/docker.sock:/var/run/docker.sock"
    network_mode: "host"
    cpus: 1
    #mem_limit: 4g



mkdir /data/jenkins_home



```



### jenkins 主目录结构



Jenkins 的所有重要数据都存放在它的主目录中，即 `JENKINS_HOME`。它默认位于当前用户主目录下的 `.jenkins` 隐藏目录中，即 `~/.jenkins`。可通过修改环境变量 `JENKINS_HOME` 的值，来更改 jenkins 主目录。

其中存储了关于构建服务器的配置信息、构建作业、构建产物、插件和其它有用的信息。**这个目录可能会占用大量的磁盘空间。**



# Jenkins 构建项目



持续集成不是一个一蹴而就的事物。要把持续继承引入到一个公司需要通过几个不同的阶段。



## 自由风格



自由风格，允许配置任何类型的构建作业：它们是高度灵活的。





## 流水线







## 视图



现在的编程中，公司往往将一个项目拆分成多个工程，前后端分离，由多个开发团队负责一个大项目的编写。

这样在我们对项目进行维护的时候就要将不同的项目区分开，方便管理。

在jenkins的主页面中，在所有的旁边，点击+号，就可以创建视图。

在新建视图中，按图示填写自己的视图名称（选择自己的项目名，方便区分），选择列表视图，点击确定。



## 构建触发器

构建触发器，顾名思义，就是构建任务的触发器。

如果不配置这一段，则要手动发布项目。配置如下后，则根据配置自动发布，例如每天发布一次，或代码更新就发布一次。



- 定时构建
- Generic Webhook Trigger （插件，一般默认都会安装）
- Build when a change is pushed to GitLab （gitlab插件，一般默认都会安装）

 

## 常用插件



Role-based Authorization Strategy          https://www.cnblogs.com/netflix/p/12109278.html





### Jenkins集成钉钉通知



1. 创建钉钉群，在群聊中添加机器人。
2. 安装[钉钉机器人插件](https://jenkinsci.github.io/dingtalk-plugin/)





### Blue Ocean

Blue Ocean 插件默认没有被安装。





### gitlab和git插件





### NodeJS插件



 



## jenkins 分布式构建

项目比较多时，单个master负载较大，构建会出现长时间等待，可以采用 master-slave 架构来提升构建性能。

利用多台服务器来进行构建。分担构建压力。

Jenkins采用分布式架构，分为server节点和agent节点。可以采用多个agent节点在不同环境中为多个项目并行构建多个任务。

- master 节点安装 jenkins 服务。 master 节点负责分配调度任务。

- agent 节点安装 jdk 和各种编译运行环境。agent 节点负责具体的构建任务。

  

server节点（jenkins安装节点）也是可以运行构建任务的，但我们分布式构建场景中一般使其主要来做任务的调度。

随着现在容器的盛行，我们可以将server节点和agent节点在容器或者基于Kubernetes中部署。

关于agent节点借助容器可以实现动态的资源分配等等好处。agent节点可以分为静态节点和动态节点：

- 静态节点是固定的一台vm虚机或者容器。
- 动态节点是随着任务的构建来自动创建agent节点。







### 固定节点

物理固定节点是指专门准备和配置单独的主机来处理构建任务。

1. 准备一台单独的主机，配置好jdk1.8。

2. 在  jenkins 服务器上创建 sshkey  （用于登陆和管理从节点）。把公钥从添加到节点的 ~/.ssh/authorized_keys 中。

   ```shell
    ssh-keygen -t rsa -b 4096 -C "jenkins-agent-key"  -f ~/.ssh/jenkins_agent_key
   ```
   
3. 在 jenkins 管理界面的   manage credentials 中添加这个key。

4. 在 jenkins  管理界面的  Manage Nodes and clouds 添加 agent 节点。启动节点。

5. 在主节点可以看到从节点在线，在从节点可以看到如下进程。

   ```shell
    /usr/java/jdk1.8.0_201/bin/java -jar remoting.jar -workDir /home/jenkins -jar-cache /home/jenkins/remoting/jarCache
   ```

   


### docker agent



1. 先在 jenkins 服务器上创建 sshkey  

```shell
 ssh-keygen -t rsa -b 4096 -C "jenkins-agent-key"  -f ~/.ssh/jenkins_agent_key
```

2. 在 jenkins 服务器的 manage credentials 中添加这个key



3. 创建docker agents

```shell
# 注意公钥，要替换成上面生成的公钥：cat ~/.ssh/jenkins_agent_key.pub
docker run -d --rm --name=agent1 -p 22:22 -e "JENKINS_AGENT_SSH_PUBKEY=[your-public-key]" jenkins/ssh-agent:alpine
```



4. 在 jenkins 服务器中的 Manage Nodes and clouds 添加 agent 节点



# Jenkins && Gitlab 集成



我们学习了`Jenkins`的搭建和插件+流水线的基本使用方法，`Jenkins`极大地提升了部署效率。
最近想学习一下如何集成`GitLab webhook`，实现进一步解放双手，目标：

- 推送（`git push`）触发构建
- 推送到指定分支触发构建
- 根据`commit`的文件，结合`mvn -pl`指令，实现部分增量构建，并记录`commit`信息

推送事件也可以换成`Tag push events`、`Merge request events`等其他触发条件，根据需要自由选择。



**基础实现**

使用`Gitlab Hook Plugin`，并在 Jenkins 和 GitLab 中分别配置。在Jenkins 插件管理中搜索并安装插件：





# CDF基金会

2019年3月12日，CDF（Continuous Delivery Foundation，持续交付基金会）在开源领袖峰会上启动。

Linux 基金会与 CloudBees、Google 和一些其他公司启动了一个新的开源软件基金会，也就是持续交付基金会(CDF)。

CDF 相信持续交付的力量，它旨在培养与支持开源生态，以及厂商中立的项目。



Jenkins 的贡献者们已经决定，我们的项目应该加入这个新的基金会。 实际上，这样的讨论持续了多年，大致的动机简洁摘要在这里。





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







# 各种项目的cicd



### java 项目



```yaml
stages:
  - build jar
  - build and run image

# 打包流程
buildJar:
  stage: build jar
  variables:
    # 默认是clone，改为fetch加快拉取速度（若本地无则会自动clone）
    GIT_STRATEGY: fetch
  only:
    # 将只会运行以issue-开始的refs(分支)
    - /^issue-.*$/
  script:
    - >
      docker run -d --rm --name justforpackage-$CI_COMMIT_REF_NAME
      -v "$(pwd)":/build/inkscreen
      -v /inkscreen/maven/m2:/root/.m2
      -w /build/inkscreen
      maven:3-jdk-8 mvn clean package

    - sleep 60
  tags:
    - inkscreen_hostrunner
  artifacts:
    paths:
      - louwen-admin/target/louwen-admin.jar
    expire_in: 3600 seconds

testDeploy:
  stage: build and run image
  only:
    - dev
  variables:
    # 不拉取代码
    GIT_STRATEGY: none
    IMAGE_NAME: louwen/inkscreen-api:$CI_COMMIT_REF_NAME
    PORT: 38082
  before_script:
    # 移除旧容器和镜像。这里为什么要写成一行，下面有讲
    - if [ docker ps | grep inkscreen-$CI_COMMIT_REF_NAME ]; then docker stop inkscreen-$CI_COMMIT_REF_NAME; docker rm inkscreen-$CI_COMMIT_REF_NAME; docker rmi $IMAGE_NAME; fi
  script:
    - docker build --build-arg JAR_PATH=louwen-admin/target/louwen-admin.jar -t $IMAGE_NAME .
    - >
      docker run -d --name inkscreen-$CI_COMMIT_REF_NAME
      -p $PORT:$PORT
      --network my_bridge --env spring.redis.host=myredis
      -v /inkscreen/inkscreen-api/logs/:/logs/
      -v /inkscreen/inkscreen-api/louwen-admin/src/main/resources/:/configs/
      $IMAGE_NAME
  tags:
    - inkscreen_hostrunner
```









参考

https://www.cnblogs.com/newton/p/14035169.html

