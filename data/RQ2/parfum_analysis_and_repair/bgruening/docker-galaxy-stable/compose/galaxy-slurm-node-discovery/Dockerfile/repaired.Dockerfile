FROM alpine:3.11

RUN apk add --no-cache curl jq

COPY run.sh /usr/bin/run.sh

ENTRYPOINT /usr/bin/run.sh
