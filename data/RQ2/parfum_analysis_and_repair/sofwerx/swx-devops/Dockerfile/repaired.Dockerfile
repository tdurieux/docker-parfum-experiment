FROM ubuntu:16.04

RUN apt-get update \
 && apt-get install --no-install-recommends -y sudo wget && rm -rf /var/lib/apt/lists/*;

ADD dependencies/ubuntu.sh /ubuntu.sh

RUN /ubuntu.sh

RUN mkdir /swx
WORKDIR /swx

VOLUME /swx

CMD screen -a -A -fn -h 10000 -s swx-devops ./shell.bash
