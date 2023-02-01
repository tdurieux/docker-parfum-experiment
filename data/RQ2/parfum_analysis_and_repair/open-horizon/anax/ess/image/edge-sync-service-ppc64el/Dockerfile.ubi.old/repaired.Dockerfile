FROM multiarch/alpine:ppc64le-v3.8

RUN apk --no-cache add libcrypto1.0 libssl1.0 ca-certificates 

ADD edge-sync-service /edge-sync-service/

CMD ["/edge-sync-service/edge-sync-service"]