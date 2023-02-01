FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

USER root

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY . /root/nypower/

RUN pip3 install --no-cache-dir -U /root/nypower/
