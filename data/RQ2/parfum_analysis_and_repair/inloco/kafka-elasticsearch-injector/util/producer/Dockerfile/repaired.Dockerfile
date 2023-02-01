FROM alpine:latest
RUN apk add --no-cache --update ca-certificates
COPY bin/producer /
RUN chmod +x producer
ENTRYPOINT ["/producer"]