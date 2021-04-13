# Installing on Debian and Ubuntu



RabbitMQ 是在标准的 Debian 和 Ubuntu 仓库中的。通常仓库中的可能不是最新版。



> 支持的操作系统
>
>  
>
> - Ubuntu 16.04 ~ 20.04
>
> - Debian Stretch (9), Buster (10) and Sid ("unstable")







RabbitMQ 团队每次发布版本时，都会提供 Debian 包，包地址是 https://www.rabbitmq.com/install-debian.html#apt

Debian 包地址： https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.9/rabbitmq-server_3.8.9-1_all.deb



```shell
# import PackageCloud signing key
wget -O - "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | sudo apt-key add -


curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash

```





### 安装erlang

RabbitMQ 依赖于 Erlang/OTP 才能运行。Erlang/OTP 包也是存在于 `Debian` 和 `Ubuntu` 的仓库中。

标准 `Debian` 和 `Ubuntu` 仓库倾向于用老版本的 Erlang/OTP 。RabbitMQ 团队维护了一个 deb 仓库。

支持的操作系统版本：

- Ubuntu 20.04 (Focal)
- Ubuntu 18.04 (Bionic)
- Ubuntu 16.04 (Xenial)
- Debian Buster
- Debian Stretch

支持的 erlang 版本：

- 23.x
- 22.3.x
- 21.3.x
- 20.3.x
- master (24.x)
- R16B03 (16.x)



为了安装这种仓库，需要三个步骤：

- 导入仓库签名
- 添加仓库源
- 更新仓库源
- 安装 `RabbitMQ`  需要的  `erlang` 包



| **Erlang Release Series** | **Apt Repositories that provide it**                         | **Notes**                                                    |
| ------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 23.x                      | [Debian packages of Erlang](https://www.rabbitmq.com/install-debian.html#apt-bintray-erlang) by Team RabbitMQ[Erlang Solutions](https://packages.erlang-solutions.com/erlang/#tabs-debian) | **Supported [starting with 3.8.4](https://groups.google.com/forum/#!topic/rabbitmq-users/wlPIWz3UYHQ)**. See [Erlang compatibility guide](https://www.rabbitmq.com/which-erlang.html). |
| 22.x                      | [Debian packages of Erlang](https://www.rabbitmq.com/install-debian.html#apt-bintray-erlang) by Team RabbitMQ[Erlang Solutions](https://packages.erlang-solutions.com/erlang/#tabs-debian) | **Supported [starting with 3.7.15](https://groups.google.com/forum/#!topic/rabbitmq-users/vcRLhpUdg_o)**. See [Erlang compatibility guide](https://www.rabbitmq.com/which-erlang.html). |
| 21.3.x                    | [Debian packages of Erlang](https://www.rabbitmq.com/install-debian.html#apt-bintray-erlang) by Team RabbitMQ[Erlang Solutions](https://packages.erlang-solutions.com/erlang/#tabs-debian) | **Supported [starting with 3.7.7](https://groups.google.com/forum/#!msg/rabbitmq-users/KbOldePfgYw/cjYzldEJAQAJ)**. See [Erlang compatibility guide](https://www.rabbitmq.com/which-erlang.html). |

 



```shell
#!/bin/sh

## If sudo is not available on the system,
## uncomment the line below to install it
# apt-get install -y sudo

sudo apt-get update -y

## Install prerequisites
sudo apt-get install curl gnupg -y

## Install RabbitMQ signing key
curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | sudo apt-key add -

## Install apt HTTPS transport
sudo apt-get install apt-transport-https

## Add Bintray repositories that provision latest RabbitMQ and Erlang 23.x releases
sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list <<EOF
## Installs the latest Erlang 23.x release.
## Change component to "erlang-22.x" to install the latest 22.x version.
## "bionic" as distribution name should work for any later Ubuntu or Debian release.
## See the release to distribution mapping table in RabbitMQ doc guides to learn more.
deb https://dl.bintray.com/rabbitmq-erlang/debian focal erlang
## Installs latest RabbitMQ release
deb https://dl.bintray.com/rabbitmq/debian focal main 
EOF

## Update package indices
sudo apt-get update -y

## Install rabbitmq-server and its dependencies
sudo apt-get install rabbitmq-server -y --fix-missing





# This is recommended. Metapackages such as erlang and erlang-nox must only be used
# with apt version pinning. They do not pin their dependency versions.
sudo apt-get install -y erlang-base \
                        erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
                        erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
                        erlang-runtime-tools erlang-snmp erlang-ssl \
                        erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl
```













# 配置文件



rabbitMq有三个配置文件，分别为：

- 主配置文件（rabbitmq.conf）
- Erlang术语格式配置文件(advanced.config)
- 环境变量配置文件(rabbitmq-env.conf)



RabbitMQ 提供了三种方式来定制服务器:

- [环境](http://www.rabbitmq.com/configure.html#define-environment-variables)变量

  定义端口，文件位置和名称（接受shell输入，或者在环境配置文件（rabbitmq-env.conf）中设置）

- **配置文件**

  为服务器组件设置权限,限制和集群，也可以定义插件设置.

- **运行时参数和策略**

  可在运行时进行修改集群设置

大部分设置都使用前面的两种方法，但

