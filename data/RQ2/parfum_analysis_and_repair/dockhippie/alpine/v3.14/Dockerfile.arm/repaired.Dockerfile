FROM arm32v6/alpine:3.14@sha256:54959ffc0f689960664029c5b2ee36ca06b029e506bc149eca18fdab8f7201a3 AS build

RUN apk add --no-cache -U curl ca-certificates

# renovate: datasource=github-releases depName=thegeeklab/wait-for
ENV WAITFOR_VERSION=0.2.0

RUN curl -f -sSLo /tmp/wait-for-it https://github.com/thegeeklab/wait-for/releases/download/v${WAITFOR_VERSION}/wait-for && \
  chmod +x /tmp/wait-for-it

# renovate: datasource=github-releases depName=hairyhenderson/gomplate
ENV GOMPLATE_VERSION=3.11.1

RUN curl -f -sSLo /tmp/gomplate https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-armv6 && \
  chmod +x /tmp/gomplate

FROM arm32v6/alpine:3.14@sha256:54959ffc0f689960664029c5b2ee36ca06b029e506bc149eca18fdab8f7201a3

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
