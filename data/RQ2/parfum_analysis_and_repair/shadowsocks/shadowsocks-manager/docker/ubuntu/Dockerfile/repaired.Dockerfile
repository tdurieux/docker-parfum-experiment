FROM ubuntu:18.04
LABEL maintainer="Gyteng <igyteng@gmail.com>"
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install --no-install-recommends tzdata iproute2 curl wget git sudo software-properties-common python-pip -y && \
    pip install --no-cache-dir git+https://github.com/gyteng/shadowsocks.git@master && \
    curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install --no-install-recommends -y nodejs shadowsocks-libev && \
    npm i -g shadowsocks-manager --unsafe-perm && \
    cd /tmp && \
    wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.11.2/shadowsocks-v1.11.2.x86_64-unknown-linux-musl.tar.xz && \
    xz -d shadowsocks-v1.11.2.x86_64-unknown-linux-musl.tar.xz && \
    tar -xvf shadowsocks-v1.11.2.x86_64-unknown-linux-musl.tar && \
    mv /tmp/ssmanager /usr/bin/ && \
    rm -rf /tmp/* && \
    echo "Asia/Shanghai" > /etc/timezone && \
    rm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && npm cache clean --force; && rm shadowsocks-v1.11.2.x86_64-unknown-linux-musl.tar && rm -rf /var/lib/apt/lists/*;
CMD ["/usr/bin/ssmgr"]
