FROM buildpack-deps:bionic

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt update
RUN apt install --no-install-recommends -y cmake make git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libpcap0.8-dev && rm -rf /var/lib/apt/lists/*;
