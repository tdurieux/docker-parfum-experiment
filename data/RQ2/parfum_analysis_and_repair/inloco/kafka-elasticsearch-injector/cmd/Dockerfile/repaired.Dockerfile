FROM alpine:latest
RUN apk add --no-cache --update ca-certificates
COPY bin/injector /
RUN chmod +x injector
ENTRYPOINT ["/injector"]