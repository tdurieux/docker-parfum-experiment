FROM alpine:latest

RUN apk add --no-cache bash procps

RUN wget -qP /etc/ https://trivialrc.cf/trc && \
    ( cd /etc && wget -qO - https://trivialrc.cf/trc.sha256 | sha256sum -c) && \
    chmod +x /etc/trc && \
    /etc/trc --version

ENTRYPOINT ["/etc/trc"]
