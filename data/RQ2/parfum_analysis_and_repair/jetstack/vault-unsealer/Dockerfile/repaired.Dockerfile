FROM alpine:3.8

RUN apk add --no-cache --update ca-certificates

COPY vault-unsealer_linux_amd64 /usr/local/bin/vault-unsealer

ENTRYPOINT ["/usr/local/bin/vault-unsealer"]
