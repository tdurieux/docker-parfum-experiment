FROM golang:stretch as build
WORKDIR /app
COPY app/ ./
RUN export GOBIN=$PWD/bin && \
    export PATH=$GOBIN:$PATH && \
    export GO111MODULE=on && \
    go get "github.com/google/uuid"
RUN export GOBIN=$PWD/bin && \
    export PATH=$GOBIN:$PATH && \
    export GO111MODULE=on && \
    go build ./benchmark.go

FROM ubuntu:18.04 as final
WORKDIR /root
RUN apt update && \
    apt -y --no-install-recommends install vim unzip git curl && \
    mkdir -p /etc/caddy && \
    curl -f https://getcaddy.com | bash -s personal && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=RU/ST=Moscow/L=Moscow/O=Flant/CN=benchmark.test/" \
    -addext "subjectAltName = DNS:benchmark.test,DNS:localhost" && \
    mkdir -p  /usr/local/share/ca-certificates/bench && \
    cp /etc/ssl/certs/nginx-selfsigned.crt /usr/local/share/ca-certificates/bench && \
    chmod 644 /usr/local/share/ca-certificates/bench && \
    chmod 755 /usr/local/share/ca-certificates/bench/nginx-selfsigned.crt && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /app/benchmark  ./
COPY Caddyfile /etc/caddy/Caddyfile

CMD ["caddy", "-conf", "/etc/caddy/Caddyfile"]
