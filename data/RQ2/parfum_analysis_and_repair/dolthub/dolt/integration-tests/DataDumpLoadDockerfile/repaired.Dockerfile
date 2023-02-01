FROM --platform=linux/amd64 ubuntu:18.04

# install mysql-client, mysql-server, libmysqlclient-dev
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
    apt install --no-install-recommends -y \
        curl \
        gnupg \
        software-properties-common && \
    curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt update -y && \
    apt install --no-install-recommends -y \
        git \
        mysql-client \
        mysql-server \
        libmysqlclient-dev \
        bats && \
    update-ca-certificates -f && rm -rf /var/lib/apt/lists/*;

# install go
WORKDIR /root
ENV GO_VERSION=1.18
ENV GOPATH=$HOME/go
ENV PATH=$PATH:$GOPATH/bin
ENV PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
RUN curl -f -O "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" && \
    sha256sum "go${GO_VERSION}.linux-amd64.tar.gz" && \
    tar -xvf "go${GO_VERSION}.linux-amd64.tar.gz" -C /usr/local && \
    chown -R root:root /usr/local/go && \
    mkdir -p $HOME/go/{bin,src} && \
    go version && rm "go${GO_VERSION}.linux-amd64.tar.gz"

# install MySQL dependency from source
RUN git clone https://github.com/go-sql-driver/mysql.git
WORKDIR mysql
RUN git checkout tags/v1.6.0 -b v1.6.0
RUN go install .
WORKDIR /

# install dolt from source
WORKDIR /root/building
COPY ./go .
ENV GOFLAGS="-mod=readonly"
RUN go build -o /usr/local/bin/dolt ./cmd/dolt

COPY data-dump-loading-tests /data-dump-loading-tests
COPY data-dump-loading-tests/data-dump-loading-tests-entrypoint.sh /data-dump-loading-tests/entrypoint.sh

WORKDIR /data-dump-loading-tests
ENTRYPOINT ["/data-dump-loading-tests/entrypoint.sh"]
