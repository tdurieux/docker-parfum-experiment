FROM alpine:3.9

RUN apk add --no-cache --update --nocache \
    graphviz font-bitstream-type1 ghostscript-fonts \
    && rm -rf /var/cache/apk/*
