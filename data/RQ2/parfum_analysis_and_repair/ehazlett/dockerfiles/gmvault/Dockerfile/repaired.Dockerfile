FROM alpine:latest
RUN apk add -U --no-cache python py2-pip bash ca-certificates && \
    pip install --no-cache-dir gmvault
ENTRYPOINT ["gmvault"]
