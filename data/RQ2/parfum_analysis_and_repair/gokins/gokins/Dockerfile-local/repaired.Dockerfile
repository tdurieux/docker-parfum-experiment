FROM mgr9525/ubuntu:21-ali

ENV GOKINS_WORKPATH=/data/gokins

RUN apt update \
    && apt install --no-install-recommends -y openssl ca-certificates curl git wget \
    && mkdir -p /data/gokins && rm -rf /var/lib/apt/lists/*;

COPY bin/gokins-alpine /usr/bin/gokins
WORKDIR /data
ENTRYPOINT ["/usr/bin/gokins"]
