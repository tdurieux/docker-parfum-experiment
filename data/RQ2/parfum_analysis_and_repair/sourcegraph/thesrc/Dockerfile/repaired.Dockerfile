FROM ubuntu:14.04

RUN apt-get update -qq && apt-get install -y --no-install-recommends -qq curl git mercurial && rm -rf /var/lib/apt/lists/*;

# Install Go
RUN curl -f -Lo /tmp/golang.tgz https://storage.googleapis.com/golang/go1.3.linux-amd64.tar.gz
RUN tar -xzf /tmp/golang.tgz -C /usr/local && rm /tmp/golang.tgz
ENV GOROOT /usr/local/go
ENV GOBIN /usr/local/bin
ENV PATH /usr/local/go/bin:$PATH
ENV GOPATH /thesrc

ADD . /thesrc/src/sourcegraph.com/sourcegraph/thesrc

RUN go get sourcegraph.com/sourcegraph/thesrc/cmd/thesrc
#RUN go install sourcegraph.com/sourcegraph/thesrc/cmd/thesrc

EXPOSE 5000
CMD ["serve", "-http=:5000"]
ENTRYPOINT ["/usr/local/bin/thesrc"]
