FROM alpine:3.15.0

RUN apk add --no-cache nfs-utils jq && echo "hosts: files dns" > /etc/nsswitch.conf
