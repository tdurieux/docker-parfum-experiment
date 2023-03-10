FROM {{ $.source }}
LABEL maintainer="cookeem"
LABEL email="cookeem@qq.com"
USER root
RUN userdel gradle && groupadd -g 1000 dory && useradd -u 1000 -g 1000 -r dory -d /home/dory -m
USER dory
WORKDIR /home/dory

# docker build -t {{ $.source }}-dory -f Dockerfile-gradle-{{ $.tagName }} .