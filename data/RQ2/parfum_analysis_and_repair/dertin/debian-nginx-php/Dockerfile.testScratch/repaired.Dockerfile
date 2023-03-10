FROM debian:stretch

ENV APP_PATH=/root/workspace/
ENV DEBIAN_FRONTEND noninteractive

WORKDIR $APP_PATH

ADD . /root/workspace

RUN apt-get clean && \
    apt-get -y update > /dev/null && \
    apt-get install --no-install-recommends -y locales && \
    locale-gen en_US.UTF-8 && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get -y upgrade > /dev/null && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /root/workspace/*.sh
