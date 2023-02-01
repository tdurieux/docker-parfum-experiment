# Git: git version 2.30.2
# gcc: 10.3.1 20210424
# Node: 14.17.5 LTS, npm: 6.14.14, yarn: 1.22.5
# /etc/os-release: Alpine Linux v3.14
# Kernel(uname -a): Linux 55f39d8cbcc0 5.10.47-linuxkit Sat Jul 3 21:51:47 2021 x86_64
# Build cmd: docker build . -t terminus/alpine-node-14.17 -f Dockerfile.alpine.npm.6.14
# Other tags: terminus/alpine-node:14.17-lts,terminus/alpine-node:14.17
# Notice: 由于Alpine使用musl libc而不是glibc，而大多数流行的发行版使用后者，
#         为了避免兼容性问题现阶段不建议在Alpine里面构建或者部署Node应用
FROM node:14.17.5-alpine3.14

LABEL maintainer=hustcer<majun@terminus.io>

ENV LANG=en_US.UTF-8
ENV NODEJS_ORG_MIRROR="https://npmmirror.com/dist"
ENV SASS_BINARY_SITE="https://npmmirror.com/mirrors/node-sass"

# Use aliyun mirrors to speed up installation
RUN echo "https://mirrors.aliyun.com/alpine/v3.14/main/" > /etc/apk/repositories \
    && echo "https://mirrors.aliyun.com/alpine/v3.14/community/" >> /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk add --no-cache busybox-extras bash curl openssh-client vim git git-subtree python2 \
       # Dev related: install libstdc++ libc6-compat, etc. to fix node-canvas related issue
       # build-base will install: binutils, gcc, g++, make, patch, etc.
       build-base libstdc++ libc6-compat cairo-dev jpeg-dev pango-dev giflib-dev \
       # Fix: Error loading shared library libuuid.so.1
       libuuid \
       # Fix: Fontconfig error: Cannot load default config file
       fontconfig \
    # Fix: Error loading shared library ld-linux-x86-64.so.2: No such file or directory
    && ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2 \
    # Fix: Error loading shared library libresolv.so.2
    && ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2 \
    # Change default shell from ash to bash
    && sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd \
    && rm -rf /var/cache/apk/*

# Use terminus npm registry