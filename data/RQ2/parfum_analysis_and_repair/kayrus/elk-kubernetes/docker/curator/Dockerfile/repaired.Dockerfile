FROM alpine:3.4

RUN apk --update --no-cache add python py-pip && \
    pip install --no-cache-dir elasticsearch-curator==5.2.0

COPY curator-cron /usr/local/bin
