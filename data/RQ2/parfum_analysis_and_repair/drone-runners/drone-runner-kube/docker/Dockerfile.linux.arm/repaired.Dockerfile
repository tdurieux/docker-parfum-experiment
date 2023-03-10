FROM alpine:3.13 as alpine
RUN apk add -U --no-cache ca-certificates

FROM scratch
EXPOSE 3000

ENV GODEBUG netdns=go
ENV DRONE_PLATFORM_OS linux
ENV DRONE_PLATFORM_ARCH arm

COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ADD release/linux/arm/drone-runner-kube /bin/
ENTRYPOINT ["/bin/drone-runner-kube"]