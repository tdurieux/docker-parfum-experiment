FROM registry.aliyuncs.com/acs-sample/ubuntu:14.04
MAINTAINER neo1218 <neo1218@yeah.net>

ENV DEPLOY_PATH /shadowsocks

RUN mkdir -p $DEPLOY_PATH
WORKDIR $DEPLOY_PATH

RUN apt-get -y update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir shadowsocks

Add . .
