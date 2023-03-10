FROM alpine:3.10 as alpine
RUN apk add -U --no-cache ca-certificates

FROM scratch
EXPOSE 3000

ENV GODEBUG netdns=go

COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ADD release/linux/arm64/drone-convert-pathschanged /bin/
ENTRYPOINT ["/bin/drone-convert-pathschanged"]