# ssh 和 scp 基础

## OpenSSH 概览

SSH 是 Secure SHELL 的缩写，顾名思义，这是一种建立在应用层基础上的安全协议，是一种加密的[网络传输协议](https://zh.wikipedia.org/wiki/%E7%BD%91%E7%BB%9C%E4%BC%A0%E8%BE%93%E5%8D%8F%E8%AE%AE)。

可在不安全的网络中为网络服务提供安全的传输环境（即端到端加密，即使流量被劫持，也无法解密），专为 Linux 远程登陆和其他服务提供的安全协议。

人们通常利用 SSH 来远程登录到服务器上执行命令。（类似 Windows 上的 rdb 协议）

OpenSSH 是一种 SSH 的开源实现。

它是利用 OpenSSL  协议具体实现的开源软件，包括 ssh,ssh-copyid,ssh-keygen 等一系列套件，在 Linux 各大发行版基本上都已经预先安装好了。

可以使用 ssh -V 命令来查看 OpenSSH 版本。

在 Linux 中，sshd 是 OpenSSH SSH 的守护进程。用于在不可信网络上提供安全的连接通道。

 sshd 守护进程通常由 root 用户启动，它监听来自客户端的连接，然后为每个连接派生一个子进程。

 子进程负责处理密钥交换、加密、认证、执行命令、数据交换等具体事务。





Windows 下的 ssh

从 Win10 1809 和 Windows Server 2019 开始 Windows 开始支持 OpenSSH Server。

https://www.cnblogs.com/sparkdev/p/10166061.html 

本文只记录 ssh 基本组件的用法，关于 ssh-agent 和 ssh-add 等命令，这里没有记录。



openssh 的认证方式：

- 密码认证
- 密钥认证（非对称加密）



**OpenSSL** 

OpenSSL 是用于传输层安全性（TLS）协议的健壮的，商业级，功能齐全的开源工具包，因 **安全套接字层（SSL）协议** 而闻名。

这个协议的实现是基于完整功能的通用密码库，该库也可以独立使用。

OpenSSL 代码库的地址是 https://github.com/openssl/openssl 



用户可以从 [www.openssl.org/source](https://www.openssl.org/source) 或者 github 下载官方发行版的源代码压缩包 。OpenSSL项目不会以二进制形式分发工具包。

但是，对于各种各样的操作系统，可以使用 OpenSSL 工具包的预编译版本。（各大 Linux 发行版基本上都有带预编译好的 OpenSSL）

特别是在Linux和其他Unix操作系统上，通常建议与发行商或供应商提供的预编译共享库链接。**一般不建议在 Linux 上自行编译安装 OpenSSL**

**这是一个操作系统很底层的加密库，很多应用层的软件都引用了它（比如nginx,python等），所以一般不建议在生产环境直接编译。**





OpenSSL 工具包括：

- **libssl** 是TLSv1.3（[RFC 8446](https://tools.ietf.org/html/rfc8446)）之前的所有TLS协议版本的实现。

  我们平时在安装软件时，经常会安装这个依赖包，yum -y install openssl-dev openssl 

- **libcrypto** 一个功能全面的通用密码库。它构成了TLS实施的基础，但也可以独立使用。

- **openssl** OpenSSL命令行工具，瑞士军刀，用于加密任务，测试和分析。它可以用于

  - 关键参数的创建
  - X.509证书，CSR和CRL的创建
  - 消息摘要的计算
  - 加密和解密
  - SSL / TLS客户端和服务器测试
  - 处理S / MIME签名或加密的邮件
  - 和更多...

作为一个基于密码学的安全开发包，OpenSSL 提供的功能相当强大和全面，囊括了主要的密码算法、常用的[密钥](https://baike.baidu.com/item/%E5%AF%86%E9%92%A5)和证书封装管理功能以及 SSL 协议，并提供了丰富的应用程序供测试或其它目的使用。

## ssh命令组件

| 命令                                           | 作用               |
| ---------------------------------------------- | ------------------ |
| [ssh](https://www.ssh.com/ssh/)                | 登陆远程主机       |
| [ssh-keygen](https://www.ssh.com/ssh/keygen/)  | 生成密钥对         |
| [ssh-copy-id](https://www.ssh.com/ssh/copy-id) | 传输公钥到远程主机 |
| [scp](https://www.ssh.com/ssh/scp/)            | 远程传输文件       |
| [ssh-agent](<https://www.ssh.com/ssh/agent>)   |                    |



### ssh 用法

```shell
# -p 端口 -i 密钥 
# 这个命令会利用密钥认证，直接免密登陆，如果没有用密钥，那么会交互式弹出密码输入
$ ssh user@host -p port -i /path/private_key
# 查看帮助
$ ssh --help
```

#### 在远程主机上直接执行命令

远程执行命令，ssh 可以直接在远程的目标主机上执行命令，而不用登陆上去执行，就好像在本地执行一样。

例如下面这条命令，命令就直接在远程终端执行了，也直接返回到本地了。

```shell
root@fengzhao-work:~# ssh db-master-139 "df -h"
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/centos-root  793G   13G  780G   2% /
devtmpfs                  47G     0   47G   0% /dev
tmpfs                     47G     0   47G   0% /dev/shm
tmpfs                     47G  3.5G   44G   8% /run
tmpfs                     47G     0   47G   0% /sys/fs/cgroup
/dev/sda2                494M  157M  338M  32% /boot
/dev/sda1                200M   12M  189M   6% /boot/efi
/dev/sdb1                 11T  1.4G   11T   1% /data
/dev/mapper/centos-home   50G   38M   50G   1% /home
/dev/sdc1                7.3T  4.5T  2.9T  62% /backup
tmpfs                    9.4G   12K  9.4G   1% /run/user/42
tmpfs                    9.4G     0  9.4G   0% /run/user/0
/dev/sde1                7.3T   33M  7.3T   1% /DBbackup
root@fengzhao-work:~#

```



### ssh-keygen 用法

ssh-keygen 命令是用来生成一对新密钥对的。

```shell
# -t 算法 -b 密钥长度 -C 标识（一般设为邮箱） -f 密钥对名称  
# 这个命令会生成 /path/keyname.pub（传到远程主机的公钥）和 /path/keyname（登陆远程主机的私钥） 

ssh-keygen -t rsa -b 2048  -C "comment" -f /path/keyname  

# 清除ssh私钥中的phrase，交互式弹出让输入老密码，然后新密码置空，即可清除老密码
ssh-keygen -f ~/.ssh/kc_id_rsa -p
 
# 语法
ssh-keygen -p [-P old_passphrase] [-N new_passphrase] [-f keyfile]




```

### ssh-copy-id 用法

```shell
# 这个命令会交互式提示输入密码，把公钥传入远程主机中的user用户的家目录下：~/.ssh/authorized_keys
$ ssh-copy-id -i /path/publice_key  user@host -p port

-f: force mode -- copy keys without trying to check if they are already installed
-n: dry run    -- no keys are actually copied
```

### scp 用法

```shell

# 把本地文件上传到远程主机
$ scp /path/filename user@host:/path／
# 从远程主机下载文件到本地
$ scp user@host:/path/filename /var/www/local_dir
```



## OpenSSH 详解

OpenSSH 也是一种 C/S 架构的模式，客户端和服务端分别是 ssh/sshd 。

一般 Linux 启动后默认都会启动服务端的 sshd 服务，sshd 服务端默认端口一般是22，可以服务端配置文件修改。所以我们可以在某台 Linux 上以 ssh 客户端登陆到远程的 Linux 服务器上。命令大致如下：

```shell
# 使用 root 用户，私钥验证 登陆远程的 192.1668.1.102（ssh默认是用22端口，可以省略）
$ ssh root@192.168.1.102  -p 22 -i ~/.ssh/id_rsa
```

```shell
# 使用 root 用户，密码验证 登陆远程的 192.1668.1.102 （会弹出密码输入提示）
$ ssh root@192.168.1.102  -p 22 
```

### ssh 相关文件

ssh 的配置文件一般在 ~/.ssh 目录中，由于安全原因，该目录的权限一般要设置为 700 。

```shell
# ssh客户端全局配置文件，所有用户公用的配置文件。
/etc/ssh/ssh_config
# ssh客户端用户配置文件，针对某个用户的具体配置文件，可以覆盖全局配置文件
~/.ssh/config


# ssh服务端配置文件，用来配置认证方式，是否启用root登陆，加密方式
/etc/ssh/sshd_config


# 客户端用户私钥，从客户端登陆服务端需要提供这个私钥证明合法登陆。为了安全，这个文件的权限必须是600。~/.ssh 目录的权限必须是700
~/.ssh/id_rsa

# ssh服务端公钥，公钥与私钥是一对密钥对，一般要设置为600，防止其他用户把自己的公钥注入进来
# 这个文件可以存放多个公钥
~/.ssh/authorized_keys


# 你访问过远程主机的公钥指纹都记录在~/.ssh/known_hosts。当下次访问相同计算机时，OpenSSH 会核对公钥指纹。如果公钥不同，OpenSSH 会发出警告。
~/.ssh/known_hosts



# SSH中文手册和配置文件
http://www.jinbuguo.com/openssh/sshd.html
http://www.jinbuguo.com/openssh/sshd_config.html
http://www.jinbuguo.com/openssh/ssh-keygen.html
```



关于 ssh 的公钥认证详细原理，可以参考阮一峰的博客。

http://www.ruanyifeng.com/blog/2011/12/ssh_remote_login.html

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

以后在本地，可以直接使用 ssh server1 这种形式直接登陆 192.168.1.101  

``` shell
# /etc/ssh/sshd_config  sshd 服务端常用配置选项

port 22 # ssh端口，Linux一般都是22端口做为ssh服务
PermitRootLogin yes  # 允许root远程登录
PasswordAuthentication no　 # 不允许密码方式登录
RSAAuthentication yes # 允许RSA认证，只针对SSH1
PubkeyAuthentication yes # 允许公钥认证
AuthorizedKeysFile .ssh/authorized_keys #保存公钥的认证文件
```

## SSH 常用场景

### 使用密钥认证方式登陆

> 前提条件，已经可以用密码方式登陆远程主机。

1. 在本地用 ssh-keygen 命令生成密钥对，它会提示你输入密钥保存路径，确认短语（相当于私钥的密码，只要保证私钥不泄露，一般没太大必要再为私钥设密码），-t 指明加密算法（dsa,ecdsa,ed25519,rsa），-b 指明密钥长度(2048,4096)，-f 指明存储路径和文件名。
``` shell
fengzhao@fengzhao-work:/$ ssh-keygen -t rsa 
Generating public/private rsa key pair.
Enter file in which to save the key (/home/fengzhao/.ssh/id_rsa):
```
生成的两个文件 id_rsa 和 id_rsa.pub 分别是私钥（私钥自己保留）和公钥（传到远程主机）。
> 注意保存好私钥文件，开启私钥认证之后，就可以直接凭私钥登陆。

2. 通过 ssh-copy-id 命令将公钥传到远程主机。（ssh-copy-id 拥有到远程机器的home, ~./ssh , 和 ~/.ssh/authorized_keys的权限，这个命令其实就是将公钥写入到远程主机~/.ssh/authorized_key文件中，所以也可以手动复制写进去）。

``` shell
fengzhao@fengzhao-work:~$ ssh-copy-id    -i /home/fengzhao/.ssh/id_rsa.pub  root@192.168.8.23
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/fengzhao/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.8.23's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@192.168.8.23'"
and check to make sure that only the key(s) you wanted were added.

fengzhao@fengzhao-work:~$

```

3. 在远程主机 ssh 配置文件中开启允许密钥认证，确认可以用密钥登陆后再关闭密码登陆。



### SSH端口转发

SSH 端口转发也被称作 SSH 隧道([SSH Tunnel](http://blog.trackets.com/2014/05/17/ssh-tunnel-local-and-remote-port-forwarding-explained-with-examples.html))，因为它们都是通过 SSH 登陆之后，在 **SSH客户端**与 **SSH服务端 **之间建立了一个隧道，从而进行通信。

SSH隧道是非常安全的，因为SSH是通过加密传输数据的。





SSH有三种端口转发模式

- **本地端口转发(Local Port Forwarding)**

- **远程端口转发(Remote Port Forwarding)**

- **动态端口转发(Dynamic Port Forwarding)**

#### 本地端口转发



> 应用场景：远程云主机 192.168.0.1 运行了一个服务，端口为3000，但是远程主机的3000端口没办法对外开放，只有 SSH 的 22 端口可以对外开放，这个时候可以在本地的一台服务器 中开启**本地端口转发**功能，使得访问本地服务器的请求被转发到远程云主机上，就好像直接访问一样。

所谓本地端口转发：是针对进行 SSH 操作的主机来说的，如下面的例子：端口转发命令是在 192.168.0.2 上执行的，所以 192.168.0.1 就叫本地，**本地端口转发**就是将发送到**本地主机端口**(192.168.0.2:8000)的请求，转到到**远程主机端口**(192.168.0.1:3000)。仿佛是通过 ssh 建立一个中间隧道一样。

![SSH本地端口转发](../resources/SSH本地端口转发.jpg)

- 192.168.0.1——类比为远程的公网服务器，运行了 node 占用3000端口，仅对外开放 SSH 的 22 端口。
- 192.168.0.2——类比为本地的端口转发服务器，将访问 192.168.0.1:8000 的请求转发到 192.168.0.2:8000
- 192.168.0.3——类比为本地一个客户端，需要访问 192.168.0.1 上的 node 服务



在 192.168.0.1 上部署 node 项目并启动：

```shell
root@fengzhao-linux-server:/tmp# cat demo.js
var http = require('http');

var server = http.createServer(function(request, response)
{
    response.writeHead(200,
    {
        "Content-Type": "text/plain"
    });
    response.end("Hello fengzhao\n");
});

server.listen(3000);
root@fengzhao-linux-server:/tmp# forever start demo.js
warn:    --minUptime not set. Defaulting to: 1000ms
warn:    --spinSleepTime not set. Your script will exit if it does not stay up for at least 1000ms
info:    Forever processing file: demo.js
root@fengzhao-linux-server:/tmp# curl -i http://localhost:3000
HTTP/1.1 200 OK
Content-Type: text/plain
Date: Fri, 26 Jul 2019 06:41:54 GMT
Connection: keep-alive
Transfer-Encoding: chunked

Hello fengzhao
root@fengzhao-linux-server:/tmp#

```

在 192.168.0.2 上访问这个项目：

```shell
root@fengzhao-work:~# curl -i http://192.168.0.1:8000
HTTP/1.1 200 OK
Content-Type: text/plain
Date: Fri, 26 Jul 2019 06:42:23 GMT
Connection: keep-alive
Transfer-Encoding: chunked

Hello fengzhao
root@fengzhao-work:~#
```

在 192.168.0.2 上执行如下命令进行端口转发：

```shell
# -L  [bind_address:]port:host:hostport 将发到本地端口的请求转发到远端的端口请求

ssh -NTfL  192.168.0.2:8000:192.168.0.1:3000 root@192.168.0.1
```

在 192.168.0.3 上访问 192.168.0.2： 

```shell
root@fengzhao-work:~# curl -i http://192.168.0.2:8000
HTTP/1.1 200 OK
Content-Type: text/plain
Date: Fri, 26 Jul 2019 06:48:27 GMT
Connection: keep-alive
Transfer-Encoding: chunked

Hello fengzhao
root@fengzhao-work:~#

```

- N: 表示连接远程主机，不打开 shell，不执行命令
- T: 表示不为这个连接分配 TTY
- f: 表示连接成功后，转入后台运行
- L：表示本地端口转发，-L  [bind_address:]port:host:hostport 

SSH 本地端口转发的命令如下：

 ```shell
 ssh -L  本地地址:本地端口:远程地址:远程端口  user@remote-host-ip
 ```

#### 远程端口转发

> 应用场景：本地主机A1运行了一个服务，端口为3000，远程云主机B1需要访问这个服务。正常情况外网的云主机是无法访问本地服务的。
>
> 

所谓远程端口转发：是针对进行 SSH 操作的主机来说的，如下面的例子：端口转发命令是在 192.168.0.1 上执行的，所以 192.168.0.1 就叫本地，**远程端口转发**就是将发送到**远程主机端口**（192.168.0.2:4000）的的请求，转发到**本地主机端口**（192.168.0.1:3000）。



![SSH远程端口转发](../resources/SSH远程端口转发.png)

在 192.168.0.1 上运行 node 服务，占用 3000 端口。

在 192.168.0.1 上执行如下命令：

```shell
ssh -NTfR 192.168.0.2:4000:localhost:3000 root@192.168.0.2
```

然后在 192.168.0.2 上访问 localhost:4000 ，其实就是在访问 192.168.0.1:3000 

上面说了，这种情况下，在远程主机上只能监听本地环回地址，只能本机访问，假设第三台机器也想通过远程主机(192.168.0.2)来访问这个服务呢，这就需要在远程主机(192.168.0.2)上开启 sshd 服务的 GatewayPorts 参数，这个参数默认是 no，所以需要在远程主机(192.168.0.2)上修改为 yes 后，再在本地主机(192.168.0.1)上重新执行**远程端口转发**命令，这样就可以在远程主机上监听所有网卡的端口了。









## SCP 远程传输

scp 就是 secure copy，是用来进行远程文件复制的，整个复制过程是加密的，数据传输使用的是 ssh，并且使用和 ssh 相同的认证方式，提供相同的安全保证。所以 scp 也可以同时使用 密码认证 和 密钥认证 两种方式。


### 上传本地文件到远程主机
```shell 
# 上传本地文件到远程主机
$ scp /path/filename username@servername:/path/
```
### 从远程主机下载文件到本地
``` shell
# 从远程主机下载文件到本地
$ scp username@servername:/path/filename /var/www/local_dir（本地目录）
```

scp -r 可以递归上传或者下载，用于对于目录的传输。

scp -i 指定私钥文件。（如果公钥已经传到远程主机，并且开启密钥认证）

如果本地ssh客户端配置好了主机，也可以直接用 scp server1 这种格式。


## 批量分发公钥到多台主机

如果有多台远程主机时，一个一个去远程复制比较麻烦，所以考虑需要一次性把公钥复制到多个主机，之前的过程存在两个问题需要人工输入：

1. ssh 第一次登陆一台主机时，会弹出远程主机的公钥指纹，需要手动输入 yes 确认。
2. ssh 协议不支持在命令中直接输入密码，一般都是弹出 prompt 来手动输入密码。

第一个问题，可以在本地 ssh 客户端配置文件（~/.ssh/config）中配置 StrictHostKeyChecking=no 或在 ssh 命令中使用 -o StrictHostKeyChecking=no 来关闭公钥提示。

第二个问题，考虑用第三方工具 sshpass 来解决，这个工具支持在 ssh 命令行直接使用密码，而不需要弹出 prompt 再手动输入密码。

直接用 yum 或者 apt 包管理器安装 sshpass 。

> 这个配置修改和安装软件，都是在本地进行，而不需要在远程进行。

### 自动传公钥到远程主机
``` shell
$ sshpass -p 'YOUR_PASSWORD' ssh-copy-id -o StrictHostKeyChecking=no root@192.168.1.102
```
实现自动传公钥之后，考虑多台主机的一次性上传，如果多台主机的端口密码均相同，可以把主机 ip 或域名 存放到文件中。循环遍历主机并上传公钥。
```shell
for host in $(cat remote-hosts)
    do
    sshpass -p 'YOUR_PASSWORD' ssh-copy-id -i /path/id_rsa.pub -o StrictHostKeyChecking=no root@${host} 
done
```

如果主机密码和端口均不相同，可以考虑把主机ip密码端口按照一定格式存到文件中，使用 cut 命令切割获取相应记录。

主机文件格式：
``` 
10.10.10.11:2221:YOURPASSWORD1
10.10.10.12:2222:YOURPASSWORD2
```


因为ssh-copy-id使用非默认端口时，需要加双引号，没有找到地的办法，先将整个命令放至一个临时文件。再执行该临时文件，执行之后，再删除。

```shell
for host in $(cat remote-hosts)
do
   ip=$(echo ${host} | cut -f1 -d ":")
   port=$(echo ${host} | cut -f2 -d ":")
   password=$(echo ${host} | cut -f3 -d ":")
　 arg=$(echo -p ${port} -o StrickHostKeyChecking=no root@${ip})
　 echo sshpass -p ${password} ssh-copy-id '"'${arg}'"' >> tmp.sh
done
sh tmp.sh
rm -f tmp.sh
```



## ssh 和 scp 使用代理



连接国外 VPS 时，因为某些原因，ssh 连上了很卡，而且经常失去连接，因此需要让 ssh 走代理加速。

ssh 使用 socks5、http_connect 代理：

```shell
# 通过 socks5 代理
$ ssh -oProxyCommand="nc -X5 -x127.0.0.1:1080 %h %p" USER@SSH_SERVER
# 通过 http_connect 代理
$ ssh -oProxyCommand="nc -Xconnect -x127.0.0.1:1080 %h %p" USER@SSH_SERVER
```

有的时候你可能没法直接登录到某台服务器，而需要使用一台中间服务器进行中转，如公司内网服务器。首先确保你已经为服务器配置了公钥访问，并开启了agent forwarding，那么你需要添加如下配置到 `~/.ssh/config`

```shell
# github代理
host github.com
        user git
        hostname github.com
        identityfile /root/.ssh/vultr
#       PreferredAuthentications publickey
        ProxyCommand nc -x 172.31.32.1:1080 %h %p
    
    
```









scp/sftp 使用 socks5、http_connect 代理：

```shell
$ scp -Cpr -oProxyCommand="nc -X5 -x127.0.0.1:1080 %h %p" files USER@SSH_SERVER:/
$ scp -Cpr -oProxyCommand="nc -Xconnect -x127.0.0.1:1080 %h %p" files USER@SSH_SERVER:/
$ sftp -oProxyCommand="nc -X5 -x127.0.0.1:1080 %h %p" USER@SSH_SERVER
$ sftp -oProxyCommand="nc -Xconnect -x127.0.0.1:1080 %h %p" USER@SSH_SERVER
```

如果你使用的是 XShell，也可以设置代理：

```shell

```





https://blog.csdn.net/DiamondXiao/article/details/52488628





ssh 批量分发密钥



# ssh安全



火狐信息安全openssh—guidelines

https://infosec.mozilla.org/guidelines/openssh





https://github.com/jtesta/ssh-audit









## ssh-audit审计



**ssh-audit** 是一款 ssh 安全审计工具，



[jtesta/ssh-audit](https://github.com/jtesta/ssh-audit/)(v2.x) 是基于[arthepsy/ssh-audit](https://github.com/arthepsy/ssh-audit) (v1.x) 进行fork的一个项目，由于后者已经不再更新，所以现在也有很多人用这个。



主要功能特性:

- 支持 ssh1 和 ssh2 协议；
- 可以分析 ssh 客户端配置；
- 识别 ssh banner , 识别操作系统，软硬件等；
- 输出算法信息 (available since, removed/disabled, unsafe/weak/legacy, etc等);
- 输出算法建议（添加或删除基于公认的软件版本）;
- 输出安全信息（有关的问题，分配CVE列表等）;
- 没有依赖关系，与 Python 2.6+，Python的3.x和PyPy兼容;
- 从OpenSSH的，Dropbear SSH和libssh历史信息;
- 分析基于算法的信息SSH版本的兼容性;





### install-and-usage

------



```shell
# 通过 pip 安装
pip install ssh-audit


git clone https://github.com/jtesta/ssh-audit.git  ~/ssh-audit



usage: ssh-audit.py [options] <host>

   -h,  --help             print this help
   -1,  --ssh1             force ssh version 1 only
   -2,  --ssh2             force ssh version 2 only
   -4,  --ipv4             enable IPv4 (order of precedence)
   -6,  --ipv6             enable IPv6 (order of precedence)
   -b,  --batch            batch output
   -c,  --client-audit     starts a server on port 2222 to audit client
                               software config (use -p to change port;
                               use -t to change timeout)
   -j,  --json             JSON output
   -l,  --level=<level>    minimum output level (info|warn|fail)
   -L,  --list-policies    list all the official, built-in policies
        --lookup=<alg1,alg2,...>    looks up an algorithm(s) without
                                    connecting to a server
   -M,  --make-policy=<policy.txt>  creates a policy based on the target server
                                    (i.e.: the target server has the ideal
                                    configuration that other servers should
                                    adhere to)
   -n,  --no-colors        disable colors
   -p,  --port=<port>      port to connect
   -P,  --policy=<policy.txt>  run a policy test using the specified policy
   -t,  --timeout=<secs>   timeout (in seconds) for connection and reading
                               (default: 5)
   -T,  --targets=<hosts.txt>  a file containing a list of target hosts (one
                                   per line, format HOST[:PORT])
   -v,  --verbose          verbose output





# 比如，我们在服务器上执行 ssh-audit 来解决  

 ./ssh-audit.py   127.0.0.1


# 一般会报ssh加密算法不安全问题。可以在 sshd_config 文件中设置为如下加密算法


Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
HostKeyAlgorithms rsa-sha2-512,rsa-sha2-256,ssh-ed25519
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256
MACs umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com


```





# ssh漏洞及安全基线





https://www.cnblogs.com/canyezhizi/p/13537495.html







# openssh 编译升级





