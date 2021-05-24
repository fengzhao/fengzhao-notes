FROM alpine:latest

# MAINTAINER在官网文档中，已经被弃用，建议使用LABEL指令来描述作者信息

# LABEL指令用来给镜像以键值对的形式添加一些元数据(metadata)，使用键值对的方式
# LABEL <key>=<value> <key>=<value> <key>=<value> ...
# 具体可以参考https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.authors="fengzhao"



# 如果是国内服务器，一般需要给apline修改国内源
# RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk apdate && apk --no-cache add  ca-certificates python3 curl bind-tools iptoure2 iptables ipvsadm

RUN 

ADD demo.py /usr/local/bin/



ENV
# 定义环境变量，为docker build过程指定的环境变量。在ENV之后的RUN指令或者其他指令可以通过${key}这种形式直接引用变量
# 参考nginx官方的Dockerfile文件 https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
# 如果环境变量仅在构建时需要，最终的镜像并不需要，可以在像下面一样在一句命令行中执行:
# RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ...
# ENV允许的语法格式：
# ENV <key>=<value> ...  # 这种格式允许在一行声明多个变量 
# ENV MY_VAR my-value    # 这种格式不允许在一行声明多个变量


# 变量替换

# 在引用变量的时候，也可以支持bash里面的语法：
# ${variable:-word} 如果variable被赋值，则变量直接取取值，如果未被赋值，则变量值为word
# ${variable:+word} 如果variable被赋值，则变量值为word，否则变量值为空字符串

# FROM busybox
# ENV FOO=/bar
# WORKDIR ${FOO}   # WORKDIR /bar
# ADD . $FOO       # ADD . /bar
# COPY \$FOO /quux # COPY $FOO /quux





ARG 

EXPOSE 


VOLUME 

ENTRYPOINT