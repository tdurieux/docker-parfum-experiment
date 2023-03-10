FROM ubuntu:20.04
LABEL maintainer="libreliu@foxmail.com"

WORKDIR /app
COPY ./requirements-judger.txt /app

ARG USE_APT_MIRROR=no
ARG USE_PIP_MIRROR=no

# Suppress tzdata interactive selection
ENV DEBIAN_FRONTEND noninteractive

RUN (test ${USE_APT_MIRROR} = yes \
       && \
       (sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list) \
       || \
       (echo "APT mirror config untouched.");) \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install --no-install-recommends -y tzdata \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt-get install --no-install-recommends -y yosys python3 iverilog python3-pip \
    && apt-get install --no-install-recommends -y git \
    && (test ${USE_PIP_MIRROR} = yes \
        && \
        (pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/) \
        || \
        (echo "pip mirror config untouched.");) \
    && pip3 install --no-cache-dir git+https://github.com/libreliu/pyDigitalWaveTools \
    && pip3 install --no-cache-dir -r requirements-judger.txt && rm -rf /var/lib/apt/lists/*;

# Add /app/testcase/main.sh by script manually, in case the sh filename changes
# https://stackoverflow.com/questions/21553353/what-is-the-difference-between-cmd-and-entrypoint-in-a-dockerfile
