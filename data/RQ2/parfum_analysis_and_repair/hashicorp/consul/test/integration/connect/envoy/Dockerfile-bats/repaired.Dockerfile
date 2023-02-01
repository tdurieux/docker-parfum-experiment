FROM docker.mirror.hashicorp.services/fortio/fortio AS fortio

FROM docker.mirror.hashicorp.services/bats/bats:1.7.0

RUN apk add --no-cache curl
RUN apk add --no-cache openssl
RUN apk add --no-cache jq
COPY --from=fortio /usr/bin/fortio /usr/sbin/fortio
