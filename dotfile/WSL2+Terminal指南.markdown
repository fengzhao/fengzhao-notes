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



### Windows Terminal 配置文件

Windows Terminal 配置文件主要分为：

- globals
- profiles
- schemes



#### 全局配置文件

| 名称                          | 类型    | 说明                                                         |
| ----------------------------- | ------- | ------------------------------------------------------------ |
| `defaultProfile`              | string  | 默认使用的命令行配置的 GUID。                                |
| `initialRows`                 | number  | 命令行窗口的宽度，以字符为单位。                             |
| `initialCols`                 | number  | 命令行窗口的高度，以字符为单位。                             |
| `alwaysShowTabs`              | boolean | 在只有一个命令行窗口时，是否显示选项卡。                     |
| `showTerminalTitleInTitlebar` | boolean | 是否在窗口标题栏显示命令行程序的路径，设为`false`则固定显示 “Windows Terminal”。 |
| `showTabsInTitlebar`          | boolean | 是否将选项卡显示在窗口标题栏的位置，设为`true`会无视`alwaysShowTabs`的设定，在标题栏显示选项卡。 |
| `requestedTheme`              | string  | Windows Terminal 窗口的颜色主题，`light`和`dark`分别对应浅色和深色主题，`system`是与系统设置相同。 |

#### 命令行配置

| 名称                         | 类型    | 说明                                                         |
| ---------------------------- | ------- | ------------------------------------------------------------ |
| `startingDirectory`          | string  | 初始时的当前目录。                                           |
| `guid`                       | string  | 命令行配置的 GUID，格式形如`{c1491760-c502-57a1-b9bf-696a5f735a34}`。 |
| `name`                       | string  | 命令行配置的名称，显示在“添加窗口”按钮中。                   |
| `icon`                       | string  | 命令行配置的图标路径，显示在选项卡和“添加窗口”按钮中。**路径中的斜杠`\`要转义写成`\\`。** |
| `background`                 | string  | 窗口背景的颜色，格式为`#RRGGBB`。**会覆盖主题配色的背景色。** |
| `colorscheme`                | string  | 使用的主题配色的名称。                                       |
| `historySize`                | number  | 保存命令记录的数量。输入命令时按↑或↓就可以使用历史记录中的命令。 |
| `snapOnInput`                | boolean | ？？？                                                       |
| `cursorColor`                | string  | 光标的颜色。                                                 |
| `cursorShape`                | string  | 光标的形状，可以设定的值为`emptyBox`、`filledBox`、`bar`、`vintage`、`underscore`。显示效果参见下图。 |
| `commandline`                | string  | 新建命令行选项卡时运行的命令。                               |
| `fontFace`                   | string  | 窗口使用的字体，支持 TTF 和 OTF 格式。                       |
| `fontSize`                   | number  | 窗口使用的字体大小。                                         |
| `useAcrylic`                 | boolean | 是否使用亚克力背景。                                         |
| `acrylicOpacity`             | number  | 一个`0`到`1`的小数，设定亚克力背景的透明度。                 |
| `backgroundImage`            | string  | 设定使用的背景图片的路径，**背景图片不能和亚克力同时使用**。 |
| `backgroundImageOpacity`     | number  | 一个`0`到`1`的小数，设定背景图片的透明度。（不过图片下面的背景色固定为白色……也就是说这个参数只能用来将背景图片变量而不是变暗） |
| `backgroundImageStretchMode` | string  | 背景图片的拉伸方式，可以设定的值为`fill`、`uniform`、`uniformToFill`、`none`。 |
| `closeOnExit`                | boolean | 使用`exit`等命令退出命令行程序后，是否关闭命令行选项卡。     |
| `padding`                    | string  | 按照`10, 20, 30, 40`的格式输入四个数值，设定命令行窗口的左上右下四个方向的边距，单位为像素。 |





### Windows Terminal 快捷键

|             |       |
| ----------- | ----- |
| 新开一个tab | ctr+t |
| 关闭 tab    | ctr+w |
| 下一个tab   |       |
| 上一个tab   |       |
|             |       |



```json


{ "command": "splitHorizontal", "keys": [ "alt+shift+-" ] },
{ "command": "splitVertical", "keys": [ "alt+shift+plus" ] },
{ "command": { "action": "moveFocus", "direction":"down" }, "keys": [ "alt+down" ] },
{ "command": { "action": "moveFocus", "direction":"left" }, "keys": [ "alt+left" ] },
{ "command": { "action": "moveFocus", "direction":"right" }, "keys": [ "alt+right" ] },
{ "command": { "action": "moveFocus", "direction":"up" }, "keys": [ "alt+up" ] },
{ "command": { "action": "resizePane", "direction":"down" }, "keys": [ "alt+shift+down" ] },
{ "command": { "action": "resizePane", "direction":"left" }, "keys": [ "alt+shift+left" ] },
{ "command": { "action": "resizePane", "direction":"right" }, "keys": [ "alt+shift+right" ] },
{ "command": { "action": "resizePane", "direction":"up" }, "keys": [ "alt+shift+up" ] },
```

​      







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