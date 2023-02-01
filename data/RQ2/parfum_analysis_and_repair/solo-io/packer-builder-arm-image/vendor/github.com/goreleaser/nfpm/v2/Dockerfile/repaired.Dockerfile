FROM alpine
COPY nfpm_*.apk /tmp/
RUN apk add --no-cache --allow-untrusted /tmp/nfpm_*.apk
ENTRYPOINT ["/usr/local/bin/nfpm"]
