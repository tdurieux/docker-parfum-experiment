FROM jwilder/docker-gen:latest

# From https://github.com/gliderlabs/docker-alpine/blob/master/docs/usage.md#example
RUN apk add --update \
    python \
    py-pip \
  && pip install --no-cache-dir virtualenv \
  && pip install --no-cache-dir docker-cloud \
  && rm -rf /var/cache/apk/*

COPY restart_service.sh /restart_service.sh
RUN chmod u+x /restart_service.sh