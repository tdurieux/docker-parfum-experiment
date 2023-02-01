FROM golang:1.4.2

RUN apt-get update && apt-get install --no-install-recommends -y libxml2-dev pkg-config && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /src/github.com/dynport/dgtk

COPY . /src/github.com/dynport/dgtk

ENV GOPATH /

WORKDIR /src/github.com/dynport/dgtk

RUN make jenkins
