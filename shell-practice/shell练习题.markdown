

编写一个脚本 createuser.sh

**要求：**

1）脚本的执行语法必须是:createuser.sh -u username -m password，选项与参数间可支持多空格，但不能顺序颠倒。

2）当未指定正确的选项或参数时，以错误输出方式提示“createuser.sh -u username -m password ”后退出脚本。

3）用户名必须以字母开头，可包括数字和_。否则不合法。以错误输出提示用户"用户名仅包含字母数据和下划线"

4）当用户名检测合法后，判断用户名是否已存在，若存在，再判断用户是否已设置过密码，若设置过密码，直接退出，未设置，则将密码设置为所指定的密码后以正确输出方式显示“username 密码已更新后退出”

5）当用户名不存在，则创建用户，并为该用户设置所指定的密码后以正确输出方式显示“用户username已创建并更新密码”

6）要求脚本执行过程中不能有非要求的其他输出结果出现。脚本在非正确方式退出时应反回给?参数非0值。









```shell
### 检查目录是否存在
if [ -d "$DIRECTORY" ]; then
  # 如果目录存在，就执行这个条件
fi

if [ ! -d "$DIRECTORY" ]; then
  # 如果目录不存在，就执行这个条件
fi








### 检查是否存在某个文件，是否存在可执行的二进制文件
if  [ ! -e '/usr/bin/wget' ]; then
    echo "Error: wget command not found. You must be install wget command at first."
    exit 1
fi



### 获取当前远程连接到服务器上的用户的IP地址

[root@localhost ~]# who am i
root     pts/1        2019-04-30 15:19 (192.168.2.126)
[root@localhost ~]#
[root@localhost ~]# who am i | awk '{print $NF}' | sed -e 's/[()]//g'
192.168.2.126
[root@localhost ~]#






### 安装 virt-what ，使用 virt-what 检测当前操作系统使用的虚拟化技术

if  [ ! -e '/usr/sbin/virt-what' ]; then
    echo "Installing Virt-What......"
    if [ "${release}" == "centos" ]; then
        yum -y install virt-what > /dev/null 2>&1
    else
        apt-get update > /dev/null 2>&1
        apt-get -y install virt-what > /dev/null 2>&1
    fi
fi
```









