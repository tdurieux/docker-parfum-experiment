FROM ubuntu:12.04
# Let's install go just like Docker (from source).
RUN apt-get update -q
RUN apt-get install --no-install-recommends -qy build-essential curl git && rm -rf /var/lib/apt/lists/*;

#golang
RUN apt-get install --no-install-recommends -y --force-yes curl && \
    curl -f -O https://go.googlecode.com/files/go1.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.2.linux-amd64.tar.gz && rm go1.2.linux-amd64.tar.gz && rm -rf /var/lib/apt/lists/*;

ENV GOPATH /gopath
ENV PATH $PATH:$GOPATH/bin:/usr/local/go/bin
ADD . /gopath/src/github.com/virgo-agent-toolkit/go-agent-endpoint/
RUN cd /gopath/src/github.com/virgo-agent-toolkit/go-agent-endpoint/endpoint && go get -v
RUN cd /gopath/src/github.com/virgo-agent-toolkit/go-agent-endpoint/examples/monitoring && go install
EXPOSE 443
ENTRYPOINT /gopath/bin/monitoring 0.0.0.0:443 1
