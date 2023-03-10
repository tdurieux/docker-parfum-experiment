FROM alpine:3.10

MAINTAINER goldeneggg

RUN mkdir -p /tmp/prv-bash/alpine3
WORKDIR /tmp/prv-bash

ADD entry.sh entry.sh
ADD alpine3/prepare.sh alpine3/prepare.sh
ADD alpine3/envs alpine3/envs
ADD alpine3/files alpine3/files
ADD alpine3/init.sh alpine3/init.sh

RUN apk update && \
  apk add --no-cache bash && \
  apk add --no-cache tzdata && \
  bash entry.sh --local alpine3 init.sh

# other script
#ADD alpine3/init.sh /tmp/prv-bash/alpine3/xxx.sh
#RUN bash entry.sh --local alpine3 xxx.sh
