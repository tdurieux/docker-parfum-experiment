FROM alpine:latest

RUN apk add --no-cache curl
WORKDIR /
COPY bin/tornjak-manager tornjak-manager
COPY ui-manager ui-manager

# Add init
ENTRYPOINT ["/tornjak-manager"]
