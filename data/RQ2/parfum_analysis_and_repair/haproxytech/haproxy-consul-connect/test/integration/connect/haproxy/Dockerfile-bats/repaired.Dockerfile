FROM fortio/fortio AS fortio

FROM bats/bats:latest

RUN apk add --no-cache curl
RUN apk add --no-cache openssl
RUN apk add --no-cache jq
COPY --from=fortio /usr/bin/fortio /usr/sbin/fortio
