#!/usr/bin/env bash
# CentOS Linux release 7.5.1804 系统初始化脚本，需要以 root 进行
# powered by fengzhao
# TODO
# 设置国内yum源
# 批量创建用户
# 检查ip是不是有效
# 重启系统？
# 测试软件是不是安装完成了
# 设置swap的时候GM大写
# 修改ssh端口
# 定时重启
# 晚上定时kill ssh
# ssh 端口 只允许特定ip
# 显示系统信息
# 设置dns

Green_font="\033[32m"
Red_font="\033[31m" 
Font_suffix="\033[0m"


add_user()
{
    echo -e  "${Green_font} Starting add user ${Font_suffix}"
    read -p "Username:" username
    i=`cat /etc/passwd | cut -f1 -d':' | grep -w -c "$username" `
    if [ $i -le 0 ]; then
        read -p "Password:" password
        useradd $username
        echo $password | passwd --stdin $username
        echo -e "${Green_font}user created !!!${Font_suffix}"         
    else
	#显示用户存在
		echo "${Red_font} User $1 is in then passwd ${Font_suffix}"
		return 1
	fi

}

install_software()
{
    echo -e  "${Green_font} starting install software ... ${Font_suffix}"
    yum install epel-release -y
    yum update -y
    yum -y install git wget tmux  nmap vim htop iftop iotop gcc gcc-c++ net-tools unzip nfs-utils psmisc zip rsync  
    echo -e  "${Green_font} software installed !!! ${Font_suffix}"
}

install_python()
{
    echo -e  "${Green_font} starting install python ... ${Font_suffix}"
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
    echo "export PATH=\"/root/.pyenv/bin:\$PATH\"">>/etc/profile
    echo "eval \"\$(pyenv init -)\"">>/etc/profile
    echo "eval \"\$(pyenv virtualenv-init -)\"">>/etc/profile
    source /etc/profile
    echo -e  "${Green_font} python installed  !!! ${Font_suffix}"
}

set_static_ip()
{
    # 检查/etc/sysconfig/network-scripts/ifcfg-enp0s3存不存在
    # 检查如果有静态ip那么提示静态ip已经设置完成
    echo "starting setting static ip ..."
    filename="/etc/sysconfig/network-scripts/ifcfg-enp0s3"
    if [ -f $filename ]
    then
        read -p "Please enter the static ip you want to set: " ip
        read -p "Please enter the gateway you want to set: " gateway
        read -p "Please enter the netmask ip you want to set: " netmask
        read -p "Please enter the dns ip you want to set: " dns1
        echo "文件存在"
        echo -e "IPADDR=\"$ip\"">>$filename
        echo -e "GATEWAY=\"$gateway\"">>$filename
        echo -e "NETMASK=\"$netmask\"">>$filename
        echo -e "DNS1=\"$dns1\"">>$filename
        sed -i 's/BOOTPROTO="dhcp"/BOOTPROTO="static"/g' $filename
    else
        read -p "thereis no ifcfg-enp0s3 file so please input your filename( in /etc/sysconfig/network-scripts/ like ifcfg-en*):" filename
        read -p "Please enter the static ip you want to set: " ip
        read -p "Please enter the gateway you want to set: " gateway
        read -p "Please enter the netmask ip you want to set: " netmask
        read -p "Please enter the dns ip you want to set: " dns1
        echo -e "IPADDR=\"$ip\"">>$filename
        echo -e "GATEWAY=\"$gateway\"">>$filename
        echo -e "NETMASK=\"$netmask\"">>$filename
        echo -e "DNS1=\"$dns1\"">>$filename
        sed -i 's/BOOTPROTO="dhcp"/BOOTPROTO="static"/g' $filename
    fi
    echo -e  "${Green_font} static ip set !!! ${Font_suffix}"
}

close_firewalld()
{
    echo "starting stop firewalld ..."
    systemctl stop firewalld
    systemctl disable firewalld
    echo "firewalld stoped !!!"
}

set_hostname()
{
    echo "start set your hostname ..."
    read -p "please input your hostname: " hostname
    hostnamectl set-hostname $hostname
    echo "your hostname is set to" $hostname
}

close_selinux()
{
    echo "starting close selinux ..."
    setenforce 0
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    echo "selinux closed !!!"
}

install_docker()
{
    echo "installing docker ..."
    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    echo "docker installed !!!!!!!!!!!"
    systemctl start docker && systemctl enable docker
    echo "installing docker-compose ......"
    wget https://github.com/docker/compose/releases/download/1.23.2/docker-compose-Linux-x86_64
    mv docker-compose-Linux-x86_64 /usr/bin/docker-compose
    chmod +x /usr/bin/docker-compose
    echo "docker-compose installed !!!"
}

change_swap()
{
    echo "starting change swap ..."
    read -p "please input your swapfile size:" size
    dd if=/dev/zero of=/usr/local/swapfile  bs=$size count=1
    mkswap /usr/local/swapfile
    swapon /usr/local/swapfile
    echo "/usr/local/swapfile     swap                    swap    defaults        0 0" >> /etc/fstab
    echo "swap changed !!!"
}

#kernel_optimization()

install_ohmyzsh()
{
    echo "starting install oh-my-zsh ..."
    yum install zsh -y
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "oh-my-zsh installed !!!"
}

print_systeminfo()
{
    echo "**********************************"
    echo "Powered by fengzhao"
    echo "Email: fengzhao1124@gmail.com"
    echo "Hostname:" `hostname`
    # virtualization
    cat /proc/cpuinfo |grep vmx >> /dev/null
    if [ $? == 0 ]
    then
        echo "Supporting virtualization"
    else
        echo "Virtualization is not supported"
    fi
    echo "Cpu model:" `cat /proc/cpuinfo |grep "model name" | awk '{ print $4" "$5""$6" "$7 ; exit }'`
    echo "Memory:" `free -m |grep Mem | awk '{ print $2 }'` "M"
    echo "Swap: " `free -m |grep Swap | awk '{ print $2 }'` "M"
    echo "Kernel version: " `cat /etc/redhat-release`
    echo "**********************************"
}

help()
{
    echo "1) install_software    5) set_hostname	     9) install_ohmyzsh"
    echo "2) install_python      6) close_selinux	    10) add_user"
    echo "3) set_static_ip       7) install_docker    11) exit:"
    echo "4) close_firewalld     8) change_swap"
}

main()
{
    print_systeminfo
    centos_funcs="install_software install_python set_static_ip close_firewalld 
                set_hostname close_selinux install_docker change_swap install_ohmyzsh add_user exit help"
    select centos_func in $centos_funcs:
    do 
        case $REPLY in
        1) install_software
        ;;
        2) install_python
        ;;
        3) set_static_ip
        ;;
        4) close_firewalld
        ;;
        5) set_hostname
        ;;
        6) close_selinux
        ;;
        7) install_docker
        ;;
        8) change_swap
        ;;
        9) install_ohmyzsh
        ;;
        10) add_user
        ;;
        11) exit
        ;;
        12) help
        ;;
        *) echo "please select a true num"
        ;;
        esac
    done
}

main
