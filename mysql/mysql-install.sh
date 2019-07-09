#!/bin/bash
# -------------------------------------------------------------------------------
# Revision:    1.1
# Date:        2019/05/13
# Author:      fengzhao
# Email:       fengzhaowork@outlook.com
# Description: 在Centos中安装 mysql5.6.44
# Notes:       
# -------------------------------------------------------------------------------
log=/script/mv_db_log.txt

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/opt/bin:/opt/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
fi

# Check the network status
NET_NUM=`ping -c 4 www.baidu.com |awk '/packet loss/{print $6}' |sed -e 's/%//'`
if [ -z "$NET_NUM" ] || [ $NET_NUM -ne 0 ];then
        echo "Please check your internet"
        exit 1
fi

#set mysql root password
echo "==========================="
mysqlrootpwd="admin@123456"
echo "Please input the root password of mysql:"
read -p "(Default password: admin@123456):" mysqlrootpwd
if [ "$mysqlrootpwd" = "" ]; then
	mysqlrootpwd="admin@123456"
fi
echo "==========================="
echo "MySQL root password:$mysqlrootpwd"
echo "==========================="

#which MySQL Version do you want to install?
echo "==========================="
	isinstallmysql56="n"
	echo "Install MySQL 5.6.44,Please input y"
	echo "Don't install MySQL,Please input n or press Enter"
	read -p "(Please input y or n):" isinstallmysql56

	case "$isinstallmysql56" in
	y|Y|Yes|YES|yes|yES|yEs|YeS|yeS)
	echo "You will install MySQL 5.6.44"
	isinstallmysql56="y"
	;;
	n|N|No|NO|no|nO)
	echo "You will exit install MySQL"
	isinstallmysql56="n"
	;;
	*)
	echo "INPUT error,You will exit install MySQL"
	isinstallmysql56="n"
	esac

function InitInstall()
{
	#Set timezone
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

	yum install -y ntpdate
	ntpdate -u pool.ntp.org
	date -R

	rpm -qa|grep mysql
	rpm -e mysql

	yum -y remove mysql-server mysql mysql-libs
	yum -y remove php-mysql
	yum -y install yum-fastestmirror
	yum -y install perl-Data-Dumper.x86_64
}

function CheckAndDownloadFiles()
{
echo "============================check files=================================="
if [ -s mysql-5.6.44-linux-glibc2.12-x86_64.tar.gz ];then
	echo "mysql-5.6.44-linux-glibc2.12-x86_64.tar.gz [found]"
else
	wget -c https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.44-linux-glibc2.12-x86_64.tar.gz
fi
echo "============================check files=================================="
}

function InstallMySQL56()
{
echo "============================Install MySQL 5.6.44=================================="
user_mysql=`cat /etc/passwd|grep mysql|awk -F : '{print $1}'`
if [ -s /etc/my.cnf ]; then
	rm -f /etc/my.cnf
fi

if [ -z "$user_mysql" ];then
	groupadd mysql
	useradd -s /sbin/nologin -M -g mysql mysql
else
	echo "user mysql already exists!"
fi

mkdir -p /data/mysql
mkdir -p /var/log/mysql


tar zxf mysql-5.6.44-linux-glibc2.12-x86_64.tar.gz
mv mysql-5.6.44-linux-glibc2.12-x86_64 /usr/local/mysql
chown -R mysql:mysql /data/mysql
chown -R mysql:mysql /usr/local/mysql

cat >>/etc/my.cnf<<EOF
[client]
port= 3306
socket= /data/mysql/mysql.sock
default-character-set=utf8

[mysql]
default-character-set=utf8

[mysqld]
port= 3306
socket= /data/mysql/mysql.sock
basedir= /usr/local/mysql
datadir= /data/mysql
open_files_limit    = 3072
back_log = 103
max_connections = 800
max_connect_errors = 100000
table_open_cache = 512
external-locking = FALSE
max_allowed_packet = 32M
sort_buffer_size = 2M
join_buffer_size = 2M
thread_cache_size = 51
query_cache_size = 32M
tmp_table_size = 96M
max_heap_table_size = 96M
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
log-error = /var/log/mysql/error.log
long_query_time = 1
server-id = 1
log-bin = mysql-bin
sync_binlog = 1
binlog_cache_size = 4M
max_binlog_cache_size = 4096M
max_binlog_size = 1024M
expire_logs_days = 60
key_buffer_size = 32M
read_buffer_size = 1M
read_rnd_buffer_size = 16M
bulk_insert_buffer_size = 64M
character-set-server=utf8
default-storage-engine = InnoDB
binlog_format = row
innodb_buffer_pool_dump_at_shutdown = 1
innodb_buffer_pool_load_at_startup = 1
binlog_rows_query_log_events = 1
explicit_defaults_for_timestamp = 1
#log_slave_updates=1
#gtid_mode=on
#enforce_gtid_consistency=1
#innodb_write_io_threads = 8
#innodb_read_io_threads = 8
#innodb_thread_concurrency = 0
transaction_isolation = REPEATABLE-READ
innodb_additional_mem_pool_size = 16M
innodb_buffer_pool_size = 512M
#innodb_data_home_dir =
innodb_data_file_path = ibdata1:1024M:autoextend
innodb_flush_log_at_trx_commit = 1
innodb_log_buffer_size = 16M
innodb_log_file_size = 512M
innodb_log_files_in_group = 2
innodb_max_dirty_pages_pct = 50
innodb_file_per_table = 1
innodb_locks_unsafe_for_binlog = 0
wait_timeout = 14400
interactive_timeout = 14400
skip-name-resolve

[mysqldump]
quick
max_allowed_packet = 32M
EOF

/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data/mysql --defaults-file=/etc/my.cnf --user=mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
sed -i "s:^datadir=.*:datadir=/data/mysql/mysql:g" /etc/init.d/mysqld
cat >> /etc/ld.so.conf.d/mysql.conf<<EOF
/usr/local/mysql/lib
EOF
/etc/init.d/mysqld start

/usr/local/mysql/bin/mysqladmin -u root password $mysqlrootpwd

cat > /tmp/mysql_sec_script<<EOF
use mysql;
update user set password=password('$mysqlrootpwd') where user='root';
select Host,User,Password,Select_priv,Grant_priv from user;
delete from mysql.user where not (user='root') ;
delete from mysql.user where user='';
delete from user where user='';
delete from user where password='';
delete from user where host='';
drop database test;
delete from db;
flush privileges;
EOF

/usr/local/mysql/bin/mysql -u root -p$mysqlrootpwd -h localhost < /tmp/mysql_sec_script

rm -f /tmp/mysql_sec_script

/etc/init.d/mysqld restart
echo "export PATH=$PATH:/usr/local/mysql/bin">>/etc/profile
source /etc/profile
echo "============================MySQL 5.6.44 install completed========================="
}

function CheckInstall()
{
echo "===================================== Check install ==================================="
clear
ismysql=""
echo "Checking..."
if [ -s /usr/local/mysql/bin/mysql ] && [ -s /usr/local/mysql/bin/mysqld_safe ] && [ -s /etc/my.cnf ];then
	  echo "MySQL: OK"
	  ismysql="ok"
else
	  echo "Error: /usr/local/mysql not found!!!MySQL install failed."
fi

if [ "$ismysql" = "ok" ];then
	echo "Install MySQL 5.6.44 completed! enjoy it."
	echo "========================================================================="
	netstat -ntl
else
	echo "Sorry,Failed to install MySQL!"
	echo "You can tail /root/mysql-install.log from your server."
fi
}

#The installation log
InitInstall 2>&1 | tee /root/mysql-install.log
CheckAndDownloadFiles 2>&1 | tee -a /root/mysql-install.log
InstallMySQL56 2>&1 | tee -a /root/mysql-install.log
CheckInstall 2>&1 | tee -a /root/mysql-install.log
