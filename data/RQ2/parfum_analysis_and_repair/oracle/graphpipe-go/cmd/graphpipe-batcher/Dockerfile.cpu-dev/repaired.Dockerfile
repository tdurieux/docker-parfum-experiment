FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt-get update && apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:gophers/archive
RUN apt-get update && apt-get install --no-install-recommends -y \
    linux-libc-dev \
    manpages-dev \
    python-dev \
    golang-1.10-go \
    git \
    curl \
    patch && rm -rf /var/lib/apt/lists/*;

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/go-1.10/bin:/go/bin

RUN go get -u github.com/kardianos/govendor
