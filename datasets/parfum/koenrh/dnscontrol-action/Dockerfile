FROM alpine:3.16.0@sha256:686d8c9dfa6f3ccfc8230bc3178d23f84eeaf7e457f36f271ab1acc53015037c

LABEL repository="https://github.com/koenrh/dnscontrol-action"
LABEL maintainer="Koen Rouwhorst <info@koenrouwhorst.nl>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

ENV DNSCONTROL_VERSION="3.17.0"
ENV DNSCONTROL_CHECKSUM="86c0be36fef3e398b7b0713efedd188e06a0c0126fd7970202f4431b7fe8a199"

RUN apk -U --no-cache upgrade && \
    apk add --no-cache bash ca-certificates curl libc6-compat

RUN curl -sL "https://github.com/StackExchange/dnscontrol/releases/download/v$DNSCONTROL_VERSION/dnscontrol-Linux" \
  -o dnscontrol && \
  echo "$DNSCONTROL_CHECKSUM  dnscontrol" | sha256sum -c - && \
  chmod +x dnscontrol && \
  mv dnscontrol /usr/local/bin/dnscontrol

RUN ["dnscontrol", "version"]

COPY README.md entrypoint.sh bin/filter-preview-output.sh /
ENTRYPOINT ["/entrypoint.sh"]
