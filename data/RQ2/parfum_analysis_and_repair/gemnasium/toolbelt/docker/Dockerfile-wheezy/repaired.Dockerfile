FROM debian:wheezy

RUN echo "deb http://ftp.debian.org/debian wheezy-backports main" >> /etc/apt/sources.list.d/backports.list
RUN apt-get update && apt-get install --no-install-recommends -y debhelper build-essential git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -t wheezy-backports golang-go && rm -rf /var/lib/apt/lists/*;
RUN mkdir /go
ENV GOPATH /go
RUN go get github.com/tools/godep

COPY docker/build.sh /bin/build.sh
COPY docker/gpg_wrapper.sh /bin/gpg_wrapper.sh
COPY docker/test.sh /bin/test.sh

WORKDIR /go/src/github.com/gemnasium/toolbelt

