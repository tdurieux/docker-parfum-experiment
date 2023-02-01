FROM ubuntu:21.04

USER root

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
    apt-get update && \
    apt-get -y --no-install-recommends install apt-utils && \
    apt-get -y --no-install-recommends install git wget cmake build-essential python3 python3-dev python3-pip && \
    python3 -m pip install argparse numpy && rm -rf /var/lib/apt/lists/*;
