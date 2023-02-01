FROM ubuntu:18.04
LABEL maintainer="Gyteng <igyteng@gmail.com>"
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install --no-install-recommends tzdata iproute2 curl git sudo software-properties-common python-pip -y && \
    pip install --no-cache-dir git+https://github.com/gyteng/shadowsocks.git@master && \
    curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install --no-install-recommends -y nodejs shadowsocks-libev && \
    git clone https://github.com/gyteng/shadowsocks-manager-tiny.git ssmgr && \
    echo "Asia/Shanghai" > /etc/timezone && \
    rm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && rm -rf /var/lib/apt/lists/*;
CMD ["node", "/ssmgr"]
