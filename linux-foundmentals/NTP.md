

# chrony时间同步



RHEL/CentOS 6.x 下的时间同步基本是使用 ntpdate 和 ntpd  这两个工具实现的，但是这两个工具已经很古老了。

RHEL/CentOS 7.x 已经将 chrony 作为默认时间同步工具了（其他 systemd 系统下无需安装 ntp/chrony，使用 systemd-timesyncd 服务即可）。







Ubuntu 内置了时间同步，默认情况下使用systemd的timesyncd服务激活。

查找服务器上date最基本命令是date 。 任何用户都可以输入此命令来打印日期和时间：