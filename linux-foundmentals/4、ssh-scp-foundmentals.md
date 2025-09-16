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

OpenSSL是Openssl团队的一个开源的能够实现安全套接层（SSLv2/v3）和安全传输层（TLSv1）协议的通用加密库。

该产品支持多种加密算法，包括对称密码、哈希算法、安全散列算法等。

OpenSSL 是用于传输层安全性（TLS）协议的健壮的，商业级，功能齐全的开源工具包，因 **安全套接字层（SSL）协议** 而闻名。

这个协议的实现是基于完整功能的通用密码库，该库也可以独立使用。

OpenSSL 存在操作系统命令注入漏洞，该漏洞源于c_rehash 脚本未正确清理 shell 元字符导致命令注入。攻击者利用该漏洞执行任意命令。

```shell
wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz 
wget https://www.openssl.org/source/openssl-1.1.1u.tar.gz
wget https://www.openssl.org/source/openssl-3.0.9.tar.gz
wget https://www.openssl.org/source/openssl-3.1.1.tar.gz
```



现在几乎所有的服务器软件和很多客户端软件都在使用OpenSSL，其中基于命令行的工具是进行密钥、证书管理以及测试最常用到的软件了。

有意思的是，之前很多使用其他库作为SSL/TLS解析的浏览器正发生一些变化，例如Google正在将Chrome迁移到他们自己的OpenSSL分支BoringSSL



OpenSSL 代码库的地址是 https://github.com/openssl/openssl ，项目由遍布世界的志愿者所组成的社区进行管理，他们通过互联网进行沟通、计划和开发OpenSSL工具集以及相关的文档。

用户可以从 [www.openssl.org/source](https://www.openssl.org/source) 或者 github 下载官方发行版的源代码压缩包 。OpenSSL 项目不会以二进制形式分发工具包。

但是，对于各种各样的操作系统，可以使用 OpenSSL 工具包的预编译版本。（各大 Linux 发行版基本上都有带预编译好的 OpenSSL）

特别是在Linux和其他Unix操作系统上，通常建议与发行商或供应商提供的预编译共享库链接。**一般不建议在 Linux 上自行编译安装 OpenSSL**

**这是一个操作系统很底层的加密库，很多应用层的软件都引用了它（比如nginx,python等），所以一般不建议在生产环境直接编译。**



很多关于SSL/TLS以及PKI的著作，但是这些材料都存在两个问题：

(1) 你需要的内容分布在不同的地方，很难形成整体（例如，RFC），因而难以寻找；

(2) 大多数著作都非常详细而且深入底层。很多文档已经废弃。



为了让这些材料变得有价值，我花了好几年时间工作和学习，才仅仅开始理解整个生态体系。



**OpenSSL 3.0** 

OpenSSL 3.0 是下一代的 OpenSSL 发布版，目前仍然在开发中。2021.11发布了3.0版本，开源协议也改成 `Apache License v2.0`

https://wiki.openssl.org/index.php/OpenSSL_3.0

https://www.cnblogs.com/Neeo/articles/17861749.html



历时三年的开发，17次 `alpha releases`，2 次 `beta releases`



OpenSSL是一款广泛使用的开源套件，可帮助应用程序实现安全通信。其1.1.1版本自2018年9月发布以来，已得到官方长达5年的更新与维护。

据 OPENSSL 项目组发布公告，发布于 2018 年 9 月 11 日的 `OPENSSL 1.1.1 LTS` 版即将结束 5 年长期支持，将在 2023 年 9 月 11 日正式结束支持。

在结束支持后此版本不会再接收任何公开可用的安全修复程序，也就是即便出现安全漏洞也得不到修复，因此很容易因为安全漏洞而遭到攻击。

对于仍然需要使用 `OPENSSL 1.1.1 LTS` 的企业来说，还可以选择付费购买高级支持合同，这样在结束支持后仍然可以获得某些安全更新，可以继续使用。



对于普通用户来说 OPENSSL 项目组推荐在结束支持前升级到受支持版本，可选版本包括最新的 `OPENSSL 3.1` 版，该版本的支持周期到 2025 年 3 月 14 日；

另一个可选版本是 `OPENSSL 3.0 LTS` 版，该版本支持周期到 2026 年 9 月 7 日。



为确保安全性，官方强烈建议用户在此之前升级到更新版本的OpenSSL。目前，最新版本`OpenSSL 3.1`将在2025年3月14日前获得官方支持。

而长期支持版本`OpenSSL 3.0`的生命周期则可达到2026年9月7日。值得一提的是，`OpenSSL 3.0`相较于旧版本有许多重大变更，但并非完全兼容旧版本。

这些变更包括加入联邦资讯处理标准（FIPS）、采用Apache License 2.0开源授权，以及废弃一些较旧的API。

官方表示，大部分使用OpenSSL 1.1.1的软件只需重新编译即可正常运行。然而，开发者可能会看到一些已废弃的API的编译警告。

在OpenSSL 1.1.1生命周期结束前，用户需采取必要行动，确保获得官方支持和安全保障。





目前，OpenSSL 的最新版本是 3.0，它于 2021 年 9 月 7 日正式发布。

OpenSSL 3.0 是一个重大的更新，它引入了许多新的概念和特性，例如提供者（Provider）、FIPS 模块（FIPS Module）、低级 API 的弃用（Deprecation of Low Level APIs）等。这些变化旨在提高 OpenSSL 的可扩展性、灵活性、安全性和易用性。



**与此同时，OpenSSL 1.1.1 版本已经达到了其生命周期（EOL）的尾声。**

**根据 OpenSSL 官方的声明，OpenSSL 1.1.1 版本将在 2023 年 9 月 11 日停止支持，届时它将不再收到公开的安全修复程序。**

**这意味着如果您继续使用 OpenSSL 1.1.1 版本，您的数据安全将面临巨大的风险。**





因此，我们强烈建议您尽快升级到 OpenSSL 3.0 版本，以享受最新的安全保护和功能增强。

升级到 OpenSSL 3.0 版本并不复杂，您只需要下载最新的源代码包，编译并安装即可。

如果您遇到任何问题或困难，您可以参考 OpenSSL 官方提供的迁移指南，或者在社区论坛寻求帮助。



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



OpenSSL没有自带可信根证书（也叫作可信证书库）



```bash
#!/bin/bash 


yum -y install zlib  perl zlib-devel bzip2-devel ncurses-devel sqlite-devel readline-devel tk-devel \
		gcc make libffi-devel gcc-c++ glibc  autoconf  openssl-devel pcre-devel  pam-devel  perl-IPC-Cmd

OPENSSL_VERSION="3.4.0"

mkdir -p /tmp/soft/  && cd  /tmp/soft/
wget --no-check-certificate  -c  https://ftp.openssl.org/source/${OPENSSL_VERSION}.tar.gz -O ${OPENSSL_VERSION}.tar.gz
# https://github.com/openssl/openssl/releases/download/openssl-${openssl_version}/openssl-${openssl_version}.tar.gz


# "备份OpenSSL"
mv -f /usr/bin/openssl /usr/bin/openssl_bak
mv -f /usr/include/openssl /usr/include/openssl_bak
mv -f /usr/lib64/libssl.so /usr/lib64/libssl.so.bak

cd  /tmp/soft/
./config --prefix=/usr/local/openssl -d shared && make -j 4 && make install -j 4

```



> 现在时间是 2024 年 04 月：
>
> OpenSSL 1.1.1 是长期支持版本（LTS），原先策略支持到2023-09-11，
>
> OpenSSL 1.1.0 支持到 2019-09-11，
>
> OpenSSL 1.0.2 是长期支持版本（LTS），支持到2019-12-31。



关于 OpenSSL 当前和未来版本的生命周期策略如下：

- 3.2 版本将支持到 2025-11-23，
- 3.1 版本将支持到 2025-03-14，
- 3.0 版本将支持到 2026-09-07(LTS)，
- **1.1.1, 1.0.2 版本将不再支持**，提供对1.1.1, 1.0.2的扩展支持，以访问这些版本的安全修复补丁，
- OpenSSL 1.1.0, 1.0.1, 1.0.0 和 0.9.8 版本已不再支持。



## BoringSSL

[BoringSSL](https://opensource.google.com/projects/boringssl) 是由谷歌开发，从 [OpenSSL](https://www.openssl.org/) 中分离的一个分支。BoringSSL 现阶段已经在 Chrome/Chromium 、 Android 等应用上

## Windows 下的 ssh

从 Win10 1809 和 Windows Server 2019 开始 Windows 开始支持 OpenSSH Server。

https://www.cnblogs.com/sparkdev/p/10166061.html 

所以我们在 windows 10 上基本也可以不用安装什么 xshell ，只要 cmd 或 terminal 就可以 ssh 到远程服务器了。



OpenSSH 客户端程序默认已经被系统安装好了，打开 设置->应用->可选功能面板就可以看到：

也可以添加功能，安装 openssh server，安装好后，在服务中启动 openssh server 就可以让 windows 被 ssh 远程连接。

Windows 系统中 OpenSSH 的安装目录为 C:\Windows\System32\OpenSSH，不管是客户端程序还是服务器端程序都这这个目录中：

OpenSSH 服务器端程序的默认配置文件 sshd_config_default 也在这个目录中。这个目录会被添加到 PATH 环境变量中：



本文只记录 ssh 基本组件的用法，关于 ssh-agent 和 ssh-add 等命令，这里没有记录。



openssh 的认证方式：

- 密码认证
- 密钥认证（非对称加密）





## ssh命令组件

| 命令                                           | 文件             | 作用                                                         |
| ---------------------------------------------- | ---------------- | ------------------------------------------------------------ |
| [ssh](https://www.ssh.com/ssh/)                | 二进制可执行文件 | ssh客户端，用于登陆远程主机                                  |
| [ssh-keygen](https://www.ssh.com/ssh/keygen/)  | 二进制可执行文件 | 生成密钥对                                                   |
| [ssh-copy-id](https://www.ssh.com/ssh/copy-id) | shell脚本        | 传输公钥到远程主机                                           |
| [scp](https://www.ssh.com/ssh/scp/)            | 二进制可执行文件 | 远程传输文件                                                 |
| [ssh-agent](<https://www.ssh.com/ssh/agent>)   |                  | `ssh-agent` 后台运行。负责安全地持有你已经解密的私钥，这样你在进行多次 SSH 连接时，就不需要一遍又一遍地输入密钥的密码了 |
| ssh-keyscan                                    |                  |                                                              |
| sshd                                           | 二进制可执行文件 | ssh服务端，用于在服务器上启动sshdj进程                       |
|                                                |                  |                                                              |



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
-o 在 ssh 命令里，-o 选项是用来指定配置项的（相当于写在 ~/.ssh/config 里的 Key Value）
```



```bash
# 查看所有可用的密钥交换算法
ssh -Q kex
diffie-hellman-group1-sha1
diffie-hellman-group14-sha1
diffie-hellman-group14-sha256
diffie-hellman-group16-sha512
diffie-hellman-group18-sha512
diffie-hellman-group-exchange-sha1
diffie-hellman-group-exchange-sha256
ecdh-sha2-nistp256
ecdh-sha2-nistp384
ecdh-sha2-nistp521
curve25519-sha256
curve25519-sha256@libssh.org
sntrup761x25519-sha512@openssh.com

# 查看所有可用的对称加密算法（Ciphers）
ssh -Q cipher
3des-cbc
aes128-cbc
aes192-cbc
aes256-cbc
aes128-ctr
aes192-ctr
aes256-ctr
aes128-gcm@openssh.com
aes256-gcm@openssh.com
chacha20-poly1305@openssh.com

# 查看所有可用的主机密钥算法（HostKeyAlgorithms）
ssh -Q key
ssh-ed25519
ssh-ed25519-cert-v01@openssh.com
sk-ssh-ed25519@openssh.com
sk-ssh-ed25519-cert-v01@openssh.com
ecdsa-sha2-nistp256
ecdsa-sha2-nistp256-cert-v01@openssh.com
ecdsa-sha2-nistp384
ecdsa-sha2-nistp384-cert-v01@openssh.com
ecdsa-sha2-nistp521
ecdsa-sha2-nistp521-cert-v01@openssh.com
sk-ecdsa-sha2-nistp256@openssh.com
sk-ecdsa-sha2-nistp256-cert-v01@openssh.com
ssh-dss
ssh-dss-cert-v01@openssh.com
ssh-rsa
ssh-rsa-cert-v01@openssh.com

# 查看 MAC 算法
ssh -Q mac
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

ssh-keygen 命令是用来生成一对新密钥对

```shell
# ssh-keygen -t 算法 -b 密钥长度 -C 标识（一般设为邮箱） -f 密钥对名称  
# 这个命令会生成 /path/keyname.pub（传到远程主机的公钥）和 /path/keyname（登陆远程主机的私钥） 
# 生成 SSH 密钥时，可以添加密码以进一步保护密钥。 每当使用密钥时，都必须输入密码。

# Ed25519 是一种用于数字签名的椭圆曲线算法，由丹尼尔·J·伯恩斯坦、Niels Duif、Tanja Lange、Peter Schwabe 和 Bo-Yin Yang 在 2011 年提出。
# 相较于传统的 RSA 和 DSA，Ed25519 具有更高的安全性和性能，近年来越来越受到欢迎。

ssh-keygen -t rsa -b 4096  -C "comment" -f /path/keyname  

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

### ssh-keyscan 用法

`ssh-keyscan` 是一个用于从一个或多个主机收集 SSH 公钥的实用工具。它旨在帮助构建和验证 `ssh_known_hosts` 文件。

`ssh_known_hosts` 文件位于用户的 `~/.ssh/` 目录下（或系统的 `/etc/ssh/` 目录下），用于记录已知 SSH 服务器的公钥。当您第一次通过 SSH 连接到某个服务器时，SSH 客户端会提示您是否信任该服务器的公钥，并将该公钥添加到 `known_hosts` 文件中。

下次连接到同一服务器时，SSH 客户端会比对服务器发送的公钥与 `known_hosts` 文件中记录的公钥，如果匹配，则认为连接是安全的，避免了中间人攻击的风险。

`ssh-keyscan` 的主要用途是**自动化获取远程服务器的 SSH 公钥，并将其添加到 `known_hosts` 文件中**，从而避免首次连接时手动确认和添加的过程。



这在以下场景中非常有用：

- **自动化部署和配置：** 在脚本或自动化配置管理工具中，可以使用 `ssh-keyscan` 预先获取目标服务器的公钥，避免在自动化过程中出现交互式提示。
- **批量添加主机密钥：** 当需要管理大量 SSH 服务器时，可以使用 `ssh-keyscan` 批量获取它们的公钥，而无需逐个手动连接。
- **验证现有 `known_hosts` 文件：** 可以使用 `ssh-keyscan` 再次扫描已知的主机，确认其公钥是否与 `known_hosts` 文件中的记录一致，从而检测潜在的密钥变更或中间人攻击。



### ssh-agent 用法

生成 SSH 密钥时，可以添加密码以进一步保护密钥。 每当使用密钥时，都必须输入密码。 如果密钥具有密码并且你不想每次使用密钥时都输入密码，则可以将密钥添加到 ssh agent。 ssh agent 会管理 SSH 密钥并记住你的密码。

可以把 `ssh-agent` 看作是一个在后台运行的“密钥管家”。它负责安全地持有你已经解密的私钥，这样你在进行多次 SSH 连接时，就不需要一遍又一遍地输入密钥的密码了。

**用途：**

- **一次登录，多次畅行：** 最主要的用途就是让你只需要在将私钥添加到 `ssh-agent` 时输入一次密码，之后在同一个会话中进行多次 SSH 连接时，就无需再次输入密码。
- **提升安全性：** 私钥在解密后只存储在 `ssh-agent` 的内存中，不会以未加密的形式保存在磁盘上，降低了密钥泄露的风险。而且密钥默认是不可导出的。
- **代理转发（Agent Forwarding）：** 这是一个非常强大的功能。通过 `ssh-agent` 转发，你可以在本地 SSH 连接到服务器 A 后，再从服务器 A SSH 连接到服务器 B，而无需将你的私钥复制到服务器 A 上。整个过程中，身份验证仍然是通过你本地机器上的私钥进行的。



### ssh-add 用法

`ssh-add` 是一个命令行工具，用于将你的私有 SSH 密钥文件添加到正在运行的 `ssh-agent` 中。

**用途：**

- **加载私钥：** 将你的私钥加载到 `ssh-agent` 中，这样 SSH 客户端就可以使用它们进行身份验证，而无需你重复输入密码。
- **管理密钥：** 它可以列出当前 `ssh-agent` 管理的密钥，也可以从 `ssh-agent` 中移除密钥。



```bash
# 要添加你的默认私钥（通常是 ~/.ssh/id_rsa、~/.ssh/id_dsa、~/.ssh/id_ecdsa 或 ~/.ssh/id_ed25519，直接运行：
ssh-add
# 如果你的密钥有密码，它会提示你输入。

# 要添加特定的私钥文件，指定文件路径。同样，如果密钥有密码，你需要输入。
ssh-add ~/.ssh/my_other_key

# 列出 ssh-agent 中管理的密钥
ssh-add -l

# 从 ssh-agent 中移除指定的密钥
ssh-add -d ~/.ssh/my_other_key

# 移除 ssh-agent 中的所有密钥
ssh-add -D


# 为密钥设置过期时间: 你可以使用 -t 选项设置密钥在 ssh-agent 中保留的时间（以秒为单位，或者使用 m、h、d、w 等单位）
ssh-add -t 1h ~/.ssh/temporary_key
# 这个密钥会在一小时后自动从 ssh-agent 中移除。


# 你只需要在一个会话中启动一次 ssh-agent（或者它可能自动启动）。
# 使用 ssh-add 将你的私钥加载到运行中的 ssh-agent 中，每个密钥的密码只需要输入一次。
# 一旦密钥被添加到 ssh-agent，你就可以使用 ssh、scp 等 SSH 客户端连接到信任你的公钥的远程服务器，而无需再次输入密码。
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

# 当第一次登陆远程主机时，不管是用密码还是密钥，这段话提示用户无法确认远程主机的真实性，只知道 RSA 公钥的指纹，询问用户是否继续。

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

port 22 									# ssh端口，Linux一般都是22端口做为ssh服务
PermitRootLogin yes  						# 是否允许root远程登录
PasswordAuthentication no　 		   		   # 是否允许密码方式登录
RSAAuthentication yes 						# 允许RSA认证，只针对SSH1
PubkeyAuthentication yes 					# 是否允许公钥认证
AuthorizedKeysFile .ssh/authorized_keys 	# 保存公钥的认证文件

UseDNS  yes       # 服务端sshd服务开启UseDNS选项状态下，当客户端试图使用SSH连接服务器时，服务器端先根据客户端的IP地址进行DNS PTR反向查询出客户端的主机名，然后根据查询出的客户端主机名进行DNS正向A记录查询，验证与其原始IP地址是否一致，这是防止客户端欺骗的一种措施，但一般我们的是动态IP不会有PTR记录，建议关闭该选项。

KexAlgorithms 	KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256
						
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

https://harttle.land/2022/05/02/ssh-port-forwarding.html





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









#### SSH 反向内网穿透

SSH反向穿透需要有一台有公网IP的服务器作为桥梁，此处将位于多重NAT网络中需要访问的主机称为**Target**，而将有固定IP的中转服务器称为**Server**。

SSH反向穿透的原理是：**Target主动建立与Server间的SSH连接，利用SSH的端口转发功能，将访问Server某端口的数据包转发到Target SSH端口（22端口）上，以此实现间接登陆Target的目的。**

假设Server上的转发端口为`6766`，使用如下命令在Target上建立与Server间的反向隧道：

```shell
# -R用于定义反向隧道，-fN用于在建立SSH连接后SSH进入后台运行。

ssh -p 22 -fN -R 6766:localhost:22 userServer@Server

```





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





## Systemd下的ssh服务



配置 sshd 大家都很熟悉，主要就是围绕 `/etc/ssh/sshd_config` 进行配置。而配置 sshd 的端口则是配置 `sshd_config` 中的 `Port`。

不过在 systemd 环境下，根据服务是由 `.socket` 文件配置启动还是 `.service` 文件配置启动的不同，配置端口分别需要配置 **`sshd.socket`** 文件或依然是 `sshd_config`。



需要确认系统所用的 sshd 服务，是由 `sshd.socket` 提供的，还是由 `sshd.service` 提供的。

- 如果服务由 `sshd.socket` 提供，配置端口需要配置 `sshd.socket` 文件；
- 如果服务由 `sshd.service` 提供，配置端口则需要配置传统的 `sshd_config` 文件。

一般系统中所安装的ssh服务都是由 `openssh` 包提供的：

```shell
# Ubuntu / Debian 下使用以下命令
dpkg -L openssh-server
# Red Hat / CentOS 下使用以下命令
rpm -ql openssh-server
# Arch Linux 下使用以下命令
pacman -Ql openssh
```

其中，在 systemd 环境下，

- CentOS 7 的 sshd 服务默认是由 `sshd.service` 文件启动的；
- Arch Linux 的 sshd 服务默认是由 `sshd.socket` 文件启动的；
- 其他系统也可以按照下面介绍的方法来确认服务是如何启动的。



# ssh安全



火狐信息安全openssh—guidelines

https://infosec.mozilla.org/guidelines/openss

https://github.com/jtesta/ssh-audit



对于有公网IP的Linux，一般一定要设置 ssh 登陆保护。

1、将 ssh 端口修改成非默认的 22 端口，可以有效的避免互联网上攻击者的恶意扫描和尝试登陆。

2、





## TCP Wrappers 访问控制



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



以ssh为例，每当有ssh的连接请求时，先读取系统管理员所设置的访问控制文件，符合要求，则会把这次连接原封不动的转给ssh进程，由ssh完成后续工作；

如果这次连接发起的ip不符合访问控制文件中的设置，则会中断连接请求，拒绝提供ssh服务[通过审查客户端的来源地址，决定该客户端的请求是否需要送达到SSH服务]



 **匹配顺序：**

- **优先查看/etc/hosts.allow，匹配即停止**
- **允许个别，拒绝所有（白名单）：/etc/hosts.allow文件添加允许的策略，hosts.deny文件添加all**
- **拒绝个别，允许所有（黑名单）：/etc/hosts.allow文件为空，hosts.deny文件添加单个拒绝的策略**



TCP_Wrappers的使用主要是依靠两个配置文件/etc/hosts.allow, /etc/hosts.deny，以此实现访问控制。

默认情况下，/etc/hosts.allow，/etc/hosts.deny什么都没有添加，此时没有限制。



**配置文件编写规则：**

```bash
# service_list@host:client_list
# service_list:是程序（服务）的列表，可以是多个，多个时，使用，隔开
# @host:设置允许或禁止他人从自己的哪个网口进入。这一项不写，就代表全部
# client_list:是访问者的地址，如果需要控制的用户较多，可以使用空格或，隔开
# client_list格式如下：
# 基于IP地址： 192.168.88.1 192.168.88.
# 基于域（域名）： www.kernel.com .kernel.com 较少用（域名IP可能变）
# 基于网络/掩码： 192.168.0.0/255.255.255.0
# 内置ACL：ALL(所有主机)、LOCAL(本地主机)


# 拒绝单个IP使用ssh远程连接（黑名单）效果
/etc/hosts.allow： 空着
/etc/hosts.deny：sshd:192.168.88.20

# 拒绝某一网段使用ssh远程连接：
/etc/hosts.allow：空着
/etc/hosts.deny：sshd:192.168.88. 或者 sshd:192.168.88.0/255.255.255.0
# 但sshd:192.168.88.0/24 可写入，但加入限制名单后仍可正常登入，故未生效，如图

# 仅允许某一IP使用ssh远程连接（白名单）效果
/etc/hosts.allow：sshd:192.168.88.20 
/etc/hosts.deny：sshd:ALL
```

**特性**

- 工作在第四层（传输层）的TCP协议
- 对有状态连接的特定服务进行安全检测并实现访问控制
- 以库文件形式实现
- 某进程是否接受libwrap的控制取决于发起此进程的程序在编译时是否针对libwrap进行编译的
- 判断sshd服务是否支持tcp_wrapper：



## 防爆破



暴露给互联网的所有服务器都有遭受恶意软件攻击的风险。 例如，如果您有连接到互联网的软件，则攻击者可以利用蛮力尝试来访问应用程序



### sshguard

sshguard采用宽容的BSD许可证来发行

软件在最常用的GNU/Linux发行版的主存储库中发行，面向某个BSD系统，但是你也可以[下载页面](http://www.sshguard.net/download/)下载源代码。



```shell
# SSHGuard在一些软件包仓库中可以直接安装，一般来说，包名就是sshguard。

# 依赖
apt install autoconf automake byacc flex gcc python-docutils
dnf install autoconf automake byacc flex gcc python-docutils

# 源码构建
git clone https://bitbucket.org/sshguard/sshguard.git
cd sshguard/
autoreconf -i
./configure
make && make install
```





### file2ban

https://github.com/fail2ban/fail2ban



Fail2ban是一个开源工具，可以通过监视服务日志中的恶意活动来帮助你保护Linux免受暴力攻击和其他自动攻击。

它使用正则表达式来扫描日志文件。将对所有与模式匹配的记录进行计数，并且当它们的数量达到某个预定义的阈值时。

Fail2ban会在指定时间段内禁止有问题的IP。 默认使用[系统防火墙](https://www.myfreax.com/how-to-setup-a-firewall-with-ufw-on-ubuntu-20-04/)阻止该IP的访问。 禁止期限到期后，IP地址将从禁止列表中删除。



## 查看用户登录及用户操作历史相关信息

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



https://blog.izayoih.com/artical/6c52d045/






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





# pdssh和pssh

parallel-ssh 是为小规模自动化而设计的异步并行的  SSH 库，包括 pssh、pscp、prsync、pslurp 和 pnuke工具，其源代码使用 Python语言编写开发的。

该项目最初位于Google Code上，是由Brent N.Chun编写和维护的，但是由于工作繁忙，Brent于2009年10月将维护工作移交给了Andrew McNabb管理。

到了 2012年的时候，由于Google Code的已关闭，该项目一度被废弃，现在也只能在 Google Code 的归档中找到当时的版本了。

但是需要注意的是，之前的版本是不支持 Python3 的，但是 Github 上面有人 Fork 了一份，自己进行了改造使其支持 Python3 以上的版本了。

与此同时，还有一个组织专门针对 [parallel-ssh](https://github.com/ParallelSSH/parallel-ssh) 进行了开发和维护，今天看了下很久都没有更新了。有需要的，自己可以自行查阅。





pssh是一个用python编写的可以在多台服务器上执行命令的工具，同时支持拷贝文件等功能，在同类工具中还是很方便使用的。项目地址：[parallel-ssh](https://code.google.com/p/parallel-ssh/)

