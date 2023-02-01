FROM alpine:3.5



RUN apk update && apk add --no-cache collectd



CMD [ "/bin/sh", "-c", "collectd; while :; do sleep 300; done" ]
