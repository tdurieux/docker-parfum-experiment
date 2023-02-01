# base on nivida official cuda image
FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

LABEL maintainer "comzyh <comzyh@gmail.com>"

# if you wan't to use HTTPS sources
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;

# use mirrors, use ubuntu 16.04 for example
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list

# install python3 and pip
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget python3.5 python3-pip locales && rm -rf /var/lib/apt/lists/*;

# generate UTF-8 locales, to avoid encoding error when printing logs
RUN locale-gen en_US.UTF-8

# add tensorflow pakcage and install tensorflow
ADD tensorflow*.whl /tmp/
RUN python3.5 -m pip  install --upgrade pip && python3.5 -m pip install --ignore-installed -i https://pypi.tuna.tsinghua.edu.cn/simple /tmp/tensorflow*.whl
