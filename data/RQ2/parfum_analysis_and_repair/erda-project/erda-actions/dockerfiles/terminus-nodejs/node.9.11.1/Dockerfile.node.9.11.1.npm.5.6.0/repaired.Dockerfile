FROM registry.erda.cloud/erda/terminus-centos:base

LABEL maintainer="lj@terminus.io"

ENV SASS_BINARY_SITE="https://npmmirror.com/mirrors/node-sass"
ENV NODEJS_ORG_MIRROR="https://npmmirror.com/dist"

ENV LC_ALL=en_US.utf8

RUN yum install -y git openssh curl && rm -rf /var/cache/yum

ENV NODE_VERSION 9.11.1

# nodejs
RUN \
    curl -f --silent --location https://rpm.nodesource.com/setup_9.x | bash - && \
    yum install -y nodejs-$NODE_VERSION && rm -rf /var/cache/yum

RUN npm config set @terminus:registry http://registry.npm.terminus.io/ && \
    npm config set registry http://registry.npmmirror.com/
