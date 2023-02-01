FROM ubuntu:18.04
RUN apt-get update -y && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN umask 022

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
RUN python3 -m pip install tensorboard
RUN mkdir -p /data/tensorborad-log
CMD ["/bin/sh" "-c" "sleep infinity"]