

## 阿里云k8s选型

https://www.cnblogs.com/leozhanggg/p/13522155.html

https://help.aliyun.com/document_detail/98886.html?spm=a2c4g.11186623.6.1078.323b1c9bpVKOry







## 三节点



**节点规划**

| 主机          | 配置                   | 主机名    | 部署组件 |      |      |
| ------------- | ---------------------- | --------- | -------- | ---- | ---- |
| 192.168.4.96  | CPU 2核 内存2G 硬盘60G | master-01 | etcd     |      |      |
| 192.168.4.100 | CPU 2核 内存2G 硬盘60G | node-01   | etcd     |      |      |
| 192.168.4.100 | CPU 2核 内存2G 硬盘60G | node-02   | etcd     |      |      |



## 准备安装包文件





```shell
# cfssl工具包，可以先下好
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64

chmod +x cfssl_linux-amd64 cfssljson_linux-amd64 cfssl-certinfo_linux-amd64
cp cfssl_linux-amd64 /usr/local/bin/cfssl
cp cfssljson_linux-amd64 /usr/local/bin/cfssljson
cp cfssl-certinfo_linux-amd64 /usr/bin/cfssl-certinfo

# etcd-3.4.9
wget https://github.com/etcd-io/etcd/releases/download/v3.4.9/etcd-v3.4.9-linux-amd64.tar.gz
```





## etcd集群部署



### 生成etcd证书

```shell
##  自签证书颁发机构（CA）

mkdir -p ~/TLS/{etcd,k8s}

cd ~/TLS/etcd

cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "www": {
         "expiry": "87600h",
         "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ]
      }
    }
  }
}
EOF



cat > ca-csr.json <<EOF
{
    "CN": "etcd CA",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "Beijing",
            "ST": "Beijing"
        }
    ]
}
EOF


# 签发CA证书
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
# 会在当前目录生成一下两个证书文件 ca-key.pem 和 ca.pem 

# etcd集群节点数量一般是奇数
# 生成etcd域名证书，没有域名使用IP代替这里部署etcd的三台服务器的IP

# 使用自签CA签发Etcd HTTPS证书
# 创建证书申请文件
cat > server-csr.json <<EOF
{
    "CN": "etcd",
    "hosts": [
    "192.168.4.96",
    "192.168.4.100",
    "192.168.4.101"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "BeiJing",
            "ST": "BeiJing"
        }
    ]
}
EOF


# 生成证书
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www server-csr.json | cfssljson -bare server

# ls server*pem
server-key.pem  server.pem


# 创建etcd配置文件
cat > /opt/etcd/cfg/etcd.conf << EOF
#[Member]
ETCD_NAME="etcd-1"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://192.168.4.96:2380"
ETCD_LISTEN_CLIENT_URLS="https://192.168.4.96:2379"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://192.168.4.96:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://192.168.4.96:2379"
ETCD_INITIAL_CLUSTER="etcd-1=https://192.168.4.96:2380,etcd-2=https://192.168.4.100:2380,etcd-3=https://192.168.4.101:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF

## 配置说明
ETCD_NAME：节点名称，集群中唯一
ETCD_DATA_DIR：数据目录
ETCD_LISTEN_PEER_URLS：集群通信监听地址
ETCD_LISTEN_CLIENT_URLS：客户端访问监听地址
ETCD_INITIAL_ADVERTISE_PEER_URLS：集群通告地址
ETCD_ADVERTISE_CLIENT_URLS：客户端通告地址
ETCD_INITIAL_CLUSTER：集群节点地址
ETCD_INITIAL_CLUSTER_TOKEN：集群Token
ETCD_INITIAL_CLUSTER_STATE：加入集群的当前状态，new是新集群，existing表示加入已有集群



# 准备etcd安装目录

mkdir -p  /opt/etcd/{bin,cfg,ssl}
mv etcd-v3.4.9-linux-amd64/{etcd,etcdctl} /opt/etcd/bin/


# 创建服务启动文件
cat > /usr/lib/systemd/system/etcd.service << EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
[Service]
Type=notify
EnvironmentFile=/opt/etcd/cfg/etcd.conf
ExecStart=/opt/etcd/bin/etcd \
--cert-file=/opt/etcd/ssl/server.pem \
--key-file=/opt/etcd/ssl/server-key.pem \
--peer-cert-file=/opt/etcd/ssl/server.pem \
--peer-key-file=/opt/etcd/ssl/server-key.pem \
--trusted-ca-file=/opt/etcd/ssl/ca.pem \
--peer-trusted-ca-file=/opt/etcd/ssl/ca.pem \
--logger=zap
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

# 拷贝证书到etcd配置路径
cp ~/TLS/etcd/ca*pem ~/TLS/etcd/server*pem /opt/etcd/ssl/


# 开机自启
systemctl daemon-reload
systemctl start etcd
systemctl enable etcd



# 分别

scp -r /opt/etcd/ root@192.168.4.100:/opt/
scp /usr/lib/systemd/system/etcd.service root@192.168.4.100:/usr/lib/systemd/system/

scp -r /opt/etcd/ root@192.168.4.101:/opt/
scp /usr/lib/systemd/system/etcd.service root@192.168.4.101:/usr/lib/systemd/system/




ETCDCTL_API=3 /opt/etcd/bin/etcdctl --cacert=/opt/etcd/ssl/ca.pem --cert=/opt/etcd/ssl/server.pem --key=/opt/etcd/ssl/server-key.pem --endpoints="https://192.168.4.96:2379,https://192.168.4.100:2379,https://192.168.4.101:2379" endpoint health

```





## 部署 Master Node



### 生成kube-apiserver证书

```shell
mkdir -p /root/TLS/k8s/
cd /root/TLS/k8s/

# 自签证书颁发机构（CA）
cat > ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "kubernetes": {
         "expiry": "87600h",
         "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ]
      }
    }
  }
}
EOF


cat > ca-csr.json << EOF
{
    "CN": "kubernetes",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "Beijing",
            "ST": "Beijing",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF

# 生成证书：
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -


# 使用自签CA签发kube-apiserver HTTPS证书

# 注：上述文件hosts字段中IP为所有Master/LB/VIP IP，一个都不能少！为了方便后期扩容可以多写几个预留的IP。
cat > server-csr.json << EOF
{
    "CN": "kubernetes",
    "hosts": [
      "10.0.0.1",
      "127.0.0.1",
      "192.168.4.96",
      "192.168.4.100",
      "192.168.4.101",
      "192.168.4.102",
      "192.168.4.103",
      "192.168.4.104",
      "192.168.4.105",
      "192.168.4.106",
      "192.168.4.107",
      "192.168.4.108",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "BeiJing",
            "ST": "BeiJing",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF


# 生成证书
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes server-csr.json | cfssljson -bare server


# 下载k8s二进制文件
https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.18.md

wget https://dl.k8s.io/v1.18.8/kubernetes-server-linux-amd64.tar.gz
https://storage.googleapis.com/kubernetes-release/release/v1.18.8/kubernetes-server-linux-amd64.tar.gz

# 准备k8s安装文件
mkdir -p /opt/kubernetes/{bin,cfg,ssl,logs} 










cat > /opt/kubernetes/cfg/kube-apiserver.conf << EOF
KUBE_APISERVER_OPTS="--logtostderr=false \\
--v=2 \\
--log-dir=/opt/kubernetes/logs \\
--etcd-servers=https://192.168.4.96:2379,https://192.168.4.100:2379,https://192.168.4.101:2379 \\
--bind-address=192.168.4.96 \\
--secure-port=6443 \\
--advertise-address=192.168.4.96 \\
--allow-privileged=true \\
--service-cluster-ip-range=10.0.0.0/24 \\
--enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction \\
--authorization-mode=RBAC,Node \\
--enable-bootstrap-token-auth=true \\
--token-auth-file=/opt/kubernetes/cfg/token.csv \\
--service-node-port-range=30000-32767 \\
--kubelet-client-certificate=/opt/kubernetes/ssl/server.pem \\
--kubelet-client-key=/opt/kubernetes/ssl/server-key.pem \\
--tls-cert-file=/opt/kubernetes/ssl/server.pem  \\
--tls-private-key-file=/opt/kubernetes/ssl/server-key.pem \\
--client-ca-file=/opt/kubernetes/ssl/ca.pem \\
--service-account-key-file=/opt/kubernetes/ssl/ca-key.pem \\
--etcd-cafile=/opt/etcd/ssl/ca.pem \\
--etcd-certfile=/opt/etcd/ssl/server.pem \\
--etcd-keyfile=/opt/etcd/ssl/server-key.pem \\
--audit-log-maxage=30 \\
--audit-log-maxbackup=3 \\
--audit-log-maxsize=100 \\
--audit-log-path=/opt/kubernetes/logs/k8s-audit.log"
EOF



head -c 16 /dev/urandom | od -An -t x | tr -d ' '

# 创建token文件
cat > /opt/kubernetes/cfg/token.csv << EOF
0fd7a1ed94d0f80d8607e3e588f30e6c,kubelet-bootstrap,10001,"system:node-bootstrapper"
EOF

# systemd管理apiserver
cat > /usr/lib/systemd/system/kube-apiserver.service << EOF
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes
[Service]
EnvironmentFile=/opt/kubernetes/cfg/kube-apiserver.conf
ExecStart=/opt/kubernetes/bin/kube-apiserver \$KUBE_APISERVER_OPTS
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF


# 启动并设置开机启动
systemctl daemon-reload
systemctl start kube-apiserver
systemctl enable kube-apiserver




# 授权kubelet-bootstrap用户允许请求证书
kubectl create clusterrolebinding kubelet-bootstrap \
--clusterrole=system:node-bootstrapper \
--user=kubelet-bootstrap





# 部署kube-controller-manager

# 配置文件
cat > /opt/kubernetes/cfg/kube-controller-manager.conf << EOF
KUBE_CONTROLLER_MANAGER_OPTS="--logtostderr=false \\
--v=2 \\
--log-dir=/opt/kubernetes/logs \\
--leader-elect=true \\
--master=127.0.0.1:8080 \\
--bind-address=127.0.0.1 \\
--allocate-node-cidrs=true \\
--cluster-cidr=10.244.0.0/16 \\
--service-cluster-ip-range=10.0.0.0/24 \\
--cluster-signing-cert-file=/opt/kubernetes/ssl/ca.pem \\
--cluster-signing-key-file=/opt/kubernetes/ssl/ca-key.pem  \\
--root-ca-file=/opt/kubernetes/ssl/ca.pem \\
--service-account-private-key-file=/opt/kubernetes/ssl/ca-key.pem \\
--experimental-cluster-signing-duration=87600h0m0s"
EOF

# systemd管理controller-manager
cat > /usr/lib/systemd/system/kube-controller-manager.service << EOF
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes
[Service]
EnvironmentFile=/opt/kubernetes/cfg/kube-controller-manager.conf
ExecStart=/opt/kubernetes/bin/kube-controller-manager \$KUBE_CONTROLLER_MANAGER_OPTS
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

# 启动并设置开机启动
systemctl daemon-reload  && systemctl start kube-controller-manager  && systemctl enable kube-controller-manager



# 部署kube-scheduler

# 创建配置文件
cat > /opt/kubernetes/cfg/kube-scheduler.conf << EOF
KUBE_SCHEDULER_OPTS="--logtostderr=false \
--v=2 \
--log-dir=/opt/kubernetes/logs \
--leader-elect \
--master=127.0.0.1:8080 \
--bind-address=127.0.0.1"
EOF

# systemd管理scheduler
cat > /usr/lib/systemd/system/kube-scheduler.service << EOF
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes
[Service]
EnvironmentFile=/opt/kubernetes/cfg/kube-scheduler.conf
ExecStart=/opt/kubernetes/bin/kube-scheduler \$KUBE_SCHEDULER_OPTS
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

# 启动并设置开机启动
systemctl daemon-reload  && systemctl start kube-scheduler && systemctl enable kube-scheduler
```







## 部署 worker node



```
mkdir -p /opt/kubernetes/{bin,cfg,ssl,logs} 


cp /usr/local/src/kubernetes/server/bin/kube-proxy /opt/kubernetes/bin
cp /usr/local/src/kubernetes/server/bin/kubelet /opt/kubernetes/bin
```