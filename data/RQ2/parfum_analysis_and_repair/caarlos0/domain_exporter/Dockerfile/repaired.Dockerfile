FROM alpine
EXPOSE 9222
ENTRYPOINT ["/usr/bin/domain_exporter"]
COPY domain_exporter_*.apk /tmp/
RUN apk add --no-cache --allow-untrusted /tmp/domain_exporter_*.apk
