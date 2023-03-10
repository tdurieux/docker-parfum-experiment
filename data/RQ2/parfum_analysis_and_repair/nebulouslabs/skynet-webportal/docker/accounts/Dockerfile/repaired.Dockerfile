FROM golang:1.15
LABEL maintainer="NebulousLabs <devs@nebulous.tech>"

ENV GOOS linux
ENV GOARCH amd64

WORKDIR /root

RUN git clone --single-branch --branch main https://github.com/NebulousLabs/skynet-accounts.git && \
    cd skynet-accounts && \
    go mod download && \
    make release

ENV SKYNET_DB_HOST="localhost"
ENV SKYNET_DB_PORT="27017"
ENV SKYNET_DB_USER="username"
ENV SKYNET_DB_PASS="password"
ENV SKYNET_ACCOUNTS_PORT=3000

ENTRYPOINT ["skynet-accounts"]