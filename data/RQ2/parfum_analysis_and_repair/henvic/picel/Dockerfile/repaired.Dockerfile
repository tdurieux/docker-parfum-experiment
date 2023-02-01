FROM golang:onbuild
MAINTAINER Henrique Vicente <henriquevicente@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y \
    imagemagick \
    webp && rm -rf /var/lib/apt/lists/*;

EXPOSE 8123
