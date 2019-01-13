## Nginx安装指南

在 web 服务中，经常需要用到 nginx ，整理一下几种常用的 nginx 安装方案。

### 脚本一键安装

脚本安装，方便快捷，暂时仅支持 debian 和 redhat系列。同时支持二进制和源代码编译方式安装，执行本目录中的 [nginx_autoinstall.sh](./nginx-autoinstall.sh) 脚本即可完成安装。


### Linux 下手动编译安装

安装环境

- GNU/Linux 64位
- 安装路径 /usr/local/nginx/



1. 安装依赖环境 

   redhat 和 centos 系
   ```shell
   $ yum -y install pcre openssl opssl-devel  # pcre支持url重写，openssl是https协议用到的库
   ```
   debian 和 Ubuntu 系

   ```shell
   $ sudo apt-get install libpcre3 libpcre3-dev
   $ sudo apt-get install openssl libssl-dev libperl-dev
   $ sudo apt-get install -y zlib1g zlib1g-dev
   ```


2. 下载源码到/tmp目录下， 并创建相关用户。

   ```shell
   $ cd /tmp
   $ useradd nginx -s /sbin/nologin -M
   $ wget http://nginx.org/download/nginx-1.15.6.tar.gz  
   $ tar -zxvf nginx-1.15.6.tar.gz  
   $ cd  nginx-1.15.6
   ```


3. 编译并安装

   ```shell
   $ ./configure --user=nginx --group=nginx  --prefix=/usr/local/nginx/ --with-http_stub_status_module  --with-http_ssl_module
   $ make && make install 
   ```

4. 设置开机自启，添加本目录下的 [nginx_service.sh](./nginx-service.sh)到 /etc/init.d/nginx 文件中。

   ```shell
   $ wget -O /etc/init.d/nginx https://raw.githubusercontent.com/fengzhao/fengzhao-notes/master/nginx/nginx-service.sh
   ```

5. 给可执行命令创建一个软连接到可执行目录下。

   ```shell
   $ ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
   ```

6. 添加执行权限，配置成系统服务。

   ```shell
   $ chmod a+x /etc/init.d/nginx
   $ chkconfig --add /etc/init.d/nginx
   $ chkconfig nginx on
   ```












