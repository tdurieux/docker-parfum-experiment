FROM alpine:3.15.0

RUN apk add --no-cache e2fsprogs xfsprogs findmnt blkid e2fsprogs-extra && echo "hosts: files dns" > /etc/nsswitch.conf
