FROM ethereum/client-go:v1.10.17

RUN apk add --no-cache jq

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/db"]

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]