# 安装





## 机器准备

| hostname   | ip地址        | 系统版本   | cpu  | 内存 |
| ---------- | ------------- | ---------- | ---- | ---- |
| k8s-master | 192.168.88.35 | centos 7.9 | 4核  | 8G   |
| k8s-node   | 192.168.88.37 | centos 7.9 | 4核  | 8G   |



## 初始化



```shell
# 设置主机名
hostnamectl set-hostname k8s-master
hostnamectl set-hostname k8s-node

# 设置hosts解析
cat >> /etc/hosts << EOF
192.168.88.35 k8s-master
192.168.88.37 k8s-node
EOF

# 关闭防火墙
systemctl stop firewalld
systemctl disable firwalld

# 关闭selinux
setenforce 0 
sed -i 's/enforcing/disabled/' /etc/selinux/config

# 关闭swap交换分区
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab


```





## docker

> **`自 1.24.x版起，Docker不能再作为Kubernetes的容器运行时了，但因安装Docker会默认安装Containerd且个人觉得Docker用的顺手，所以这里还是安装Docker，也可以直接安装Containerd节省资源`**
>
> Kubernates 中 pod 的运行必须有容器运行环境，以前 kubernetes 是使用 Docker，后面主要使用 containerd 等，目前支持的运行时可以参考 [container-runtimes](https://link.juejin.cn/?target=https%3A%2F%2Fkubernetes.io%2Fdocs%2Fsetup%2Fproduction-environment%2Fcontainer-runtimes%2F)
>
> 本文使用 containerd，前面我们也讲过 Docker 也是基于 containerd 的，那么我们直接使用 Docker 的安装源，只安装 containerd 就行



```shell
# 直接执行安装
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

