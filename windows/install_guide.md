# Windows安装指南


> 系统镜像

win10 

https://www.microsoft.com/zh-cn/software-download/windows10ISO

win-server

https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2016


> 密钥和激活相关

https://docs.microsoft.com/zh-cn/windows-server/get-started/kmsclientkeys

https://docs.microsoft.com/zh-cn/DeployOffice/vlactivation/gvlks

https://docs.microsoft.com/zh-cn/previous-versions/office/

https://hub.docker.com/r/luodaoyi/kms-server


> 刻录工具

rufus

https://rufus.ie/en_IE.html

UNetbootin

https://unetbootin.github.io/

> 系统优化精简工具

ntlite

https://www.bilibili.com/video/av43379038

Dism++

https://www.chuyu.me/zh-Hans/index.html



### 安装过程

1、用谷歌浏览器打开上述地址，打开 F12 调试工具，在最右边的三个点处选择 more tools ，选择 network conditions ，修改 UA 为 chrome——mac。F5 刷新浏览器，下载最新镜像。

2、系统镜像优化（可选）

win10 原版镜像自带了很多冗余的一大堆应用，包括一些UWP应用，windows defender，人脉，skype等等，可以对系统镜像进行一些自定义的优化。

3、用 rufus 刻录工具把 windows 镜像刻录到 U 盘 （16GB以上，需要格式化）

4、开机进 bios 选择 U 盘启动开始安装。

5、激活，一般找个 kms server 就可以用 kms 方式激活了(使用管理员身份运行 cmd )。

        slmgr.vbs -ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
        slmgr.vbs -skms kms.serveryoufind
        slmgr.vbs -ato


6、win server 评估版转正式版。（使用管理员身份运行 cmd )

```
C:\Windows\system32>DISM /online /Get-CurrentEdition

部署映像服务和管理工具
版本: 10.0.17763.1

映像版本: 10.0.17763.253

当前版本为:

当前版本 : Professional

操作成功完成。

C:\Windows\system32>DISM /online /Set-Edition:<edition ID> /ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX /AcceptEula

```

`DISM /online /Get-CurrentEdition` 获取当前版本
`>DISM /online /Set-Edition` 设置版本 

<Edition ID>为当前可以转换的版本，ProductKey为产品KEY。

如需把标准版再升级至数据中心或企业版，可以先输入dism /online /get-targeteditions，查看当前系统可以升级的目标版本（如下图），再通过第二步命令升级至较高版本。

> win server 版本区别 https://zh.wikipedia.org/wiki/Windows_Server_2012#版本



## 2、OFFICE激活

```shell
# office转换工具
git clone https://github.com/kkkgo/office-C2R-to-VOL.git
# 以管理员身份运行 Convert-C2R.cmd

# 32位
cd "C:\Program Files (x86)\Microsoft Office\Office16"
# 64位
cd "C:\Program Files\Microsoft Office\Office16"
# 注册kms服务器地址
cscript ospp.vbs /sethst:kms.03k.org
# 执行激活
cscript ospp.vbs /act
```





## 3、搭建内部的 KMS Server 服务器

KMS 激活原理：KMS 是微软提供的批量激活功能，一般在一个局域网内，可以把其中某台机器搭建成 kms 服务器。这样局域网内的其他机器安装操作系统后，激活时，直接使用官网提供的批量激活密钥，设置 kms 服务器地址。然后就可以完成激活。这样每台客户端每 180 天都会与 kms 服务器通讯一次。这样一直保持激活状态，网上有大神写了搭建搭建 kms 的教程并开源，也有人在网上搭建好 kms 服务器，并免费提供 kms 服务，我们激活的时候，也可以直接使用别人的 kms 服务器激活，如果将来哪一天发现电脑变成未激活了，那就是连不上 kms 服务器了，再去网上找一个 kms 服务器即可。在一个组织内部，我们可以根据大神的脚本，搭建属于组织内部的 kms 服务器。提供给组织内部的人使用。

> https://teddysun.com/530.html

- docker方法：

```shell
docker run  -d -p  1688:1688  --name kms-server luodaoyi/kms-server
```

https://hub.docker.com/r/luodaoyi/kms-server



直接安装： 

sh -c "$(curl -fsSL https://raw.githubusercontent.com/fengzhao/fengzhao-notes/master/windows/kms.sh)"









## 4、Windows 10 家庭版升级到专业版

```
VK7JG-NPHTM-C97JM-9MPGT-3V66T
4N7JM-CV98F-WY9XX-9D8CF-369TT 
FMPND-XFTD4-67FJC-HDR8C-3YH26
```













