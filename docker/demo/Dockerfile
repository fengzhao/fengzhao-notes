FROM python:3.7-alpine

MAINTAINER fengzhao<fengzhao1124@hotmail.com>
# 工作目录
WORKDIR /code
# 环境变量
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
# apk添加各种基础环境
RUN apk add --no-cache gcc musl-dev linux-headers
# 复制文件进容器
COPY requirements.txt requirements.txt
# 容器内安装相关依赖
RUN pip install -r requirements.txt
# 暴露端口
EXPOSE 5000
# 连代码一起拷贝进容器
COPY . .
# 启动执行命令
CMD ["flask", "run"]