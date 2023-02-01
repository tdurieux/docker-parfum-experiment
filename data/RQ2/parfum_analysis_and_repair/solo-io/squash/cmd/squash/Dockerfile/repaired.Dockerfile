FROM ubuntu:18.04 as base

RUN apt-get update
RUN apt-get install --no-install-recommends --yes gdb build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://storage.googleapis.com/golang/go1.11.linux-amd64.tar.gz | tar -C /usr/lib -xz

ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN mkdir -p $GOPATH/src/github.com/go-delve/ && cd  $GOPATH/src/github.com/go-delve/ && git clone https://github.com/go-delve/delve/
RUN cd $GOPATH/src/github.com/go-delve/delve/ && git checkout v1.2.0
RUN cd $GOPATH/src/github.com/go-delve/delve/cmd/dlv && go install

FROM base

COPY squash /
ENTRYPOINT ["/squash"]
