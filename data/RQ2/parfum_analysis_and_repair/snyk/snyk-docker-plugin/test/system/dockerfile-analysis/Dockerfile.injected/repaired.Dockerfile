ARG FROM
ARG TAG

FROM ${FROM}:${TAG}

RUN apk add --no-cache openssl
