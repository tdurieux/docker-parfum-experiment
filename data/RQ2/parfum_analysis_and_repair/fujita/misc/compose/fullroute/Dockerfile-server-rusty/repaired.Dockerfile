FROM golang as builder

ENV HOME /root
WORKDIR /root

COPY watcher /go/src/watcher
RUN cd /go/src/watcher && go mod init && go build -tags netgo -ldflags '-extldflags "-static"'

FROM tomo/rustybgp

ENV HOME /root
WORKDIR /root

RUN apk add --no-cache --update supervisor

ADD supervisord.conf /etc/
ADD start-server-rusty /usr/bin/start-gobgpd

COPY --from=builder /go/src/watcher/watcher /usr/bin

ENTRYPOINT ["/usr/bin/supervisord"]