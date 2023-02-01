FROM ubuntu:16.04

WORKDIR /workspace

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    mkdir -p /build_temp/python36 /build_temp/nodejs && \
    apt update && \
    apt install --no-install-recommends -y binutils software-properties-common gcc g++ \
    gconf2 libxkbfile-dev p7zip-full make libssh2-1-dev libkrb5-dev wget curl \
    openssl pkg-config build-essential && \
    cd /build_temp/python36 && \
    apt-get install --no-install-recommends -y aptitude && \
    aptitude -y install gcc make zlib1g-dev libffi-dev libssl-dev && \
    mkdir -p test && cd test && \
    wget https://npmmirror.com/mirrors/python/3.6.5/Python-3.6.5.tgz && \
    tar -xvf Python-3.6.5.tgz && \
    chmod -R +x Python-3.6.5 && \
    cd Python-3.6.5/ && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    aptitude -y install  libffi-dev libssl-dev && \
    make && make install && \
    cd /build_temp/nodejs && \
    wget https://deb.nodesource.com/setup_16.x && \
    chmod +x setup_16.x && \
    ./setup_16.x && \
    apt-get install --no-install-recommends -y nodejs && \
    rm -rf /build_temp && \
    apt install --no-install-recommends -y gosu && \
    gosu nobody true && \
    useradd -s /bin/bash -m user && rm Python-3.6.5.tgz && rm -rf /var/lib/apt/lists/*;

RUN apt remove -y p7zip p7zip-full p7zip-rar &&\
    rm -rf /opt/7z && \
    mkdir -p /opt/7z && \
    cd /opt/7z && \
    wget https://www.7-zip.org/a/7z2107-linux-x64.tar.xz && \
    tar -xJf 7z2107-linux-x64.tar.xz && \
    ln -s 7zz 7z && rm 7z2107-linux-x64.tar.xz
ENV PATH=/opt/7z:$PATH