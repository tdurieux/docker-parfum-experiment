# A Dockerfile that tries to simulate running in Travis CI, to make
# debugging test failures easier.

FROM ubuntu:12.04

RUN apt-get update -q
RUN apt-get install -y --no-install-recommends -qq software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:mercurial-ppa/releases
RUN apt-get update -q
RUN apt-get install -y --no-install-recommends -qq curl git mercurial && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends -qq python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN easy_install python-hglib

# Install Go
RUN curl -f -Ls https://golang.org/dl/go1.4.linux-amd64.tar.gz | tar -C /usr/local -xz
ENV PATH /usr/local/go/bin:$PATH
ENV GOBIN /usr/local/bin

ENV GOPATH /opt
ADD . /opt/src/sourcegraph.com/sourcegraph/go-vcs
WORKDIR /opt/src/sourcegraph.com/sourcegraph/go-vcs
RUN go get -v -t -d ./...

CMD ["test", "./..."]
ENTRYPOINT ["/usr/local/go/bin/go"]
