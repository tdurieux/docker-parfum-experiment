FROM golang:1.12.1
LABEL maintainer="github@github.com"

RUN apt-get update && apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

COPY . /go/src/github.com/github/ccql
WORKDIR /go/src/github.com/github/ccql

CMD ["script/test"]
