FROM golang:latest
WORKDIR /
RUN curl -f https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN curl -f -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
RUN chmod 755 nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y protobuf-compiler libprotobuf-dev && rm -rf /var/lib/apt/lists/*;
RUN go get -u github.com/golang/protobuf/protoc-gen-go
RUN mkdir -p /go/src/github.com/singnet
WORKDIR /go/src/github.com/singnet
RUN git clone https://github.com/singnet/snet-daemon.git
WORKDIR /go/src/github.com/singnet/snet-daemon
RUN ./scripts/install
RUN ./scripts/build linux amd64
