FROM ubuntu:14.04
MAINTANER Igor Mihalik <igor.mihalik@gmail.com>

RUN apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -qy build-essential curl git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://storage.googleapis.com/golang/go1.3.1.src.tar.gz | tar -v -C /usr/local -xz
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1
ENV PATH /usr/local/go/bin:$PATH
ENV GOPATH /go

RUN go get github.com/igm/sockjs-go/examples/webchat
EXPOSE 8080

WORKDIR /go/src/github.com/igm/sockjs-go/examples/webchat
ENTRYPOINT ["/go/bin/webchat"]
