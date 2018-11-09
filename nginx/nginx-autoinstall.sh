#!/bin/bash
############### CentOS一键安装Nginx脚本 ###############
#Author:fengzhao.me
#Update:2018-11-09
####################### END #######################

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/sbin
export PATH

dir='/usr/local/'

#对系统进行判断
function check_os(){
	#CentOS
	if test -e "/etc/redhat-release"
		then
		yum -y install gcc gcc-c++ perl unzip  zlib  openssl opssl-devel
	#Debian
	elif test -e "/etc/debian_version"
		then
		apt-get -y install perl unzip
		apt-get -y install build-essential
	else
		echo "当前系统不支持！"
	fi
}
#获取服务器公网IP
function get_ip(){
	osip=$(curl https://ip.awk.sh/api.php?data=ip)
	echo $osip
}
#防火墙放行端口80和443
function chk_firewall(){
	if [ -e "/etc/sysconfig/iptables" ]
	then
		iptables -I INPUT -p tcp --dport 80 -j ACCEPT
		iptables -I INPUT -p tcp --dport 443 -j ACCEPT
		service iptables save
		service iptables restart
	else
		firewall-cmd --zone=public --add-port=80/tcp --permanent 
		firewall-cmd --zone=public --add-port=443/tcp --permanent 
		firewall-cmd --reload
	fi
}
#防火墙删除端口
function DelPort(){
	if [ -e "/etc/sysconfig/iptables" ]
	then
		sed -i '/^.*80/d' /etc/sysconfig/iptables
		sed -i '/^.*443/d' /etc/sysconfig/iptables
		service iptables save
		service iptables restart
	else
		firewall-cmd --zone=public --remove-port=80/tcp --permanent
		firewall-cmd --zone=public --remove-port=443/tcp --permanent
		firewall-cmd --reload
	fi
}



#编译安装Nginx
function CompileInstall(){
	#创建用户和用户组
	groupadd nginx
	useradd -M -g nginx nginx -s /sbin/nologin
	
	#安装Nginx
	cd /usr/local
	wget http://nginx.org/download/nginx-1.15.6.tar.gz  
	tar -zxvf nginx-1.15.6.tar.gz  
	cd nginx-1.15.6
	./configure --prefix=/usr/local/nginx --user=nginx --group=nginx \
	--with-stream \
	--with-http_stub_status_module \
	--with-http_v2_module \
	--with-http_ssl_module \
	--with-http_gzip_static_module \
	--with-http_realip_module \
	make -j4 && make -j4 install

	#一点点清理工作
	rm -rf ${dir}nginx-1.15.6*


	#复制配置文件

	mkdir -p /usr/local/nginx/conf/vhost
	/usr/local/nginx/sbin/nginx

	#环境变量与服务
	echo "export PATH=$PATH:/usr/local/nginx/sbin" >> /etc/profile
	export PATH=$PATH:'/usr/local/nginx/sbin'

	#开机自启
	echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.d/rc.local

	echo "Nginx installed successfully. Please visit the http://${osip}"
}

#二进制安装Nginx
function BinaryInstall(){
	#创建用户和用户组
	groupadd www
	useradd -M -g www www -s /sbin/nologin

	#下载到指定目录
	wget http://soft.xiaoz.org/nginx/nginx-binary-1.14.0.tar.gz -P /usr/local

	#解压
	cd /usr/local && tar -zxvf nginx-binary-1.14.0.tar.gz

	#环境变量
	echo "export PATH=$PATH:/usr/local/nginx/sbin" >> /etc/profile
	export PATH=$PATH:'/usr/local/nginx/sbin'

	#启动
	/usr/local/nginx/sbin/nginx
	#开机自启
	echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.d/rc.local

	echo "------------------------------------------------"
	echo "Nginx installed successfully. Please visit the http://${osip}"
}

#卸载Nginx
function uninstall(){
	# 杀掉nginx进程
	pkill nginx
	#删除www用户
	userdel www && groupdel www 
	#备份一下配置
	cp -a /usr/local/nginx/conf/vhost /home/vhost_bak
	#删除目录
	rm -rf /usr/local/nginx
	sed -i "s%:/usr/local/nginx/sbin%%g" /etc/profile
	#删除自启
    sed -i '/^.*nginx/d' /etc/rc.d/rc.local
}

#选择安装方式
echo "------------------------------------------------"
echo "欢迎使用Nginx一键安装脚本^_^，请先选择安装方式："
echo "1) 编译安装，支持CentOS 6/7"
echo "2) 二进制安装，支持CentOS 7"
echo "3) 卸载Nginx"
echo "q) 退出！"
read -p ":" istype

case $istype in
    1) 
    	check_os
    	get_ip
    	chk_firewall
    	#安装依赖
    	depend
    	#安装nginx
    	CompileInstall
    ;;
    2) 
    	check_os
    	get_ip
    	chk_firewall
    	BinaryInstall
    ;;
    3) 
    	#执行卸载函数
    	uninstall
    	#删除端口
    	DelPort
    	echo 'Uninstall complete.'
    ;;
    q) 
    	exit
    ;;
    *) echo '参数错误！'
esac