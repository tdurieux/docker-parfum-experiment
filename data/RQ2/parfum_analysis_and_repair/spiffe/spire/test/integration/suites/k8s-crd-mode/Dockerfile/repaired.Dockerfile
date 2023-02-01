FROM spire-agent:latest-local AS example-crd-agent
RUN apk add --no-cache --update openssl && \
    rm -rf /var/cache/apk/*
CMD []
