FROM alpine AS final
LABEL author="Chris Lu"
COPY  ./weed /usr/bin/
RUN mkdir -p /etc/seaweedfs
COPY ./filer.toml /etc/seaweedfs/filer.toml
COPY ./entrypoint.sh /entrypoint.sh
RUN apk add --no-cache fuse# for weed mount

# volume server grpc port
EXPOSE 18080
# volume server http port
EXPOSE 8080
# filer server grpc port
EXPOSE 18888
# filer server http port
EXPOSE 8888
# master server shared grpc port
EXPOSE 19333
# master server shared http port
EXPOSE 9333
# s3 server http port
EXPOSE 8333
# webdav server http port
EXPOSE 7333

RUN mkdir -p /data/filerldb2

VOLUME /data
WORKDIR /data

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
