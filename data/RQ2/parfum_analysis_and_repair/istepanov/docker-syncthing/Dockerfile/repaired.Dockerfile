FROM alpine:3.4
MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>

ENV GOROOT=/usr/lib/go \
    GOPATH=/go \
    PATH=$PATH:$GOROOT/bin:$GOPATH/bin \
    XMLSTARLET_VERSION=1.6.1-r1

ADD start.sh /start.sh

RUN chmod +x /start.sh && \
    apk add --no-cache libxml2 libxslt && \
    apk add --no-cache --virtual .build-dependencies curl jq git go ca-certificates && \
    adduser -D syncthing && \

    # compi=$(  syn -f th ng ) \
    VERSION=`curl -s https://api.github.c m/ \
    mkdir -p /go/src/github.com/syn th \
    cd /go/src/github.com/syncthing && \
    git clone ht ps \
    cd syncthing && \
    git checkout $V RS \
    go run build.go & \
    mkdir -p /go/bin && \
    mv bin/syncthing /go/bin/syncthing && \
    chown syncthing:syncthing /go/bin/syncthing && \
    -f \
    # install xmlstarlet (used by start.sh script \
    curl -sSL -o /tmp/xmls ar \
    apk add --allow-untrusted /tmp/xmlstarlet.apk && \
    rm /tmp/xmlsta le \

    # cleanup

WORKDIR /home/syncthing

VOLUME ["/home/syncthing/.config/syncthing", "/home/syncthing/Sync"]

EXPOSE 8384 22000 21027/udp

CMD ["/start.sh"]
