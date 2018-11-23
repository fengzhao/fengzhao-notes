# Windows安装指南



## 1、windows操作系统镜像下载


微软官网下载，官网始终是最新版的操作系统，官网下载地址：

https://www.microsoft.com/zh-cn/software-download/windows10ISO


刻录工具下载

https://rufus.ie/en_IE.html

https://unetbootin.github.io/


 1、用谷歌浏览器打开上述地址，打开 F12 调试工具，在最右边的三个点处选择 more tools ，选择 network conditions ，修改 UA 为 chrome——mac。F5 刷新浏览器，下载最新镜像。

2、用 rufus 刻录工具把 windows 镜像刻录到 U 盘 （16GB以上，需要格式化）

3、开机进 bios 选择 U 盘启动开始安装。

4、激活，一般找个 kms server 就可以用 kms 方式激活了(使用管理员身份运行 cmd )。

        slmgr.vbs -ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
        slmgr.vbs -skms kms.serveryoufind
        slmgr.vbs -ato

5、密钥相关

https://docs.microsoft.com/zh-cn/windows-server/get-started/kmsclientkeys

https://docs.microsoft.com/zh-cn/DeployOffice/vlactivation/gvlks

https://docs.microsoft.com/zh-cn/previous-versions/office/




## 2、搭建内部的 KMS Server 服务器

KMS 是微软提供的批量激活功能，一般在一个局域网内，可以把其中某台机器搭建成 kms 服务器。这样局域网内的其他机器安装操作系统后，激活时，直接使用官网提供的批量激活密钥，设置 kms 服务器地址。然后就可以完成激活。这样每台客户端每 180 天都会与 kms 服务器通讯一次。这样一直保持激活状态，网上有大神写了搭建搭建 kms 的教程并开源，也有人在网上搭建好 kms 服务器，并免费提供 kms 服务，我们激活的时候，也可以直接使用别人的 kms 服务器激活，如果将来哪一天发现电脑变成未激活了，那就是连不上 kms 服务器了，再去网上找一个 kms 服务器即可。在一个组织内部，我们可以根据大神的脚本，搭建属于组织内部的 kms 服务器。提供给组织内部的人使用。



















