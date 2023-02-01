FROM golang:1.12-buster
MAINTAINER Eric Garrido <eric@ericgar.com>

RUN apt-get update && apt-get install --no-install-recommends -y xvfb default-jre unzip chromium firefox-esr bzip2 && rm -rf /var/lib/apt/lists/*;
VOLUME /code
