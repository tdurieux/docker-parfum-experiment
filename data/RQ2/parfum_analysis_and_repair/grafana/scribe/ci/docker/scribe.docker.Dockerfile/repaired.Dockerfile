ARG VERSION=latest
FROM grafana/shipwright:${VERSION}

RUN apk add --no-cache docker git
WORKDIR /var/scribe
