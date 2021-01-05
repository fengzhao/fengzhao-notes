## 使用 Docker 安装 MySQL





```shell
mkdir -p /data/mysql/{data,log,conf}

docker pull mysql:8.0.22


```





```yaml
# /data/mysql/docker-compose.yml


version: '3.3'
services:
  db:
    image: mysql:5.7
    # 自动重启
    restart: always
    # 容器名称
    container_name: mysql-db
    # 主机名
    hostname: db-master
    # 启动参数
    # command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci 
    environment:
      MYSQL_DATABASE: 'db'
      # So you don't have to use root, but you can if you like
      MYSQL_USER: 'user'
      # You can use whatever password you like
      MYSQL_PASSWORD: 'password'
      # Password for root access
      MYSQL_ROOT_PASSWORD: 'password'
    ports:
      # <Port exposed> : < MySQL Port running inside container>
      - '3306:3306'
    expose:
      # Opens port 3306 on the container
      - '3306'
    # Where our data will be persist
    volumes:
      # 宿主机目录：容器目录
      # 数据目录  
      - /data/docker/data/mysql-5.7:/var/lib/mysql
      # 配置文件
      - /data/docker/conf/my.cnf:/etc/my.cnf
      # 日志文件
      -  /data/docker/log/:var/log/mysql/error.log
```

