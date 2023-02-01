FROM alpine:3.11.5
RUN apk add --no-cache curl
COPY core-cleanup.sh /usr/bin/
