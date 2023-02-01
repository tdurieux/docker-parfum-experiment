FROM alpine:3.14

RUN apk add --no-cache --update netcat-openbsd && \
  rm -rf /var/cache/apk/*

COPY wait_for_up.bash /bin/wait_for_up
RUN chmod +x /bin/wait_for_up
