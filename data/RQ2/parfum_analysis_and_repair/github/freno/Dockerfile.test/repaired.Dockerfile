FROM golang:1.16-buster
LABEL maintainer="github@github.com"

RUN useradd -m testuser

RUN apt-get update && apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

COPY . /go/src/github.com/github/freno
WORKDIR /go/src/github.com/github/freno

RUN chown -R testuser .
USER testuser

CMD ["script/test"]
