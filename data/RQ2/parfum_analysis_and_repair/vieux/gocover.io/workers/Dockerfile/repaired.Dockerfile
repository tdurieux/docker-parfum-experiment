FROM debian:jessie

MAINTAINER "Victor Vieux"

RUN echo "deb http://security.debian.org testing/updates main" >> /etc/sources.list

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y ca-certificates curl mercurial git-core subversion bzr build-essential --no-install-recommends -y && rm -rf /var/lib/apt/lists/*;

# Custom libs for some projects
RUN apt-get install --no-install-recommends libreadline-dev -y && rm -rf /var/lib/apt/lists/*;

ARG GO_VERSION

RUN curl -f -sL https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz | tar -v -C /usr/local -xz
ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $PATH:/usr/local/go/bin:/go/bin

RUN go get golang.org/x/tools/cmd/cover

ADD gocover.sh /
RUN chmod +x /gocover.sh

WORKDIR /go/src

ENTRYPOINT ["/gocover.sh"]
