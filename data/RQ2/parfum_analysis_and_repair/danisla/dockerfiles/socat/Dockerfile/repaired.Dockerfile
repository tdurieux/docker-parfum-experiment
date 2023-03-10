FROM alpine:3.4

RUN apk update && \
    apk add --no-cache socat && \
    rm -rf /var/cache/apk/*

# Using sh as entrypoint to allow complete shell execution of socat.
ENTRYPOINT ["sh"]
