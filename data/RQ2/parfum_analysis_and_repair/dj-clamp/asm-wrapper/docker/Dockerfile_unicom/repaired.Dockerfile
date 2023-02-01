FROM node:lts-alpine
LABEL maintainer="clamp <imclamp@foxmail.com>"
ARG ASM_WRAPPER_URL=https://github.com/DJ-clamp/asm-wrapper
ARG ASM_WRAPPER_BRANCH=main
ARG enable_unicom=true
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ " \
    ASM_DIR=/AutoSignMachine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && apk --no-cache add -f bash \
    coreutils \
    moreutils \
    git \
    wget \
    curl \
    nano \
    tzdata \
    perl \
    openssl \
    openssh-client \
    libav-tools \
    libjpeg-turbo-dev \
    libpng-dev \
    libtool \
    libgomp \
    tesseract-ocr \
    graphicsmagick \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && git clone -b ${ASM_WRAPPER_BRANCH} ${ASM_WRAPPER_URL} ${ASM_DIR} \
    && mkdir ${ASM_DIR}/scripts \
    && cp -f ${ASM_DIR}/docker/entrypoint.sh /entrypoint.sh \
    && chmod 777 /entrypoint.sh

WORKDIR ${ASM_DIR}
ENTRYPOINT /entrypoint.sh