FROM alpine:3.15@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454 AS build

RUN apk add --no-cache -U curl ca-certificates

# renovate: datasource=github-releases depName=thegeeklab/wait-for
ENV WAITFOR_VERSION=0.2.0

RUN curl -f -sSLo /tmp/wait-for-it https://github.com/thegeeklab/wait-for/releases/download/v${WAITFOR_VERSION}/wait-for && \
  chmod +x /tmp/wait-for-it

# renovate: datasource=github-releases depName=hairyhenderson/gomplate
ENV GOMPLATE_VERSION=3.11.1

RUN curl -f -sSLo /tmp/gomplate https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64 && \
  chmod +x /tmp/gomplate

FROM alpine:3.15@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454

ENV CRON_ENABLED false
ENV TERM xterm

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/entrypoint"]
CMD ["bash"]

COPY ./overlay /

COPY --from=build /tmp/wait-for-it /usr/bin/
COPY --from=build /tmp/gomplate /usr/bin/

RUN apk update && \
  apk upgrade -a || apk fix && \
  apk add ca-certificates curl bash bash-completion ncurses vim tar rsync shadow su-exec tini s6 xz && \
  update-ca-certificates && \
  rm -rf /var/cache/apk/*
