FROM arm32v6/docker:19.03.8-dind

ENV DOCKER_HOST=unix:///var/run/docker.sock

RUN apk --update add --virtual .build-deps curl && \
    mkdir -p /etc/docker/ && \
    curl -f -SsL -o /etc/docker/default.json https://raw.githubusercontent.com/moby/moby/19.03/profiles/seccomp/default.json && \
    sed -i 's/SCMP_ACT_ERRNO/SCMP_ACT_TRACE/g' /etc/docker/default.json && \
    chmod 600 /etc/docker/default.json && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

ADD release/linux/arm/drone-docker /bin/
ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh", "/bin/drone-docker"]
