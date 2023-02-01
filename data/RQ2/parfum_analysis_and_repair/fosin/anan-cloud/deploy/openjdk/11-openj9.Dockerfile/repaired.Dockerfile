FROM adoptopenjdk:11-jdk-openj9
MAINTAINER fosin 28860823@qq.com

VOLUME ["/tmp","/logs"]

WORKDIR /anan

COPY entrypoint.sh wait-for.sh ./
COPY sources.list /etc/apt/

RUN chmod +x entrypoint.sh wait-for.sh \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apt update \
    && set -eux \
    && apt -y --no-install-recommends install netcat \
    && apt -y --no-install-recommends install net-tools \
    && apt -y --no-install-recommends install iputils-ping \
    && apt -y --no-install-recommends install telnet \
    && rm -rf /var/lib/apt/lists/*
