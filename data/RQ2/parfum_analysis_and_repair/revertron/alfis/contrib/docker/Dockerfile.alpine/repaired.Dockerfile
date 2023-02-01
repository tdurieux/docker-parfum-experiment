FROM alpine:3.15

LABEL Description="Alfis Alternative Free Identity System"
LABEL URL="https://github.com/Revertron/Alfis/releases"

ARG arch=amd64
ARG srv_port=4244
ARG dns_port=53

RUN apk add --no-cache curl && \
    curl -f -SsL "https://github.com/Revertron/Alfis/releases/download/$( curl -f --silent "https://api.github.com/repos/Revertron/Alfis/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')/alfis-linux-${arch}-$( curl -f --silent "https://api.github.com/repos/Revertron/Alfis/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')-nogui" -o /usr/bin/alfis && \
    chmod a+x /usr/bin/alfis && \
    apk del curl

RUN /usr/bin/alfis -g > /etc/alfis.conf

EXPOSE ${srv_port}
EXPOSE ${dns_port}
EXPOSE ${dns_port}/udp

WORKDIR /var/lib/alfis

CMD ["/usr/bin/alfis", "-n", "-c", "/etc/alfis.conf"]
