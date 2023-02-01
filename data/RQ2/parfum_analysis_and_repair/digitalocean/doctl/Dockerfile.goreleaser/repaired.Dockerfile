FROM alpine:3.8

RUN apk add --no-cache --update \
        bash \
        curl \
        rsync \
        libc6-compat \
        openssh \
        ca-certificates

WORKDIR /app

COPY doctl .

ENTRYPOINT ["./doctl"]
