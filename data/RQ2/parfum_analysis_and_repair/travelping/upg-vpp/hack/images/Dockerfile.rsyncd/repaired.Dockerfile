FROM alpine
ADD ./rsyncd.sh /
RUN apk add --no-cache bash rsync

ENTRYPOINT ["/rsyncd.sh"]
