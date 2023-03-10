FROM docker.io/ubuntu:impish
MAINTAINER Pacur <contact@pacur.org>

RUN apt-get --assume-yes update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends --assume-yes install build-essential reprepro rsync wget zip git mercurial && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes upgrade


RUN wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz
RUN echo "956f8507b302ab0bb747613695cdae10af99bbd39a90cae522b7c0302cc27245  go1.18.3.linux-amd64.tar.gz" | sha256sum -c -
RUN tar -C /usr/local -xf go1.18.3.linux-amd64.tar.gz && rm go1.18.3.linux-amd64.tar.gz
RUN rm -f go1.18.3.linux-amd64.tar.gz

ENV GOPATH /go
ENV PATH /usr/local/go/bin:$PATH:/go/bin
ENV GO111MODULE on

RUN go install github.com/pacur/pacur@latest

ENTRYPOINT ["pacur"]
CMD ["build", "ubuntu-impish"]
