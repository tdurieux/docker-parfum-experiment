FROM openjdk:8-jre-alpine

RUN apk add --update bash go gcc musl-dev diffutils util-linux coreutils && \
    rm -rf /var/cache/apk/*

COPY . /opt/keysync

ENV GOPATH /go

RUN adduser -S keysync-test && \
    addgroup -S keysync-test && \
    mkdir -p /go/src/github.com/square && \
    ln -s /opt/keysync /go/src/github.com/square/keysync && \
    go build -o /usr/bin/keysync github.com/square/keysync/cmd/keysync && \
    chmod +x /usr/bin/keysync && \
    java -jar /opt/keysync/testing/keywhiz-server.jar migrate /opt/keysync/testing/keywhiz-config.yaml && \
    java -jar /opt/keysync/testing/keywhiz-server.jar db-seed /opt/keysync/testing/keywhiz-config.yaml

CMD /opt/keysync/testing/run-tests.sh
