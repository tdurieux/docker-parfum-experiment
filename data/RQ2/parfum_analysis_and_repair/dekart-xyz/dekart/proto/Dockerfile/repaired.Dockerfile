FROM golang:1.14.1

ENV GOPATH=/home/root/go/
ENV PATH="${GOPATH}/bin:${PATH}"
ENV GO111MODULE="on"

RUN apt-get update
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/root/


# getting protoc for correct platform;
ARG PLATFORM=x86_64
RUN curl -f -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/protoc-3.14.0-linux-${PLATFORM}.zip
RUN unzip -o protoc-3.14.0-linux-${PLATFORM}.zip -d /usr/local bin/protoc
RUN unzip -o protoc-3.14.0-linux-${PLATFORM}.zip -d /usr/local 'include/*'
RUN rm -f protoc-3.14.0-linux-${PLATFORM}.zip

# Install buf
RUN curl -f -sSL \
    "https://github.com/bufbuild/buf/releases/download/v0.33.0/buf-$(uname -s)-$(uname -m)" -o "/usr/local/bin/buf"
RUN chmod +x "/usr/local/bin/buf"

# Install protoc plugins
RUN go get google.golang.org/protobuf/cmd/protoc-gen-go
RUN go get google.golang.org/grpc/cmd/protoc-gen-go-grpc
RUN curl -f -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/protobuf-js-3.14.0.zip
RUN unzip -o protobuf-js-3.14.0.zip -d ./protobuf-js-3.14.0
WORKDIR /home/root/protobuf-js-3.14.0
RUN npm install && npm cache clean --force;

RUN npm install -g ts-protoc-gen && npm cache clean --force;

WORKDIR /home/root/dekart