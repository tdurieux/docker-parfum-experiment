FROM golang:latest
RUN go get github.com/chrislusf/seaweedfs/weed

# volume server gprc port
EXPOSE 18080
# volume server http port
EXPOSE 8080
# filer server gprc port
EXPOSE 18888
# filer server http port
EXPOSE 8888
# master server shared gprc port
EXPOSE 19333
# master server shared http port
EXPOSE 9333
# s3 server http port
EXPOSE 8333

RUN mkdir -p /data/filerdb

VOLUME /data

RUN mkdir -p /etc/seaweedfs
RUN cp /go/src/github.com/chrislusf/seaweedfs/docker/filer.toml /etc/seaweedfs/filer.toml
RUN cp /go/src/github.com/chrislusf/seaweedfs/docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN cp /go/bin/weed /usr/bin/

ENTRYPOINT ["/entrypoint.sh"]
