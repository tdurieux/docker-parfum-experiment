FROM alpine:3.7

LABEL maintainer="Ryu Sato <ryu@weseek.co.jp>"
LABEL description="Create S3 bucket and wait until mongodb is initialized for test"

RUN apk add --no-cache \
    coreutils \
    bash \
    tzdata \
    curl \
    py2-pip
RUN pip install --no-cache-dir awscli

# install dockerize
ENV DOCKERIZE_VERSION v0.5.0
RUN curl -f -SL https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
      | tar -xz -C /usr/local/bin

# dummy backup data for restore
COPY dummy-backup-20180622000000.tar.bz2 /

# copy shell script for entrypoint
COPY entrypoint.init_test.sh /root

# set timezone JST
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
