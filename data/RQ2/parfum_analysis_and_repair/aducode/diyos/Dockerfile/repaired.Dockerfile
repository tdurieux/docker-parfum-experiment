#FROM ubuntu:18.04
# FROM dorowu/ubuntu-desktop-lxde-vnc:bionic
FROM dorowu/ubuntu-desktop-lxde-vnc:focal
RUN sed -i 's#mirror://mirrors.ubuntu.com/mirrors.txt#https://mirrors.aliyun.com/ubuntu/#' /etc/apt/sources.list
RUN apt update && apt install --no-install-recommends -y git cmake nasm libc6-dev-i386 build-essential xorg-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /root/workspace
RUN wget -q https://bochs.sourceforge.net/svn-snapshot/bochs-20201008.tar.gz
RUN tar zxvf bochs-20201008.tar.gz && rm bochs-20201008.tar.gz
WORKDIR /root/workspace/bochs-20201008
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-debugger --enable-disasm && make && make install
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["/bin/bash"]
