FROM openjdk:8-jre-alpine

RUN apk add --no-cache --update bash go gcc git musl-dev diffutils util-linux coreutils curl && \
    rm -rf /var/cache/apk/*

COPY testing /opt/keysync/testing/

RUN adduser -S keysync-test && \
    addgroup -S keysync-test && \
    java -jar /opt/keysync/testing/keywhiz-server.jar migrate /opt/keysync/testing/keywhiz-config.yaml && \
    java -jar /opt/keysync/testing/keywhiz-server.jar db-seed /opt/keysync/testing/keywhiz-config.yaml

ENV GO111MODULE on
COPY go.mod /opt/keysync
COPY go.sum /opt/keysync
WORKDIR /opt/keysync
RUN go mod download

COPY . /opt/keysync

WORKDIR /opt/keysync/cmd/keysync
RUN go build -o /usr/bin/keysync

WORKDIR /opt/keysync/cmd/keyrestore
RUN go build -o /usr/bin/keyrestore

WORKDIR /opt/keysync/cmd/keyunwrap
RUN go build -o /usr/bin/keyunwrap

CMD /opt/keysync/testing/run-tests.sh
