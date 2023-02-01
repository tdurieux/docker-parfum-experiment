FROM python:3.10.1-buster

MAINTAINER AKFamily <akfamily.aktools@gmail.com>

# time-zone
RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends -y tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir fastapi
RUN pip install --no-cache-dir uvicorn
RUN pip install --no-cache-dir aktools
RUN pip install --no-cache-dir akshare --upgrade
