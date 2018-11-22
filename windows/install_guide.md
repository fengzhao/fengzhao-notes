# Windows安装指南



## 1、indows操作系统镜像下载


微软官网下载，官网始终是最新版的操作系统，官网下载地址：

https://www.microsoft.com/zh-cn/software-download/windows10ISO


刻录工具下载

https://rufus.ie/en_IE.html

https://unetbootin.github.io/


 1、用谷歌浏览器打开上述地址，打开 F12 调试工具，在最右边的三个点处选择 more tools ，选择 network conditions ，修改 UA 为 chrome——mac。F5 刷新浏览器，下载最新镜像。

2、用 rufus 刻录工具把 windows 镜像刻录到 U 盘 （16GB以上，需要格式化）

3、开机进 bios 选择 U 盘启动开始安装。

4、激活,一般网上找个 kms server 就可以用 kms 方式激活了(使用管理员身份运行 cmd )。

        slmgr.vbs -ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
        slmgr.vbs -skms kms.serveryoufind
        slmgr.vbs -ato

5、密钥相关

https://docs.microsoft.com/zh-cn/windows-server/get-started/kmsclientkeys

https://docs.microsoft.com/zh-cn/DeployOffice/vlactivation/gvlks

https://docs.microsoft.com/zh-cn/previous-versions/office/




## 2、装机必备




















