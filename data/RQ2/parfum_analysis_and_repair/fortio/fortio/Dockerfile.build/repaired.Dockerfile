# Dependencies and linters for build:
FROM golang:1.18.3
# Need gcc for -race test (and some linters though those work with CGO_ENABLED=0)
RUN apt-get -y update && \
  apt-get --no-install-recommends -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install libc6-dev apt-transport-https ssh \
  ruby-dev build-essential rpm gnupg zip netcat && rm -rf /var/lib/apt/lists/*;

# Install FPM
RUN gem install --no-document fpm
RUN go version # check it's indeed the version we expect

# golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin
RUN golangci-lint version

# Docker:
RUN set -x;if [ x"$(dpkg --print-architecture)" != x"s390x" ]; then \
    curl -fsSL "https://download.docker.com/linux/debian/gpg" | apt-key add; \
    echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian bullseye stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get -y update && apt-get install --no-install-recommends -y docker-ce; rm -rf /var/lib/apt/lists/*; \
    fi

WORKDIR /build
VOLUME /build
COPY .golangci.yml .
