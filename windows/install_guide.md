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

https://www.kms.pub


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



> 参考教程
>
> https://a-little-cat.github.io/2019/05/08/kms.html#office-2019
>
> https://moe.best/tutorial/linux-kms-server.html

### 安装过程

1、用谷歌浏览器打开上述地址，打开 F12 调试工具，在最右边的三个点处选择 more tools ，选择 network conditions ，修改 UA 为 chrome——mac。F5 刷新浏览器，下载最新镜像。

2、系统镜像优化（可选）

win10 原版镜像自带了很多冗余的一大堆应用，包括一些UWP应用，windows defender，人脉，skype等等，可以对系统镜像进行一些自定义的优化。

3、用 rufus 刻录工具把 windows 镜像刻录到 U 盘 （16GB以上，需要格式化盘）。

4、开机进 bios 选择 U 盘启动开始安装。

5、激活，一般找个 kms server 就可以用 kms 方式激活了(使用管理员身份运行 cmd )。

        slmgr.vbs -ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
        slmgr.vbs -skms  ali.fengzhao.me:
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

// win-server-2012 转为正式版
DISM /online  /Set-Edition:ServerDatacenter /ProductKey:W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9 /AcceptEula

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


slmgr.vbs -skms kms.03k.org
```





## 3、KMS 激活原理

Key Management Service（简称:KMS），这个功能是在Windows Vista之后的产品中的一种新型产品激活机制，目的是为了Microsoft更好的遏制非法软件授权行为(盗版)。实际上这个功能提供了更简洁的破解方案…



由于Windows VL都是为批量激活而诞生，所以在一个激活单位中肯定会有很多台配置相等的计算机，并用一个服务器建立起一个局域网（LAN），而KMS正好利用这一点，它要求局域网中必须有一台KMS服务器，KMS服务器的作用是给局域网中的所有计算机的操作系统定周期(一般是180天)提供一个随机的激活ID(不同于产品激活密钥)，然后计算机里面的KMS服务就会自动将系统激活，实现正常的系统软件服务与操作。所以计算机必须保持与KMS服务器的定期连接，以便KMS激活服务的自动检查实现激活的自动续期，这样就实现了限制于公司域内的激活范围，避免了对于外界计算机的非法授权，当非法激活者离开公司域后，由于客户端KMS服务不能连接位于域内的KMS激活服务器，让它提供一个新的序列号，超过180天以后就会因为激活ID过期而重新回到试用版本状态，而合法授权者则能够定期获得ID更新，保持一直正确的激活状态。

KMS虽然定位于仅提供企业域内的内部网络的激活服务，但是基于MDL辛勤工作者的成果，全世界的志愿者们在全世界搭建了上百个位于广域互联网内的KMS服务器，并能够为任何能够访问互联网的Windows KMS终端提供激活服务，并且只要能够正常访问服务器就能够自动续期，不存在后期附加的定期操作，方便安全。

GVLK，英文全称Generic Volume License Key，表示批量授权许可密钥，用于kms客户端的通用激活序列号，凡是使用kms激活的windows系统还是Office，使用的都是GVLK密钥。GVLK密钥是微软官方免费提供给用户的,vol版系统安装后默认key即为GVLK，如果使用过其它key，需要切换为GVLK才能使用kms激活。





## 4、搭建内部的 KMS Server 服务器

KMS 激活原理：

KMS 是微软提供的批量激活功能，一般在一个局域网内，可以把其中某台机器搭建成 kms 服务器。

这样局域网内的其他机器安装操作系统后，激活时，直接使用官网提供的批量激活密钥，设置 kms 服务器地址，然后就可以完成激活。

这样每台客户端每 180 天都会与 kms 服务器通讯一次。这样一直保持激活状态，网上有大神写了搭建搭建 kms 的教程并开源。

也有人在网上搭建好 kms 服务器，并免费提供 kms 服务，我们激活的时候，也可以直接使用别人的 kms 服务器激活。

如果将来哪一天发现电脑变成未激活了，那就是连不上 kms 服务器了，再去网上找一个 kms 服务器即可。

在一个组织内部，我们可以根据大神的脚本，搭建属于组织内部的 kms 服务器。提供给组织内部的人使用。

> https://teddysun.com/530.html

- docker方法：

```shell


docker run  -d -p  1688:1688  --name kms-server luodaoyi/kms-server
```

https://hub.docker.com/r/luodaoyi/kms-server



直接安装： 

sh -c "$(curl -fsSL https://raw.githubusercontent.com/fengzhao/fengzhao-notes/master/windows/kms.sh)"









## 5、Windows 10 家庭版升级到专业版

```
VK7JG-NPHTM-C97JM-9MPGT-3V66T
4N7JM-CV98F-WY9XX-9D8CF-369TT 
FMPND-XFTD4-67FJC-HDR8C-3YH26
```





## 6、Windows Server 2012 设置多用户登陆



https://lighti.me/2858.html





## 7、Windows裁切精简与封装



所谓母盘就是我们平时说的官方原版镜像，在封装系统的过程中常常需要精简某些功能，有些功能在系统封装阶段是没办法彻底精简的。



所以我们首先需要对官方镜像进行精简操作，以去除某些不需要的功能，减小镜像大小。精简母盘的工具有很多，Dism++、MSMG Toolkit、NTLite等，这里我用的是 NTLite。



封装环境可以分为两种 —— 基于实体机、基于虚拟机。



准备工具：

- 移动硬盘 / U盘
- 原版windows操作系统镜像
- 7zip压缩软件，Dism++软件
- 



制作过程：

- 用7zip解压windows原版镜像

- 打开 dism++ 软件，挂载原版映像，选择解压后的source文件夹下的install.wim格式的文件。xuan'ze

  

打开 dism++ 软件，挂在原版iso镜像，选择目标映像（专业版win10），选择挂载路径





https://www.cnblogs.com/caishuaichao/p/14452670.html

https://sspai.com/post/61917

## 8、PE系统

Win PE 全称叫做 Windows 预安装系统，是 Windows 系统运行所必须的所有组件的最小集合。



> Windows PE系统的全称叫做Windows Preinstallation Environment，即Windows预安装环境。
>
> Windows PE的全称是Windows Preinstallation Environment，即Microsoft Windows 预安装环境，是一个基于保护模式下运行的Windows [ xp](http://www.mt30.com/system.html) Professional的工具，只拥有较少（但是非常核心）服务的Win32子[ 系统](http://www.mt30.com/Soft/systools/Index.html)。这些服务为Windows安装、实现[ 网络](http://www.mt30.com/Soft/nettools/Index.html)共享、自动底层处理进程和实现硬件验证。
>
> 顾名思义，这是安装系统前需要进入的环境，为安装系统而生。



然而，微软原版PE是什么样子的呢？一个纯粹的命令行就是一切的Shell。



可能这么说大家感觉比较绕，简单来说，PE 系统就是用来安装和修复系统的工具系统，最主要的作用就是用来重装系统。

当然PE系统的作用并不是仅仅用来重装系统，还有其他很多作用：

- 新装的电脑没系统怎么办，用PE可以直接格式化分区并释放镜像；
- 系统登录密码忘记了怎么办，用PE系统可以清除系统密码；
- 系统中了病毒没办法启动怎么办，用PE可以杀毒或者从硬盘恢复文件；
- 不小心把系统引导项删了怎么办，PE可以重建引导记录。



所以如果想要成为一个出色的系统重装大师（误），做一个PE启动盘是必须的。

优秀的PE系统有很多，像大白菜、老毛桃、微PE等等都是很老牌的PE系统，但是它们存在一些问题。

有的PE虽然非常有名，但是原作者早已将其卖掉了，新接手的商业公司不会像原来那么良心，会捆绑一些软件。

而有的PE时间比较久了，很多功能没有更新，没办法适应现在的系统和硬件。

更严重的问题则是假冒网站，这种现象对于越是出名的PE系统就越严重，实话说我到现在也不知道老毛桃的真正官网，网上搜到的可能一大半都是钓鱼网站。



https://hikaripe-sc.hikaricalyx.com/chapter1

https://post.smzdm.com/p/a25dx0rp/


### Hikari PE

### Edgeless

[edgeless](https://home.edgeless.top/) 是一款开源的PE，拥有详细的用户手册，他的插件功能给你非常的强大，用户可以根据使用手册自行定制对应的插件！而且日常使用和完整win10体验相差不远，很多软件都能装！推荐指数：五颗星。并且有微PE专用版。[文档地址](https://wiki.edgeless.top/v2/required.html)

### firpe

https://firpe.cn/




## 9、激活码



### Windows 10

| Operating system edition          | KMS Client Setup Key          |
| --------------------------------- | ----------------------------- |
| Windows 10 Core                   | TX9XD-98N7V-6WMQ6-BX7FG-H8Q99 |
| Windows 10 Core N                 | 3KHY7-WNT83-DGQKR-F7HPR-844BM |
| Windows 10 Core Country Specific  | PVMJN-6DFY6-9CCP6-7BKTT-D3WVR |
| Windows 10 Core Single Language   | 7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH |
| Windows 10 Professional           | W269N-WFGWX-YVC9B-4J6C9-T83GX |
| Windows 10 Professional N         | MH37W-N47XK-V7XM9-C7227-GCQG9 |
| Windows 10 Enterprise             | NPPR9-FWDCX-D2C8J-H872K-2YT43 |
| Windows 10 Enterprise N           | DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4 |
| Windows 10 Education              | NW6C2-QMPVW-D7KKK-3GKT6-VCFB2 |
| Windows 10 Education N            | 2WH4N-8QGBV-H22JP-CT43Q-MDWWJ |
| Windows 10 Enterprise 2015 LTSB   | WNMTR-4C88C-JK8YV-HQ7T2-76DF9 |
| Windows 10 Enterprise 2015 LTSB N | 2F77B-TNFGY-69QQF-B8YKP-D69TJ |
| Windows 10 Enterprise 2016 LTSB   | DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ |
| Windows 10 Enterprise 2016 LTSB N | QFFDN-GRT3P-VKWWX-X7T3R-8B639 |

### Windows 8 / 8.1

| Operating system edition                 | KMS Client Setup Key          |
| ---------------------------------------- | ----------------------------- |
| Windows 8 Professional                   | NG4HW-VH26C-733KW-K6F98-J8CK4 |
| Windows 8 Professional N                 | XCVCF-2NXM9-723PB-MHCB7-2RYQQ |
| Windows 8 Enterprise                     | 32JNW-9KQ84-P47T8-D8GGY-CWCK7 |
| Windows 8 Enterprise N                   | JMNMF-RHW7P-DMY6X-RF3DR-X2BQT |
| Windows Embedded 8 Industry Professional | RYXVT-BNQG7-VD29F-DBMRY-HT73M |
| Windows Embedded 8 Industry Enterprise   | NKB3R-R2F8T-3XCDP-7Q2KW-XWYQ2 |
| Windows 8.1 Professional                 | GCRJD-8NW9H-F2CDX-CCM8D-9D6T9 |
| Windows 8.1 Professional N               | HMCNV-VVBFX-7HMBH-CTY9B-B4FXY |
| Windows 8.1 Enterprise                   | MHF9N-XY6XB-WVXMC-BTDCT-MKKG7 |
| Windows 8.1 Enterprise N                 | TT4HM-HN7YT-62K67-RGRQJ-JFFXW |
| Windows Embedded 8.1 Industry Pro        | NMMPB-38DD4-R2823-62W8D-VXKJB |
| Windows Embedded 8.1 Industry Enterprise | FNFKF-PWTVT-9RC8H-32HB2-JB34X |

### Windows 7

| Operating system edition | KMS Client Setup Key          |
| ------------------------ | ----------------------------- |
| Windows 7 Professional   | FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4 |
| Windows 7 Professional N | MRPKT-YTG23-K7D7T-X2JMM-QY7MG |
| Windows 7 Professional E | W82YF-2Q76Y-63HXB-FGJG9-GF7QX |
| Windows 7 Enterprise     | 33PXH-7Y6KF-2VJC9-XBBR8-HVTHH |
| Windows 7 Enterprise N   | YDRBP-3D83W-TY26F-D46B2-XCKRJ |
| Windows 7 Enterprise E   | C29WB-22CC8-VJ326-GHFJW-H9DH4 |

### Windows Server 2016

| Operating system edition       | KMS Client Setup Key          |
| ------------------------------ | ----------------------------- |
| Windows Server 2016 Datacenter | CB7KF-BWN84-R7R2Y-793K2-8XDDG |
| Windows Server 2016 Standard   | WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY |
| Windows Server 2016 Essentials | JCKRF-N37P4-C2D82-9YXRT-4M63B |

### Windows Server 2012

| Operating system edition                | KMS Client Setup Key          |
| --------------------------------------- | ----------------------------- |
| Windows Server 2012                     | BN3D2-R7TKB-3YPBD-8DRP2-27GG4 |
| Windows Server 2012 N                   | 8N2M2-HWPGY-7PGT9-HGDD8-GVGGY |
| Windows Server 2012 Single Language     | 2WN2H-YGCQR-KFX6K-CD6TF-84YXQ |
| Windows Server 2012 Country Specific    | 4K36P-JN4VD-GDC6V-KDT89-DYFKP |
| Windows Server 2012 Server Standard     | XC9B7-NBPP2-83J2H-RHMBY-92BT4 |
| Windows Server 2012 MultiPoint Standard | HM7DN-YVMH3-46JC3-XYTG7-CYQJJ |
| Windows Server 2012 MultiPoint Premium  | XNH6W-2V9GX-RGJ4K-Y8X6F-QGJ2G |
| Windows Server 2012 Datacenter          | 48HP8-DN98B-MYWDG-T2DCC-8W83P |
| Windows Server 2012 R2 Server Standard  | D2N9P-3P6X9-2R39C-7RTCD-MDVJX |
| Windows Server 2012 R2 Datacenter       | W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9 |
| Windows Server 2012 R2 Essentials       | KNC87-3J2TX-XB4WP-VCPJV-M4FWM |

### Windows Server 2008

| Operating system edition                         | KMS Client Setup Key          |
| ------------------------------------------------ | ----------------------------- |
| Windows Server 2008 Web                          | WYR28-R7TFJ-3X2YQ-YCY4H-M249D |
| Windows Server 2008 Standard                     | TM24T-X9RMF-VWXK6-X8JC9-BFGM2 |
| Windows Server 2008 Standard without Hyper-V     | W7VD6-7JFBR-RX26B-YKQ3Y-6FFFJ |
| Windows Server 2008 Enterprise                   | YQGMW-MPWTJ-34KDK-48M3W-X4Q6V |
| Windows Server 2008 Enterprise without Hyper-V   | 39BXF-X8Q23-P2WWT-38T2F-G3FPG |
| Windows Server 2008 HPC                          | RCTX3-KWVHP-BR6TB-RB6DM-6X7HP |
| Windows Server 2008 Datacenter                   | 7M67G-PC374-GR742-YH8V4-TCBY3 |
| Windows Server 2008 Datacenter without Hyper-V   | 22XQ2-VRXRG-P8D42-K34TD-G3QQC |
| Windows Server 2008 for Itanium-Based Systems    | 4DWFP-JF3DJ-B7DTH-78FJB-PDRHK |
| Windows Server 2008 R2 Web                       | 6TPJF-RBVHG-WBW2R-86QPH-6RTM4 |
| Windows Server 2008 R2 HPC edition               | TT8MH-CG224-D3D7Q-498W2-9QCTX |
| Windows Server 2008 R2 Standard                  | YC6KT-GKW9T-YTKYR-T4X34-R7VHC |
| Windows Server 2008 R2 Enterprise                | 489J6-VHDMP-X63PK-3K798-CPX3Y |
| Windows Server 2008 R2 Datacenter                | 74YFP-3QFB3-KQT8W-PMXWJ-7M648 |
| Windows Server 2008 R2 for Itanium-based Systems | GT63C-RJFQ3-4GMB6-BRFB9-CB83V |

### Office 2019

| Product                       | GVLK                          |
| ----------------------------- | ----------------------------- |
| Office Professional Plus 2019 | NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP |
| Office Standard 2019          | 6NWWJ-YQWMR-QKGCB-6TMB3-9D9HK |
| Project Professional 2019     | B4NPR-3FKK7-T2MBV-FRQ4W-PKD2B |
| Project Standard 2019         | C4F7P-NCP8C-6CQPT-MQHV9-JXD2M |
| Visio Professional 2019       | 9BGNQ-K37YR-RQHF2-38RQ3-7VCBB |
| Visio Standard 2019           | 7TQNQ-K3YQQ-3PFH7-CCPPM-X4VQ2 |
| Access 2019                   | 9N9PT-27V4Y-VJ2PD-YXFMF-YTFQT |
| Excel 2019                    | TMJWT-YYNMB-3BKTF-644FC-RVXBD |
| Outlook 2019                  | 7HD7K-N4PVK-BHBCQ-YWQRW-XW4VK |
| PowerPoint 2019               | RRNCX-C64HY-W2MM7-MCH9G-TJHMQ |
| Publisher 2019                | G2KWX-3NW6P-PY93R-JXK2T-C9Y9V |
| Skype for Business 2019       | NCJ33-JHBBY-HTK98-MYCV8-HMKHJ |
| Word 2019                     | PBX3G-NWMT6-Q7XBW-PYJGG-WXD33 |

### Office 2016

| Product                       | GVLK                          |
| ----------------------------- | ----------------------------- |
| Office Professional Plus 2016 | XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99 |
| Office Standard 2016          | JNRGM-WHDWX-FJJG3-K47QV-DRTFM |
| Project Professional 2016     | YG9NW-3K39V-2T3HJ-93F3Q-G83KT |
| Project Standard 2016         | GNFHQ-F6YQM-KQDGJ-327XX-KQBVC |
| Visio Professional 2016       | PD3PC-RHNGV-FXJ29-8JK7D-RJRJK |
| Visio Standard 2016           | 7WHWN-4T7MP-G96JF-G33KR-W8GF4 |
| Access 2016                   | GNH9Y-D2J4T-FJHGG-QRVH7-QPFDW |
| Excel 2016                    | 9C2PK-NWTVB-JMPW8-BFT28-7FTBF |
| OneNote 2016                  | DR92N-9HTF2-97XKM-XW2WJ-XW3J6 |
| Outlook 2016                  | R69KK-NTPKF-7M3Q4-QYBHW-6MT9B |
| PowerPoint 2016               | J7MQP-HNJ4Y-WJ7YM-PFYGF-BY6C6 |
| Publisher 2016                | F47MM-N3XJP-TQXJ9-BP99D-8K837 |
| Skype for Business 2016       | 869NQ-FJ69K-466HW-QYCP2-DDBV6 |
| Word 2016                     | WXY84-JN2Q9-RBCCQ-3Q3J3-3PFJ6 |

### Office 2013

| Product                       | GVLK                          |
| ----------------------------- | ----------------------------- |
| Office 2013 Professional Plus | YC7DK-G2NP3-2QQC3-J6H88-GVGXT |
| Office 2013 Standard          | KBKQT-2NMXY-JJWGP-M62JB-92CD4 |
| Project 2013 Professional     | FN8TT-7WMH6-2D4X9-M337T-2342K |
| Project 2013 Standard         | 6NTH3-CW976-3G3Y2-JK3TX-8QHTT |
| Visio 2013 Professional       | C2FG9-N6J68-H8BTJ-BW3QX-RM3B3 |
| Visio 2013 Standard           | J484Y-4NKBF-W2HMG-DBMJC-PGWR7 |
| Access 2013                   | NG2JY-H4JBT-HQXYP-78QH9-4JM2D |
| Excel 2013                    | VGPNG-Y7HQW-9RHP7-TKPV3-BG7GB |
| InfoPath 2013                 | DKT8B-N7VXH-D963P-Q4PHY-F8894 |
| Lync 2013                     | 2MG3G-3BNTT-3MFW9-KDQW3-TCK7R |
| OneNote 2013                  | TGN6P-8MMBC-37P2F-XHXXK-P34VW |
| Outlook 2013                  | QPN8Q-BJBTJ-334K3-93TGY-2PMBT |
| PowerPoint 2013               | 4NT99-8RJFH-Q2VDH-KYG2C-4RD4F |
| Publisher 2013                | PN2WF-29XG2-T9HJ7-JQPJR-FCXK4 |
| Word 2013                     | 6Q7VD-NX8JD-WJ2VH-88V73-4GBJ7 |

### Office 2010

| Product                       | GVLK                          |
| ----------------------------- | ----------------------------- |
| Office Professional Plus 2010 | VYBBJ-TRJPB-QFQRF-QFT4D-H3GVB |
| Office Standard 2010          | V7QKV-4XVVR-XYV4D-F7DFM-8R6BM |
| Access 2010                   | V7Y44-9T38C-R2VJK-666HK-T7DDX |
| Excel 2010                    | H62QG-HXVKF-PP4HP-66KMR-CW9BM |
| SharePoint Workspace 2010     | QYYW6-QP4CB-MBV6G-HYMCJ-4T3J4 |
| InfoPath 2010                 | K96W8-67RPQ-62T9Y-J8FQJ-BT37T |
| OneNote 2010                  | Q4Y4M-RHWJM-PY37F-MTKWH-D3XHX |
| Outlook 2010                  | 7YDC2-CWM8M-RRTJC-8MDVC-X3DWQ |
| PowerPoint 2010               | RC8FX-88JRY-3PF7C-X8P67-P4VTT |
| Project Professional 2010     | YGX6F-PGV49-PGW3J-9BTGG-VHKC6 |
| Project Standard 2010         | 4HP3K-88W3F-W2K3D-6677X-F9PGB |
| Publisher 2010                | BFK7F-9MYHM-V68C7-DRQ66-83YTP |
| Word 2010                     | HVHB3-C6FV7-KQX9W-YQG79-CRY7T |
| Visio Standard 2010           | 767HD-QGMWX-8QTDB-9G3R2-KHFGJ |
| Visio Professional 2010       | 7MCW8-VRQVK-G677T-PDJCM-Q8TCP |
| Visio Premium 2010            | D9DWC-HPYVV-JGF4P-BTWQB-WX8BJ |



# win10设置多人同时远程登录

RDP，Remote Desktop Protocol,远程桌面协议，是一个多通道（mutil-channel）的协议，让用户（客户端或称“本地电脑”）连上提供微软终端机服务的电脑（服务器端或称“远程电脑”）。

大部分的Windows、Linux、FreeBSD、Mac OS X都有相应的客户端。服务端听取送到 TCP 3389 端口的数据。

windows从NT开始提供终端服务，它是微软买来的网络协议技术(Citrix)，服务器端要安装、配置，客户端要连接程序。

终端服务使任何一台有权限的终端机，用已知的账号登录服务器，可以使用账号内的资源，包括软件，硬件资源；

同时，在协议升级后，客户端连接后可以使用本地的资源，包括本地打印机、声音本地回放，本地磁盘资源和本地硬件接口。

**所有的计算都在服务器端进行，客户端只需要处理网络连接、接收数据、界面显示和设备数据输出。**

目前，关于RDP服务的linux客户端程序有 winconnect，linrdp，rdesktop，前两个没有源码，但 redsktop 已经由原来的个人开发后公开代码演变成现在的项目组开发。

[RDP简介](https://blog.csdn.net/qq_38526635/article/details/81672490)

[RDP协议](https://docs.microsoft.com/zh-CN/troubleshoot/windows-server/remote/understanding-remote-desktop-protocol)

设置之前注意防火墙问题，可以先把防火墙关掉，不想关的话需要设置防火墙允许通过的应用，在里面找到远程桌面，将其设置为允许（默认是关闭的）。





在 window 上新建多个用户账号

右键 "此电脑" -> 管理 -> 本地用户和组 -> 右键“用户”选择【新用户】-> 点击【创建】按钮，即可完成创建







由于RDP很久没有更新了，而win10系统还在持续更新中，所以就会造成系统更新时修改termsrv.dll文件(termsrv.dll所在位置为: C:\Windows\System32，可右键查看其版本信息)，导致多人同时远程登录失败，同时RDP也无法设置成功，幸好一直有大佬在及时更新rdpwrap.ini，这样就可以仅更新rdpwrap.ini文件即可成功配置成功。
具体操作步骤可参考如下：

1、克隆一个包含rdpwrap.ini最新内容的GitHub链接`git clone https://github.com/asmtron/rdpwrap`。如果克隆过了，可以使用`git pull origin`更新本地仓库。
2、第一次使用请将rdpwrap中bin目录下的helper文件夹和autoupdate.bat复制到C:\Program Files\RDP Wrapper下。
3、每次重新配置都需要将rdpwrap中res目录下的rdwrap.ini复制到C:\Program Files\RDP Wrapper（一定要确保此时的rdpwrap.ini中包含当前系统中termsrv.dll的版本信息说明，可以用记事本打开rdpwrap.ini文件查看）
4、右键管理员运行autoupdate.bat，执行成功即可。
5、双击RDPCheck.exe测试是否成功配置成功。
6、如果没有，可以再次查看rdpwrap.ini文件确保该文件中包含当前系统中termsrv.dll的版本信息说明,并确保autoupdate.bat执行成功，然后尝试重启电脑。

7、如果还是没有配置成功，可尝试管理员运行uninstall.bat，重新安装rdpwrap软件，然后重复上述步骤。

这个方法可以不关闭远程服务，即可在远程连接的状态下完成，不过我感觉有可能程序关闭远程服务导致远程断开，所以为了解决远程服务莫名断开而无法远程连接的问题，我自己找到了一个方法，让电脑自动在某个时间重启远程连接服务，特别在另一篇博客中记录，欢迎大家浏览，[链接](https://www.cnblogs.com/xingyu666/p/14279630.html)。

----------分割线----------

设置成功之后，就可以多人同时登陆工作站了。



# 固件



### 固件

确切的说，固件（Firmware）也是一种软件，但是它比一般的软件（例如操作系统或者运行在操作系统上的应用软件）更接近硬件，一般是由硬件厂商在硬件出厂前直接固化到硬件内部的芯片上。有些固件是可以升级的，例如大部分计算机主板的固件，这里我们讨论的也主要是计算机主板的固件。

我们国内常说的BIOS更新，BIOS升级（其实就是升级主板固件的意思）





BIOS 和 UEFI 都是计算机的固件类型。BIOS 固件（主要）用于 IBM PC 兼容计算机。UEFI 的通用性更强，可用在非“IBM PC 兼容”系列的计算机上。



现在我们能看到的计算机主板固件主要上分为两种：BIOS（Legacy BIOS）和 UEFI，BIOS 历史悠久，数十年没有太大的变化，已经不太适应计算机的发展，因而催生了更加先进和适应时代需求的 UEFI。

- BIOS 是 Basic Input Output System（基本输入输出系统）的缩写，如前文所说，它也是可执行的程序代码，计算机启动时会首先将 BIOS 载入到内存并执行，并由 BIOS 来完成硬件检测和初始化，然后启动磁盘上的操作系统。

- UEFI 是 Unified Extensible Firmware Interface（统一可扩展固件接口）的缩写，它是 BIOS 的替代者，并且本着向下兼容的原则，大部分 UEFI 都包含 BIOS 的兼容模块（Compatibility Support Module/CSM），在其设置中也能找到相关的选项。



> 不存在“UEFI BIOS”。没有任何一台计算机会有“UEFI BIOS”。请不要再说“UEFI BIOS”。BIOS 不是所有 PC 固件的通用术语，它只是 PC 固件的一种特定类型。计算机中包含固件。如果你有一台 IBM PC 兼容计算机，那么固件几乎肯定就是 BIOS 或 UEFI。如果你运行的是 Coreboot，那么恭喜，你是个例外，引以为傲吧。



安全启动 (Secure Boot) 与 UEFI 不是同一个概念。请不要将这些术语混淆使用。安全启动 (Secure Boot) 实际上是 UEFI 规范的一项可选功能，于 UEFI 规范版本 2.2 引入。我们稍后会详细讨论安全启动 (Secure Boot) 到底是什么，但是目前而言，只需要记住它和 UEFI 不同即可。你需要区分安全启动 (Secure Boot) 和 UEFI 的差异，在任何场合，你都应当了解你实际上讨论的是其中哪一个。我们首先讨论 UEFI，然后我们将把安全启动 (Secure Boot) 作为 UEFI 的一项“扩展”来进行讨论，因为这就是安全启动 (Secure Boot) 的本质。

> 注释：UEFI 不是由微软开发的，也从来不受微软控制。它的前身和基础——EFI，是由 Intel 开发和发布的。UEFI 由 UEFI 论坛进行管理。微软是 UEFI 论坛的成员之一。
>
> Red Hat、Apple、几乎所有主要 PC 制造商、Intel（显然）、AMD 和一大批其他主要和次要硬件、软件和固件公司及组织也都是 UEFI 论坛的成员。
>
> UEFI 是一套业已达成广泛共识的规范，其中当然也包含各种混乱（我们稍后会专门讨论其中一部分）。UEFI 并不由任何一家公司独裁掌控。
> 参考资料

如果想真正了解 UEFI，阅读 UEFI 规范是个不错的方法。这件事并不难，也不需要什么代价。阅读 UEFI 规范相当枯燥乏味，但是会让你受益匪浅。

你可以从官方 UEFI 网站下载 UEFI 规范。尽管下载 UEFI 规范需要先同意某些条款和条件，但是不会带来损失。

在我撰写本文时，UEFI 规范的最新版本是 2.4 Errata A（译者注：现在更新到了 2.4 Errata B），本文所写内容也基于这一版本。

BIOS 没有制定相应规范。BIOS 本身就是一项事实标准，从 20 世纪 80 年代开始，BIOS 的工作方式就一成不变。这也是诞生 UEFI 的原因之一。

简单起见，我们可以把 BIOS 和 UEFI 看成两种不同的组合。其中一种是 UEFI和 GPT （我们稍后会讨论 GPT）产生之前，IBM PC 兼容计算机（以下称为 PC）所广泛采用的组合。

大部分人可能对这种组合非常熟悉，对其中的细节了如指掌。那么我们就先来讨论在具有 BIOS 固件的 PC 上，启动是如何工作的。



### BIOS 启动

事实上，BIOS 启动的工作原理非常非常简单。在老式 BIOS PC 上，装有一个或多个磁盘，每个磁盘中包含 MBR。

MBR 是另一套事实标准；大体而言，磁盘起始位置以特定格式描述磁盘上的分区，并包含“启动装载程序 (boot loader)”，BIOS 固件知道如何执行这一小段启动装载程序代码。

启动装载程序的职责是启动操作系统（现代启动装载程序的大小通常超出了 MBR 空间所能容纳的范围，因此必须采用多阶段设计，其中 MBR 部分只知道如何从其他位置加载下一阶段，我们现在先不着重讨论这一过程）。

在启动系统的过程中，BIOS 固件只能识别系统包含的磁盘。而作为 BIOS 计算机的拥有者，你可以告诉 BIOS 固件你想从哪个磁盘启动系统。而固件本身并不知道其他细节，它只会执行在指定磁盘的 MBR 部分所发现的启动装载程序，就这么回事。在执行启动装载程序之后，固件本身就不再参与启动。

在 BIOS 组合中，所有的多重启动形式都肯定是在固件层上进行处理的。固件层无法真正识别启动装载程序或操作系统，甚至连分区都无法识别。

固件所能执行的操作只是从磁盘的 MBR 中运行启动装载程序。你无法从固件外部配置启动过程。





### UEFI 启动：背景

UEFI 与 BIOS 完全不同。UEFI 启动原理与 BIOS 绝对不同。你不能把 BIOS 启动的原理直接套用到原生 UEFI 启动上。你不能把专为 BIOS 启动设计的工具应用到原生 UEFI 启动的系统上。记住，UEFI 组合完全不同。

还需要了解一个重点：许多 UEFI 固件实现了某种 BIOS 兼容模式（有时候称为 CSM）。许多 UEFI 固件可以像 BIOS 固件一样启动系统，它们可以查找磁盘上的 MBR，然后从 MBR 中执行启动装载程序，接着将后续工作完全交给启动装载程序。有时候，其他人误将此功能称为“禁用 UEFI”，从语言学角度而言，这种说法是荒谬的。系统固件是无法“禁用”的。这种说法很愚蠢，不要采用这种说法。但是在其他人这么说的时候，应该了解他们真正想表达什么。他们讨论的是通过 UEFI 固件的一项功能，以“BIOS 风格”启动系统，而不是采用原生 UEFI 方式启动系统。

我想解释一下原生 UEFI 启动。如果你有一台基于 UEFI 的计算机，其固件具有 BIOS 兼容功能，并且你打算一直使用这项兼容功能，在启动过程中，你的计算机看起来就是基于 BIOS 的。你只需要像 BIOS 启动一样进行所需操作即可。如果你确实有此打算，那么就不要中途变卦。对于你日常使用的操作系统，强烈建议不要混合使用原生 UEFI 启动和 BIOS 兼容启动，尤其不要在同一块磁盘上混用。这么做的话，你会痛不欲生。如果你决定混合使用原生 UEFI 启动和 BIOS 兼容启动，到时候就别找我哭诉。

为了理清头绪，我将假设磁盘采用 [GPT](https://en.wikipedia.org/wiki/GUID_Partition_Table)，并且包含用于 EFI 的 FAT32 [EFI 系统分区](https://en.wikipedia.org/wiki/EFI_System_partition) (ESP)。根据你对这些知识的深入程度，你可能发现，在进行原生 UEFI 启动时，GPT 磁盘和 EFI FAT32 ESP 并不是必要条件。但是 UEFI 规范和 GPT 磁盘以及 EFI FAT32 ESP 的联系程度相当密切。在99%的情况下，你要处理的也正是这样的组合。除非你在使用 Mac（老实说，Mac 混乱不堪）。