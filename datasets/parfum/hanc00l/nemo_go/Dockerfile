FROM ubuntu:20.04

ENV LC_ALL C.UTF-8
# Docker timezone
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive
# Install tzdata
RUN set -x \
    && sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt update \
    && apt install -y tzdata \
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

# Init
RUN set -x \
    # You may need this if you're in Mainland China \
    && apt update \
    && apt install -y  python3-pip python3-setuptools \
    wget curl vim net-tools  iputils-ping git unzip \
    nmap masscan  --fix-missing

# Install chrome instead of chromium-browser(can't do screenshot,why?)
RUN set -x \
    && curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb

# pip package
RUN set -x \
    # You may need this if you're in Mainland China
    # && python3 -m pip config set global.index-url 'https://pypi.mirrors.ustc.edu.cn/simple/' \
    && python3 -m pip install -U pip -i https://mirrors.aliyun.com/pypi/simple/ --user \
    && python3 -m pip install -U requests pocsuite3 -i https://mirrors.aliyun.com/pypi/simple/

COPY . /opt/nemo

#link to mysql and rabbitmq
RUN set -x \
    && sed -i 's/host: 127.0.0.1/host: mysql/g' /opt/nemo/conf/server.yml \
    && sed -i 's/host: localhost/host: rabbitmq/g' /opt/nemo/conf/server.yml \
    && sed -i 's/host: localhost/host: rabbitmq/g' /opt/nemo/conf/worker.yml
