FROM docker:20.10.14-dind-rootless
ENV TZ="Europe/Paris"

USER root
RUN apk update && apk add --no-cache python3 python3-dev py3-pip gcc linux-headers musl-dev util-linux

RUN pip3 install --no-cache-dir prefect==1.2.2
