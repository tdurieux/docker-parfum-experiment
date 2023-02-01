FROM docker
MAINTAINER Roman Galeev <jamhed@2600hz.com>

RUN apk update && apk add --no-cache git openssh
RUN git clone https://github.com/jamhed/kazoo-docker
WORKDIR /kazoo-docker
