FROM alpine:3.15 as certs
RUN apk --update --no-cache add ca-certificates
ARG TARGETARCH
COPY bin/linux/tempo-${TARGETARCH} /tempo
ENTRYPOINT ["/tempo"]
