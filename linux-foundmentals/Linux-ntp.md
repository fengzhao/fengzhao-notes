# Linux时间

 在Linux计算机上，有两个时间，一个是硬件时间（BIOS中记录的时间，称为hwclock），另一个是操作系统时间（osclock）。

硬件时钟由BIOS电池供电，当计算机关机后，会继续运行，BIOS电池一般可使用几年，如果没电了，那BIOS中的数据会恢复出厂设置。

硬件时钟



操作系统时间

osclock的时区配置文件为/etc/timezone，如果你想修改系统时区，那最好使用sudo dpkg-reconfigure tzdata来修改时区，不建议直接修改/etc/timezone文件，

如果你想修改为UTC时间，那执行 sudo dpkg-reconfigure tzdata 命令时，选择 None of the above->UTC  即可

```shell
# 查看所有时区
sudo timedatectl list-timezones
# 设置为中国上海
sudo timedatectl set-timezone Asia/Shanghai
```





# chrony时间同步



RHEL/CentOS 6.x 下的时间同步基本是使用 ntpdate 和 ntpd  这两个工具实现的，但是这两个工具已经很古老了。

RHEL/CentOS 7.x 已经将 chrony 作为默认时间同步工具了（其他 systemd 系统下无需安装 ntp/chrony，使用 systemd-timesyncd 服务即可）。







Ubuntu 内置了时间同步，默认情况下使用systemd的timesyncd服务激活。

查找服务器上date最基本命令是date 。 任何用户都可以输入此命令来打印日期和时间：



```shell
# 查看系统当前时间，以 RFC 5322 格式查看
sudo date -R
Wed, 19 May 2021 01:46:02 +0000

sudo timedatectl list-timezones
sudo timedatectl set-timezone Asia/Shanghai
```







# timesyncd时间同步

Ubuntu 的默认安装现在使用 timesyncd 而不是 ntpd。（**ubuntu时间同步客户端配置systemd-timesyncd（20.04、18.04下配置通过）**）

timesyncd 连接到相同的时间服务器，并以大致相同的方式工作，但更轻量级，更集成 systemd 和 Ubuntu 的低级别工作。

我们可以通过运行没有参数的timedatectl来查询timesyncd的状态。

这将打印出本地时间，通用时间（如果您没有从UTC时区切换，可能与本地时间相同），以及一些网络时间状态信息。 

System clock synchronized: yes 表示时间已成功同步。

Systemd-timesyncd.service active: yes表示 timesyncd 已启用并正在运行。


```shell
# 查看systemd-timesyncd服务状态，可以看到是跟ntp.ubuntu.com同步时间
systemctl status systemd-timesyncd.service

Status: "Synchronized to time server 91.189.89.198:123 (ntp.ubuntu.com)."

# /etc/systemd/timesyncd.conf


# /etc/systemd/timesyncd.conf
# /etc/systemd/timesyncd.conf.d/*.conf
# /run/systemd/timesyncd.conf.d/*.conf
# /usr/lib/systemd/timesyncd.conf.d/*.conf

# 这些配置文件控制着NTP网络时间同步



```
