#################################################
# SmartIDE Developer Container Image
# Licensed under GPL v3.0
# Copyright (C) leansoftX.com
#################################################

FROM ubuntu:20.04 AS ideDownloader
# -------------下载IDE文件
# prepare tools:
RUN apt-get update && apt-get -y install --no-install-recommends wget ca-certificates tar
# download IDE to the /ide dir:
WORKDIR /download

# https://download.jetbrains.com/idea/ideaIC-2021.2.3.tar.gz
ARG downloadUrl=https://download.jetbrains.com/go/goland-2020.3.5.tar.gz
RUN wget -q $downloadUrl -O - | tar -xz
RUN find . -maxdepth 1 -type d -name * -execdir mv {} /ide \;

# -------------构建projector-server库，运行依赖
FROM smartide/projector-server:2021.2.2-1673 as projectorGradleBuilder


# -------------处理IDE运行程序，和构建好的rojector-server库
FROM ubuntu:20.04 AS projectorStaticFiles

# prepare tools:
RUN apt-get update && apt-get -y install --no-install-recommends unzip
# create the Projector dir:
ENV PROJECTOR_DIR /projector
RUN mkdir -p $PROJECTOR_DIR
# copy IDE:
COPY --from=ideDownloader /ide $PROJECTOR_DIR/ide
# copy projector files to the container:
COPY static $PROJECTOR_DIR
# copy projector:
COPY --from=projectorGradleBuilder $PROJECTOR_DIR/projector-server/projector-server/build/distributions/projector-server.zip $PROJECTOR_DIR
# prepare IDE - apply projector-server:
RUN unzip $PROJECTOR_DIR/projector-server.zip
RUN rm $PROJECTOR_DIR/projector-server.zip
RUN find . -maxdepth 1 -type d -name projector-server-* -exec mv {} projector-server \;
RUN mv projector-server $PROJECTOR_DIR/ide/projector-server
RUN mv $PROJECTOR_DIR/ide-projector-launcher.sh $PROJECTOR_DIR/ide/bin
RUN chmod 644 $PROJECTOR_DIR/ide/projector-server/lib/*



# -------------配置运行环境 ##TODO image参数化

FROM registry.cn-hangzhou.aliyuncs.com/smartide/smartide-golang-v2:latest

RUN true \
# Any command which returns non-zero exit code will cause this shell script to exit immediately:
   && set -e \
# Activate debugging to show execution details: all commands will be printed before execution
   && set -x \
# install packages:
    && apt-get update \
# packages for awt:
    && apt-get install --no-install-recommends libxext6 libxrender1 libxtst6 libxi6 libfreetype6 -y \
# packages for user convenience:
    && apt-get install --no-install-recommends git wget curl bash-completion net-tools sudo ca-certificates g++ gcc libc6-dev make pkg-config -y \
# clean apt to reduce image size:
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
# ENV GOLANG_VERSION=1.17.5
# ENV GOPATH=/home/smartide/go
# ENV GOROOT=/usr/local/go
# ENV PATH=/usr/local/go/bin:$PATH
# ENV PATH=/home/smartide/go/bin:$PATH

# copy the Projector dir:
ENV PROJECTOR_DIR /projector
COPY --from=projectorStaticFiles $PROJECTOR_DIR $PROJECTOR_DIR

# # 安装sdk
# RUN wget -O go.tgz https://go.dev/dl/go$GOLANG_VERSION.linux-amd64.tar.gz \
#     && tar -C /usr/local -xzf go.tgz \
#     && rm -rf go.tgz

ENV PROJECTOR_USER_NAME smartide

RUN true \
# Any command which returns non-zero exit code will cause this shell script to exit immediately:
    && set -e \
# Activate debugging to show execution details: all commands will be printed before execution
    && set -x \
# move run scipt: ##will remove
    && mv $PROJECTOR_DIR/run.sh run.sh \ 
# change user to non-root (http://pjdietz.com/2016/08/28/nginx-in-docker-without-root.html):
    # && mv $PROJECTOR_DIR/$PROJECTOR_USER_NAME /home \
    && chmod g+rw /home && mkdir -p /home/smartide && mkdir -p /home/project && mkdir -p /home/smartide/go \
    #&& useradd -d /home/$PROJECTOR_USER_NAME -s /bin/bash -G sudo $PROJECTOR_USER_NAME \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && chown -R $PROJECTOR_USER_NAME.$PROJECTOR_USER_NAME /home/$PROJECTOR_USER_NAME \
    && chown -R $PROJECTOR_USER_NAME.$PROJECTOR_USER_NAME /home/project \
    && chown -R $PROJECTOR_USER_NAME.$PROJECTOR_USER_NAME $PROJECTOR_DIR/ide/bin \
	##will remove && chmod +x run.sh 
    && chmod +x run.sh && chmod +x /projector/ide/bin/ide-projector-launcher.sh \
    && mkdir -p "$GOPATH/src" "$GOPATH/bin" "$GOPATH/pkg/mod" && chmod -R 777 "$GOPATH" \
    && echo "export PATH=/usr/local/go/bin:/home/smartide/go/bin:$PATH" >> /etc/profile

USER $PROJECTOR_USER_NAME
ENV HOME /home/$PROJECTOR_USER_NAME

# RUN go get -v \
#     github.com/uudashr/gopkgs/cmd/gopkgs@v2 \
#     github.com/ramya-rao-a/go-outline \
#     github.com/cweill/gotests/gotests \
#     github.com/fatih/gomodifytags \
#     github.com/josharian/impl \
#     github.com/haya14busa/goplay/cmd/goplay \
#     github.com/go-delve/delve/cmd/dlv \
#     github.com/golangci/golangci-lint/cmd/golangci-lint && \
#     GO111MODULE=on go get -v \
#     golang.org/x/tools/gopls@v0.7.3

USER root

EXPOSE 8887

#CMD ["bash", "-c", "/run.sh"]

COPY gosu_entrypoint_jetbrain.sh /idesh/gosu_entrypoint_jetbrain.sh
RUN chmod +x /idesh/gosu_entrypoint_jetbrain.sh

ENTRYPOINT ["/idesh/gosu_entrypoint_jetbrain.sh"]