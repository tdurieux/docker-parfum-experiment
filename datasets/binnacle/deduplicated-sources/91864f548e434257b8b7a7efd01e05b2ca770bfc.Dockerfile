FROM alpine:3.7
LABEL maintainer "Lucas Lorentz <lucaslorentzlara@hotmail.com>"

EXPOSE 80 443 2015

RUN apk add --no-cache ca-certificates curl

COPY artifacts/binaries/linux/amd64/caddy /bin/

ENTRYPOINT ["/bin/caddy"]