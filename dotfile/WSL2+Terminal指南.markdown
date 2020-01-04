### 条件

> WSL 2 仅适用于 Windows 10 版本18917或更高版本

- 方法：加入[Windows 预览体验计划](https://insider.windows.com/en-us/)，并选择 "快速" 环或 "慢速" 环。

- 可以通过打开命令提示符并运行 `ver` 命令来检查 Windows 版本。



### 启用WSL2

```powershell
# 以管理员身份运行 powershell，执行下列命令
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 设置安装的WSL为WSL2
wsl --set-default-version 2

```

### 安装 Ubuntu18.04

在应用商店搜索ubuntu，安装ubuntu18.04 

```shell
# 验证发行版使用的WSL版本
wsl --list --verbose

# 为root用户设置密码
sudo passwd

# 设置默认用户为root
ubuntu1804.exe config --default-user root
```



### 安装 Windows Terminal

在应用商店搜索 Windows Terminal，并安装。设置配置文件:  https://github.com/fengzhao/fengzhao-notes/blob/master/dotfile/WSL2-config-file.json



### WSL2访问Windows网络应用

- 通过运行命令 `cat /etc/resolv.conf` 并在 `nameserver`术语后面复制 IP 地址，来获取主机的 IP 地址。
- 使用复制的 IP 地址连接到任何 Windows server。



```shell
# 在 .bashrc 或 .zshrc 中添加下面的语句，使WSL共享WIN上的代理。
# WSL2使用的是虚拟机技术和WSL第一版本不一样，和宿主windows不在同一个网络内
# 获取宿主windows的ip
export windows_host=`ipconfig.exe | grep -n4 WSL  | tail -n 1 | awk -F":" '{ print $2 }'  | sed 's/^[ \r\n\t]*//;s/[ \r\n\t]*$//'`

# 假设宿主机windwos跑v2rayN，代理端口是1080
# 假设你的宿主windows代理端口是1080, 在终端输入命令 proxy 开启代理，通过 unproxy 关闭代理，
# curl 支持 http、https、socks4、socks5 . wget 支持 http、https

ALL_PROXY:强制终端中的 wget、curl 等都走 SOCKS5 代理
alias proxy='export http_proxy=socks5://$windows_host:1080; export https_proxy=socks5://$windows_host:1080; ALL_PROXY=socks5://$windows_host:1080'
alias unproxy='unset http_proxy; unset https_proxy'
# 强制终端中的 wget、curl 等都走 SOCKS5 代理
export ALL_PROXY=socks5://127.0.0.1:1080
# 设置git的代理
if [ "`git config --global --get proxy.https`" != "socks5://$windows_host:1080" ]; then
    git config --global proxy.https socks5://$windows_host:1080
fi

```



https://segmentfault.com/a/1190000019682322



https://www.goozp.com/article/105.html