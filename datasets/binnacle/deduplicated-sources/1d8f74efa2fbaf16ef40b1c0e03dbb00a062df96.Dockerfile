FROM alpine:3.7 as alpine
RUN apk add -U --no-cache ca-certificates

# Image starts here
FROM arm32v6/alpine:3.7
LABEL maintainer "Lucas Lorentz <lucaslorentzlara@hotmail.com>"

EXPOSE 80 443 2015

COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY artifacts/binaries/linux/arm32v6/caddy /bin/

ENTRYPOINT ["/bin/caddy"]