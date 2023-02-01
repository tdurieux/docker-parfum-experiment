FROM spire-agent:latest-local AS nested-agent
RUN apk add --no-cache --update openssl && \
    rm -rf /var/cache/apk/*
CMD []
