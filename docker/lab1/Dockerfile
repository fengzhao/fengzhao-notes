FROM alpine:latest

# MAINTAINER在官网文档中，已经被弃用，建议使用LABEL指令来描述作者信息

# LABEL指令用来给镜像以键值对的形式添加一些元数据(metadata)，使用键值对的方式，就是容器的注解。
# LABEL <key>=<value> <key>=<value> <key>=<value> ...
# 具体可以参考https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.authors="fengzhao"


# LABEL org.label-schema.schema-version="1.0" \                                     
#       org.label-schema.name="CentOS Base Image" \                              
#       org.label-schema.vendor="CentOS" \
#       org.label-schema.license="GPLv2" \
#       org.label-schema.build-date="20200114" \
#       org.opencontainers.image.title="CentOS Base Image" \
#       org.opencontainers.image.vendor="CentOS" \
#       org.opencontainers.image.licenses="GPL-2.0-only" \
#       org.opencontainers.image.created="2020-01-14 00:00:00-08:00"

# https://github.com/CentOS/sig-cloud-instance-images/blob/CentOS-8.1.1911-x86_64/docker/Dockerfile



# 如果是国内服务器，一般需要给apline修改国内源
# RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
# RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
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

# 使用 ENV 设置的环境变量将一直存在于构建镜像时以及镜像容器运行时，可以使用 docker inspect 查看设置打的变量。也可以使用 docker run --env <key> = <value> 来更改它们。



# ARG指令 
# ARG <name>[=<default value>]
# Dockerfile 里面的 ARG 指令定义了一个变量，在运行 docker build 命令时可以使用 --build-arg <varname> = <value> 参数将其传递给构建器。
# 这种变量只存在于镜像构建的时候，一旦镜像构建完成就失效了，不要使用构建时变量来传递诸如 github 密钥，用户凭据等机密数据，构建时变量值可以使用 docker history 命令查看。




EXPOSE 


VOLUME 

ENTRYPOINT