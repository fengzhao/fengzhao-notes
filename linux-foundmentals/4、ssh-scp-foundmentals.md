# ssh 和 scp 基础

## OpenSSH 概览

**SSH 是 Secure SHELL 的缩写，顾名思义，这是一种建立在应用层基础上的安全协议，是一种加密的[网络传输协议](https://zh.wikipedia.org/wiki/%E7%BD%91%E7%BB%9C%E4%BC%A0%E8%BE%93%E5%8D%8F%E8%AE%AE)。**

可在不安全的网络中为网络服务提供安全的传输环境（即端到端加密，即使流量被劫持，也无法解密），专为 Linux 远程登陆和其他服务提供的安全协议。

SSH 是目前较可靠，专为远程登录会话和其他网络服务提供安全性的协议。利用 SSH 协议可以有效防止远程管理过程中的信息泄露问题。

通过 SSH 可以对所有传输的数据进行加密，也能够防止 DNS 欺骗和 IP 欺骗。

人们通常利用 SSH 来远程登录到服务器上执行命令。（类似 Windows 上的 rdb 协议）



**平时大家经常所讲的 SSH ，其实是 OpenSSH 。它是基于 SSH 协议的开源实现 ，基于 SSH 协议实现的工具中 OpenSSH 最为出名。**

在嵌入式服务器中，用户通过远程主机通过`OpenSSH`连接服务器。在`Linux`下基于tty运行login程序供client程序连接。

https://www.openssh.com/releasenotes.html

https://www.openssh.com/





openssh 是利用 OpenSSL  协议具体实现的开源软件，包括 ssh,ssh-copyid,ssh-keygen 等一系列套件，在 Linux 各大发行版基本上都已经预先安装好了。

可以使用 ssh -V 命令来查看 OpenSSH 版本。

在 Linux 中，sshd 是 OpenSSH SSH 的守护进程。**用于在不可信网络上提供安全的连接通道。**

 sshd 守护进程通常由 root 用户启动，它监听来自客户端的连接，然后为每个连接派生一个子进程。

 子进程负责处理密钥交换、加密、认证、执行命令、数据交换等具体事务。



## **OpenSSL** 

OpenSSL 是用于传输层安全性（TLS）协议的健壮的，商业级，功能齐全的开源工具包，因 **安全套接字层（SSL）协议** 而闻名。

这个协议的实现是基于完整功能的通用密码库，该库也可以独立使用。

OpenSSL 代码库的地址是 https://github.com/openssl/openssl 

源代码包下载

```shell
wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz 


```





用户可以从 [www.openssl.org/source](https://www.openssl.org/source) 或者 github 下载官方发行版的源代码压缩包 。OpenSSL 项目不会以二进制形式分发工具包。

但是，对于各种各样的操作系统，可以使用 OpenSSL 工具包的预编译版本。（各大 Linux 发行版基本上都有带预编译好的 OpenSSL）

特别是在Linux和其他Unix操作系统上，通常建议与发行商或供应商提供的预编译共享库链接。**一般不建议在 Linux 上自行编译安装 OpenSSL**

**这是一个操作系统很底层的加密库，很多应用层的软件都引用了它（比如nginx,python等），所以一般不建议在生产环境直接编译。**



**OpenSSL 3.0** 

OpenSSL 3.0 是下一代的 OpenSSL 发布版，目前仍然在开发中。

https://wiki.openssl.org/index.php/OpenSSL_3.0

历时三年的开发，17次 alpha releases，2 次 beta releases





OpenSSL 版本发布策略 

https://blog.csdn.net/qq2399431200/article/details/93600738



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

https://blog.csdn.net/naioonai/article/details/80984032









## Windows 下的 ssh

从 Win10 1809 和 Windows Server 2019 开始 Windows 开始支持 OpenSSH Server。

https://www.cnblogs.com/sparkdev/p/10166061.html 

所以我们在 windows 10 上基本也可以不用安装什么 xshell ，只要 cmd 或 terminal 就可以 ssh 到远程服务器了。



OpenSSH 客户端程序默认已经被系统安装好了，打开 设置->应用->可选功能 面板就可以看到：

也可以添加功能，安装 openssh server，安装好后，在服务中启动 openssh server 就可以让 windows 被 ssh 远程连接。

Windows 系统中 OpenSSH 的安装目录为 C:\Windows\System32\OpenSSH，不管是客户端程序还是服务器端程序都这这个目录中：

OpenSSH 服务器端程序的默认配置文件 sshd_config_default 也在这个目录中。这个目录会被添加到 PATH 环境变量中：







本文只记录 ssh 基本组件的用法，关于 ssh-agent 和 ssh-add 等命令，这里没有记录。



openssh 的认证方式：

- 密码认证
- 密钥认证（非对称加密）





## ssh命令组件

| 命令                                           | 文件             | 作用                                   |
| ---------------------------------------------- | ---------------- | -------------------------------------- |
| [ssh](https://www.ssh.com/ssh/)                | 二进制可执行文件 | ssh客户端，用于登陆远程主机            |
| [ssh-keygen](https://www.ssh.com/ssh/keygen/)  | 二进制可执行文件 | 生成密钥对                             |
| [ssh-copy-id](https://www.ssh.com/ssh/copy-id) | shell脚本        | 传输公钥到远程主机                     |
| [scp](https://www.ssh.com/ssh/scp/)            | 二进制可执行文件 | 远程传输文件                           |
| [ssh-agent](<https://www.ssh.com/ssh/agent>)   |                  |                                        |
| ssh-keyscan                                    |                  |                                        |
| sshd                                           |                  | ssh服务端，用于在服务器上启动sshdj进程 |
|                                                |                  |                                        |



### ssh 用法

```shell
# -p 端口 -i 密钥 
# 这个命令会利用密钥认证，直接免密登陆，如果没有用密钥，那么会交互式弹出密码输入
$ ssh user@host -p port -i /path/private_key
# 查看帮助
$ ssh --help
```



#### SSH命令格式

```shell
usage: ssh [-1246AaCfgKkMNnqsTtVvXxYy] [-b bind_address] [-c cipher_spec]  
           [-D [bind_address:]port] [-e escape_char] [-F configfile]  
           [-I pkcs11] [-i identity_file]  
           [-L [bind_address:]port:host:hostport]  
           [-l login_name] [-m mac_spec] [-O ctl_cmd] [-o option] [-p port]  
           [-R [bind_address:]port:host:hostport] [-S ctl_path]  
           [-W host:port] [-w local_tun[:remote_tun]]  
           [user@]hostname [command] 
```

#### 主要参数说明

```shell
-l 指定登入用户
-p 设置端口号
-f 后台运行，并推荐加上 -n 参数
-n 将标准输入重定向到 /dev/null，防止读取标准输入。如果在后台运行ssh的话（-f选项），就需要这个选项。
-N 不执行远程命令，只做端口转发
-q 安静模式，忽略一切对话和错误提示
-T 禁用伪终端配置
-t （tty）为远程系统上的ssh进程分配一个伪tty（终端）。如果没有使用这个选项，当你在远程系统上运行某条命令的时候，ssh不会为该进程分配tty（终端）。相反，ssh将会把远端进程的标准输入和标准输出附加到ssh会话上去，这通常就是你所希望的（但并非总是如此）。这个选项将强制ssh在远端系统上分配tty，这样那些需要tty的程序就能够正常运行。
-v verbose）显示与连接和传送有关的调试信息。如果命令运行不太正常的话，这个选项就会非常有用。
```







#### 在远程主机上直接执行命令

远程执行命令，ssh 可以直接在远程的目标主机上执行命令，而不用登陆上去后再来执行，就好像在本地执行一样。

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



如果是简单执行几个命令，则：

```shell
ssh user@remoteNode "cd /home ; ls"

```

　基本能完成常用的对于远程节点的管理了，几个注意的点：

1. 双引号，必须有。如果不加双引号，第二个ls命令在本地执行。
2. 分号，两个命令之间用分号隔开。

ssh 会将远程命令的 stdout 和本地的 stdout 连接起来。可以用这样的命令来看实时的日志：` ssh root@myserver.com "tail -f access.log"`。

这样就可以在本地执行一条命令就可以了，方便脚本化或记录到 本地 history。

```shell
# 将本地的公钥，通过管道传到远程主机的~/.ssh/authorized_keys文件中

cat ~/.ssh/id_rsa.pub | ssh root@myserver.com "cat - >> ~/.ssh/authorized_keys"
```





对于脚本的方式：



有些远程执行的命令内容较多，单一命令无法完成，考虑脚本方式实现：

```shell
#!/bin/bash
ssh user@remoteNode > /dev/null 2>&1  << remotessh    
cd /home
touch abcdefg.txt
# 执行一大堆命令
exit
remotessh    
echo done!

# 　远程执行的内容在 "<< remotessh " 至 "remotessh " 之间，在远程机器上的操作就位于其中，注意的点：
# << remotessh，ssh后直到遇到remotessh这样的内容结束，remotessh可以随便修改成其他形式。
# 重定向目的在于不显示远程的输出了
# 在结束前，加exit退出远程节点
```



#### ssh的-t参数

```shell
-t      Force pseudo-tty allocation.  This can be used to execute arbitrary screen-based programs on a remote machine, which can be very useful, e.g. when implementing menu services.  Multiple -t options force tty allocation, even if ssh has no local tty.  

```

中文翻译一下：就是可以提供一个远程服务器的虚拟tty终端，加上这个参数我们就可以在远程服务器的虚拟终端上输入自己的提权密码了，非常安全。

命令格式

```shell
ssh -t -p $port $user@$ip  'cmd'  
```

```shell
#!/bin/bash  
  
# 变量定义  
ip_array=("192.168.1.1" "192.168.1.2" "192.168.1.3")  
user="test1"  
remote_cmd="/home/test/1.sh"  
  
# 本地通过ssh执行远程服务器的脚本  
for ip in ${ip_array[*]}  
do  
    if [ $ip = "192.168.1.1" ]; then  
        port="7777"  
    else  
        port="22"  
    fi  
    ssh -t -p $port $user@$ip "remote_cmd"  
done 
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
$ scp /path/filename user@host:/path/
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

**ssh 的配置文件一般在 ~/.ssh 目录中，由于安全原因，该目录的权限一般要设置为 700 。**

```shell
# 查看ssh有哪些包
$ rpm -qa | grep -i ssh
openssh-clients-7.4p1-16.el7.x86_64
libssh2-1.4.3-12.el7_6.2.x86_64
openssh-7.4p1-16.el7.x86_64
openssh-server-7.4p1-16.el7.x86_64

# 查看openssh-client相关的文件
$ rpm -ql openssh-clients

/etc/ssh/ssh_config
/usr/bin/scp
/usr/bin/sftp
/usr/bin/slogin
/usr/bin/ssh
/usr/bin/ssh-add
/usr/bin/ssh-agent
/usr/bin/ssh-copy-id
/usr/bin/ssh-keyscan
/usr/lib64/fipscheck/ssh.hmac
/usr/libexec/openssh/ssh-pkcs11-helper
/usr/share/man/man1/scp.1.gz
/usr/share/man/man1/sftp.1.gz
/usr/share/man/man1/slogin.1.gz
/usr/share/man/man1/ssh-add.1.gz
/usr/share/man/man1/ssh-agent.1.gz
/usr/share/man/man1/ssh-copy-id.1.gz
/usr/share/man/man1/ssh-keyscan.1.gz
/usr/share/man/man1/ssh.1.gz
/usr/share/man/man5/ssh_config.5.gz
/usr/share/man/man8/ssh-pkcs11-helper.8.gz

# 查看openssh-server相关的文件
[root@localhost ~]# rpm -ql openssh-server
/etc/pam.d/sshd
/etc/ssh/sshd_config
/etc/sysconfig/sshd
/usr/lib/systemd/system/sshd-keygen.service
/usr/lib/systemd/system/sshd.service
/usr/lib/systemd/system/sshd.socket
/usr/lib/systemd/system/sshd@.service
/usr/lib64/fipscheck/sshd.hmac
/usr/libexec/openssh/sftp-server
/usr/sbin/sshd
/usr/sbin/sshd-keygen
/usr/share/man/man5/moduli.5.gz
/usr/share/man/man5/sshd_config.5.gz
/usr/share/man/man8/sftp-server.8.gz
/usr/share/man/man8/sshd.8.gz
/var/empty/sshd
[root@localhost ~]#


# ssh客户端全局配置文件，所有用户公用的配置文件
/etc/ssh/ssh_config
# ssh客户端用户配置文件，针对某个用户的具体配置文件，可以覆盖全局配置文件
~/.ssh/config


# ssh服务端配置文件，用来配置认证方式，是否启用root登陆，加密方式等等。
/etc/ssh/sshd_config

# 服务程序sshd启动时生成的服务端公钥和私钥文件。如ssh_host_rsa_key和ssh_host_rsa_key.pub。
# 其中.pub文件是主机验证时的host key(服务端主机指纹)，将写入到客户端的~/.ssh/known_hosts文件中。
# 其中私钥文件严格要求权限为600，若不是则sshd服务可能会拒绝启动。
/etc/ssh/ssh_host_*

# 客户端用户私钥，从客户端登陆服务端需要提供这个私钥证明合法登陆。为了安全，这个文件的权限必须是600。~/.ssh 目录的权限必须是700
~/.ssh/id_rsa

# ssh服务端公钥，公钥与私钥是一对密钥对，一般要设置为600，防止其他用户把自己的公钥注入进来
# 这个文件可以追加写入多个公钥
~/.ssh/authorized_keys


# 你访问过远程主机的公钥指纹都记录在~/.ssh/known_hosts。当下次访问相同计算机时，OpenSSH 会核对公钥指纹。如果公钥不同，OpenSSH 会发出警告。
~/.ssh/known_hosts



# SSH中文手册和配置文件
http://www.jinbuguo.com/openssh/sshd.html
http://www.jinbuguo.com/openssh/sshd_config.html
http://www.jinbuguo.com/openssh/ssh-keygen.html
```



### 相关配置参数说明

https://github.com/fengzhao/sshd_config/blob/master/sshd_config

关于 ssh 的公钥认证详细原理，可以参考阮一峰的博客。

http://www.ruanyifeng.com/blog/2011/12/ssh_remote_login.html

``` shell
# ~/.ssh/config 配置示例
# https://www.cnblogs.com/xjshi/p/9146296.html
# 这个例子配置了三个主机。端口，用户，私钥这些可以共用的配置都被 * 号这个主机段匹配。

# SSH 使命令行中给出的主机名与配置文件中定义的 Host 来匹配。它从文件顶部向下执行此操作，所以顺序非常重要。
# 现在是指出 Host 定义中的模式不必与您要连接的实际主机匹配的好时机。 实际上，您可以使用这些定义为主机设置别名，以替代实际的主机名。


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

UseDNS  yes            # 服务端sshd服务开启UseDNS选项状态下，当客户端试图使用SSH连接服务器时，服务器端先根据客户端的IP地址进行DNS PTR反向查询出客户端的主机名，然后根据查询出的客户端主机名进行DNS正向A记录查询，验证与其原始IP地址是否一致，这是防止客户端欺骗的一种措施，但一般我们的是动态IP不会有PTR记录，建议关闭该选项。


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

2. 通过 ssh-copy-id 命令将公钥传到远程主机。（ssh-copy-id 拥有到远程机器的home, ~./ssh , 和 ~/.ssh/authorized_keys的权限，这个命令其实就是将公钥写入到远程主机的 ~/.ssh/authorized_key文件中，所以也可以手动复制写进去）。

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

scp 就是 secure copy，是用来进行远程文件复制的，整个复制过程是加密的，数据传输使用的是 ssh，并且使用和 ssh 相同的认证方式，提供相同的安全保证。

实现的是在host与host之间的拷贝，可以是**本地到远程的、本地到本地的，甚至可以远程到远程复制。**

- 如果scp拷贝的源文件在目标位置上已经存在时(文件同名)，scp会替换已存在目标文件中的内容，但保持其inode号。
- 如果scp拷贝的源文件在目标位置上不存在，则会在目标位置上创建一个空文件，然后将源文件中的内容填充进去。



所以 scp 也可以同时使用 密码认证 和 密钥认证 两种方式。


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



## sftp文件传输

sftp 是 Secure FileTransferProtocol 的缩写，安全文件传送协议。可以为传输文件提供一种安全的加密方法。

sftp 与 ftp 有着几乎一样的语法和功能。

SFTP 为 SSH 的一部分，是一种服务器之间文件传输的安全方式。SCP 和 SFTP 的共同之处在于「使用SSH将文件加密才传输的」。

由于这种传输方式使用了加密/解密技术，所以传输效率比普通的 FTP 要低得多，如果您对网络安全性要求更高时，可以使用 SFTP 代替 FTP。



可以使用「WinSCP」或者「FileZilla」之类的客户端，还可以和 Windows 之间进行文件传输。



**设置目标**

在Ubuntu系统上开通 sftp 文件服务，允许某些用户上传及下载文件。但是这些用户只能使用 sftp 传输文件，不能使用 SSH 终端访问服务器。

并且 sftp 不能访问系统文件。

系统管理员则既能使用 sftp 传输文件，也能使用 SSH 远程管理服务器。

以下是将允许 sftp-users 用户组内的用户使用 sftp，但不允许使用 SSH Shell，且该组用户不能访问系统文件。

在 sftp-users 组内创建一个用户 "sftp"。允许 ssh-users 用户组内的用户使用 sftp 以及 SSH。系统管理员的账户名为 bbc2005。



https://www.cnblogs.com/binarylei/p/9201975.html





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





对于有公网IP的Linux，一般一定要设置 ssh 登陆保护。

1、将 ssh 端口修改成非默认的 22 端口，可以有效的避免互联网上攻击者的恶意扫描和尝试登陆。

2、





#### 查看用户登录及用户操作历史相关信息

使用 who 命令查看当前用户登录状况

使用 w 命令查看当前在线用户情况

使用 last 命令查看当前用户最近登录情况



使用 lastlog 命令查看各个用户登录情况

查看 /var/log/auth.log 文件，分析用户登陆行为（通过查看auth.log，可以分析出用户尝试登录情况，以及退出历史；）





东北大学防黑教程

http://antivirus.neu.edu.cn/scan/



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



https://github.com/cpandya2909/CVE-2020-15778/

https://www.cnblogs.com/canyezhizi/p/13537495.html







# openssh 编译升级



```shell
yum -y install zlib*  libcry*  openssl openssl-devel  pam-devel   gcc make cmake 



```



https://blog.51cto.com/gagarin/2989884










# ssh-deny



https://blog.csdn.net/weixin_41305441/article/details/107108429









# ssh 连接速度



How to Check the Speed of Your ssh Connection



https://webleit.info/how-to-check-the-speed-of-your-ssh-connection/



Have you ever wondered what is the speed of your ssh connection ？

For example you are connected to a server in Dubai but you live in London and now you want to know what is the speed if you need to scp something. 

Well the solution to this problem is called PV.



PV is a terminal-based (command-line based) tool in Linux that allows the **monitoring of data** being sent through pipe. The full form of PV command is **Pipe Viewer**. PV helps the user by giving him a visual display of the following：

- Time Elapsed
- Completed Progress (percentage bar)
- Current data transfer speed (also referred to as throughput rate)
- Data Transferred
- ETA (Estimated Time) (Remaining time)



pv命令是Pipe Viewer 的简称，由Andrew Wood 开发。意思是通过管道显示数据处理进度的信息。

这些信息包括已经耗费的时间，完成的百分比(通过进度条显示)，当前的速度，全部传输的数据，以及估计剩余的时间。



显示与操作有关的有用信息，包括已经传输了的数据量，花费的时间，传输速率，进度条，进度的百分比，以及剩余的时间



https://www.linuxcool.com/pv



```shell
apt install pv


yes | pv | ssh remote_host "cat >/dev/null"

166MiB 0:01:01 [2.52MiB/s] [   <=>

```



# TCP Wrappers 访问控制



TCP Wrappers 像一个防护罩一样，保护着TCP服务程序，它代为监听TCP服务程序的端口，为其增加了一个安全检测过程。

外来的连接请求必须先通过这层安全检测，获得许可后才能访问真正的服务程序。大多数 Linux 发行版，TCP Wrappers 是默认提供的功能。

tcp wrapper是Wietse Venema开发的一个开源软件。它是一个**用来分析TCP/IP封包的软件**，类似的IP封包软件还有iptables。Linux默认安装了tcp_wrapper。



作为一个安全的系统，Linux本身有两层安全防火墙，通过IP过滤机制的iptables实现第一层防护。

iptables防火墙通过直观的监视系统的运行状况，阻挡网络中的一些恶意攻击，保护整个系统正常运行免遭攻击和破坏。

如果通过了第一层防护，那么下一层防护就是tcp_wrapper了。

**通过tcp_wrapper可以实现对系统中提供的某些服务的开放和关闭、允许及禁止，从而更有效的保证系统安全运行。**

使用tcp_wrapper的功能仅需要两个配置文件：/etc/hosts.allow 和/etc/hosts.deny。

**如何界定特殊服务: 凡是调用了libwrap.so库的文件都受TCP Wrapper控制**



判断方式：

- 查看服务命令所在路径

  - 拿 ssh 为例

    ```shell
    [root@centos7 ~]# which sshd
    ```

- 查看指定命令时是否调用libwrap.so文件

  - ```shell
    [root@centos7 ~]# ldd /usr/sbin/sshd | grep libwrap.so
    libwrap.so.0 => /lib64/libwrap.so.0 (0x00007fbfcf5c0000)
    ```

**ldd是用来静态查看服务启动时所调用的库**



**特性**

- 工作在第四层（传输层）的TCP协议
- 对有状态连接的特定服务进行安全检测并实现访问控制
- 以库文件形式实现
- 某进程是否接受libwrap的控制取决于发起此进程的程序在编译时是否针对libwrap进行编译的
- 判断sshd服务是否支持tcp_wrapper：





# OpenSSH隧道



OpenSSH 可以使用tun/tap设备来创建一个加密隧道，SSH隧道类似mode TCP模式下的OpenVPN，对于有需求快速设置一个基于IP的VPN来说非常方便。



使用SSH隧道的优点：

1. 不需要安装和配置额外的软件
2. 使用SSH认证并自带加密，不需要使其它VPN软件一样配置共享密钥或者证书
3. 兼容性强，可以建立二层隧道或三层隧道，所有3/4层协议如：ICMP、TCP/UDP 等都可支持
4. 配置过程简单

当然也有缺点：

1. 基于TCP协议，其传输效率较低
2. 隧道依赖于单个TCP连接，容易中断或假死
3. 需要ROOT权限



这里还要说明一下二层和三层的区别：

- layer 2 : 交换单元是帧，只识别MAC地址，只有交换功能。
  - 相关协议：Ethernet、VLAN、STP、PPP、FDDI、ARP（OSI模型）、MPLS（介于2层3层之间）等，在Linux中是虚拟点对点设备，显示为tap
- layer 3 : 交换单元是包，能识别MAC地址和IP，有交换和路由功能。
  - 相关协议：IP、ICMP、IGMP、IPsec等，在Linux中是虚拟以太网设备，显示tun

在Linux中 tun/tap 都可以设置 IP，只是模拟的工作层有区别，tun 是模拟三层网络设备，收发的是 IP 包，无法处理以太网数据帧。

tap模拟的是二层设备，收发的是以为网数据帧，更接近物理网卡，可以和物理网卡通过网桥绑定。

我们日常用的wmware虚拟机中的nat网络，对应的就是tun，桥接网络对应的就是tap。







# 反弹shell







正常情况，我们登陆服务器获取 Shell 会话是这个步骤，客户端在终端软件（Terminal）中输入 `ssh root@ip` 登陆目标机器，登陆成功后即可以开始Shell操作。



反弹Shell（Reverse Shell），顾名思义是指与正常的 sshd 服务相反，由控制端监听，被控制端发起请求到监听端口，并将其命令行的输入输出转到控制端。









# X11转发



在 Linux 中可以通过SSH转发X以远程运行图形应用程序，这种机制称为 **X11转发**。



X11转发是允许用户启动安装在远程Linux系统上的图形应用程序并将该应用程序窗口（屏幕）转发到本地系统的方法。

远程系统不必具有X服务器或图形桌面环境。因此，使用SSH配置X11转发使用户可以通过SSH会话安全地运行图形应用程序。



从原理来讲。

- 对于用户login来说，本地主机是客户端（SSH Client），远程主机是服务端（SSH Server）；
- 对于X11程序来说，本地主机是服务端(X Server)，远程主机是客户端(X Client)。

从实际使用体验来说，是用户在本地主机通过 SSH Client 登录到启用了 X11 转发功能的远程主机的 SSH Server 上执行 GUI 图形界面程序，此时本地主机的显示器(X Server DISPLAY)上会呈现远程主机的GUI程序的图形界面。

## 预准备

| Linux             | SSH协议中的角色 | X协议中的角色 | OS        | IP            |
| ----------------- | --------------- | ------------- | --------- | ------------- |
| 本地Linux操作系统 | SSH Client      | X Server      | ArchLinux | 172.18.253.70 |
| 远程Linux操作系统 | SSH Server      | X Client      | CentOS    | 172.18.253.19 |





参考 

https://blog.csdn.net/yanggleyang/article/details/104727065


# 常见问题排查

(参考)[https://help.aliyun.com/document_detail/41470.html]
