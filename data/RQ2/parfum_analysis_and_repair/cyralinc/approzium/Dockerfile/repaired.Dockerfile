FROM golang:1.13 AS dev
ENV HOME /root
ENV GOPATH /usr
# enable GOMODULES
ENV GO111MODULE on
ENV CGO_ENABLED 0
# Nice to haves for development
RUN apt-get update && apt-get install --no-install-recommends -y iputils-ping vim && rm -rf /var/lib/apt/lists/*;
# Install protoc-gen-go
RUN go get -u github.com/golang/protobuf/protoc-gen-go@v1.3.3
# Install protobuf compiler
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.7.0/protoc-3.7.0-linux-x86_64.zip
RUN unzip protoc-3.7.0-linux-x86_64.zip -d protoc3
RUN mv protoc3/bin/* /usr/local/bin/
RUN mv protoc3/include/* /usr/local/include/
# Install Vault CLI for ease of testing Vault out
RUN wget https://releases.hashicorp.com/vault/1.4.2/vault_1.4.2_linux_amd64.zip
RUN unzip vault_1.4.2_linux_amd64.zip
RUN mv vault /usr/local/bin/
# Intall AWS CLI
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install
RUN apt-get install --no-install-recommends -y \
  build-essential \
  libpq-dev \
  python3.7 \
  python3.7-dev \
  python3-pip \
  python3-venv && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir poetry tox
WORKDIR /usr/src/approzium/sdk/python
COPY sdk/python .
RUN poetry run pip install -U pip setuptools
RUN poetry install --extras "sqllibs tracing"
# Build Authenticator Go Binary
WORKDIR /usr/src/approzium/authenticator
COPY authenticator/ .
RUN --mount=type=cache,target=$GOPATH/pkg/mod go build

FROM alpine:latest AS authenticator-build
WORKDIR /app/
COPY --from=dev /usr/src/approzium/authenticator/authenticator .
ENTRYPOINT ["./authenticator"]

FROM authenticator-build AS authenticator-dev
COPY --from=dev /usr/src/approzium/authenticator/server/testing/approzium.pem .
RUN chmod 644 /app/approzium.pem
COPY --from=dev /usr/src/approzium/authenticator/server/testing/approzium.key .
RUN chmod 644 /app/approzium.key
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY --from=dev /usr/src/approzium/authenticator/server/testing/ca.cert /usr/local/share/ca-certificates/self-signed-ca.cert
RUN chmod 644 /usr/local/share/ca-certificates/self-signed-ca.cert && update-ca-certificates
