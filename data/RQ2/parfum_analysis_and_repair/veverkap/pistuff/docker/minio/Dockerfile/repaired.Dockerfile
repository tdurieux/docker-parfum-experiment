FROM armhf/alpine:latest
WORKDIR /root/
RUN apk add --no-cache --update curl ca-certificates && \
  curl -f -sSLO https://dl.minio.io/server/minio/release/linux-arm/minio && \
  mv minio /usr/bin/

EXPOSE 9000
RUN mkdir /objects/
VOLUME /objects/
RUN chmod +x /usr/bin/minio

CMD ["/usr/bin/minio", "server", "/objects/"]
