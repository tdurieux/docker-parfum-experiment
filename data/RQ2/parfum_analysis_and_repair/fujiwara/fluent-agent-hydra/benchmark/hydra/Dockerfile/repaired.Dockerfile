FROM alpine:latest
WORKDIR /usr/local/bin
RUN apk add --no-cache --update unzip curl && rm -rf /var/cache/apk/*
COPY fluent-agent-hydra /usr/local/bin/fluent-agent-hydra
COPY hydra.conf /etc/hydra.conf
CMD exec /usr/local/bin/fluent-agent-hydra -c /etc/hydra.conf
