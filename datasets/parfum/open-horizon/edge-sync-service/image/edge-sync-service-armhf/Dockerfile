FROM docker.io/multiarch/alpine:armhf-v3.6

RUN apk --no-cache add libcrypto1.0 libssl1.0 ca-certificates 

ADD build/edge-sync-service /edge-sync-service/

CMD ["/edge-sync-service/edge-sync-service"]

