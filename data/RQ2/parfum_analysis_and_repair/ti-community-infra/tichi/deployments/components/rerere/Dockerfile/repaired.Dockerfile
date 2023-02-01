FROM alpine:3.12

RUN apk --update --no-cache add git less openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

ADD rerere /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/rerere"]