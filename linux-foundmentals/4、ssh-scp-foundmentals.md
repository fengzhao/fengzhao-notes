# ssh 和 scp 基础

## OpenSSH 概览

SSH 是 Secure SHELL的缩写，顾名思义，这是一种建立在应用层基础上的安全协议。专为 Linux 远程登陆和其他服务提供的安全协议。

OpenSSH 是一种 SSH 的开源实现。它是利用 OpenSSl 协议具体实现的开源软件，包括 ssh,ssh-copyid,ssh-keygen 等一系列套件，在 Linux 各大发行版基本上都已经预先安装好了。可以使用 ssh -V 命令来查看 OpenSSH 版本。

本文只记录 ssh 基本组件的用法，关于 ssh-agent 和 ssh-add 等命令，这里没有记录。

## ssh命令组件

| 命令                                           | 作用               |
| ---------------------------------------------- | ------------------ |
| [ssh](https://www.ssh.com/ssh/)                | 登陆远程主机       |
| [ssh-keygen](https://www.ssh.com/ssh/keygen/)  | 生成密钥对         |
| [ssh-copy-id](https://www.ssh.com/ssh/copy-id) | 传输公钥到远程主机 |
| [scp](https://www.ssh.com/ssh/scp/)            | 远程传输文件       |

### ssh 用法

```shell
# -p 端口 -i 密钥 
# 这个命令会利用密钥认证，直接免密登陆
$ ssh user@host -p port -i /path/private_key
```

### ssh-keygen 用法

```shell
# -t 算法 -b 密钥长度 -C 标识（一般设为邮箱） -f 密钥对名称  
# 这个命令会生成 /path/keyname.pub（传到远程主机的公钥）和 /path/keyname（登陆远程主机的密钥） 
$ ssh-keygen -t rsa -b 2048  -C "comment" -f /path/keyname  
```

### ssh-copy-id 用法

```shell
# 这个命令会交互式提示输入密码，把公钥传入user用户的家目录下。~/.ssh/authorized_keys
$ ssh-copy-id -i /path/publice_key  user@host -p port
```

### scp 用法

```shell

# 把本地文件上传到远程主机
$ scp /path/filename user@host:/path／
# 从远程主机下载文件到本地
$ scp user@host:/path/filename /var/www/local_dir
```



## OpenSSH 详解

OpenSSH 也是一种 C/S 架构的模式，客户端和服务端分别是 ssh/sshd 。一般 Linux 启动后默认都会启动服务端的 sshd 服务，sshd服务端默认端口一般是22，可以服务端配置文件修改。所以我们可以在某台 Linux 上以 ssh 客户端登陆到远程的 Linux 服务器上。命令大致如下：

```shell
# 使用 root 用户，私钥验证 登陆远程的 192.1668.1.102（ssh默认是用22端口，可以省略）
$ ssh root@192.168.1.102  -p 22 -i ~/.ssh/id_rsa
```

```shell
# 使用 root 用户，密码验证 登陆远程的 192.1668.1.102 （会弹出密码输入提示）
$ ssh root@192.168.1.102  -p 22 
```

### ssh 相关配置文件

ssh 的配置文件一般在 ~/.ssh 目录中，由于安全原因，该目录的权限一般要设置为 700 。

- /etc/ssh/ssh_config  ssh客户端全局配置文件，所有用户公用的配置文件。
- ~/.ssh/config ssh客户端用户配置文件，针对某个用户的配置文件，如果没有，可以创建.
- /etc/ssh/sshd_config  ssh服务端配置文件，用来配置认证方式，是否启用root登陆等。
- ~/.ssh/id_rsa  ssh 客户端用户私钥，从客户端登陆服务端需要提供这个私钥证明合法登陆。为了安全，这个文件的权限必须是600。
- ~/.ssh/authorized_keys  ssh服务端公钥，公钥与私钥是一对密钥对。
- ~/.ssh/known_hosts  每个你访问过计算机的公钥(public key)都记录在~/.ssh/known_hosts。当下次访问相同计算机时，OpenSSH会核对公钥。如果公钥不同，OpenSSH会发出警告。

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

PermitRootLogin yes #允许root远程登录
PasswordAuthentication no　 #不允许密码方式登录
RSAAuthentication yes #允许RSA认证，只针对SSH1
PubkeyAuthentication yes #允许公钥认证
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

2. 通过 ssh-copy-id 命令将公钥传到远程主机。（ssh-copy-id 拥有到远程机器的home, ~./ssh , 和~/.ssh/authorized_keys的权限，这个命令其实就是将公钥写入到远程主机~/.ssh/authorized_key文件中，所以也可以手动复制写进去）。

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

3. 在远程主机ssh配置文件中开启允许密钥认证，确认可以用密钥登陆后再关闭密码登陆。



## SCP 远程传输

scp 就是 secure copy，是用来进行远程文件复制的，整个复制过程是加密的，数据传输使用的是 ssh，并且使用和 ssh 相同的认证方式，提供相同的安全保证。所以 scp 也同时可以使用 密码认证 和 密钥认证 两种方式。


### 上传本地文件到远程主机
```shell 
$ scp /path/filename username@servername:/path/
```
### 从远程主机下载文件到本地
``` shell
$ scp username@servername:/path/filename /var/www/local_dir（本地目录）
```

scp -r 可以递归上传或者下载，用于对于目录的传输。

scp -i 指定私钥文件。（如果公钥已经传到远程主机，并且开启密钥认证）

如果本地ssh客户端配置好了主机，也可以直接用 scp server1 这种格式。


## 利用 ssh-copy-id 复制公钥到多台主机

如果有多台远程主机时，一个一个去远程复制比较麻烦，所以考虑需要一次性把公钥复制到多个主机，之前的过程存在两个问题需要人工输入：

1. ssh 第一次登陆一台主机时，会弹出远程主机的公钥指纹，需要手动输入 yes 确认。
2. ssh 协议不支持在命令中直接输入密码，一般都是弹出 prompt 来手动输入密码。

第一个问题，可以在本地 ssh 客户端配置文件（~/.ssh/config）中配置 StrictHostKeyChecking=no 或在 ssh 命令中使用 -o StrictHostKeyChecking=no 来关闭公钥提示。

第二个问题，考虑用第三方工具 sshpass 来解决，这个工具支持在 ssh 命令行直接使用密码，而不需要弹出 prompt 再手动输入密码。直接用 yum 或者 apt 包管理器安装 sshpass 。

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

scp/sftp 使用 socks5、http_connect 代理：

```shell
$ scp -Cpr -oProxyCommand="nc -X5 -x127.0.0.1:1080 %h %p" files USER@SSH_SERVER:/
$ scp -Cpr -oProxyCommand="nc -Xconnect -x127.0.0.1:1080 %h %p" files USER@SSH_SERVER:/
$ sftp -oProxyCommand="nc -X5 -x127.0.0.1:1080 %h %p" USER@SSH_SERVER
$ sftp -oProxyCommand="nc -Xconnect -x127.0.0.1:1080 %h %p" USER@SSH_SERVER
```

如果你使用的是 XShell，也可以设置代理：

```shell
属性` -> `连接` -> `代理` -> `添加、选择代理服务器` -> `重新连接ssh
```








