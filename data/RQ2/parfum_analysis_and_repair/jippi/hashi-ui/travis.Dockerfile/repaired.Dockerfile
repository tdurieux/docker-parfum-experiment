# application container
FROM alpine

# we need ca-certificates for any external https communication
RUN apk --update upgrade && \
    apk add --no-cache curl ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

COPY backend/build/hashi-ui-linux-amd64 /hashi-ui
EXPOSE 3000
CMD ["/hashi-ui"]
