# sshfs简介



sshfs 是基于 ssh 中的 sftp 的一个工具，用于挂载远端的文件系统到本地.。只要可以用 ssh 方式访问远端。

那么就可以用 sshfs 这个工具把有权限的目录挂载到本地来。有点像远程挂载。





sshfs  的代码仓库地址：https://github.com/libfuse/sshfs

 在 linux 系统中，有一个虚拟文件系统的概念，虚拟文件系统作为一个统一的文件系统接口，各种不同的文件系统的驱动只要实现虚拟文件系统接口就可以了，而驱动一般都不会运行在用户空间。

而为了在用户空间也可以 export 一个虚拟文件系统接口，fuse 这个工具就被创造出来了。fuse 就是实现用户空间export 出一个虚拟文件系统的接口。

基于 fuse ， sshfs 这个工具才可以很好的工作， **mount 时候指定的 filesystem 类型就是fuse , 而一旦 mount 之后，用 df 看到的文件系统类型则是： fuse.sshfs**  。



#### sshfs的使用方法

强烈建议使用普通用户来运行 sshfs 挂载。

使用sshfs 命令进行挂载的格式就是:   **sshfs  -o  OPTION   LOGINID@HOST:/REMOTE_PATH     /LOCAL_PATH**

```shell
# 


sshfs -o rw,default_permissions,allow_other,uid=1000,gid=100,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3  

# 将远程主机192.168.0.105的/data 挂载到当前系统下的/data_tmp/ (一般先在当前系统下建一个空目录)
sshfs root@192.168.0.105: /mnt

test@192.168.0.114:/home/test/      /mnt

```

配置到 fstab 以方便开机就可以进行自动挂载，写法和 传统的文件系统略有不同，采用如下的语法格式：

