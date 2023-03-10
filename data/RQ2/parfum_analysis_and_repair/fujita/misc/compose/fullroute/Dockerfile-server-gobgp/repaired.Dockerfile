FROM golang as builder

ENV HOME /root
WORKDIR /root

RUN wget https://github.com/osrg/gobgp/releases/download/v2.11.0/gobgp_2.11.0_linux_amd64.tar.gz
RUN tar xzf gobgp_2.11.0_linux_amd64.tar.gz && rm gobgp_2.11.0_linux_amd64.tar.gz
COPY watcher /go/src/watcher
RUN cd /go/src/watcher && go mod init && go build -tags netgo -ldflags '-extldflags "-static"'

FROM alpine

RUN apk add --no-cache --update supervisor

ADD supervisord.conf /etc/
ADD start-server-gobgpd /usr/bin/start-gobgpd

COPY --from=builder /go/src/watcher/watcher /usr/bin

COPY --from=builder /root/gobgpd /usr/bin
COPY --from=builder /root/gobgp /usr/bin

ENTRYPOINT ["/usr/bin/supervisord"]

