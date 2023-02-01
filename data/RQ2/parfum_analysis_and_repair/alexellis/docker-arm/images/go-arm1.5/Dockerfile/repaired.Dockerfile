FROM armhf/ubuntu
RUN apt-get update && apt-get -qy --no-install-recommends install git nano curl wget build-essential && rm -rf /var/lib/apt/lists/*;

RUN wget \
	https://github.com/hypriot/golang-armbuilds/releases/download/v1.5.2/go1.5.2.linux-armv7.tar.gz
RUN tar -xf go*.tar.gz -C /usr/local/ && rm go*.tar.gz

ENV PATH \
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin
RUN mkdir /go
ENV GOPATH /go
ENV AUTO_GOPATH 1
RUN go version
RUN AUTO_GOPATH=1 go get github.com/tools/godep

CMD ["go version"]
