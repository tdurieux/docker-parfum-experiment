FROM --platform=linux/amd64 ubuntu:18.04

# install peewee
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
    apt install --no-install-recommends -y \
        curl \
        gnupg \
        software-properties-common && \
    curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt update -y && \
    apt install --no-install-recommends -y \
        python3.8 \
        python3-pip \
        git \
        mysql-client \
        libmysqlclient-dev \
        bats && \
    update-ca-certificates -f && rm -rf /var/lib/apt/lists/*;

# install go
WORKDIR /root
ENV GO_VERSION=1.17.1
ENV GOPATH=$HOME/go
ENV PATH=$PATH:$GOPATH/bin
ENV PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
RUN curl -f -O "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" && \
    sha256sum "go${GO_VERSION}.linux-amd64.tar.gz" && \
    tar -xvf "go${GO_VERSION}.linux-amd64.tar.gz" -C /usr/local && \
    chown -R root:root /usr/local/go && \
    mkdir -p $HOME/go/{bin,src} && \
    go version && rm "go${GO_VERSION}.linux-amd64.tar.gz"

# install mysql connector and pymsql
RUN pip3 install --no-cache-dir mysql-connector-python PyMySQL sqlalchemy

# install dolt from source
WORKDIR /root/building
COPY ./go .
ENV GOFLAGS="-mod=readonly"
RUN go build -o /usr/local/bin/dolt ./cmd/dolt

COPY orm-tests /orm-tests
COPY orm-tests/orm-tests-entrypoint.sh /orm-tests/entrypoint.sh

WORKDIR /orm-tests
ENTRYPOINT ["/orm-tests/entrypoint.sh"]
