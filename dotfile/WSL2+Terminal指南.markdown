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



