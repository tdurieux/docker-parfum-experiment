FROM ubuntu:20.04

LABEL maintainer service@fisco.com.cn

RUN apt-get -q update && apt-get install -qy --no-install-recommends libzstd-dev\
    git clang build-essential cmake libssl-dev zlib1g-dev ca-certificates \
    && export DEBIAN_FRONTEND=noninteractive \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get install -qy --no-install-recommends tzdata \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm  -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*