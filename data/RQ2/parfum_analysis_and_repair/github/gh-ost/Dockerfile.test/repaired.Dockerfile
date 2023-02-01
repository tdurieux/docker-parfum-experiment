FROM golang:1.17
LABEL maintainer="github@github.com"

RUN apt-get update && apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

COPY . /go/src/github.com/github/gh-ost
WORKDIR /go/src/github.com/github/gh-ost

CMD ["script/test"]
