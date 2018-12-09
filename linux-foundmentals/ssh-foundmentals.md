# ssh 基础

## OpenSSH 概览

SSH 是 Secure SHELL的缩写，顾名思义，这是一种建立在应用层基础上的安全协议。专为 Linux 远程登陆和其他服务提供的安全协议。 

OpenSSH 是一种 SSH 的开源实现。它是利用 OpenSSl 协议具体实现的开源软件，包括一系列组件，在 Linux 各大发行版基本上都已经预先安装好了。可以使用 ssh -V 命令来查看 OpenSSH 版本。

## OpenSSH 详解

OpenSSH 也是一种C/S架构的模式，客户端和服务端分别是 ssh/sshd 。一般 Linux 启动后默认都会启动服务端的 sshd 服务，sshd服务端默认端口一般是22，可以服务端配置文件修改。所以我们可以在某台 Linux 上以 ssh 客户端登陆到远程的 Linux 服务器上。命令大致如下：

```shell
# 使用 root 用户，私钥登陆远程的 192.1668.1.102
$ ssh root@192.168.1.102  -p 22 -i ~/.ssh/id_rsa
```

### ssh 相关配置

ssh 的配置文件一般在 ~/.ssh 目录中，由于安全原因，该目录的权限一般要设置为 700 。

- /etc/ssh/ssh_config  ssh全局配置文件，所有用户公用的配置文件。
- ~/.ssh/config ssh客户端用户配置文件，针对某个用户的配置文件，如果没有，可以创建.
- /etc/ssh/sshd_config  ssh服务端配置文件，用来配置认证方式，是否启用root登陆等。
- ~/.ssh/id_rsa  ssh 客户端用户私钥，从客户端登陆服务端需要提供这个私钥证明合法登陆。为了安全，这个文件的权限必须是600。
- ~/.ssh/authorized_keys  ssh服务端公钥，公钥与私钥是一对密钥对。
- ~/.ssh/known_hsots  每个你访问过计算机的公钥(public key)都记录在~/.ssh/known_hosts。当下次访问相同计算机时，OpenSSH会核对公钥。如果公钥不同，OpenSSH会发出警告。

``` shell
# ~/.ssh/config 配置示例
# 这个例子配置了三个主机。端口，用户，私钥这些可以共用的配置都被 * 号这个主机段匹配。
Host server1
         Hostname 192.168.1.101    
Host server2
         Hostname 192.168.1.102
Host server3
         Hostname 192.168.1.103       
Host *
         Identityfile /home/fengzhao/.ssh/server
         port 22
         User root
```

``` shell
# /etc/ssh/sshd_config  sshd 服务端常用相关配置




```
