FROM arm64v8/alpine:3.12

ADD https://dl.minio.io/server/minio/release/linux-arm64/minio /usr/bin/minio
RUN chmod a+rx /usr/bin/minio && mkdir /root/.minio/ && mkdir /data
COPY config.json /root/.minio/config.json

CMD ["/usr/bin/minio", "server", "/data"]