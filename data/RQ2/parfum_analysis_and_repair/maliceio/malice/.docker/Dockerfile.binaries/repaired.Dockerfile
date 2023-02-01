FROM golang

MAINTAINER blacktop, https://github.com/blacktop

RUN apt-get update && apt-get install --no-install-recommends -y libmagic-dev zip && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/github.com/maliceio/malice

ENTRYPOINT install/scripts/compile.sh
