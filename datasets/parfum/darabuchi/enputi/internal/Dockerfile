FROM ghcr.io/troian/golang-cross
# https://hub.docker.com/r/troian/golang-cross
#"https://docker.mirrors.ustc.edu.cn/",
#"https://hub-mirror.c.163.com/",
#"https://reg-mirror.qiniu.com"

MAINTAINER darabuchi <darabuchi0818@gmail.com>

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y upx-ucl

# goreleaser version
ARG GORELEASER_VERSION=0.179.0
ARG GORELEASER_FILENAME=goreleaser_amd64.deb
# 安装 goreleaser
RUN  #!/bin/bash \
	if [ ! -f "$${GORELEASER_FILENAME}" ]; then \
		dpkg -i /home/goreleaser_amd64.deb \
	else \
		curl -L -o ./${GORELEASER_FILENAME} "https://cdn.jsdelivr.net/gh/goreleaser/goreleaser@releases/download/v${GORELEASER_VERSION}/${GORELEASER_FILENAME}" && dpkg -i ./${GORELEASER_FILENAME} \
	fi

COPY . /home

WORKDIR /home
#ENTRYPOINT ["goreleaser", "--skip-validate" , "--snapshot", "--skip-publish","--rm-dist", "--config", ".goreleaser.yml", "--timeout=24h"]
ENTRYPOINT  ["goreleaser", "--skip-validate" ,"--rm-dist", "--config", ".goreleaser.yml", "--debug", "--timeout=24h"]
#ENTRYPOINT ["/bin/bash"]
