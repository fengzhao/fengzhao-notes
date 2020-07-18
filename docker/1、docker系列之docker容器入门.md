---

---

# Docker 概述

Docker是一个开发，运输和运行应用程序的开放平台。 Docker使您可以将应用程序与基础架构分离，以便快速交付软件。使用Docker，您可以像管理应用程序一样管理基础架构。

通过利用Docker的方法快速发送，测试和部署代码，您可以显着减少编写代码和在生产中运行代码之间的延迟。

Docker提供了在称为容器的松散隔离环境中打包和运行应用程序的功能。隔离和安全性允许您在给定主机上同时运行多个容器。

容器是轻量级的，因为它们不需要管理程序的额外负载，而是直接在主机内核中运行。这意味着您可以在给定硬件组合上运行比使用虚拟机时更多的容器。您甚至可以在实际虚拟机的主机中运行Docker容器！

开发者可以根据配置文件将应用及依赖包放到一个可移植的容器中，然后发布到一定版本以上的任何流行的操作系统上，实现轻量级别的虚拟化。

容器完全使用沙箱机制，通过镜像来保证运行环境的一致性，启动速度秒级之内，可以更好的满足云计算的自动化以及弹性扩容等场景。

Docker 可以在容器内部快速自动化的部署应用，并通过操作系统内核技术( namespaces 、cgroups 等)为容器提供资源隔离与安全保障。

Docker 是以 Docker 容器为资源分割和调度的基本单位，封装整个软件运行时环境为开发者和系统管理员设计的，用于构建、发布和运行分布式应用的平台。

Docker 是一个跨平台、可移植并且简单易用的容器解决方案。

关于 Docker 中一些 更详细的描述和定义，可以参考下面这几篇网站：

> https://www.docker.com/
>
> http://guide.daocloud.io/dcs/docker-9153160.html
>
> https://www.163yun.com/help/documents/158369209000316928

### Docker 引擎

Docker Engine是一个客户端 - 服务器应用程序，包含以下主要组件：

- 服务端，是一种长时间运行的程序（守护进程），称为 docker daemon（dockerd命令）。
- REST API 接口，它指定程序可以用来与守护进程通信并指示它做什么的接口。
- 客户端命令行（ command line interface）（docker命令）。

![engine-components-flow](./resources/engine-components-flow.png)

docker 客户端命令或 REST API 可以与服务端通讯，向服务端的守护进程下达指令。

docker daemon 创建和管理Docker对象，例如镜像，容器，网络和数据卷等。

### Docker架构

Docker 使用的是 c/s 架构，Docker 客户端与 Docker 守护进程通讯，后者负责构建，运行，分发 Docker 容器。Docker 客户端和守护进程可以在同一台机器，也可以用 Docker 客户端连接远端 docker 守护进程。Docker自带的客户端程序是通过 Unix socket 套接字文件来与服务端通讯，Docker 官方也提供了 REST 风格的 API，你也可以开发自己的客户端来使用 HTTP 协议来与服务端通讯。

![docker-architecture](./resources/docker-architecture.png)

<center>docker架构图</center>
#### docker 守护进程

Docker守护程序（`dockerd`）监听 Docker API 请求并管理 Docker 对象，如图像，容器，网络和卷。守护程序还可以与其他守护程序通信以管理 Docker 服务。

#### docker 客户端

Docker客户端（`docker`）是许多 Docker 用户与 Docker 交互的主要方式。当您使用诸如docker run之类的命令时，客户端会将这些命令发送到 `dockerd` ，后者将其执行。 `docker` 命令使用 Docker API 。 Docker 客户端可以与多个守护进程通信。

#### Docker Registry

Docker Registry 就是一个镜像商店，它里面可以包括各种镜像，可以分为私有仓库和公有仓库（其中 docker hub 最为出名，它是由 docker 公司开发，国内有阿里云等镜像市场）。我们常用的各种开源软件和运行时环境，基本上都可以在 registry 上找到 docker 镜像。

一个 Docker Registry 中可以包含多个仓库（`Repository`）；每个仓库可以包含多个标签（`Tag`）；每个标签对应一个镜像。  

> 注意：docker registry是镜像站点，仓库是镜像商店内的软件，人们常说的搭建私有仓库，应该理解成搭建私有docker registry。这与 maven 或者其他私有代码仓库的概念有些区别。

通常，一个仓库会包含同一个软件不同版本的镜像，而标签就常用于对应该软件的各个版本。我们可以通过 `<仓库名>:<标签>` 的格式来指定具体是哪个软件哪个版本的镜像。如果不给出标签，将以 `latest` 作为默认标签。

以 [Ubuntu 镜像](https://store.docker.com/images/ubuntu) 为例，`ubuntu` 是仓库的名字，其内包含有不同的版本标签，如，`14.04`, `16.04`。我们可以通过 `ubuntu:14.04`，或者 `ubuntu:16.04` 来具体指定所需哪个版本的镜像。如果忽略了标签，比如 `ubuntu`，那将视为 `ubuntu:latest`。

#### Docker 对象

使用 Docker 时，将会创建和使用镜像，容器，网络，数据卷，插件和其他对象。这些介绍其中一些对象。

镜像：镜像是一个轻量级，独立的，可执行的软件包，它包括运行这个软件的一切：代码，运行时，系统等。

容器：容器就是运行启动起来的镜像。同一个镜像可以启动多个，可以简单理解为容器就是镜像的实例化。

关于容器和镜像的基本概念，可以参考[这篇文章](http://dockone.io/article/6051)，我认为这篇文章名副其实，把 docker 的基本概念介绍的非常清楚。

### 安装 docker

docker的安装见官网安装教程：

> https://docs.docker.com/install/



#### 第一个 docker 实例

看完一大堆理论，赶紧去运行你的第一个 docker 容器吧。docker的使用非常方便。 

一句命令就可以启动 一个 nginx ，感受一下 docker 的方便吧：

docker run -d -p 8080:80 nginx 

其中 -d 指后台运行，-p 将容器内的 80 端口映射到宿主机的 8080 端口上。

启动完访问宿主机的 8080 端口，就能见到熟悉的 nginx 欢迎界面了。



### 配置 docker 

#### 运行 docker

安装好 docker 之后，一般 docker 守护进程会自动启动，我们可以通过直接启动或系统服务的方式来启动 docker。

##### 直接启动

直接执行 dockerd 命令就可以启动守护进程，它会在前台运行，输出启动日志到终端，使用 ctr+c 命令来停止进程。可以用这种方式来进行测试。

##### 开机启动

大多数当前的Linux发行版（RHEL，CentOS，Fedora，Ubuntu 16.04 及更高版本）使用 systemd 工具来管理系统启动时启动的服务。 

```shell
$ systemctl enable docker  #开机自启
$ systemctl disable docker #开机自启
$ systemctl start docker   #启动docker
$ systemctl restart docker #重启
$ systemctl stop docker    #重启
$ systemctl status docker  #查看状态
```

#### 服务端配置

docker 守护进程的配置，有两种方式指定：

- 通过在 dockerd 命令后面指定启动参数。
- 通过 dockerd  --config-file  来指定一个json 格式的配置文件 （默认在/etc/docker/daemon.json）

默认地，这个配置文件不存在，系统按照默认配置启动 docker ，如果想自定义，可以创建这个文件。下面是一个简单的示例：

```json
{
  "debug": true,
  "tls": true,
  "tlscert": "/var/docker/server.pem",
  "tlskey": "/var/docker/serverkey.pem",
  "hosts": ["tcp://192.168.59.3:2376"],
  // 设置阿里镜像
  "registry-mirrors": ["https://td520t0f.mirror.aliyuncs.com"] 
}
```

这个配置文件指定以调试模式启动，开启 TLS 安全传输协议，证书和密钥路径，并监听到 192.168.59.3:2376 。这与下面这个命令是一样的。

```shell
dockerd --debug \
  --tls=true \
  --tlscert=/var/docker/server.pem \
  --tlskey=/var/docker/serverkey.pem \
  --host tcp://192.168.59.3:2376
```

具体的配置选项可以参考 [dockerd reference doc](https://docs.docker.com/engine/reference/commandline/dockerd/) 或者使用 dockerd --help来查看。

在 Linux 中，一般使用包管理器安装 docker , 默认的 dockerd 守护进程是通过 systemd 管理的。

```shell
# 在这两个文件中，一般都默认设置了 dockerd 的启动参数。
# Ubuntu的路径
/lib/systemd/system/docker.service 
# CentOS 的路径为
/usr/lib/systemd/system/docker.service

ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock  --ipv6=false       
ExecReload=/bin/kill -s HUP $MAINPID 
```



#### 远程访问

docker 守护进程使用 unix, tcp, fd 三种类型的 Socket 通信来监听 [Docker Engine API](https://docs.docker.com/develop/sdk/) 。

默认地，docker 会创建一个 /var/run/docker.sock 文件，它只允许本地的 root 权限的用户访问，或 docker 用户组。

这就是进程间通讯（IPC）。我们平时使用 docker ps 等命令就是这样操作的。

默认地，docker 没有开启远程访问，如果需要开启远程访问，需要开启 tcp socket 通讯，需要注意的是，默认安装没有启用对服务端访问的加密和认证。也就是说一旦开启远程访问，任何人都可以通过 docker 客户端来访问并控制你的 docker 守护进程来进行创建删除容器等操作。所以必须要开启加密认证或者在守护进程前面加上一个安全的代理。

> 注意：不要轻易开放远程访问，如果开放，要确认开放对象是可信赖的或者开启访问认证和加密传输。

譬如，docker 服务器的内网 ip 是 10.0.0.1，外网 ip 是 45.57.36.48 ：

- 使用 -H tcp://0.0.0.0:2375 来监听的所有网卡的 2375 端口
- 使用 -H tcp://45.57.36.48:2376 来监听45.57.36.48这个网卡的 2376 端口，
- 可以很方便的实现 2375 端口用于非加密访问（内网无须认证），2376 端口用于加密访问，然后通过防火墙规则限定 2375 端口对指定管理终端开放。

下面是一个简单的远程访问的例子：

两台服务器，都安装好 docker ，192.168.1.2 作为服务端，192.168.1.3 作为客户端。

服务端配置文件：

```json
// 三种类型，端口用于远程访问，本地的socker文件，fd用于Systemd based 的操作系统
{
  "hosts": ["tcp://0.0.0.0:2375","unix:///var/run/docker.sock","-H fd://"]
}
```

重新加载服务端配置文件

```shell
# 修改配置文件时，要检查Docker服务启动文件传入的命令行参数和配置文件的命令行参数，是否冲突
# /usr/lib/systemd/system/docker.service

$ systemctl restart docker.service
```

在客户端，访问服务端的 docker 服务：

- 通过 http 连接 server ，访问服务端的 info 接口。

  ```shell
  curl http://192.168.1.2:2375/info 
  ```

- 通过 docker 客户端命令访问服务端：

  ```shell
  docker -H tcp://192.168.1.2:2375 info
  
  # 只要远端开了远程，就可以在客户端执行这种命令来访问远端的docker 
  docker -H tcp://192.168.2.85:2375 ps
  ```

默认地，在客户端执行 docker 命令是连接本地的守护进程，可以修改 DOCKER_HOST 环境变量来改变默认连接：

```shell
export DOCKER_HOST="tcp://192.168.1.2:2375"
```

通过将 DOCKER_HOST 置空来恢复本地连接：

```shell
export DOCKER_HOST=""
```



#### **Docker-API**

docker-API 的官网地址是 https://docs.docker.com/engine/api/

不仅仅是容器，还有网络，镜像，

```json
// 如果没有开启远程访问，在宿主机上，可以用 curl 通过 socket 文件来进行通讯，请求这些API

// 查看容器，返回json格式的数据
curl --unix-socket /var/run/docker.sock -X GET http://localhost/containers/json

// 创建容器
curl --unix-socket /var/run/docker.sock -X POST http://localhost/containers/create
{
	// 请求的数据体为json数据
}

// 启动容器
curl --unix-socket /var/run/docker.sock -X POST /containers/{id}/start
```







#### docker 命令

docker 命令主要是用来向服务端守护进程发送控制指令，来进行构建镜像，启动容器等一些列操作。它包括一系列子命令。每个子命令都有其单独的选项，查看 docker --help 来看命令概述，通过 docker COMMAND --help 来看子命令详细用法。

下面是一些常见的 docker 命令：

```shell
$ docker --help  #查看帮助
$ docker version #查看版本
$ docker pull image #下载镜像
$ docker image ls # 列出所有镜像
$ docker run image #从镜像启动一个新的容器
$ docker ps  #查看运行中的容器，-a 查看所有容器
$ docker 




```



```shell
# docker支持很多子命令

docker run 



```



# Docker 实战



### 镜像

docker 镜像的概念，前面已经大致讲过，这里不再赘述，容器的构建，一般会基于某个父镜像去构建。容器的构建方法一般有三种方式：

- 通过一个 Dockerfile 文件来描述镜像中的内容和操作，然后用 docker build 命令构建镜像。
- 启动一个容器后，在容器中通过一些基本操作做出改变后，用 docker commit 将容器提交为镜像。
- 按上述之一方式做好镜像后，推送到镜像仓库，下次使用时，可以直接从镜像仓库拉取到本地。

举个例子，我们在一台新电脑上安装操作系统时，主要步骤是去微软官网下载 windows iso 镜像，然后刻录到U盘，然后去电脑上安装，然后自己去安装各种开发环境，和常用软件。

我们可以在安装好软件后，通过工具创建镜像，这样下次通过自己制作的镜像安装操作系统，就会自带这些额外的软件，这就是第二种方式。

但是有人认为制作镜像还是要手工安装软件。于是写了一个文件，里面包含安装开发环境和常用软件的指令，执行这个文件就会自动创建自己制作的镜像，这就是第一种方式，这个文件就是 Dockerfile。

通常，使用 Dockerfile 文件来构建镜像是比较多的做法。Dockerfile 中有一系列指令来构建镜像。

docker 镜像的命名空间主要是 Registry/Users/Repository/Tag，分别表示 Registry地址/用户名称/仓库名称/标签。

默认地的  Registry 是 dockerhub ，如果通过 docker image ls 查看到某个镜像没有 Registry ，那就是来自docker hub。

一些大型软件 在docker hub 上的镜像，都是由官方（docker 官方或软件发行官方）维护，在 [docker hub](https://hub.docker.com/)上搜索可以看到 official 字样，这类镜像，一般没有用户名称，或者其名称为 library 。



主要分为以下几种情况

1. docker hub 上的官方镜像为默认Registry    ubuntu:16.04
2. docker hub 上用户空间下的镜像   fengzhao/nginx:latest
3. 私有 docker registry上的镜像   hub.mycompany.com/dev/nginx:latest 



每个镜像，下载到当前服务器内，都有一个唯一的镜像 id，我们可以给同一个镜像打多个标签，使用 docker tag命令来给镜像添加标签，docker tag 

docker tag 一般用于给镜像打标签，用于区分设置镜像的版本号。

#### 镜像管理





docker image COMMAND 是镜像管理的基本命令，可以通过帮助命令，逐层查看其所有的子命令。下面仅列举一些常用的 docker 镜像管理命令：

```shell
$ docker pull  Registry/Users/Repository/Tag # 从registry上拉取镜像，私有的可能需要docker login认证
# 列出所有镜像
$ docker image ls
# 删除这个id的镜像，参数可以是id，也可以是repoistry+tag，
$ docker rmi  45fb1e3aa
# 给镜像添加额外的标签
$ docker tag busybox:latest  fengzhao/busybox:latest  


# docker 镜像导出

# docker 加载本地镜像

```



#### Dockerfile 构建镜像

通过 docker build 命令来从 Dockerfile 和下文中构建镜像，上下文一般就是 Dockerfile 文件所在的路径， 其中包含一系列制作镜像的所需的原文件，上下文可以在某个路径，或者是某个 URL （一般是git repo）中。上下文会被递归处理，所以路径下可以包含子文件夹。

构建过程是 docker daemon 来执行的，第一件事就是把整个上下文传给 daemon 。在多数情况下，创建一个空文件夹来存放 Dockerfile 和构建镜像所需的文件。把这个文件夹作为上下文。可以在任何位置执行 docker build 构建镜像，通过 -f 选项来指定 Dockerfile 文件。

```shell
$ docker build -f /path/to/a/Dockerfile 
```

-t  选项来指定 **用户空间:仓库名称:标签**，可以指定多个标签（tag）。

```shell
docker build -t shykes/myapp:1.0.2 -t shykes/myapp:latest .  #最后的. 表示以当前路径作为上下文开始构建
```

Dockerfile 包含一系列指令，它必须以 FROM 作为第一行，表示基于某个父镜像构建。



下面是一个 postgresql 的 Dockerfile 示例： 

```dockerfile
#
# example Dockerfile for https://docs.docker.com/engine/examples/postgresql_service/
#

# 基于ubuntu
FROM ubuntu

# 添加 PostgreSQL key 并验证其来源合法性
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# 添加 PostgreSQL 仓库
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# 安装``python-software-properties``, ``software-properties-common``, PostgreSQL 9.3
RUN apt-get update && apt-get install -y python-software-properties software-properties-common postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]
```



## 网络概述







### 网络驱动

docker 网络子系统



### bridge网络

这是 docker 默认的网络驱动设置，大多数情况下都可以用这种方式来使用 docker 的网络。

在网络术语中，桥接是工作在链路层的。在 docker 中，可以让所有的容器连接到 docker 网桥中。

可以理解为一个子网，然后使用 NAT 技术通过宿主机与外界通讯。

当 Docker 启动后，会自动创建一个默认的网桥 docker0 ，其IP地址默认为 172.17.0.1/16 。新启动的容器默认会加入到其中。

在宿主机中，使用 ip addr 看到多了一块docker0 的网卡。有了这样一块网卡，宿主机也会在内核路由表上添加一条到达相应网络的静态路由。

可以使用 ip route 命令看到。



```shell
# 查看所有网络
docker network ls
# 用户自定义bridge网络，可以理解为创建一个子网，新建的子网，会自动在内核中添加静态路由
docker network create my-net  
# 用户自定义bridge网络，自定义子网地址，自定义宿主机中的网卡名称
docker network create docker02 --subnet=172.30.0.0/16 -o com.docker.network.bridge.name=docker02

# 查看network基本信息，可以看到连接到这个网络的网段，连接到其中的容器。 
docker network inspect bridge

# 将容器从某个网络中移除
docker network disconnect network_name container_id
# 将容器加入到某个网络中，一个容器可以加入到多个网络中。
docker network connect network_name container_id



```



**用户自定义 bridge 和 默认 bridge 的区别**

- 用户自定义 bridge 自动提供容器间的 DNS 解析，可以直接使用容器名称来进行网络通讯。

  - 使用默认 bridge 启动的容器只能通过 IP 地址互联，或者使用 --link 选项。这是一个历史遗留的选项，一般不建议使用默认 brige。

- 用户自定义 bridge 提供更好的隔离性，所有没有使用 --network 选项的容器都会连到默认 bridge 

- 在用户自定义 bridge 中的容器，可以随时把容器 disconnect 出来，再 connect 到其他的用户自定义 bridge 中。而不用关闭容器

  而在默认 bridge 中的容器，必须要关闭重启才能设置其他网络选项。





**配置容器访问外部**

默认情况下，从容器发送到默认网桥的流量，并不会被转发到外部。要开启转发，需要改变两个设置。这些不是 Docker 命令，并且它们会影响 Docker 主机的内核。

```sh
# 配置 Linux 内核来允许 IP 转发
sysctl net.ipv4.conf.all.forwarding=1

# 改变iptables的FORWARDDROP策略，从drop变为ACCEPT
sudo iptables -P FORWARD ACCEPT
```



**配置默认网桥**

```json
// daemon.json文件中声明配置
{
  "bip": "192.168.1.5/24",
  "fixed-cidr": "192.168.1.5/25",
  "fixed-cidr-v6": "2001:db8::/64",
  "mtu": 1500,
  "default-gateway": "10.20.1.1",
  "default-gateway-v6": "2001:db8:abcd::89",
  "dns": ["10.20.1.2","10.20.1.3"]
}
```





### host网络

host 网络，其实就是去除网络隔离，让容器直接使用宿主机的网络。

从网络的角度看，这个进程就像直接运行在宿主机上一样。但是其他的存储，进程和用户空间，又跟宿主机进行隔离。

### overlay网络

overlay网络可以让两个运行在不同宿主机上的直接通讯，而不需要通过宿主机 OS 层面的路由。这是比较高阶的用法。



### macvlan网络

macvlan 可以给容器分配 mac 地址，在网络中就像一个物理设备一样。	

### Docker高级网络实践



####  Linux network namespace



```sh
# 管理Linux network namespace

# 创建一个networkspace，
ip netns add nstest
# 删除
ip netns delete nstest 
# 查看所有
ip netns list
# 在namespace中执行命令
ip netns exec nstest commad
# 例如:在nstest namespace中显示网卡信息
ip netns exec nstest ip addr
# 在name space中启动一个shell方便
ip netns exec nstest bash 



# 为Linux network namespace配置网络

# 当使用ip命令创建一个network space后，默认创建一个回环设备lo，该设备默认不启动，用户最好将其启动
ip netns exec nstest ip link set dev lo up

# 在主机上创建两张虚拟网卡，veth-a和veth-b
ip link add veth-a type veth peer name veth-b

# 将 veth-b 设备添加到nstest这个network namespace中
ip link set veth-b netns nstest

# 现在 nstest这个network namespace就有了两块网卡 lo和veth-b，验证一下
ip netns exec nstest ip link  

# 为网卡分配IP并启动网卡
# 在 


```







## docker-compose

docker-compose 是定义多个容器的编排工具。通过 yaml 文件来描述一组容器。

通过一个命令来管理一组应用中的容器。使用 docker-compose 的流程大致分为：

- 编写 dockerfile 来定义环境
- 在 docker-compose.yml 文件中来定义服务。
- 使用docker-compose 命令来管理服务中容器。





#### 编排

编排指根据被部署的对象之间的耦合关系，以及被部署对象对环境的依赖。

制定部署流程中各个动作的执行顺序，部署过程所需要的依赖文件和被部署文件的存储位置和获取方式，以及如何验证部署成功。

这些信息都会在编排工具中以指定的格式(比如配置文件或特定的代码)来要求运维人员定义并保存起来，从而保证这个流程能够随时在全新的环境中可靠有序地重现出来。



#### 部署

部署是指按照编排所指定的内容和流程，在目标机器上执行环境初始化，存放指定的依赖文件，运行指定的部署动作，最终按照编排中的规则来确认部署成功。

所以说，编排是一个指挥家，他的大脑里存储了整个乐曲此起彼伏的演奏流程，对于每一个小节每一段音乐的演奏方式都了然于胸。

而部署就是整个乐队，他们严格按照指挥家的意图用乐器来完成乐谱的执行。

最终，两者通过协作就能把每一位演奏者独立的演奏通过组合、重叠、衔接来形成高品位的交响乐。这也是 docker compose 要完成的使命。



docker-compose的安装

```shell
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

# 自动补全的bash_completion文件
https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose 
# 自动补全的zsh_completion文件
https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose
```



#### 概念

**project**

通过 docker compose 管理的一个项目被抽象称为一个 project，它是由一组关联的应用容器组成的一个完整的业务单元。

简单点说就是一个 docker-compose.yml 文件定义一个 project。

我们可以在执行 docker-compose 命令时通过 -p 选项指定 project 的名称，如果不指定，则默认是 docker-compose.yml 文件所在的目录名称。

**service**

运行一个应用的容器，实际上可以是一个或多个运行相同镜像的容器。可以通过 docker-compose up 命令的 --scale 选项指定某个 service 运行的容器个数：

```shell
# 启动两个redis容器
docker-compose up -d --scale redis=2
```



**网络**







## Docker 高级实践



### 容器化思维 

一些人将 docker 是为轻量级虚拟机技术，如果这理解，可以会提出如下问题，sshd 如何配置 ？ 如何备份容器 ？

要正确使用 docker ，就要建立容器化思维，从本质上理解容器，其实就是一个进程以及运行该进程所需的各种依赖。

有了容器化思维，





## Docker核心原理

### **docker 中的组件**

docker 底层有一些概念，可以进一步梳理一下。通过 ps 等命令可以查看到详细的关系

```shell
 # 启动两个alpine容器， 
root@pve /data#  docker run -dit --name alpine1 alpine ash  
root@pve /data#  docker run -dit --name alpine2 alpine ash  
root@pve /data#                                                                                               
root@pve /data# docker ps                                                                                                        
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES                                            
0a03403e05ef        alpine              "ash"               35 hours ago        Up 35 hours                             alpine2                                       
057b5a67bb89        alpine              "ash"               35 hours ago        Up 34 hours                             alpine1


# 通过 ps 可以看到docker daemon是通过dockerd这个二进制起来的，进程号是31377 
root@pve /data# ps -ef | grep docker
root       548 31386  0 Jul17 ?        00:00:07 docker-containerd-shim -namespace moby -workdir /var/lib/docker/containerd/daemon/io.containerd.runtime.v1.linux/moby/0a03403e05ef43ccccc3a80dd7961e4d8e27f4a203144c8a65ee91379baa470c -address /var/run/docker/containerd/containerd.so
ck -containerd-binary /usr/bin/docker-containerd -runtime-root /var/run/docker/runtime-runc                                                                                                                                                                                             
root      1132 31386  0 Jul17 ?        00:00:06 docker-containerd-shim -namespace moby -workdir /var/lib/docker/containerd/daemon/io.containerd.runtime.v1.linux/moby/057b5a67bb89b8cf5e3b8fada72d3a8c21c75732cb5dc95ebf352bae95a68e54 -address /var/run/docker/containerd/containerd.so
ck -containerd-binary /usr/bin/docker-containerd -runtime-root /var/run/docker/runtime-runc 
root     29615  2099  0 23:43 pts/4    00:00:00 grep --color=auto docker                                                                                                               root     31377     1  0 Jul14 ?        00:19:20 /usr/sbin/dockerd -H fd:// 
root     31386 31377  0 Jul14 ?        00:31:54 docker-containerd --config /var/run/docker/containerd/containerd.toml --log-level info  

root@pve /data#                                                                                                                                                                       
root@pve /data#   
root@pve /data#   
# 通过 pstree 可以查看到进程树的调用关系
root@pve /data# pstree  -l -a -A 31377                                                                                                                                                                                                                                                  
dockerd -H fd://                                                                                                                                                                                                                                                                        
  |-docker-containe --config /var/run/docker/containerd/containerd.toml --log-level info                                                                                                                                                                                                
  |   |-docker-containe -namespace moby -workdir /var/lib/docker/containerd/daemon/io.containerd.runtime.v1.linux/moby/0a03403e05ef43ccccc3a80dd7961e4d8e27f4a203144c8a65ee91379baa470c -address /var/run/docker/containerd/containerd.sock -containerd-binary /usr/bin/docker-container
d -runtime-root /var/run/docker/runtime-runc                                                                                                                                                                                                                                            
  |   |   |-ash                                                                                                                                                      
  |   |   `-9*[{docker-containe}]                                                                                                                                                                                                                                                       
  |   |-docker-containe -namespace moby -workdir /var/lib/docker/containerd/daemon/io.containerd.runtime.v1.linux/moby/057b5a67bb89b8cf5e3b8fada72d3a8c21c75732cb5dc95ebf352bae95a68e54 -address /var/run/docker/containerd/containerd.sock -containerd-binary /usr/bin/docker-container
d -runtime-root /var/run/docker/runtime-runc                                                                                                                                                                                                                                            
  |   |   |-ash                                                                                                                                                                                                                                                                         
  |   |   `-9*[{docker-containe}]                                                                                                                                                                                                                                                       
  |   `-19*[{docker-containe}]                                                                                                                                                                                                                                                          
  `-17*[{dockerd}]                                                                                                                                                                                                                                                                      
root@pve /data#    

```



可以看到，docker 的进程树大概是如下结构

```
----
```







### namespace资源隔离

<https://www.redhat.com/zh/topics/containers/whats-a-linux-container>

很多人都知道 docker 底层其实就是 Linux 的容器技术。

> **docker 通过 namespace 实现资源隔离，通过 cgroups 实现了资源限制。**

实质上，Linux 内核实现 namespace 的主要目的，就是实现轻量级虚拟化（容器）服务。**namespace 是 Linux 内核用来隔离内核资源的方式。**

在同一个 namespace 下的进程可以感知彼此的变化，而对外界的进程一无所知。

这样就可以让容器中的进程产生错觉，仿佛自己置身于一个独立的系统环境中。以达到独立和隔离的目的。



网络隔离，进程隔离，用户隔离，权限隔离，文件隔离。



| namespace |      | 隔离内容                   |
| --------- | ---- | -------------------------- |
| UTS       |      | 主机名和域                 |
| IPC       |      | 信号量，消息队列，共享内存 |
| PID       |      | 进程编号                   |
| Network   |      | 网络设备，网络栈，端口等   |
| Mount     |      | 挂载点，（文件系统）       |
| User      |      | 用户和用户组               |





####  namespace API 

Linux 对 namespace 提供了四种API：

- 通过 clone() 在创建新进程的时候创建namespace
- 查看 /proc/pid/ns 目录，具体可以看内核文档  <https://linux.die.net/man/5/proc>
  -  /proc/pid/ns 里面其实是几个链接文件，其实就是指向不同 namespace 号的文件。
- 通过 setns() 加入一个已经存在的 namespace 



从 3.8 版本的内核开始，用户就可以在 **/proc/[pid]/ns** 文件下看到指向不同 namespace 号的文件

```shell
root@pve:~# ps -ef | grep docker                                                                                    
root      7921 31025  0 00:05 pts/1    00:00:00 grep docker                                                                                 
root     31377     1  0 Jul14 ?        00:00:11 /usr/sbin/dockerd -H fd://                                                                                 
root     31386 31377  0 Jul14 ?        00:00:18 docker-containerd --config /var/run/docker/containerd/containerd.toml --log-level info                                               
root@pve:~#  
root@pve:~#
root@pve:~# ls -al /proc/31377/ns/
total 0
dr-x--x--x 2 root root 0 Jul 15 00:05 .
dr-xr-xr-x 9 root root 0 Jul 14 23:09 ..
lrwxrwxrwx 1 root root 0 Jul 15 00:05 cgroup -> 'cgroup:[4026531835]'
lrwxrwxrwx 1 root root 0 Jul 15 00:05 ipc -> 'ipc:[4026531839]'
lrwxrwxrwx 1 root root 0 Jul 15 00:05 mnt -> 'mnt:[4026531840]'
lrwxrwxrwx 1 root root 0 Jul 15 00:05 net -> 'net:[4026531992]'
lrwxrwxrwx 1 root root 0 Jul 15 00:05 pid -> 'pid:[4026531836]'
lrwxrwxrwx 1 root root 0 Jul 15 00:05 pid_for_children -> 'pid:[4026531836]'
lrwxrwxrwx 1 root root 0 Jul 15 00:05 user -> 'user:[4026531837]'
lrwxrwxrwx 1 root root 0 Jul 15 00:05 uts -> 'uts:[4026531838]'
root@pve:~#
root@pve:~#
root@pve:~# ls -al /proc/$$/ns/           <<-- $$ 在bash shell中表示当前shell的进程pid号 
root@pve:~# ls -al /proc/$fish_pid/ns/    <<-- 在fish shell中用 $fish_pid 来表示 
root@pve:~#

```

这些 namespace 文件都是链接文件。链接文件的内容的格式为 xxx:[inode number]。

其中的 xxx 为 namespace 的类型，inode number 则用来标识一个 namespace，我们也可以把它理解为 namespace 的 ID。

如果两个进程的某个 namespace 文件指向同一个链接文件，说明其相关资源在同一个 namespace 中。

一旦这些链接文件被打开，只要打开的文件描述符 (fd) 存在。即使这个namespace中的所有进程都已经结束，这个 namespace 还是会保留继续存在，后续的进程也可以添加进来。

在 docker 中，通过文件描述符定位和加入一个存在的 namespace 是最基本的方式。

```shell
#  把 /proc/xxxx/ns 目录文件使用 --bind 的方式挂载起来，就可以起到上述作用。
root@pve:~# touch ~/uts
root@pve:~#
root@pve:~#
root@pve:~# mount --bind /proc/16239/ns/uts ~/uts
root@pve:~#
root@pve:~#
root@pve:~# stat ~/uts
  File: /root/uts
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: 4h/4d   Inode: 4026531838  Links: 1
Access: (0444/-r--r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2020-07-15 00:26:00.130037180 +0800
Modify: 2020-07-15 00:26:00.130037180 +0800
Change: 2020-07-15 00:26:00.130037180 +0800
 Birth: -
root@pve:~#
```



#### 内核调用



 fork,vfork,clone都是linux的系统调用，这三个函数分别调用了sys_fork、sys_vfork、sys_clone。

最终都调用了do_fork函数，差别在于参数的传递和一些基本的准备工作不同，主要用来linux创建新的子进程或线程（vfork创造出来的是线程）。

    进程的四要素：
       （1）有一段程序供其执行（不一定是一个进程所专有的），就像一场戏必须有自己的剧本。
       （2）有自己的专用系统堆栈空间（私有财产）
       （3）有进程控制块（task_struct）（“有身份证，PID”）
       （4）有独立的存储空间。
          缺少第四条的称为线程，如果完全没有用户空间称为内核线程，共享用户空间的称为用户线程。


##### fork() 调用

在 Linux 多进程中，系统函数 **fork()** 可以在父进程中创建一个子进程，并为其分配资源，例如存储数据和代码的空间。然后把原来进程的所有值都复制到新进程中。

 fork 创造的子进程复制了父亲进程的资源（写时复制技术），包括内存的内容task_struct内容（2个进程的pid不同）。这里是资源的复制不是指针的复制。

在一个进程接到来自客户端新的请求时就可以复制出一个子进程让其来处理，父进程只需负责监控请求的到来，然后创建子进程让其去处理，这样就能做到并发处理。

```python
#!/usr/bin/env python
import os

print('当前进程:%s 启动中 ....' % os.getpid())
# 在 Linux 版本的 python 中，os模块才支持fork函数去调用操作系统的fork()函数。
pid = os.fork()
if pid == 0:
    print('子进程:%s,父进程是:%s' % (os.getpid(), os.getppid()))
else:
    print('进程:%s 创建了子进程:%s' % (os.getpid(),pid ))
    
    
# 程序输出      
# 当前进程:27223 启动中 ....
# 进程:27223 创建了子进程:27224
# 子进程:27224,父进程是:27223  

```



代码执行过程中，在语句  `pid = os.fork() ` 之前，只有一个进程在执行这段代码，在之后，就启动了子进程开始执行，这两个进程几乎完全相同。

将要执行的下一条语句都是 if 判断，fork 调用，可以返回两个值分别为父进程和子进程。

- 给父进程返回的是子进程的ID。
- 给子进程返回的是0

所以这段代码的判断语句的逻辑可以理解为:

- 通过判断 fork 返回值，来指定子进程中的代码和父进程中的代码。
- 在这里，上面一行代码是在子进程中执行的，下面一行是在父进程中执行的。

使用 fork 后，父进程有义务监控子进程的运行状态，并在子进程退出后自己才能正常退出。否则子进程就会成为 `孤儿进程`。



![1595089965538](assets/1595089965538.png)





可以看到，在 python 中调用 fork 函数时，并不总是异步的。



**父子进程的执行顺序由操作系统来决定，相互之间没有任何时序上的关系，**

**所以在我们没有加入进程同步机制的代码的情况下，我们看到每次运行的结果都有可能与上次的运行结果不同。**



关于 fork 函数的细节，可以看这篇文章。<https://blog.csdn.net/qq_38898129/article/details/80827280>

fork函数启动一个新的进程，前面我们说过，这个进程几乎是当前进程的一个拷贝：子进程和父进程使用相同的代码段；子进程复制父进程的堆栈段和数据段。

这样，父进程的所有数据都可以留给子进程，但是，子进程一旦开始运行，虽然它继承了父进程的一切数据，但实际上数据却已经分开，相互之间不再有影响了，也就是说，它们之间不再共享任何数据了。

在程序设计中，父进程和子进程都要调用函数fork（）下面的代码，而我们就是利用fork（）函数对父子进程的不同返回值用if...else...语句来实现让父子进程完成不同的功能，正如我们上面举的例子一样。

我们看到，上面例子执行时两条信息是交互无规则的打印出来的，这是父子进程独立执行的结果，虽然我们的代码似乎和串行的代码没有什么区别。

如果一个大程序在运行中，它的数据段和堆栈都很大，一次fork就要复制一次，那么fork的系统开销不是很大吗？

**写时复制（copy on write）**

其实UNIX自有其解决的办法，大家知道，一般CPU都是以"页"为单位来分配内存空间的，每一个页都是实际物理内存的一个映像，像 INTEL 的 CPU，其一页在通常情况下是 4086字节大小。

而无论是数据段还是堆栈段都是由许多"页"构成的，fork函数复制这两个段，只是"逻辑"上的，并非"物理"上的。

也就是说，实际执行fork时，物理空间上两个进程的数据段和堆栈段都还是共享着的，当有一个进程写了某个数据时，这时两个进程之间的数据才有了区别，系统就将有区别的" 页"从物理上也分开。

系统在空间上的开销就可以达到最小。







关于 fork 系统调用，不得不提的就是 `fork炸弹` 这个经典的例子了。

#### UTS namespace

UTS(Unix Time-sharing System) namespace 提供了主机名和域名的隔离。这样每个 docker container 就拥有独立的主机名和域名了。

在网络上被视为一个独立的节点，而非宿主机上的进程。



#### IPC namespace 

进程间通讯(IPC) 涉及的 IPC 资源包括创建的 信号量，消息队列和共享内存。

申请 IPC 资源就申请一个全局唯一的 32 位 ID，所以 IPC namespace 中实际上包含了系统 IPC 标识符以及实现了 POSIX 消息队列的文件系统。

在同一个 IPC namespace 下的进程彼此可见，不同 IPC namespace 下的进程则互相不可见。



首先在 shell 中华使用 ipcmk -Q 命令创建一个消息队列。通过 ipcs -q 查看已经开启的消息队列和序号









#### PID namespace

pid namespace 隔离非常有用，它对进程 PID 重新标号，即两个不同namespace下的进程可以有相同的PID。每个PID namespace 都有自己的计数程序。	

内核为所有 pid namespace 维护了一个树状结构，最顶层是系统初始化创建的，称为 root namespace 。它创建的新 pid namespace 被称为子 namespace。

通过这种方式，不同的 namespace 会形成一个层次体系，父节点可以看到子节点中的进程，并可以通过信号等方式对子节点产生影响。

- 每个 pid namespace 的第一个进程 pid1 都像传统 Linux 中的init进程一样有特权，起特殊作用。
- 一个 namespace 中的进程，不能影响其父节点和兄弟节点中的进程。
- 在 root namespace 中，可以看到所有进程，并且递归包含子节点中的进程。

监控 docker 容器中的程序的方案之一，就是监控 docker daemon 所在 pid namespace 下的所有进程及其子进程，在进行筛选即可。



**PID namespace 下的 init 进程**

在传统的 Unix 系统中，PID 为 1 的进程是 init ，地位非常特殊。它作为所有进程的父进程，维护一张进程表，不断检查进程状态。

一旦发现某个子进程因为父进程错误而成了 `孤儿进程` 。就会回收资源并结束进程。

所以容器中的 init 进程，也需要实现类似的功能，维护所有后续进程的状态。

#### mount namespace



启动一个 alpine 容器

```sh
 docker run -dit --name alpine1 alpine ash  
 
 
```



#### network namespace

network namespace 主要提供了关于网络资源的隔离，







# kubernetes



## k8s简介



## 核心概念

k8s集群



### master组件



#### kubectl 

用户通过 kubectl 发送指令，将管理容器的请求提交到 API server 

#### kube-apiserver

主节点上负责提供 Kubernetes API 服务的组件；它是 Kubernetes 控制面的前端。

kube-apiserver 在设计上考虑了水平扩缩的需要。 换言之，通过部署多个实例可以实现扩缩。

#### kube-controller-manager



#### kube-scheduler

从多个worker node 节点中选举一个来启动服务

#### etcd

k8s的数据库，用来注册节点、服务、记录、记录账号、记录节点的信息。

### node组件

#### kubelet

向 docker 发送指令管理 docker 容器的组件

#### kubeproxy

管理 docker 容器的网络



### pod

<https://kubernetes.io/zh/docs/concepts/workloads/pods/pod/>

kubernetes 中创建和管理的、最小的可部署的计算单元。kubernetes 中是无法直接操作容器的。

pod就是一组容器，这些容器共享存储、网络、以及怎样运行这些容器的声明。

在 [Docker](https://www.docker.com/) 体系的术语中，Pod 被建模为一组具有共享命名空间和共享文件系统[卷](https://kubernetes.io/docs/concepts/storage/volumes/) 的 Docker 容器。





## 生产安装



**集群规划**



**服务器初始化**



- 配置主机名
- 关闭selinux
- 关闭防火墙
- 禁用swap
- 设置时间同步
- 设置主机名解析





**证书颁发**

使用 cfssl 工具来进行颁发，cloudflare 出品的 ssl 证书，githup 地址是 <https://github.com/cloudflare/cfssl>

https://app.yinxiang.com/shard/s67/res/2eb07eec-ef64-4114-8a75-003b0fdca2ee/TLS.tar.gz





**etcd安装**









